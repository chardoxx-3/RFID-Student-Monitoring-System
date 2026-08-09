// Excel Export Functionality using SheetJS (xlsx)
class AttendanceExporter {
    constructor() {
        this.initializeExportButton();
    }
    
    initializeExportButton() {
        const exportBtn = document.getElementById('export-btn');
        if (exportBtn) {
            exportBtn.addEventListener('click', () => this.exportData());
        }
    }
    
    async exportData() {
        try {
            // Show loading state
            this.showLoading(true);
            
            // Get the current filter values
            const dateRange = document.querySelector('.date-filter-btn.active')?.dataset.range || 'week';
            const section = document.getElementById('section-filter')?.value || 'all';
            
            // In a real app, you would fetch data from your API
            // const response = await fetch(`/api/attendance/export?range=${dateRange}&section=${section}`);
            // const data = await response.json();
            
            // For demo, we'll use mock data
            const data = this.generateMockExportData();
            
            // Create Excel workbook
            const wb = XLSX.utils.book_new();
            
            // Create worksheets
            const summaryWS = this.createSummaryWorksheet(data.summary);
            const detailWS = this.createDetailWorksheet(data.details);
            
            // Add worksheets to workbook
            XLSX.utils.book_append_sheet(wb, summaryWS, "Summary");
            XLSX.utils.book_append_sheet(wb, detailWS, "Details");
            
            // Generate file and download
            const fileName = `Attendance_Export_${new Date().toISOString().slice(0, 10)}.xlsx`;
            XLSX.writeFile(wb, fileName);
            
        } catch (error) {
            console.error('Export failed:', error);
            alert('Failed to generate export. Please try again.');
        } finally {
            this.showLoading(false);
        }
    }
    
    createSummaryWorksheet(summaryData) {
        const wsData = [
            ["Attendance Summary"],
            [],
            ["Period", summaryData.period],
            ["Section", summaryData.section],
            [],
            ["Category", "Count", "Percentage"],
            ["Present", summaryData.present, this.calculatePercentage(summaryData.present, summaryData.total)],
            ["Late", summaryData.late, this.calculatePercentage(summaryData.late, summaryData.total)],
            ["Absent", summaryData.absent, this.calculatePercentage(summaryData.absent, summaryData.total)],
            [],
            ["Total", summaryData.total, "100%"]
        ];
        
        const ws = XLSX.utils.aoa_to_sheet(wsData);
        
        // Add some styling through cell ranges
        if (ws['!merges']) ws['!merges'] = [];
        ws['!merges'].push({ s: { r: 0, c: 0 }, e: { r: 0, c: 2 } });
        
        return ws;
    }
    
    createDetailWorksheet(detailData) {
        // Prepare headers
        const headers = [
            "Date",
            "Student ID",
            "Student Name",
            "Section",
            "Time In",
            "Time Out",
            "Status",
            "Photo Available"
        ];
        
        // Prepare data rows
        const rows = detailData.map(record => [
            record.date,
            record.studentId,
            record.studentName,
            record.section,
            record.timeIn,
            record.timeOut,
            record.status,
            record.photoAvailable ? "Yes" : "No"
        ]);
        
        // Combine headers and data
        const wsData = [headers, ...rows];
        
        return XLSX.utils.aoa_to_sheet(wsData);
    }
    
    calculatePercentage(value, total) {
        return total > 0 ? `${Math.round((value / total) * 100)}%` : "0%";
    }
    
    showLoading(isLoading) {
        const exportBtn = document.getElementById('export-btn');
        if (exportBtn) {
            exportBtn.disabled = isLoading;
            exportBtn.innerHTML = isLoading ? 
                '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Exporting...' : 
                '<i class="fas fa-file-excel"></i> Export to Excel';
        }
    }
    
    generateMockExportData() {
        // Generate mock data for demonstration
        const sections = ['A', 'B', 'C', 'D'];
        const statuses = ['Present', 'Late', 'Absent'];
        
        const details = [];
        const days = 7; // One week of data
        
        for (let i = 0; i < 50; i++) {
            const date = new Date();
            date.setDate(date.getDate() - Math.floor(Math.random() * days));
            
            const studentId = `2023-${String(Math.floor(Math.random() * 1000)).padStart(3, '0')}`;
            const section = sections[Math.floor(Math.random() * sections.length)];
            const status = statuses[Math.floor(Math.random() * statuses.length)];
            
            details.push({
                date: date.toLocaleDateString(),
                studentId,
                studentName: this.generateRandomName(),
                section: `Grade ${Math.floor(Math.random() * 4) + 1}-${section}`,
                timeIn: status === 'Absent' ? '' : this.generateRandomTime(7, 9),
                timeOut: status === 'Absent' ? '' : this.generateRandomTime(15, 17),
                status,
                photoAvailable: status !== 'Absent'
            });
        }
        
        // Calculate summary
        const present = details.filter(d => d.status === 'Present').length;
        const late = details.filter(d => d.status === 'Late').length;
        const absent = details.filter(d => d.status === 'Absent').length;
        const total = details.length;
        
        return {
            summary: {
                period: "Last 7 days",
                section: "All Sections",
                present,
                late,
                absent,
                total
            },
            details
        };
    }
    
    generateRandomName() {
        const firstNames = ['Juan', 'Maria', 'Jose', 'Ana', 'Pedro', 'Carmen', 'Miguel', 'Isabel'];
        const lastNames = ['Dela Cruz', 'Santos', 'Reyes', 'Garcia', 'Lopez', 'Martinez', 'Gonzales'];
        
        return `${firstNames[Math.floor(Math.random() * firstNames.length)]} ${
            lastNames[Math.floor(Math.random() * lastNames.length)]
        }`;
    }
    
    generateRandomTime(startHour, endHour) {
        const hour = startHour + Math.floor(Math.random() * (endHour - startHour));
        const minute = Math.floor(Math.random() * 60);
        const ampm = hour >= 12 ? 'PM' : 'AM';
        const displayHour = hour % 12 || 12;
        
        return `${displayHour}:${String(minute).padStart(2, '0')} ${ampm}`;
    }
}

// Initialize when DOM is loaded and XLSX is available
document.addEventListener('DOMContentLoaded', () => {
    if (typeof XLSX !== 'undefined' && document.getElementById('export-btn')) {
        new AttendanceExporter();
    } else if (document.getElementById('export-btn')) {
        console.warn('XLSX library not loaded - Excel export will not work');
    }
});