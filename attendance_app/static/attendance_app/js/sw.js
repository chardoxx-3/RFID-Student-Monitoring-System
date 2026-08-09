// Service Worker for Attendance Kiosk PWA
const CACHE_NAME = 'attendance-kiosk-v1.2';
const urlsToCache = [
  '/kiosk/',
  '/static/attendance_app/css/styles.css',
  '/static/attendance_app/js/main.js',
  'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css',
  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css',
  'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js',
  'https://code.jquery.com/jquery-3.6.0.min.js'
];

// Install event - cache essential resources
self.addEventListener('install', event => {
  console.log('Service Worker installing...');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('Opened cache');
        return cache.addAll(urlsToCache);
      })
      .then(() => self.skipWaiting())
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', event => {
  console.log('Service Worker activating...');
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            console.log('Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch event - serve from cache when offline
self.addEventListener('fetch', event => {
  // Skip non-GET requests and external resources
  if (event.request.method !== 'GET') return;
  
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // Return cached version or fetch from network
        if (response) {
          return response;
        }
        
        return fetch(event.request).then(response => {
          // Check if we received a valid response
          if (!response || response.status !== 200 || response.type !== 'basic') {
            return response;
          }
          
          // Clone the response
          const responseToCache = response.clone();
          
          caches.open(CACHE_NAME)
            .then(cache => {
              cache.put(event.request, responseToCache);
            });
          
          return response;
        });
      })
      .catch(() => {
        // If both cache and network fail, show offline page
        if (event.request.destination === 'document') {
          return caches.match('/kiosk/');
        }
      })
  );
});

// Sync event for background sync
self.addEventListener('sync', event => {
  console.log('Background sync triggered:', event.tag);
  
  if (event.tag === 'sync-attendance') {
    event.waitUntil(syncPendingAttendance());
  }
});

// Function to sync pending attendance records
async function syncPendingAttendance() {
  try {
    // Get pending records from IndexedDB
    const pendingRecords = await getPendingRecords();
    
    for (const record of pendingRecords) {
      try {
        const formData = new FormData();
        formData.append('rfid_tag', record.rfid_tag);
        
        if (record.photo_blob) {
          const blob = await fetch(record.photo_blob).then(r => r.blob());
          formData.append('photo', blob, 'attendance_photo.jpg');
        }
        
        const response = await fetch(`/api/attendance/log/${record.rfid_tag}/`, {
          method: 'POST',
          body: formData
        });
        
        if (response.ok) {
          // Remove from pending records on success
          await removePendingRecord(record.id);
          console.log('Synced record for:', record.rfid_tag);
        }
      } catch (error) {
        console.error('Failed to sync record:', error);
      }
    }
  } catch (error) {
    console.error('Sync error:', error);
  }
}

// IndexedDB functions for offline storage
function openDB() {
  return new Promise((resolve, reject) => {
    const request = indexedDB.open('AttendanceKioskDB', 1);
    
    request.onerror = () => reject(request.error);
    request.onsuccess = () => resolve(request.result);
    
    request.onupgradeneeded = (event) => {
      const db = event.target.result;
      
      // Create object store for pending attendance records
      if (!db.objectStoreNames.contains('pendingRecords')) {
        const store = db.createObjectStore('pendingRecords', { 
          keyPath: 'id',
          autoIncrement: true 
        });
        store.createIndex('rfid_tag', 'rfid_tag', { unique: false });
        store.createIndex('timestamp', 'timestamp', { unique: false });
      }
      
      // Create object store for student cache
      if (!db.objectStoreNames.contains('studentCache')) {
        const store = db.createObjectStore('studentCache', { keyPath: 'rfid_tag' });
        store.createIndex('student_id', 'student_id', { unique: true });
      }
    };
  });
}

async function savePendingRecord(record) {
  const db = await openDB();
  const transaction = db.transaction(['pendingRecords'], 'readwrite');
  const store = transaction.objectStore('pendingRecords');
  
  record.timestamp = new Date().getTime();
  
  return new Promise((resolve, reject) => {
    const request = store.add(record);
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

async function getPendingRecords() {
  const db = await openDB();
  const transaction = db.transaction(['pendingRecords'], 'readonly');
  const store = transaction.objectStore('pendingRecords');
  
  return new Promise((resolve, reject) => {
    const request = store.getAll();
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

async function removePendingRecord(id) {
  const db = await openDB();
  const transaction = db.transaction(['pendingRecords'], 'readwrite');
  const store = transaction.objectStore('pendingRecords');
  
  return new Promise((resolve, reject) => {
    const request = store.delete(id);
    request.onsuccess = () => resolve();
    request.onerror = () => reject(request.error);
  });
}

async function saveStudentCache(studentData) {
  const db = await openDB();
  const transaction = db.transaction(['studentCache'], 'readwrite');
  const store = transaction.objectStore('studentCache');
  
  return new Promise((resolve, reject) => {
    const request = store.put(studentData);
    request.onsuccess = () => resolve();
    request.onerror = () => reject(request.error);
  });
}

async function getStudentFromCache(rfid_tag) {
  const db = await openDB();
  const transaction = db.transaction(['studentCache'], 'readonly');
  const store = transaction.objectStore('studentCache');
  
  return new Promise((resolve, reject) => {
    const request = store.get(rfid_tag);
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

async function getAllStudentCache() {
  const db = await openDB();
  const transaction = db.transaction(['studentCache'], 'readonly');
  const store = transaction.objectStore('studentCache');
  
  return new Promise((resolve, reject) => {
    const request = store.getAll();
    request.onsuccess = () => {
      const cache = {};
      request.result.forEach(student => {
        cache[student.rfid_tag] = student;
      });
      resolve(cache);
    };
    request.onerror = () => reject(request.error);
  });
}