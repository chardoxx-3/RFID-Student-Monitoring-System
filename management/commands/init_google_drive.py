# management/commands/init_google_drive.py
from django.core.management.base import BaseCommand
from attendance_app.google_drive import drive_service

class Command(BaseCommand):
    help = 'Initialize Google Drive service'
    
    def handle(self, *args, **options):
        if drive_service.service:
            self.stdout.write(
                self.style.SUCCESS('Google Drive service initialized successfully')
            )
        else:
            self.stdout.write(
                self.style.ERROR('Failed to initialize Google Drive service')
            )