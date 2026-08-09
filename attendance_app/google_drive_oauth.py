# google_drive_oauth.py - Updated with persistent authentication
import os
import io
import logging
import time
import random
import threading
from queue import Queue, Empty
from django.conf import settings
from django.core.cache import cache
import json
from datetime import datetime, timedelta

logger = logging.getLogger(__name__)

try:
    from google.oauth2.credentials import Credentials
    from google_auth_oauthlib.flow import Flow
    from googleapiclient.discovery import build
    from googleapiclient.http import MediaIoBaseUpload
    from googleapiclient.errors import HttpError
    from google.auth.transport.requests import Request
    
    class GoogleDriveOAuthService:
        def __init__(self):
            self.service = None
            self.credentials = None
            self.upload_queue = Queue()
            self.is_processing = False
            self.max_retries = 5
            self.upload_delay = 0.5
            self.credentials_file = os.path.join(settings.BASE_DIR, 'google_drive_credentials.json')
            self.attendance_folder_id = None
            self.token_expiry_days = 7  # Token considered valid for 7 days
            self.initialize_service()
            self.start_upload_processor()
        
        def initialize_service(self):
            """Initialize the Google Drive service with persistent credentials"""
            try:
                # Try to load credentials from file first
                self.credentials = self.load_credentials_from_file()
                
                if not self.credentials:
                    # Fall back to cache
                    self.credentials = self.get_stored_credentials()
                
                if not self.credentials:
                    logger.warning("No OAuth credentials found")
                    return
                
                # Check if token is expired or will expire soon
                if self.is_token_expired_or_expiring_soon():
                    logger.info("Token expired or expiring soon, attempting refresh...")
                    if not self.refresh_token():
                        logger.error("Failed to refresh token, clearing credentials")
                        self.clear_credentials()
                        return
                
                self.service = build('drive', 'v3', credentials=self.credentials)
                
                # Ensure attendance folder exists and get its ID
                self.attendance_folder_id = self.ensure_attendance_folder()
                
                logger.info("Google Drive service initialized successfully")
                
            except Exception as e:
                logger.error(f"Failed to initialize Google Drive service: {e}")
                self.service = None
                self.attendance_folder_id = None
        
        def is_token_expired_or_expiring_soon(self):
            """Check if token is expired or will expire within 24 hours"""
            if not self.credentials or not self.credentials.expiry:
                return True
            
            # Consider token expiring if it has less than 24 hours remaining
            expiry_buffer = timedelta(hours=24)
            return self.credentials.expiry <= datetime.now() + expiry_buffer
        
        def refresh_token(self):
            """Refresh the access token using refresh token"""
            try:
                if not self.credentials or not self.credentials.refresh_token:
                    logger.error("No refresh token available")
                    return False
                
                # Refresh the token
                self.credentials.refresh(Request())
                
                # Update expiry to 7 days from now for our tracking
                new_expiry = datetime.now() + timedelta(days=self.token_expiry_days)
                self.credentials.expiry = new_expiry
                
                # Save the refreshed credentials
                self.save_credentials_to_file(self.credentials)
                self._save_credentials_to_cache(self.credentials)
                
                logger.info("Access token refreshed successfully")
                return True
                
            except Exception as refresh_error:
                logger.error(f"Error refreshing token: {refresh_error}")
                return False
        
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
                    folder_id = folders[0]['id']
                    logger.info(f"ATTENDANCE folder found: {folder_id}")
                    return folder_id
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
                    
                    folder_id = folder['id']
                    logger.info(f"Created ATTENDANCE folder: {folder_id}")
                    return folder_id
                    
            except Exception as e:
                logger.error(f"Error ensuring ATTENDANCE folder exists: {e}")
                return None
        
        def _upload_photo_direct(self, image_data, filename, folder_id=None):
            """Direct upload implementation with proper error handling"""
            if not self.service:
                logger.error("Google Drive service not initialized - not authenticated")
                return self._save_to_local_storage(image_data, filename)
                
            try:
                # Use the attendance folder ID if no specific folder provided
                if folder_id is None:
                    folder_id = self.attendance_folder_id
                
                # Create file metadata
                file_metadata = {
                    'name': filename,
                    'mimeType': 'image/jpeg'
                }
                
                # Set parent folder if available
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
                
                logger.info(f"File uploaded successfully to Google Drive: {file['id']}")
                return file.get('webViewLink')
            
            except HttpError as e:
                logger.error(f"Google Drive API error: {e}")
                # Try to refresh token if it's an auth error
                if e.status_code in [401, 403]:
                    logger.info("Auth error detected, attempting token refresh...")
                    if self.refresh_token():
                        # Retry the upload with refreshed token
                        return self._upload_photo_direct(image_data, filename, folder_id)
                
                # Fall back to local storage
                return self._save_to_local_storage(image_data, filename)
            except Exception as e:
                logger.error(f"Error uploading file to Google Drive: {e}")
                # Fall back to local storage
                return self._save_to_local_storage(image_data, filename)
        
        def save_credentials_to_file(self, credentials):
            """Save credentials to a file for persistence"""
            try:
                # Set custom expiry for our tracking (7 days)
                custom_expiry = datetime.now() + timedelta(days=self.token_expiry_days)
                
                credentials_data = {
                    'token': credentials.token,
                    'refresh_token': credentials.refresh_token,
                    'token_uri': credentials.token_uri,
                    'client_id': credentials.client_id,
                    'client_secret': credentials.client_secret,
                    'scopes': credentials.scopes,
                    'expiry': credentials.expiry.isoformat() if credentials.expiry else None,
                    'custom_expiry': custom_expiry.isoformat()  # Our custom 7-day expiry
                }
                
                with open(self.credentials_file, 'w') as f:
                    json.dump(credentials_data, f)
                
                logger.info("Credentials saved to file for persistence")
                return True
            except Exception as e:
                logger.error(f"Error saving credentials to file: {e}")
                return False
        
        def load_credentials_from_file(self):
            """Load credentials from file"""
            try:
                if not os.path.exists(self.credentials_file):
                    return None
                
                with open(self.credentials_file, 'r') as f:
                    credentials_data = json.load(f)
                
                # Create credentials object
                credentials = Credentials(
                    token=credentials_data.get('token'),
                    refresh_token=credentials_data.get('refresh_token'),
                    token_uri=credentials_data.get('token_uri', 'https://oauth2.googleapis.com/token'),
                    client_id=credentials_data.get('client_id'),
                    client_secret=credentials_data.get('client_secret'),
                    scopes=credentials_data.get('scopes', ['https://www.googleapis.com/auth/drive.file'])
                )
                
                # Set expiry if available
                if credentials_data.get('expiry'):
                    credentials.expiry = datetime.fromisoformat(credentials_data['expiry'])
                
                # Use our custom expiry for tracking
                if credentials_data.get('custom_expiry'):
                    credentials.custom_expiry = datetime.fromisoformat(credentials_data['custom_expiry'])
                
                logger.info("Credentials loaded from persistent storage")
                return credentials
                
            except Exception as e:
                logger.error(f"Error loading credentials from file: {e}")
                return None
        
        def clear_credentials(self):
            """Clear all stored credentials"""
            try:
                # Remove file
                if os.path.exists(self.credentials_file):
                    os.remove(self.credentials_file)
                
                # Clear cache
                cache.delete('google_drive_credentials')
                
                self.credentials = None
                self.service = None
                self.attendance_folder_id = None
                
                logger.info("All credentials cleared")
            except Exception as e:
                logger.error(f"Error clearing credentials: {e}")
        
        def get_stored_credentials(self):
            """Retrieve stored OAuth credentials from cache"""
            try:
                credentials_dict = cache.get('google_drive_credentials')
                if not credentials_dict:
                    return None
                
                credentials = Credentials(
                    token=credentials_dict.get('token'),
                    refresh_token=credentials_dict.get('refresh_token'),
                    token_uri=credentials_dict.get('token_uri', 'https://oauth2.googleapis.com/token'),
                    client_id=credentials_dict.get('client_id'),
                    client_secret=credentials_dict.get('client_secret'),
                    scopes=credentials_dict.get('scopes', ['https://www.googleapis.com/auth/drive.file'])
                )
                
                # Set custom expiry if available
                if credentials_dict.get('custom_expiry'):
                    credentials.custom_expiry = datetime.fromisoformat(credentials_dict['custom_expiry'])
                
                return credentials
                
            except Exception as e:
                logger.error(f"Error retrieving stored credentials: {e}")
                return None
        
        def _save_credentials_to_cache(self, credentials):
            """Save credentials to cache"""
            # Set custom expiry for our tracking
            custom_expiry = datetime.now() + timedelta(days=self.token_expiry_days)
            
            credentials_dict = {
                'token': credentials.token,
                'refresh_token': credentials.refresh_token,
                'token_uri': credentials.token_uri,
                'client_id': credentials.client_id,
                'client_secret': credentials.client_secret,
                'scopes': credentials.scopes,
                'custom_expiry': custom_expiry.isoformat()
            }
            
            # Cache for 7 days (604800 seconds)
            cache.set('google_drive_credentials', credentials_dict, timeout=604800)
        
        def get_authorization_url(self):
            """Generate the OAuth authorization URL with offline access"""
            try:
                flow = Flow.from_client_config(
                    {
                        'web': {
                            'client_id': settings.GOOGLE_OAUTH2_CLIENT_ID,
                            'client_secret': settings.GOOGLE_OAUTH2_CLIENT_SECRET,
                            'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
                            'token_uri': 'https://oauth2.googleapis.com/token',
                            'redirect_uris': [settings.GOOGLE_OAUTH2_REDIRECT_URI]
                        }
                    },
                    scopes=['https://www.googleapis.com/auth/drive.file']
                )
                
                flow.redirect_uri = settings.GOOGLE_OAUTH2_REDIRECT_URI
                
                authorization_url, state = flow.authorization_url(
                    access_type='offline',
                    include_granted_scopes='true',
                    prompt='consent'
                )
                
                cache.set('oauth_state', state, timeout=300)
                return authorization_url
            except Exception as e:
                logger.error(f"Error generating authorization URL: {e}")
                return None
        
        def save_credentials(self, code):
            """Exchange authorization code for tokens and save credentials persistently"""
            try:
                flow = Flow.from_client_config(
                    {
                        'web': {
                            'client_id': settings.GOOGLE_OAUTH2_CLIENT_ID,
                            'client_secret': settings.GOOGLE_OAUTH2_CLIENT_SECRET,
                            'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
                            'token_uri': 'https://oauth2.googleapis.com/token',
                            'redirect_uris': [settings.GOOGLE_OAUTH2_REDIRECT_URI]
                        }
                    },
                    scopes=['https://www.googleapis.com/auth/drive.file']
                )
                
                flow.redirect_uri = settings.GOOGLE_OAUTH2_REDIRECT_URI
                flow.fetch_token(code=code)
                
                credentials = flow.credentials
                
                # Save to both file (persistent) and cache (temporary)
                self.save_credentials_to_file(credentials)
                self._save_credentials_to_cache(credentials)
                
                # Also store in memory for immediate use
                self.credentials = credentials
                self.service = build('drive', 'v3', credentials=credentials)
                
                # Ensure folder exists
                self.attendance_folder_id = self.ensure_attendance_folder()
                
                logger.info("Credentials saved successfully with persistent storage")
                return True
                    
            except Exception as e:
                logger.error(f"Error saving credentials: {e}")
                return False
        
        def is_authenticated(self):
            """Check if user is authenticated with Google Drive"""
            try:
                self.initialize_service()  # This will refresh tokens if needed
                return self.service is not None and self.credentials is not None
            except:
                return False

        # Keep all other methods the same...
        def start_upload_processor(self):
            if not self.is_processing:
                self.is_processing = True
                processor_thread = threading.Thread(target=self._process_upload_queue, daemon=True)
                processor_thread.start()
                logger.info("Upload queue processor started")
        
        def _process_upload_queue(self):
            while self.is_processing:
                try:
                    task = self.upload_queue.get(timeout=1)
                    image_data, filename, folder_id, callback = task
                    
                    result = self._upload_with_retry(image_data, filename, folder_id)
                    
                    if callback:
                        callback(result)
                    
                    time.sleep(self.upload_delay)
                    self.upload_queue.task_done()
                    
                except Empty:
                    continue
                except Exception as e:
                    logger.error(f"Error processing upload queue: {e}")
                    if callback:
                        callback(None)
                    self.upload_queue.task_done()
        
        def _upload_with_retry(self, image_data, filename, folder_id=None):
            for attempt in range(self.max_retries):
                try:
                    return self._upload_photo_direct(image_data, filename, folder_id)
                
                except HttpError as e:
                    if e.resp.status in [403, 429, 500, 502, 503, 504]:
                        sleep_time = (2 ** attempt) + random.random()
                        logger.warning(
                            f"Google Drive API error (attempt {attempt + 1}/{self.max_retries}): {e}. Retrying in {sleep_time:.2f}s"
                        )
                        time.sleep(sleep_time)
                    else:
                        logger.error(f"Google Drive API error (non-retryable): {e}")
                        raise
                
                except Exception as e:
                    logger.error(f"Unexpected error during upload (attempt {attempt + 1}): {e}")
                    if attempt == self.max_retries - 1:
                        raise
                    time.sleep(1)
            
            return None
        
        def queue_upload(self, image_data, filename, folder_id=None, callback=None):
            if not self.service:
                logger.warning("Google Drive service not available - queuing for later")
            
            self.upload_queue.put((image_data, filename, folder_id, callback))
            logger.debug(f"Upload queued: {filename}, queue size: {self.upload_queue.qsize()}")
        
        def upload_photo(self, image_data, filename, folder_id=None):
            return self._upload_with_retry(image_data, filename, folder_id)
        
        def get_queue_size(self):
            return self.upload_queue.qsize()
        
        def shutdown(self):
            self.is_processing = False
            logger.info("Upload processor shutting down")
        
        def _save_to_local_storage(self, image_data, filename):
            """Save photo to local storage with proper error handling"""
            try:
                from django.core.files.base import ContentFile
                from django.core.files.storage import default_storage
                import uuid
                from django.conf import settings
                import os
                
                photos_dir = os.path.join(settings.MEDIA_ROOT, 'attendance_photos')
                os.makedirs(photos_dir, exist_ok=True)
                
                unique_filename = f"{uuid.uuid4().hex}_{filename}"
                file_path = f"attendance_photos/{unique_filename}"
                
                if hasattr(image_data, 'read'):
                    image_data.seek(0)
                    image_content = image_data.read()
                else:
                    image_content = image_data
                
                saved_path = default_storage.save(file_path, ContentFile(image_content))
                file_url = default_storage.url(saved_path)
                
                base_url = getattr(settings, 'SITE_URL', 'http://localhost:8000')
                if base_url.endswith('/'):
                    base_url = base_url[:-1]
                if file_url.startswith('/'):
                    file_url = file_url[1:]
                
                full_url = f"{base_url}/{file_url}"
                
                logger.info(f"Photo saved locally: {full_url}")
                return full_url
                
            except Exception as e:
                logger.error(f"Error saving photo locally: {e}")
                return None

