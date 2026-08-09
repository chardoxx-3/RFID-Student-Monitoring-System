import os
import ssl
import certifi

# Fix SSL certificate path
os.environ['SSL_CERT_FILE'] = certifi.where()
os.environ['REQUESTS_CA_BUNDLE'] = certifi.where()

# Force SSL context to use our certificates
ssl._create_default_https_context = ssl._create_default_https_context


from .base import *
import ssl
import os

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['localhost', '127.0.0.1']

# Database (unchanged)
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'rfid_student_db',
        'USER': 'root',
        'PASSWORD': '',
        'HOST': 'localhost',
        'PORT': '3306',
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
            'charset': 'utf8mb4',
        }
    }
}

# ===== EMAIL CONFIGURATION (UPDATED FOR MAILTRAP) =====
# development.py - Add these imports and settings at the TOP


# DISABLE SSL VERIFICATION FOR DEVELOPMENT
ssl._create_default_https_context = ssl._create_unverified_context
os.environ['PYTHONHTTPSVERIFY'] = '0'

# EMAIL CONFIGURATION
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = os.getenv('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.getenv('EMAIL_HOST_PASSWORD')
DEFAULT_FROM_EMAIL = os.getenv('DEFAULT_FROM_EMAIL')

# Force disable SSL verification for email
EMAIL_USE_SSL = False
EMAIL_SSL_CERTFILE = None
EMAIL_SSL_KEYFILE = None

# Debug toolbar (unchanged)
INSTALLED_APPS += ['debug_toolbar']
MIDDLEWARE += ['debug_toolbar.middleware.DebugToolbarMiddleware']
INTERNAL_IPS = ['127.0.0.1']

# Static files (unchanged)
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'static'),
]

# Logging (unchanged)
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'DEBUG',
    },
}

# Google OAuth 2.0 Configuration for Personal Account
GOOGLE_OAUTH2_CLIENT_ID = os.getenv('GOOGLE_OAUTH2_CLIENT_ID')
GOOGLE_OAUTH2_CLIENT_SECRET = os.getenv('GOOGLE_OAUTH2_CLIENT_SECRET')
GOOGLE_OAUTH2_REDIRECT_URI = os.getenv('GOOGLE_OAUTH2_REDIRECT_URI')
GOOGLE_DRIVE_FOLDER_ID = os.getenv('GOOGLE_DRIVE_FOLDER_ID', '1WnKqODKuLmyto2E82_PsPMdJDuw2tDVn')

# RFID settings (unchanged)
RFID_SIMULATION_MODE = True