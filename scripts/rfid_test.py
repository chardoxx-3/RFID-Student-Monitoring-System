import os
import django
import time

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.development')
django.setup()

from attendance_app.rfid_reader import RFIDReader

def test_rfid_reader():
    print("Initializing RFID Reader...")
    reader = RFIDReader()
    
    try:
        print("Ready to scan RFID tags. Press Ctrl+C to exit.")
        while True:
            print("\nWaiting for RFID tag...")
            tag_id = reader.read_tag()
            
            if tag_id:
                print(f"Tag detected: {tag_id}")
                
                # Test writing to tag
                if input("Write to tag? (y/n): ").lower() == 'y':
                    data = input("Enter data to write: ")
                    if data:
                        print("Writing to tag...")
                        result = reader.write_tag(data)
                        if result:
                            print("Write successful")
                        else:
                            print("Write failed")
            else:
                print("No tag detected or read error")
            
            time.sleep(1)
            
    except KeyboardInterrupt:
        print("\nExiting...")
    finally:
        reader.cleanup()

if __name__ == "__main__":
    test_rfid_reader()