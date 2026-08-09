// RFID Scanner Integration
class RFIDScanner {
    constructor(options = {}) {
        this.options = {
            scanInterval: 500,
            debug: false,
            ...options
        };
        
        this.lastScanTime = 0;
        this.currentTag = null;
        this.isScanning = false;
        this.callbacks = {
            onTagScanned: [],
            onError: []
        };
        
        // Initialize based on environment
        this.initializeReader();
    }
    
    initializeReader() {
        // Check if we're running in a browser or Node.js
        if (typeof window !== 'undefined') {
            this.initializeBrowserReader();
        } else {
            this.initializeHardwareReader();
        }
    }
    
    initializeBrowserReader() {
        // Browser simulation for development
        console.log("Initializing browser RFID simulation");
        
        // For demo purposes, we'll simulate RFID tags with keyboard input
        document.addEventListener('keypress', (e) => {
            if (this.isScanning && Date.now() - this.lastScanTime > this.options.scanInterval) {
                // Simulate RFID tag (using numbers 0-9)
                if (e.key >= '0' && e.key <= '9') {
                    this.currentTag = this.currentTag ? this.currentTag + e.key : e.key;
                    this.lastScanTime = Date.now();
                    
                    // If we have a 10-digit "tag", process it
                    if (this.currentTag.length >= 10) {
                        this.processTag(this.currentTag);
                        this.currentTag = null;
                    }
                }
            }
        });
    }
    
    initializeHardwareReader() {
        // Actual hardware implementation would go here
        // This would depend on the specific RFID reader being used
        
        console.log("Initializing hardware RFID reader");
        
        // Example for MFRC522 reader on Raspberry Pi
        /*
        try {
            const MFRC522 = require('mfrc522-rpi');
            this.reader = new MFRC522();
            
            setInterval(() => {
                if (!this.isScanning) return;
                
                // Reset the reader
                this.reader.reset();
                
                // Scan for cards
                let response = this.reader.findCard();
                if (!response.status) return;
                
                // Get the UID of the card
                response = this.reader.getUid();
                if (!response.status) {
                    console.log("UID Scan Error");
                    return;
                }
                
                // If we have a UID, process it
                const uid = response.data.map(byte => byte.toString(16).padStart(2, '0')).join(':');
                this.processTag(uid);
                
            }, this.options.scanInterval);
            
        } catch (err) {
            this.triggerError(`Hardware initialization failed: ${err.message}`);
        }
        */
    }
    
    processTag(tag) {
        if (this.options.debug) {
            console.log(`RFID Tag Scanned: ${tag}`);
        }
        
        // Trigger all registered callbacks
        this.callbacks.onTagScanned.forEach(callback => {
            try {
                callback(tag);
            } catch (err) {
                console.error("Error in tag scanned callback:", err);
            }
        });
    }
    
    triggerError(error) {
        console.error("RFID Error:", error);
        
        this.callbacks.onError.forEach(callback => {
            try {
                callback(error);
            } catch (err) {
                console.error("Error in error callback:", err);
            }
        });
    }
    
    onTagScanned(callback) {
        if (typeof callback === 'function') {
            this.callbacks.onTagScanned.push(callback);
        }
        return this;
    }
    
    onError(callback) {
        if (typeof callback === 'function') {
            this.callbacks.onError.push(callback);
        }
        return this;
    }
    
    startScanning() {
        this.isScanning = true;
        if (this.options.debug) {
            console.log("RFID scanning started");
        }
        return this;
    }
    
    stopScanning() {
        this.isScanning = false;
        if (this.options.debug) {
            console.log("RFID scanning stopped");
        }
        return this;
    }
}

// Export for Node.js or browser
if (typeof module !== 'undefined' && module.exports) {
    module.exports = RFIDScanner;
} else {
    window.RFIDScanner = RFIDScanner;
}

// Example usage:
/*
const scanner = new RFIDScanner({ debug: true });
scanner.onTagScanned(tag => {
    console.log("Main app received tag:", tag);
    // Process the tag in your application
}).startScanning();
*/