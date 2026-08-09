from django.contrib import admin
from .models import (
    Course, Section, Student, 
    AttendanceRecord, SystemSettings,
    EmailSettings, SystemLog, Institute  # Add Institute here
)

class InstituteAdmin(admin.ModelAdmin):
    list_display = ('code', 'name', 'description')
    search_fields = ('code', 'name')
    list_per_page = 20

# Register the Institute model
admin.site.register(Institute, InstituteAdmin)

class CourseAdmin(admin.ModelAdmin):
    list_display = ('code', 'name', 'description')
    search_fields = ('code', 'name')
    list_per_page = 20

class SectionAdmin(admin.ModelAdmin):
    list_display = ('name', 'course', 'year_level', 'student_count')
    list_filter = ('course', 'year_level')
    search_fields = ('name', 'course__name')
    list_per_page = 20
    
    def student_count(self, obj):
        return obj.student_set.count()
    student_count.short_description = 'Students'

class StudentAdmin(admin.ModelAdmin):
    list_display = ('student_id', 'full_name', 'section', 'year_level', 'rfid_tag')
    list_filter = ('section__course', 'section', 'year_level')
    search_fields = ('student_id', 'first_name', 'last_name', 'rfid_tag')
    list_per_page = 20
    readonly_fields = ('photo_preview',)
    
    def full_name(self, obj):
        return obj.full_name
    full_name.short_description = 'Name'
    
    def photo_preview(self, obj):
        if obj.photo:
            return obj.photo.url
        return "No photo"
    photo_preview.short_description = 'Photo Preview'

# admin.py - Update the AttendanceRecordAdmin
class AttendanceRecordAdmin(admin.ModelAdmin):
    list_display = ('student', 'date', 'morning_in', 'morning_out', 'afternoon_in', 'afternoon_out')
    list_filter = ('date', 'student__section')
    search_fields = ('student__first_name', 'student__last_name', 'student__student_id')
    list_per_page = 50
    date_hierarchy = 'date'
    
    # Add readonly fields to show photo URLs
    readonly_fields = ('morning_in_photo_url', 'morning_out_photo_url', 
                      'afternoon_in_photo_url', 'afternoon_out_photo_url')
    
class SystemSettingsAdmin(admin.ModelAdmin):
    def has_add_permission(self, request):
        return False if self.model.objects.count() > 0 else super().has_add_permission(request)

class EmailSettingsAdmin(admin.ModelAdmin):
    def has_add_permission(self, request):
        return False if self.model.objects.count() > 0 else super().has_add_permission(request)

class SystemLogAdmin(admin.ModelAdmin):
    list_display = ('timestamp', 'log_type', 'message')
    list_filter = ('log_type',)
    search_fields = ('message',)
    readonly_fields = ('timestamp',)
    date_hierarchy = 'timestamp'
    list_per_page = 50

admin.site.register(Course, CourseAdmin)
admin.site.register(Section, SectionAdmin)
admin.site.register(Student, StudentAdmin)
admin.site.register(AttendanceRecord, AttendanceRecordAdmin)
admin.site.register(SystemSettings, SystemSettingsAdmin)
admin.site.register(EmailSettings, EmailSettingsAdmin)
admin.site.register(SystemLog, SystemLogAdmin)