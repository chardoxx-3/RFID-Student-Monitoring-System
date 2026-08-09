import time
import logging
import serial
import serial.tools.list_ports
from django.conf import settings
from django.utils.deprecation import MiddlewareMixin

logger = logging.getLogger(__name__)

class RFIDMiddleware(MiddlewareMixin):
    def __init__(self, get_response=None):
        super().__init__(get_response)
        self.rfid_reader = RFIDReader()  # Initialize the RFID reader here
    
    def process_request(self, request):
        try:
            tag = self.rfid_reader.read_tag()
            if tag:
                request.rfid_tag = tag
        except Exception as e:
            logger.error(f"RFID read error: {str(e)}")
        return None

class RFIDReader:
    def __init__(self):
        self.reader = None
        self.port = None
        self.baudrate = 9600
        self.initialize_reader()
    
    def initialize_reader(self):
        """Initialize the USB RFID reader"""
        try:
            if not settings.DEBUG:
                # Find the correct COM port for the RFID reader
                self.port = self.find_rfid_port()
                if self.port:
                    self.reader = serial.Serial(
                        port=self.port,
                        baudrate=self.baudrate,
                        timeout=1
                    )
                    logger.info(f"USB RFID reader initialized on {self.port}")
                else:
                    logger.error("No RFID reader found")
                    self.reader = None
            else:
                # Simulation mode for development
                self.reader = None
                logger.info("RFID reader in simulation mode")
        except Exception as e:
            logger.error(f"Failed to initialize RFID reader: {e}")
            self.reader = None
    
    def find_rfid_port(self):
        """Try to find the correct COM port for the RFID reader"""
        ports = serial.tools.list_ports.comports()
        for port in ports:
            # Try to match common USB RFID reader descriptions
            if 'USB' in port.description or 'Serial' in port.description:
                try:
                    test_serial = serial.Serial(port.device, baudrate=self.baudrate, timeout=1)
                    test_serial.close()
                    return port.device
                except serial.SerialException:
                    continue
        return None
    
    def read_tag(self):
        """Read an RFID tag from USB reader"""
        try:
            if self.reader is not None:
                # Read data from serial port
                data = self.reader.readline().decode('ascii', errors='ignore').strip()
                if data:
                    # Extract the ID from the raw data
                    # This may need adjustment based on your reader's output format
                    return data.split('\r')[0]  # Adjust based on your actual data format
            else:
                # Simulation mode - return a test ID after 2 seconds
                time.sleep(2)
                return "123456789"
        except Exception as e:
            logger.error(f"Error reading RFID tag: {e}")
            return None
    
    def write_tag(self, text):
        """Write to an RFID tag (if supported by your reader)"""
        try:
            if self.reader is not None:
                # Implementation depends on your reader's capabilities
                # Many USB readers don't support writing
                logger.warning("Writing not supported by this reader")
                return None
            else:
                # Simulation mode
                time.sleep(2)
                return "123456789"
        except Exception as e:
            logger.error(f"Error writing to RFID tag: {e}")
            return None
    
    def cleanup(self):
        """Clean up resources"""
        if self.reader is not None and self.reader.is_open:
            self.reader.close()
            logger.info("RFID reader connection closed")