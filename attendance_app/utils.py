from django.core.mail import send_mail
from django.conf import settings
from django.template.loader import render_to_string
from django.utils import timezone
from .models import SystemLog, EmailSettings
import logging
import xlrd
from datetime import datetime
import os
from attendance_app.models import Student
from attendance_app.models import AttendanceRecord  # Add this line
from django.core import mail
from datetime import date, datetime  # Add this at the top
from django.db.models import Q  # Make sure this is imported
from django.template.loader import render_to_string
from django.utils import timezone
from .models import PasswordResetOTP
from datetime import timedelta

import logging
logger = logging.getLogger(__name__)

def send_attendance_email(student, record, email_type, photo_file=None, photo_filename=None):
    """Send attendance notification email to both student and parent with optional photo attachment"""
    try:
        email_settings = EmailSettings.objects.first()
        if not email_settings:
            logger.error("Email settings not configured")
            return False
        
        # 1. Prepare the time strings first
        time_in_str = (
            record.morning_in.strftime('%I:%M %p') if record.morning_in 
            else record.afternoon_in.strftime('%I:%M %p') if record.afternoon_in 
            else '--:--'
        )
        
        time_out_str = (
            record.morning_out.strftime('%I:%M %p') if record.morning_out 
            else record.afternoon_out.strftime('%I:%M %p') if record.afternoon_out 
            else '--:--'
        )

        # 2. Create a Context Dictionary containing ALL variables
        # This makes every variable available to both Subject and Body
        context = {
            'guardian_name': student.guardian_name or "Parent/Guardian",
            'student_name': student.full_name,
            'student_id': student.student_id,
            'course': student.section.course.name if student.section and student.section.course else "N/A",
            'section': student.section.name if student.section else "N/A",
            'time_in': time_in_str,
            'time_out': time_out_str,
            'date': record.date.strftime('%B %d, %Y')
        }

        # 3. Determine Template and Format Subject/Body using the context
        if email_type == 'time_in':
            raw_subject = email_settings.time_in_subject
            template = email_settings.time_in_template
            # For time-in emails, force time_out to be empty or specific string if preferred
            context['time_out'] = '--:--' 
        else:
            raw_subject = email_settings.time_out_subject
            template = email_settings.time_out_template
            # For time-out emails, ensure time_in is populated (already done in step 1)

        # Apply variables to Subject
        try:
            subject = raw_subject.format(**context)
        except KeyError as e:
            # Fallback if user put a typo in the subject line settings
            logger.error(f"Variable error in subject line: {e}")
            subject = f"Attendance Notification for {context['student_name']}"

        # Apply variables to Body
        try:
            email_body = template.format(**context)
        except KeyError as e:
             logger.error(f"Variable error in email body: {e}")
             email_body = f"Attendance update for {context['student_name']}. Please check template settings."

        # 4. Prepare recipients
        recipients = []
        if student.email:
            recipients.append(student.email)
        if student.guardian_email:
            recipients.append(student.guardian_email)
        
        if not recipients:
            logger.warning(f"No email addresses found for {student.full_name}")
            return False
        
        # 5. Create Email Message
        email = mail.EmailMessage(
            subject=subject,
            body=email_body,
            from_email=f"{email_settings.from_name} <{email_settings.from_email}>",
            to=recipients,
        )
        
        # Attach photo if provided
        if photo_file and photo_filename:
            try:
                photo_file.seek(0)
                email.attach(
                    photo_filename,
                    photo_file.read(),
                    'image/jpeg'
                )
                logger.info(f"Photo attached to email: {photo_filename}")
            except Exception as e:
                logger.error(f"Error attaching photo to email: {e}")

        # Connection settings
        email.connection = mail.get_connection(
            username=email_settings.smtp_username,
            password=email_settings.smtp_password,
            host=email_settings.smtp_host,
            port=email_settings.smtp_port,
            use_tls=True
        )
        
        email.send()
        logger.info(f"Email sent successfully to {', '.join(recipients)}")
        return True
        
    except Exception as e:
        logger.error(f"Error sending attendance email: {e}")
        SystemLog.objects.create(
            log_type='error',
            message='Failed to send attendance email',
            details=str(e)
        )
        return False

def log_system_event(log_type, message, details=None):
    """Log system events to database"""
    SystemLog.objects.create(
        log_type=log_type,
        message=message,
        details=details
    )

