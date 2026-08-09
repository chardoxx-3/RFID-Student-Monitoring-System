// Camera and Photo Capture Functionality
document.addEventListener('DOMContentLoaded', function() {
    const video = document.getElementById('camera-preview');
    const canvas = document.getElementById('photo-canvas');
    const captureBtn = document.getElementById('capture-btn');
    const retakeBtn = document.getElementById('retake-btn');
    const usePhotoBtn = document.getElementById('use-photo-btn');
    const photoInput = document.getElementById('photo-input');
    const photoPreview = document.getElementById('photo-preview');
    let stream = null;

    // Check if we're on a page that needs camera functionality
    if (!video && !captureBtn) return;

    // Start camera when modal opens
    const cameraModal = document.getElementById('camera-modal');
    if (cameraModal) {
        cameraModal.addEventListener('shown.bs.modal', startCamera);
        cameraModal.addEventListener('hidden.bs.modal', stopCamera);
    }

    // File input change handler
    if (photoInput && photoPreview) {
        photoInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    photoPreview.src = event.target.result;
                    photoPreview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        });
    }

    // Start camera function
    async function startCamera() {
        try {
            stream = await navigator.mediaDevices.getUserMedia({ 
                video: { 
                    width: 1280, 
                    height: 720,
                    facingMode: 'user' 
                },
                audio: false 
            });
            video.srcObject = stream;
            video.style.display = 'block';
            captureBtn.style.display = 'block';
            retakeBtn.style.display = 'none';
            usePhotoBtn.style.display = 'none';
            canvas.style.display = 'none';
        } catch (err) {
            console.error("Camera error: ", err);
            alert("Could not access the camera. Please check permissions.");
        }
    }

    // Stop camera function
    function stopCamera() {
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
            video.srcObject = null;
        }
    }

    // Capture photo
    if (captureBtn) {
        captureBtn.addEventListener('click', function() {
            const context = canvas.getContext('2d');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            context.drawImage(video, 0, 0, canvas.width, canvas.height);
            
            video.style.display = 'none';
            captureBtn.style.display = 'none';
            canvas.style.display = 'block';
            retakeBtn.style.display = 'block';
            usePhotoBtn.style.display = 'block';
        });
    }

    // Retake photo
    if (retakeBtn) {
        retakeBtn.addEventListener('click', function() {
            video.style.display = 'block';
            captureBtn.style.display = 'block';
            canvas.style.display = 'none';
            retakeBtn.style.display = 'none';
            usePhotoBtn.style.display = 'none';
        });
    }

    // Use photo
    if (usePhotoBtn) {
        usePhotoBtn.addEventListener('click', function() {
            const photoData = canvas.toDataURL('image/jpeg');
            
            // Set the photo data to a hidden input or preview
            if (photoPreview) {
                photoPreview.src = photoData;
                photoPreview.style.display = 'block';
            }
            
            // Close the modal
            if (cameraModal) {
                const modal = bootstrap.Modal.getInstance(cameraModal);
                modal.hide();
            }
            
            // Stop the camera
            stopCamera();
        });
    }
});

// Helper function to capture photo from video stream
function capturePhotoFromStream(videoElement, quality = 0.8) {
    const canvas = document.createElement('canvas');
    canvas.width = videoElement.videoWidth;
    canvas.height = videoElement.videoHeight;
    const ctx = canvas.getContext('2d');
    ctx.drawImage(videoElement, 0, 0, canvas.width, canvas.height);
    return canvas.toDataURL('image/jpeg', quality);
}