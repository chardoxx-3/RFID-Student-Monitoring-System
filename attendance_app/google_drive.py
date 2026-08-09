# google_drive.py - Enhanced with retry mechanism and upload queue
import os
import io
import logging
import time
import random
import threading
from queue import Queue, Empty
from django.conf import settings

logger = logging.getLogger(__name__)

try:
    from google.oauth2 import service_account
    from googleapiclient.discovery import build
    from googleapiclient.http import MediaIoBaseUpload
    from googleapiclient.errors import HttpError
    
    class GoogleDriveService:
        def __init__(self):
            self.service = None
            self.upload_queue = Queue()
            self.is_processing = False
            self.max_retries = 5
            self.upload_delay = 0.5  # Default delay between uploads (seconds)
            self.initialize_service()
            self.start_upload_processor()
        
        def initialize_service(self):
            try:
                # Use service account info from settings directly
                service_account_info = getattr(settings, 'GOOGLE_SERVICE_ACCOUNT_INFO', None)
                
                if not service_account_info:
                    logger.error("No Google Service Account configuration found")
                    return
                
                # Fix the private key format - remove extra backslashes and newlines
                if 'private_key' in service_account_info:
                    # Clean up the private key format
                    private_key = service_account_info['private_key']
                    # Remove extra backslashes and fix newlines
                    private_key = private_key.replace('\\n', '\n').replace('\\\\', '\\')
                    service_account_info['private_key'] = private_key
                
                # Authenticate using service account info
                credentials = service_account.Credentials.from_service_account_info(
                    service_account_info,
                    scopes=['https://www.googleapis.com/auth/drive.file']
                )
                
                self.service = build('drive', 'v3', credentials=credentials)
                logger.info("Google Drive service initialized successfully")
                
            except Exception as e:
                logger.error(f"Failed to initialize Google Drive service: {e}")
                self.service = None
        
        def ensure_attendance_folder(self):
            """Create ATTENDANCE folder if it doesn't exist, or return existing folder ID"""
            if not self.service:
                logger.error("Google Drive service not initialized")
                return None
            
            try:
                # Check if folder already exists
                query = "mimeType='application/vnd.google-apps.folder' and name='ATTENDANCE' and trashed=false"
                results = self.service.files().list(
                    q=query,
                    spaces='drive',
                    fields='files(id, name)',
                    supportsAllDrives=True
                ).execute()
                
                folders = results.get('files', [])
                
                if folders:
                    # Folder exists, return its ID
                    logger.info(f"ATTENDANCE folder already exists: {folders[0]['id']}")
                    return folders[0]['id']
                else:
                    # Create the folder
                    folder_metadata = {
                        'name': 'ATTENDANCE',
                        'mimeType': 'application/vnd.google-apps.folder'
                    }
                    
                    folder = self.service.files().create(
                        body=folder_metadata,
                        fields='id',
                        supportsAllDrives=True
                    ).execute()
                    
                    logger.info(f"Created ATTENDANCE folder: {folder['id']}")
                    return folder['id']
                    
            except Exception as e:
                logger.error(f"Error ensuring ATTENDANCE folder exists: {e}")
                return None
        
        def start_upload_processor(self):
            """Start background thread to process upload queue"""
            if not self.is_processing:
                self.is_processing = True
                processor_thread = threading.Thread(target=self._process_upload_queue, daemon=True)
                processor_thread.start()
                logger.info("Upload queue processor started")
        
        def _process_upload_queue(self):
            """Background thread to process upload queue with rate limiting"""
            while self.is_processing:
                try:
                    # Get next upload task with timeout to allow graceful shutdown
                    task = self.upload_queue.get(timeout=1)
                    image_data, filename, folder_id, callback = task
                    
                    # Upload with retry mechanism
                    result = self._upload_with_retry(image_data, filename, folder_id)
                    
                    # Call callback if provided
                    if callback:
                        callback(result)
                    
                    # Rate limiting - delay between uploads
                    time.sleep(self.upload_delay)
                    
                    self.upload_queue.task_done()
                    
                except Empty:
                    # Queue empty, continue waiting
                    continue
                except Exception as e:
                    logger.error(f"Error processing upload queue: {e}")
                    if callback:
                        callback(None)
                    self.upload_queue.task_done()
        
        def _upload_with_retry(self, image_data, filename, folder_id=None):
            """Upload with exponential backoff retry mechanism"""
            for attempt in range(self.max_retries):
                try:
                    return self._upload_photo_direct(image_data, filename, folder_id)
                
                except HttpError as e:
                    if e.resp.status in [403, 429, 500, 502, 503, 504]:
                        # Retryable error - use exponential backoff
                        sleep_time = (2 ** attempt) + random.random()
                        logger.warning(
                            f"Google Drive API error (attempt {attempt + 1}/{self.max_retries}): "
                            f"{e}. Retrying in {sleep_time:.2f}s"
                        )
                        time.sleep(sleep_time)
                    else:
                        # Non-retryable error
                        logger.error(f"Google Drive API error (non-retryable): {e}")
                        raise
                
                except Exception as e:
                    logger.error(f"Unexpected error during upload (attempt {attempt + 1}): {e}")
                    if attempt == self.max_retries - 1:
                        raise
                    time.sleep(1)  # Simple delay for non-API errors
            
            return None
        
        def _upload_photo_direct(self, image_data, filename, folder_id=None):
            """Direct upload implementation without retry logic"""
            if not self.service:
                logger.error("Google Drive service not initialized")
                return None
                
            try:
                # Create file metadata
                file_metadata = {
                    'name': filename,
                    'mimeType': 'image/jpeg'
                }
                
                # Set parent folder if provided
                if folder_id:
                    file_metadata['parents'] = [folder_id]
                
                # Convert image data to bytes
                if hasattr(image_data, 'read'):
                    # It's a file-like object
                    media = MediaIoBaseUpload(image_data, mimetype='image/jpeg', resumable=True)
                else:
                    # It's bytes data
                    media = MediaIoBaseUpload(io.BytesIO(image_data), mimetype='image/jpeg', resumable=True)
                
                # Upload the file
                file = self.service.files().create(
                    body=file_metadata,
                    media_body=media,
                    fields='id, webViewLink',
                    supportsAllDrives=True
                ).execute()
                
                # Make the file publicly viewable
                self.service.permissions().create(
                    fileId=file['id'],
                    body={'type': 'anyone', 'role': 'reader'},
                    supportsAllDrives=True
                ).execute()
                
                logger.info(f"File uploaded successfully: {file['id']}")
                return file.get('webViewLink')
            
            except Exception as e:
                logger.error(f"Error in direct upload: {e}")
                raise
        
        def queue_upload(self, image_data, filename, folder_id=None, callback=None):
            """
            Queue an upload for processing (non-blocking)
            Returns immediately, callback will be called with result
            """
            if not self.service:
                logger.warning("Google Drive service not available - queuing for later")
                # Store upload task for when service becomes available
                pass
            
            self.upload_queue.put((image_data, filename, folder_id, callback))
            logger.debug(f"Upload queued: {filename}, queue size: {self.upload_queue.qsize()}")
        
        def upload_photo(self, image_data, filename, folder_id=None):
            """
            Upload a photo to Google Drive and return the shareable URL
            (Synchronous version with retry)
            """
            return self._upload_with_retry(image_data, filename, folder_id)
        
        def get_queue_size(self):
            """Get current upload queue size"""
            return self.upload_queue.qsize()
        
        def shutdown(self):
            """Gracefully shutdown upload processor"""
            self.is_processing = False
            logger.info("Upload processor shutting down")