def process_student_import(file_path, update_existing=False):
    """Process imported student data from Excel file"""
    try:
        workbook = xlrd.open_workbook(file_path)
        sheet = workbook.sheet_by_index(0)
        
        # Get headers
        headers = [sheet.cell_value(0, col) for col in range(sheet.ncols)]
        
        required_columns = ['student_id', 'first_name', 'last_name', 'year_level', 'section']
        for col in required_columns:
            if col not in headers:
                raise ValueError(f"Missing required column: {col}")
        
        # Process rows
        imported = 0
        updated = 0
        skipped = 0
        
        for row in range(1, sheet.nrows):
            try:
                row_data = dict(zip(headers, [sheet.cell_value(row, col) for col in range(sheet.ncols)]))
                
                # Get or create student
                student_id = str(row_data['student_id']).strip()
                if not student_id:
                    skipped += 1
                    continue
                
                # Get section
                section_name = str(row_data['section']).strip()
                year_level = int(row_data['year_level'])
                
                section = Section.objects.filter(
                    name__iexact=section_name,
                    year_level=year_level
                ).first()
                
                if not section:
                    skipped += 1
                    continue
                
                # Prepare student data
                student_data = {
                    'student_id': student_id,
                    'first_name': str(row_data['first_name']).strip(),
                    'last_name': str(row_data['last_name']).strip(),
                    'year_level': year_level,
                    'section': section,
                }
                
                # Optional fields
                if 'rfid_tag' in row_data:
                    student_data['rfid_tag'] = str(row_data['rfid_tag']).strip() or None
                if 'email' in row_data:
                    student_data['email'] = str(row_data['email']).strip() or None
                if 'guardian_email' in row_data:
                    student_data['guardian_email'] = str(row_data['guardian_email']).strip() or None
                if 'birthday' in row_data:
                    try:
                        if isinstance(row_data['birthday'], float):
                            # Convert Excel date number to Python date
                            birthday = xlrd.xldate.xldate_as_datetime(row_data['birthday'], workbook.datemode)
                            student_data['birthday'] = birthday.date()
                        else:
                            student_data['birthday'] = datetime.strptime(row_data['birthday'], '%Y-%m-%d').date()
                    except (ValueError, TypeError):
                        student_data['birthday'] = None
                
                # Create or update student
                if update_existing:
                    student, created = Student.objects.update_or_create(
                        student_id=student_id,
                        defaults=student_data
                    )
                    if created:
                        imported += 1
                    else:
                        updated += 1
                else:
                    if not Student.objects.filter(student_id=student_id).exists():
                        Student.objects.create(**student_data)
                        imported += 1
                    else:
                        skipped += 1
                        
            except Exception as e:
                logger.error(f"Error processing row {row}: {e}")
                skipped += 1
                continue
        
        # Clean up
        os.remove(file_path)
        
        return {
            'success': True,
            'imported': imported,
            'updated': updated,
            'skipped': skipped
        }
        
    except Exception as e:
        logger.error(f"Error processing import file: {e}")
        if os.path.exists(file_path):
            os.remove(file_path)
        return {
            'success': False,
            'error': str(e)
        }

def get_dashboard_stats():
    today = date.today()
    
    # Get all attendance records for today
    today_records = AttendanceRecord.objects.filter(date=today)
    
    # Count present students (those with any time recorded)
    present_today = today_records.exclude(
        Q(morning_in__isnull=True) &
        Q(morning_out__isnull=True) &
        Q(afternoon_in__isnull=True) &
        Q(afternoon_out__isnull=True)
    ).count()
    
    # Count completed morning sessions (both in and out)
    morning_sessions = today_records.filter(
        morning_in__isnull=False,
        morning_out__isnull=False
    ).count()
    
    # Count completed afternoon sessions (both in and out)
    afternoon_sessions = today_records.filter(
        afternoon_in__isnull=False,
        afternoon_out__isnull=False
    ).count()
    
    return {
        'total_students': Student.objects.count(),
        'present_today': present_today,
        'absent_today': Student.objects.count() - present_today,
        'morning_sessions': morning_sessions,
        'afternoon_sessions': afternoon_sessions,
        'recent_logins': today_records.select_related('student')
            .order_by('-morning_in', '-afternoon_in')[:5]
    }

def generate_and_send_otp(user):
    """Generate OTP and send it to user via email using Admin SMTP Settings"""
    try:
        # 1. Fetch Email Settings from Database
        email_settings = EmailSettings.objects.first()
        if not email_settings:
            logger.error("Email settings not configured in Admin Panel")
            return None

        # 2. Generate OTP Logic
        otp_code = PasswordResetOTP.generate_otp()
        
        # CHANGED: Expiration set to 60 seconds
        expires_at = timezone.now() + timedelta(seconds=60)
        
        # Invalidate any existing OTPs for this user
        PasswordResetOTP.objects.filter(user=user, is_used=False).update(is_used=True)
        
        # Create new OTP
        otp_record = PasswordResetOTP.objects.create(
            user=user,
            otp_code=otp_code,
            expires_at=expires_at
        )
        
        # 3. Get system settings for Title
        from .models import SystemSettings
        system_settings = SystemSettings.objects.first()
        system_title ="Student Monitoring System"
        
        # 4. Prepare email content
        subject = f"{system_title} - Password Reset OTP"
        
        context = {
            'user': user,
            'otp_code': otp_code,
            'expires_minutes': 1, # Changed for template display logic (optional, mainly for text)
            'expires_seconds': 60, # Added for specific text
            'system_title': system_title,
            'current_year': timezone.now().year
        }
        
        email_body = render_to_string('attendance_app/emails/password_reset_otp.html', context)
        
        # ... rest of the email sending logic remains the same ...
        
        connection = mail.get_connection(
            host=email_settings.smtp_host,
            port=email_settings.smtp_port,
            username=email_settings.smtp_username,
            password=email_settings.smtp_password,
            use_tls=True
        )

        email = mail.EmailMessage(
            subject=subject,
            body=email_body,
            from_email=f"{email_settings.from_name} <{email_settings.from_email}>",
            to=[user.email],
            connection=connection
        )
        
        email.content_subtype = "html" 
        email.send()
        
        logger.info(f"OTP sent to {user.email} using configured SMTP settings")
        return otp_record
        
    except Exception as e:
        logger.error(f"Error sending OTP: {e}")
        return None

def verify_otp_and_reset_password(user, otp_code, new_password):
    """Verify OTP and reset password"""
    try:
        # Find valid OTP
        otp_record = PasswordResetOTP.objects.filter(
            user=user,
            otp_code=otp_code,
            is_used=False
        ).first()
        
        if not otp_record:
            return False, "Invalid OTP code"
        
        if not otp_record.is_valid():
            return False, "OTP has expired"
        
        # Reset password
        user.set_password(new_password)
        user.save()
        
        # Mark OTP as used
        otp_record.is_used = True
        otp_record.save()
        
        logger.info(f"Password reset successful for {user.username}")
        return True, "Password reset successful"
        
    except Exception as e:
        logger.error(f"Error resetting password: {e}")
        return False, str(e)