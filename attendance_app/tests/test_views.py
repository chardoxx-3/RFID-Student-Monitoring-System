from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth import get_user_model
from django.core.files.uploadedfile import SimpleUploadedFile
from attendance_app.models import (
    Course, Section, Student,
    AttendanceRecord, SystemSettings,
    EmailSettings
)
import tempfile
import xlwt

User = get_user_model()

class AuthenticationTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(
            username='admin',
            password='password123',
            email='admin@example.com'
        )
        self.login_url = reverse('login')
        self.dashboard_url = reverse('admin_dashboard')

    def test_login_view(self):
        response = self.client.get(self.login_url)
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, 'attendance_app/login.html')

    def test_successful_login(self):
        response = self.client.post(
            self.login_url,
            {'username': 'admin', 'password': 'password123'}
        )
        self.assertRedirects(response, self.dashboard_url)

    def test_failed_login(self):
        response = self.client.post(
            self.login_url,
            {'username': 'admin', 'password': 'wrongpassword'}
        )
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Invalid username or password')

class AdminViewTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(
            username='admin',
            password='password123'
        )
        self.client.login(username='admin', password='password123')
        
        self.course = Course.objects.create(
            code="CS101",
            name="Computer Science"
        )
        self.section = Section.objects.create(
            name="A",
            course=self.course,
            year_level=1
        )
        self.student = Student.objects.create(
            student_id="2023-001",
            first_name="John",
            last_name="Doe",
            year_level=1,
            section=self.section
        )

    def test_dashboard_view(self):
        response = self.client.get(reverse('admin_dashboard'))
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, 'attendance_app/admin/dashboard.html')

    def test_course_list_view(self):
        response = self.client.get(reverse('courses'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Computer Science")

    def test_add_course_view(self):
        response = self.client.post(
            reverse('add_course'),
            {'code': 'CS102', 'name': 'Programming', 'description': 'Intro to Programming'}
        )
        self.assertRedirects(response, reverse('courses'))
        self.assertTrue(Course.objects.filter(code='CS102').exists())

    def test_student_import_view(self):
        # Create a test Excel file
        wb = xlwt.Workbook()
        ws = wb.add_sheet('Students')
        
        # Write headers
        headers = ['student_id', 'first_name', 'last_name', 'year_level', 'section']
        for col, header in enumerate(headers):
            ws.write(0, col, header)
        
        # Write data
        ws.write(1, 0, '2023-002')
        ws.write(1, 1, 'Jane')
        ws.write(1, 2, 'Smith')
        ws.write(1, 3, 1)
        ws.write(1, 4, 'A')
        
        # Save to temp file
        with tempfile.NamedTemporaryFile(suffix='.xls') as tmp:
            wb.save(tmp.name)
            tmp.seek(0)
            
            response = self.client.post(
                reverse('import_students'),
                {'excel_file': tmp, 'update_existing': False}
            )
        
        self.assertRedirects(response, reverse('students'))
        self.assertTrue(Student.objects.filter(student_id='2023-002').exists())

    def test_attendance_kiosk_view(self):
        response = self.client.get(reverse('kiosk'))
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, 'attendance_app/kiosk.html')

class KioskAPITests(TestCase):
    def setUp(self):
        self.client = Client()
        self.course = Course.objects.create(code="CS101", name="Computer Science")
        self.section = Section.objects.create(
            name="A",
            course=self.course,
            year_level=1
        )
        self.student = Student.objects.create(
            student_id="2023-001",
            first_name="John",
            last_name="Doe",
            year_level=1,
            section=self.section,
            rfid_tag="123456789"
        )
        self.api_url = reverse('log_attendance', args=['123456789'])

    def test_log_attendance(self):
        response = self.client.post(self.api_url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['success'], True)
        self.assertTrue(AttendanceRecord.objects.filter(student=self.student).exists())

    def test_log_attendance_invalid_rfid(self):
        response = self.client.post(reverse('log_attendance', args=['999999999']))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['success'], False)

class SettingsViewTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(
            username='admin',
            password='password123'
        )
        self.client.login(username='admin', password='password123')
        
        # Initialize settings
        SystemSettings.objects.create(
            system_title="Test System",
            footer_text="Test Footer"
        )
        EmailSettings.objects.create(
            time_in_subject="Test Subject",
            smtp_host="smtp.example.com"
        )

    def test_system_settings_view(self):
        response = self.client.get(reverse('system_settings'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Test System")

    def test_update_system_settings(self):
        response = self.client.post(
            reverse('system_settings'),
            {
                'system_title': 'Updated System',
                'footer_text': 'Updated Footer'
            }
        )
        self.assertRedirects(response, reverse('system_settings'))
        self.assertEqual(SystemSettings.objects.first().system_title, "Updated System")

    def test_email_settings_view(self):
        response = self.client.get(reverse('email_settings'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Test Subject")