# context_processors.py
from .models import SystemSettings
# context_processors.py
from .models import Institute

def institutes_context(request):
    institutes = Institute.objects.all().order_by('code')
    return {'institutes': institutes}

def system_settings(request):
    settings, created = SystemSettings.objects.get_or_create(pk=1)
    return {'system_settings': settings}

def google_drive_status(request):
    """Check Google Drive authentication status"""
    try:
        from .google_drive_oauth import drive_oauth_service
        
        # Check if we have valid credentials
        is_authenticated = drive_oauth_service.is_authenticated()
        
        # If not authenticated, try to initialize service
        if not is_authenticated:
            drive_oauth_service.initialize_service()
            is_authenticated = drive_oauth_service.is_authenticated()
        
        return {
            'drive_authenticated': is_authenticated,
            'drive_service': drive_oauth_service
        }
    except ImportError:
        return {
            'drive_authenticated': False,
            'drive_error': 'Google Drive module not available'
        }