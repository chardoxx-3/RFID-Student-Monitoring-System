import os
import django
from django.core.mail import send_mail
from django.conf import settings

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.production')
django.setup()

from attendance_app.models import EmailSettings, SystemLog

def test_email_config():
    email_settings = EmailSettings.objects.first()
    if not email_settings:
        print("Email settings not configured")
        return False
    
    try:
        send_mail(
            subject='Test Email from CPSC Monitoring System',
            message='This is a test email to verify email configuration.',
            from_email=f"{email_settings.from_name} <{email_settings.from_email}>",
            recipient_list=[email_settings.from_email],
            fail_silently=False,
            auth_user=email_settings.smtp_username,
            auth_password=email_settings.smtp_password,
            connection=None
        )
        
        SystemLog.objects.create(
            log_type='info',
            message='Test email sent successfully',
            details=f"Sent to: {email_settings.from_email}"
        )
        print("Test email sent successfully")
        return True
        
    except Exception as e:
        SystemLog.objects.create(
            log_type='error',
            message='Test email failed',
            details=str(e)
        )
        print(f"Failed to send test email: {str(e)}")
        return False

if __name__ == "__main__":
    test_email_config()