from django.urls import path
from attendance_app.views import google_drive_auth, google_drive_callback, google_drive_status, google_drive_disconnect
from . import views

urlpatterns = [


    # Authentication
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('register/', views.register_view, name='register'),

    path('institutes/', views.institute_list, name='institutes'),
    path('institutes/add/', views.add_institute, name='add_institute'),
    path('institutes/edit/', views.edit_institute, name='edit_institute'),
    path('institutes/delete/<int:institute_id>/', views.delete_institute, name='delete_institute'),
    path('courses/<int:institute_id>/', views.course_list, name='view_courses'),
    # Add to urls.py
    path('api/courses/<int:institute_id>/', views.get_courses_by_institute, name='get_courses_by_institute'),# Add to urls.py
    path('api/institutes/', views.get_institutes, name='get_institutes'),
    
    # Admin Views
    path('', views.admin_dashboard, name='admin_dashboard'),
    path('courses/', views.course_list, name='courses'),
    path('courses/add/', views.add_course, name='add_course'),
    path('courses/edit/', views.edit_course, name='edit_course'),
    path('courses/delete/<int:course_id>/', views.delete_course, name='delete_course'),
    path('sections/<int:course_id>/', views.section_list, name='view_sections'),
    path('sections/add/<int:course_id>/', views.add_section, name='add_section'),
    path('sections/edit/<int:section_id>/', views.edit_section, name='edit_section'),
    path('sections/delete/<int:section_id>/', views.delete_section, name='delete_section'),
    
    # Student Management
    path('students/', views.student_list, name='students'),
    path('students/add/', views.add_student, name='add_student'),
    path('students/edit/', views.edit_student, name='edit_student'),
    path('students/delete/<int:student_id>/', views.delete_student, name='delete_student'),
    path('students/import/', views.import_students, name='import_students'),
    path('students/export/', views.export_students, name='export_students'),
    path('students/delete-all/', views.delete_all_students, name='delete_all_students'),
    path('students/clear-import-errors/', views.clear_import_errors, name='clear_import_errors'),
    path('students/print/', views.print_students_report, name='print_students_report'),

    # Reports
    path('reports/', views.attendance_reports, name='reports'),
    path('reports/chart-data/', views.attendance_chart_data, name='attendance_chart_data'),
    path('reports/export/', views.export_attendance, name='export_attendance'),
    path('reports/print/', views.print_attendance_report, name='print_attendance_report'),
    
    # Settings
    path('settings/', views.settings_view, name='settings'),
    path('reports/', views.attendance_reports, name='attendance_reports'),
    path('settings/profile/', views.profile_settings, name='profile_settings'),
    path('settings/email/', views.email_settings, name='email_settings'),
    path('settings/system/', views.system_settings, name='system_settings'),
    path('settings/change-password/', views.change_password, name='change_password'),
    path('settings/send-test-email/', views.send_test_email, name='send_test_email'),
    # In your urls.py
path('api/rfid-student-map/', views.rfid_student_map, name='rfid_student_map'),
    
    # Kiosk
    path('kiosk/', views.attendance_kiosk, name='kiosk'),
    path('api/attendance/log/<str:rfid_tag>/', views.log_attendance, name='log_attendance'),
    path('api/kiosk/attendance/', views.kiosk_attendance_records, name='kiosk_attendance'),
    path('api/attendance/log/<str:rfid_tag>/quick/', views.log_attendance_quick, name='log_attendance_quick'),

    path('api/students/rfid_map/', views.rfid_student_map, name='rfid_student_map'),

    path('api/attendance/process_pending_emails/', views.process_pending_emails, name='process_pending_emails'),

    
    # API Endpoints
    path('api/sections/<int:year_level>/', views.get_sections_by_year, name='get_sections_by_year'),

    path('auth/google-drive/', google_drive_auth, name='google_drive_auth'),
    path('oauth2callback/', google_drive_callback, name='google_drive_callback'),
    path('api/google-drive-status/', google_drive_status, name='google_drive_status'),

    path('debug/drive-cache/', views.debug_drive_cache, name='debug_drive_cache'),
    path('debug/drive-auth/', views.debug_drive_auth, name='debug_drive_auth'), 

    
    path('auth/google-drive/disconnect/', google_drive_disconnect, name='google_drive_disconnect'),
        path('forgot-password/', views.forgot_password_view, name='forgot_password'),
    path('verify-otp/', views.verify_otp_view, name='verify_otp'),
    path('reset-password/', views.reset_password_view, name='reset_password'),


]