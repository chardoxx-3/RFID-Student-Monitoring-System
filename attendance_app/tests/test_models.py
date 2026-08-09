from django.test import TestCase
from django.core.files.uploadedfile import SimpleUploadedFile
from django.core.exceptions import ValidationError
from attendance_app.models import (
    Course, Section, Student,
    AttendanceRecord, SystemSettings,
    EmailSettings
)
import os
from datetime import date, time

class CourseModelTest(TestCase):
    def setUp(self):
        self.course = Course.objects.create(
            code="CS101",
            name="Computer Science",
            description="Intro to CS"
        )

    def test_course_creation(self):
        self.assertEqual(self.course.code, "CS101")
        self.assertEqual(self.course.name, "Computer Science")
        self.assertEqual(str(self.course), "CS101 - Computer Science")

    def test_course_unique_code(self):
        with self.assertRaises(Exception):
            Course.objects.create(
                code="CS101",
                name="Another Course",
                description="Test"
            )

class SectionModelTest(TestCase):
    def setUp(self):
        self.course = Course.objects.create(
            code="CS101",
            name="Computer Science"
        )
        self.section = Section.objects.create(
            name="A",
            course=self.course,
            year_level=1
        )

    def test_section_creation(self):
        self.assertEqual(self.section.name, "A")
        self.assertEqual(self.section.course, self.course)
        self.assertEqual(self.section.year_level, 1)
        self.assertEqual(str(self.section), "CS101 - A (Year 1)")

    def test_section_unique_together(self):
        with self.assertRaises(Exception):
            Section.objects.create(
                name="A",
                course=self.course,
                year_level=1
            )

class StudentModelTest(TestCase):
    def setUp(self):
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
            section=self.section
        )

    def test_student_creation(self):
        self.assertEqual(self.student.student_id, "2023-001")
        self.assertEqual(self.student.full_name, "John Doe")
        self.assertEqual(str(self.student), "2023-001 - John Doe")

    def test_student_photo_upload(self):
        photo = SimpleUploadedFile(
            "test.jpg",
            b"file_content",
            content_type="image/jpeg"
        )
        self.student.photo = photo
        self.student.save()
        self.assertTrue(self.student.photo.name.startswith('student_photos/'))
        
        # Clean up
        if os.path.exists(self.student.photo.path):
            os.remove(self.student.photo.path)

    def test_student_unique_id(self):
        with self.assertRaises(Exception):
            Student.objects.create(
                student_id="2023-001",
                first_name="Jane",
                last_name="Smith",
                year_level=1,
                section=self.section
            )

class AttendanceRecordModelTest(TestCase):
    def setUp(self):
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
            section=self.section
        )
        self.record = AttendanceRecord.objects.create(
            student=self.student,
            date=date.today(),
            time_in=time(8, 0),
            status="present"
        )

    def test_attendance_creation(self):
        self.assertEqual(self.record.student, self.student)
        self.assertEqual(self.record.date, date.today())
        self.assertEqual(self.record.time_in, time(8, 0))
        self.assertEqual(str(self.record), "2023-001 - John Doe - 2023-10-01")

    def test_attendance_unique_together(self):
        with self.assertRaises(Exception):
            AttendanceRecord.objects.create(
                student=self.student,
                date=date.today(),
                time_in=time(9, 0),
                status="present"
            )

class SystemSettingsModelTest(TestCase):
    def test_single_system_settings(self):
        settings1 = SystemSettings.objects.create(
            system_title="System 1",
            footer_text="Footer 1"
        )
        settings2 = SystemSettings.objects.create(
            system_title="System 2",
            footer_text="Footer 2"
        )
        
        # Should only have one settings object
        self.assertEqual(SystemSettings.objects.count(), 1)
        self.assertEqual(SystemSettings.objects.first().system_title, "System 1")

class EmailSettingsModelTest(TestCase):
    def test_single_email_settings(self):
        settings1 = EmailSettings.objects.create(
            time_in_subject="Subject 1",
            smtp_host="smtp1.example.com"
        )
        settings2 = EmailSettings.objects.create(
            time_in_subject="Subject 2",
            smtp_host="smtp2.example.com"
        )
        
        # Should only have one settings object
        self.assertEqual(EmailSettings.objects.count(), 1)
        self.assertEqual(EmailSettings.objects.first().time_in_subject, "Subject 1")