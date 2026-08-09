from celery import shared_task
from django.utils import timezone
from .models import Student, AttendanceRecord
from .utils import send_attendance_email
import logging

logger = logging.getLogger(__name__)

@shared_task
def send_daily_absence_notifications():
    """Send notifications to parents of absent students"""
    try:
        today = timezone.now().date()
        present_students = AttendanceRecord.objects.filter(
            date=today
        ).values_list('student_id', flat=True)
        
        absent_students = Student.objects.exclude(
            id__in=present_students
        ).filter(
            guardian_email__isnull=False
        )
        
        for student in absent_students:
            # Create an absent record
            record = AttendanceRecord.objects.create(
                student=student,
                date=today,
                status='absent'
            )
            
            # Send notification
            send_attendance_email(student, record, 'time_in')
            
        return f"Sent {absent_students.count()} absence notifications"
        
    except Exception as e:
        logger.error(f"Error sending absence notifications: {e}")
        raise

@shared_task
def cleanup_old_attendance_records():
    """Delete attendance records older than 1 year"""
    try:
        one_year_ago = timezone.now() - timezone.timedelta(days=365)
        deleted_count, _ = AttendanceRecord.objects.filter(
            date__lt=one_year_ago
        ).delete()
        
        return f"Deleted {deleted_count} old attendance records"
        
    except Exception as e:
        logger.error(f"Error cleaning up old attendance records: {e}")
        raise

@shared_task
def backup_database():
    """Create a database backup"""
    try:
        from django.conf import settings
        from django.core.management import call_command
        import os
        import datetime
        
        backup_dir = os.path.join(settings.MEDIA_ROOT, 'backups')
        os.makedirs(backup_dir, exist_ok=True)
        
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_file = os.path.join(backup_dir, f'backup_{timestamp}.json')
        
        with open(backup_file, 'w') as f:
            call_command('dumpdata', exclude=['contenttypes', 'auth.permission'], stdout=f)
        
        return f"Database backup created: {backup_file}"
        
    except Exception as e:
        logger.error(f"Error creating database backup: {e}")
        raise