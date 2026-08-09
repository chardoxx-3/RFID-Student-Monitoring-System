// Admin Dashboard Scripts
document.addEventListener('DOMContentLoaded', function() {
    // Sidebar toggle for mobile
    const sidebarToggle = document.querySelector('.sidebar-toggle');
    const sidebar = document.querySelector('.sidebar');
    
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
        });
    }


    window.addEventListener('click', function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = 'none';
        }
    });

    // Dynamic year level and section dependency
    const yearLevelSelect = document.getElementById('year-level');
    const sectionSelect = document.getElementById('section');

    if (yearLevelSelect && sectionSelect) {
        yearLevelSelect.addEventListener('change', function() {
            const yearLevel = this.value;
            sectionSelect.innerHTML = '<option value="">Select Section</option>';
            
            if (yearLevel) {
                // In a real app, you would fetch sections for this year level from the server
                const sections = getSectionsForYearLevel(yearLevel);
                sections.forEach(section => {
                    const option = document.createElement('option');
                    option.value = section.id;
                    option.textContent = section.name;
                    sectionSelect.appendChild(option);
                });
            }
        });
    }

    // Initialize charts
    initializeCharts();

    // Export button functionality
    const exportBtn = document.getElementById('export-btn');
    if (exportBtn) {
        exportBtn.addEventListener('click', exportToExcel);
    }
});

function getSectionsForYearLevel(yearLevel) {
    // Mock data - replace with actual API call in production
    const sectionsByYear = {
        '1': [
            { id: '1A', name: 'Section A' },
            { id: '1B', name: 'Section B' }
        ],
        '2': [
            { id: '2A', name: 'Section A' },
            { id: '2B', name: 'Section B' }
        ],
        '3': [
            { id: '3A', name: 'Section A' },
            { id: '3B', name: 'Section B' }
        ],
        '4': [
            { id: '4A', name: 'Section A' },
            { id: '4B', name: 'Section B' }
        ]
    };
    
    return sectionsByYear[yearLevel] || [];
}

function initializeCharts() {
    // Attendance Pie Chart
    const pieCtx = document.getElementById('attendancePieChart');
    if (pieCtx) {
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: ['Present', 'Late', 'Absent'],
                datasets: [{
                    data: [75, 15, 10],
                    backgroundColor: [
                        '#4CAF50',
                        '#FFC107',
                        '#F44336'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }

    // Daily Attendance Line Chart
    const lineCtx = document.getElementById('dailyAttendanceChart');
    if (lineCtx) {
        new Chart(lineCtx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Present Students',
                    data: [120, 115, 130, 125, 140, 50, 10],
                    borderColor: '#0D47A1',
                    backgroundColor: 'rgba(13, 71, 161, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }
}

function exportToExcel() {
    // In a real app, this would generate an Excel file from the report data
    alert('Exporting data to Excel...');
    // Implementation would use a library like SheetJS
}

// Add this to your extra_js block
$(document).ready(function() {
    // When export modal opens, populate with current filter values
    $('#exportStudentsModal').on('show.bs.modal', function() {
        var urlParams = new URLSearchParams(window.location.search);
        
        $('#export_year_level').val(urlParams.get('year_level') || '');
        $('#export_section').val(urlParams.get('section') || '');
        $('#export_search').val(urlParams.get('search') || '');
    });

    // Handle "use current filters" checkbox
    $('#export_current_filters').change(function() {
        if ($(this).is(':checked')) {
            var urlParams = new URLSearchParams(window.location.search);
            $('#exportForm').attr('action', '{% url "export_students" %}?' + urlParams.toString());
        } else {
            $('#exportForm').attr('action', '{% url "export_students" %}');
        }
    });
});