except ImportError:
    # Fallback implementation if Google packages are not installed
    logger.warning("Google API packages not installed. Using fallback implementation.")
    
    class GoogleDriveOAuthService:
        def __init__(self):
            self.service = None
            self.upload_queue = Queue()
            self.is_processing = False
            logger.warning("Google Drive service not available - using fallback mode")
        
        def ensure_attendance_folder(self):
            logger.warning("Google Drive not available - using local storage")
            return None
        
        def queue_upload(self, image_data, filename, folder_id=None, callback=None):
            result = self.upload_photo(image_data, filename, folder_id)
            if callback:
                callback(result)
        
        def is_authenticated(self):
            return False
            
        def get_authorization_url(self):
            return None
            
        def save_credentials(self, code):
            return False
        
        def clear_credentials(self):
            pass
        
        def upload_photo(self, image_data, filename, folder_id=None):
            try:
                from django.core.files.base import ContentFile
                from django.core.files.storage import default_storage
                import uuid
                from django.conf import settings
                import os
                
                photos_dir = os.path.join(settings.MEDIA_ROOT, 'attendance_photos')
                os.makedirs(photos_dir, exist_ok=True)
                
                unique_filename = f"{uuid.uuid4().hex}_{filename}"
                file_path = f"attendance_photos/{unique_filename}"
                
                if hasattr(image_data, 'read'):
                    image_data.seek(0)
                    image_content = image_data.read()
                else:
                    image_content = image_data
                
                saved_path = default_storage.save(file_path, ContentFile(image_content))
                file_url = default_storage.url(saved_path)
                
                base_url = getattr(settings, 'SITE_URL', 'http://localhost:8000')
                if base_url.endswith('/'):
                    base_url = base_url[:-1]
                if file_url.startswith('/'):
                    file_url = file_url[1:]
                
                full_url = f"{base_url}/{file_url}"
                
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
drive_oauth_service = GoogleDriveOAuthService()