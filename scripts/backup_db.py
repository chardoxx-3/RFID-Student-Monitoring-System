import os
import django
from datetime import datetime
import subprocess
from django.conf import settings

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.production')
django.setup()

from attendance_app.models import SystemLog

def backup_database():
    backup_dir = os.path.join(settings.MEDIA_ROOT, 'backups')
    os.makedirs(backup_dir, exist_ok=True)
    
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    backup_file = os.path.join(backup_dir, f'db_backup_{timestamp}.json')
    
    try:
        # Create backup using dumpdata
        with open(backup_file, 'w') as f:
            result = subprocess.run(
                ['python', 'manage.py', 'dumpdata', '--exclude=contenttypes', '--exclude=auth.Permission'],
                stdout=f,
                stderr=subprocess.PIPE,
                text=True
            )
        
        if result.returncode == 0:
            # Log successful backup
            file_size = os.path.getsize(backup_file) / (1024 * 1024)  # in MB
            SystemLog.objects.create(
                log_type='info',
                message='Database backup completed',
                details=f"Backup file: {backup_file}, Size: {file_size:.2f} MB"
            )
            print(f"Backup successful: {backup_file}")
            return True
        else:
            raise Exception(result.stderr)
            
    except Exception as e:
        SystemLog.objects.create(
            log_type='error',
            message='Database backup failed',
            details=str(e)
        )
        print(f"Backup failed: {str(e)}")
        return False

if __name__ == "__main__":
    backup_database()