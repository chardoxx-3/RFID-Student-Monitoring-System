from django.test import TestCase
from unittest.mock import patch, MagicMock
from attendance_app.rfid_reader import RFIDReader
from django.conf import settings

class RFIDReaderTests(TestCase):
    @patch('RPi.GPIO', MagicMock())
    @patch('mfrc522.SimpleMFRC522', MagicMock())
    def test_hardware_initialization(self):
        # Test hardware initialization when not in debug mode
        with self.settings(DEBUG=False):
            reader = RFIDReader()
            self.assertIsNotNone(reader.reader)
            reader.cleanup()

    def test_simulation_initialization(self):
        # Test simulation mode in debug
        with self.settings(DEBUG=True):
            reader = RFIDReader()
            self.assertIsNone(reader.reader)
            reader.cleanup()

    @patch('RPi.GPIO', MagicMock())
    @patch('mfrc522.SimpleMFRC522')
    def test_read_tag_hardware(self, mock_reader):
        # Test reading tag with hardware
        mock_instance = mock_reader.return_value
        mock_instance.read.return_value = (123, "Test Tag")
        
        with self.settings(DEBUG=False):
            reader = RFIDReader()
            tag_id = reader.read_tag()
            self.assertEqual(tag_id, "123")
            reader.cleanup()

    def test_read_tag_simulation(self):
        # Test reading tag in simulation mode
        with self.settings(DEBUG=True):
            reader = RFIDReader()
            tag_id = reader.read_tag()
            self.assertEqual(tag_id, "123456789")
            reader.cleanup()

    @patch('RPi.GPIO', MagicMock())
    @patch('mfrc522.SimpleMFRC522')
    def test_write_tag_hardware(self, mock_reader):
        # Test writing tag with hardware
        mock_instance = mock_reader.return_value
        mock_instance.write.return_value = True
        
        with self.settings(DEBUG=False):
            reader = RFIDReader()
            result = reader.write_tag("Test Data")
            self.assertEqual(result, "123456789")
            reader.cleanup()

    def test_write_tag_simulation(self):
        # Test writing tag in simulation mode
        with self.settings(DEBUG=True):
            reader = RFIDReader()
            result = reader.write_tag("Test Data")
            self.assertEqual(result, "123456789")
            reader.cleanup()

    @patch('RPi.GPIO', MagicMock())
    @patch('mfrc522.SimpleMFRC522')
    def test_cleanup(self, mock_reader):
        # Test cleanup method
        mock_instance = mock_reader.return_value
        
        with self.settings(DEBUG=False):
            reader = RFIDReader()
            reader.cleanup()
            mock_instance.cleanup.assert_called_once()