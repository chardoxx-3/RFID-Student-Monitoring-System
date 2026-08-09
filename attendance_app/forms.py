from django import forms
from django.contrib.auth.forms import UserCreationForm, PasswordChangeForm
from django.core.exceptions import ValidationError
from .models import (
    Course, Section, Student,
    SystemSettings, EmailSettings, Institute  # Add Institute here
)
from django.contrib.auth import get_user_model

User = get_user_model()

# In forms.py, add InstituteForm

class InstituteForm(forms.ModelForm):
    class Meta:
        model = Institute
        fields = ['code', 'name', 'description']
        widgets = {
            'description': forms.Textarea(attrs={'rows': 3}),
        }

# Update CourseForm to include institute field
class CourseForm(forms.ModelForm):
    class Meta:
        model = Course
        fields = ['code', 'name', 'description', 'institute']  # Add institute field
        widgets = {
            'description': forms.Textarea(attrs={'rows': 3}),
        }

class SectionForm(forms.ModelForm):
    class Meta:
        model = Section
        fields = ['name', 'course', 'year_level']

class StudentForm(forms.ModelForm):
    class Meta:
        model = Student
        fields = [
            'student_id', 'rfid_tag', 'first_name', 'last_name',
            'birthday', 'gender', 'year_level', 'section',
            'email', 'address', 'guardian_name', 'guardian_email', 'photo'
        ]
        widgets = {
            'birthday': forms.DateInput(attrs={'type': 'date'}),
            'address': forms.Textarea(attrs={'rows': 2}),
        }

class StudentImportForm(forms.Form):
    excel_file = forms.FileField(label='Excel File', help_text='Please upload an Excel file (.xlsx or .xls format)')
    update_existing = forms.BooleanField(
        label='Update existing students', 
        required=False,
        help_text='Check this to update existing student records'
    )

class SystemSettingsForm(forms.ModelForm):
    class Meta:
        model = SystemSettings
        fields = ['system_title', 'footer_text', 'logo']

class EmailSettingsForm(forms.ModelForm):
    smtp_password = forms.CharField(widget=forms.PasswordInput(render_value=True))
    
    class Meta:
        model = EmailSettings
        fields = '__all__'
        widgets = {
            'time_in_template': forms.Textarea(attrs={'rows': 5}),
            'time_out_template': forms.Textarea(attrs={'rows': 5}),
            'smtp_password': forms.PasswordInput(render_value=True),
        }

class TestEmailForm(forms.Form):
    test_email = forms.EmailField(required=True)
    test_type = forms.ChoiceField(
        choices=[('time_in', 'Time-In'), ('time_out', 'Time-Out')],
        required=True
    )

class UserRegistrationForm(UserCreationForm):
    email = forms.EmailField(required=True)
    first_name = forms.CharField(max_length=30, required=True)
    last_name = forms.CharField(max_length=30, required=True)

    class Meta:
        model = User
        fields = ['username', 'first_name', 'last_name', 'email', 'password1', 'password2']

    def clean_email(self):
        email = self.cleaned_data['email']
        if User.objects.filter(email=email).exists():
            raise ValidationError("This email address is already in use.")
        return email

class ProfileUpdateForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email']

class CustomPasswordChangeForm(PasswordChangeForm):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field in self.fields.values():
            field.widget.attrs.update({'class': 'form-control'})