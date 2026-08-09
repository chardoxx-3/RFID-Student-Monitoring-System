from django.apps import AppConfig

class AttendanceAppConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'attendance_app'
    
    def ready(self):
        # Import signals
        import attendance_app.signals