except ImportError:
    # Fallback implementation if Google packages are not installed
    logger.warning("Google API packages not installed. Using fallback implementation.")
    
    class GoogleDriveService:
        def __init__(self):
            self.service = None
            self.upload_queue = Queue()
            self.is_processing = False
            logger.warning("Google Drive service not available - using fallback mode")
        
        def ensure_attendance_folder(self):
            """Fallback method - returns None for local storage"""
            logger.warning("Google Drive not available - using local storage")
            return None
        
        def queue_upload(self, image_data, filename, folder_id=None, callback=None):
            """Fallback - save to local storage immediately"""
            result = self.upload_photo(image_data, filename, folder_id)
            if callback:
                callback(result)
        
        def upload_photo(self, image_data, filename, folder_id=None):
            """
            Fallback implementation - saves to local media folder instead of Google Drive
            """
            try:
                from django.core.files.base import ContentFile
                from django.core.files.storage import default_storage
                import uuid
                from django.conf import settings
                
                # Generate a unique filename
                unique_filename = f"{uuid.uuid4().hex}_{filename}"
                file_path = f"attendance_photos/{unique_filename}"
                
                # Save to local storage
                if hasattr(image_data, 'read'):
                    # It's a file-like object, read its content
                    image_data = image_data.read()
                
                saved_path = default_storage.save(file_path, ContentFile(image_data))
                file_url = default_storage.url(saved_path)
                
                # Build absolute URL
                base_url = getattr(settings, 'SITE_URL', 'http://localhost:8000')
                full_url = f"{base_url}{file_url}"
                
                logger.warning(f"Google Drive not available - saved photo locally: {full_url}")
                
                return full_url
                
            except Exception as e:
                logger.error(f"Error saving photo locally: {e}")
                return None
        
        def get_queue_size(self):
            return 0
        
        def shutdown(self):
            pass

# Global instance
drive_service = GoogleDriveService()