# attendance_app/password_reset_forms.py
from django import forms
from django.contrib.auth import get_user_model
from django.core.validators import validate_email
from .models import PasswordResetOTP
import re

User = get_user_model()

class ForgotPasswordForm(forms.Form):
    """Form for requesting password reset"""
    identifier = forms.CharField(
        max_length=255,
        required=True,
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'Enter your username or email',
            'autocomplete': 'username'
        })
    )
    
    def clean_identifier(self):
        identifier = self.cleaned_data.get('identifier')
        
        # Check if it's an email
        if '@' in identifier:
            try:
                validate_email(identifier)
                user = User.objects.filter(email=identifier).first()
                if not user:
                    raise forms.ValidationError("No account found with this email address.")
            except forms.ValidationError:
                user = User.objects.filter(username=identifier).first()
                if not user:
                    raise forms.ValidationError("No account found with this username.")
        else:
            # Check if it's a username
            user = User.objects.filter(username=identifier).first()
            if not user:
                # Try email as well (in case user enters email without @ by mistake)
                user = User.objects.filter(email=identifier).first()
                if not user:
                    raise forms.ValidationError("No account found with this username or email.")
        
        return identifier
    
    def get_user(self):
        identifier = self.cleaned_data.get('identifier')
        
        if '@' in identifier:
            return User.objects.filter(email=identifier).first()
        else:
            user = User.objects.filter(username=identifier).first()
            if not user:
                user = User.objects.filter(email=identifier).first()
            return user

class VerifyOTPForm(forms.Form):
    """Form for verifying OTP"""
    otp_code = forms.CharField(
        max_length=6,
        min_length=6,
        required=True,
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'Enter 6-digit OTP',
            'autocomplete': 'off',
            'inputmode': 'numeric',
            'pattern': '\d{6}'
        })
    )
    
    def __init__(self, *args, **kwargs):
        self.user = kwargs.pop('user', None)
        super().__init__(*args, **kwargs)
    
    def clean_otp_code(self):
        otp_code = self.cleaned_data.get('otp_code')
        
        # Check if OTP is 6 digits
        if not re.match(r'^\d{6}$', otp_code):
            raise forms.ValidationError("OTP must be exactly 6 digits.")
        
        # Find valid OTP for user
        otp_record = PasswordResetOTP.objects.filter(
            user=self.user,
            otp_code=otp_code,
            is_used=False
        ).first()
        
        if not otp_record:
            raise forms.ValidationError("Invalid OTP code.")
        
        if not otp_record.is_valid():
            raise forms.ValidationError("OTP has expired. Please request a new one.")
        
        return otp_code

class ResetPasswordForm(forms.Form):
    """Form for resetting password after OTP verification"""
    new_password = forms.CharField(
        widget=forms.PasswordInput(attrs={
            'class': 'form-control',
            'placeholder': 'Enter new password',
            'autocomplete': 'new-password'
        }),
        min_length=8,
        required=True
    )
    
    confirm_password = forms.CharField(
        widget=forms.PasswordInput(attrs={
            'class': 'form-control',
            'placeholder': 'Confirm new password',
            'autocomplete': 'new-password'
        }),
        required=True
    )
    
    def clean(self):
        cleaned_data = super().clean()
        new_password = cleaned_data.get('new_password')
        confirm_password = cleaned_data.get('confirm_password')
        
        if new_password and confirm_password and new_password != confirm_password:
            raise forms.ValidationError("Passwords do not match.")
        
        # Add password strength validation
        if new_password:
            # Check for minimum requirements
            if len(new_password) < 8:
                raise forms.ValidationError("Password must be at least 8 characters long.")
            
            # Check for complexity (optional, but recommended)
            if not any(char.isdigit() for char in new_password):
                raise forms.ValidationError("Password must contain at least one number.")
            
            if not any(char.isalpha() for char in new_password):
                raise forms.ValidationError("Password must contain at least one letter.")
        
        return cleaned_data