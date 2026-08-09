import os
import django
import xlrd
from datetime import datetime

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.production')
django.setup()

from attendance_app.models import Student, Section
from django.core.exceptions import ValidationError

def import_students_from_excel(file_path, update_existing=False):
    """
    Import students from Excel file
    Format:
    - student_id (required)
    - first_name (required)
    - last_name (required)
    - year_level (required, 1-4)
    - section (required, section name)
    - rfid_tag (optional)
    - email (optional)
    - guardian_email (optional)
    - birthday (optional, YYYY-MM-DD format)
    """
    try:
        workbook = xlrd.open_workbook(file_path)
        sheet = workbook.sheet_by_index(0)
        
        # Get headers
        headers = [sheet.cell_value(0, col) for col in range(sheet.ncols)]
        
        required_columns = ['student_id', 'first_name', 'last_name', 'year_level', 'section']
        for col in required_columns:
            if col not in headers:
                print(f"Error: Missing required column '{col}'")
                return False
        
        imported = 0
        updated = 0
        skipped = 0
        errors = 0
        
        for row in range(1, sheet.nrows):
            try:
                row_data = dict(zip(headers, [sheet.cell_value(row, col) for col in range(sheet.ncols)]))
                
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
                    print(f"Skipping row {row+1}: Section '{section_name}' not found for year {year_level}")
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
                print(f"Error processing row {row+1}: {str(e)}")
                errors += 1
                continue
        
        print(f"Import completed: {imported} imported, {updated} updated, {skipped} skipped, {errors} errors")
        return True
        
    except Exception as e:
        print(f"Error processing file: {str(e)}")
        return False

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description='Import students from Excel file')
    parser.add_argument('file_path', help='Path to Excel file')
    parser.add_argument('--update', action='store_true', help='Update existing students')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.file_path):
        print("Error: File not found")
    else:
        import_students_from_excel(args.file_path, args.update)