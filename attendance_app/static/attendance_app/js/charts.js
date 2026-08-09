// Chart Rendering with Chart.js
class AttendanceCharts {
    constructor() {
        this.charts = {};
        this.attendanceData = {};
        this.filters = {
            period: 'all' // all, am, pm
        };
        
        this.init();
    }
    
    init() {
        // Initialize all charts on the page
        this.initPieChart();
        this.initLineChart();
        this.initEventListeners();
        
        // Load initial data
        this.loadData();
    }
    
    initPieChart() {
        const ctx = document.getElementById('attendancePieChart');
        if (!ctx) return;
        
        this.charts.pie = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['AM In', 'AM Out', 'PM In', 'PM Out'],
                datasets: [{
                    data: [0, 0, 0, 0],
                    backgroundColor: [
                        '#4CAF50', // AM In - green
                        '#2196F3', // AM Out - blue
                        '#FFC107', // PM In - yellow
                        '#9C27B0'  // PM Out - purple
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 12,
                            padding: 20
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.raw || 0;
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = total > 0 ? Math.round((value / total) * 100) : 0;
                                return `${label}: ${value} (${percentage}%)`;
                            }
                        }
                    }
                }
            }
        });
    }
    
    initLineChart() {
        const ctx = document.getElementById('dailyAttendanceChart');
        if (!ctx) return;
        
        this.charts.line = new Chart(ctx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: 'Present Students',
                    data: [],
                    borderColor: '#0D47A1',
                    backgroundColor: 'rgba(13, 71, 161, 0.1)',
                    borderWidth: 2,
                    pointBackgroundColor: '#0D47A1',
                    pointRadius: 4,
                    pointHoverRadius: 6,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    tooltip: {
                        mode: 'index',
                        intersect: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Number of Students'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Date'
                        }
                    }
                },
                interaction: {
                    mode: 'nearest',
                    axis: 'x',
                    intersect: false
                }
            }
        });
    }
    
    initEventListeners() {
        // Period filter buttons (AM/PM/All)
        document.querySelectorAll('.chart-control[data-period]').forEach(btn => {
            btn.addEventListener('click', () => {
                this.filters.period = btn.dataset.period;
                this.updateActivePeriodButtons();
                this.updateCharts();
            });
        });
        
        // Window resize event
        window.addEventListener('resize', () => {
            this.resizeCharts();
        });
    }
    
    updateActivePeriodButtons() {
        document.querySelectorAll('.chart-control[data-period]').forEach(btn => {
            if (btn.dataset.period === this.filters.period) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });
    }
    
    resizeCharts() {
        Object.values(this.charts).forEach(chart => {
            chart.resize();
        });
    }
    
    async loadData() {
        try {
            // Show loading state
            this.showLoading(true);
            
            // In a real app, this would fetch data from your API
            // For now, we'll use mock data
            this.attendanceData = this.generateMockData();
            
            // Update charts with new data
            this.updateCharts();
            
        } catch (error) {
            console.error('Error loading attendance data:', error);
        } finally {
            this.showLoading(false);
        }
    }
    
    updateCharts() {
        // Update pie chart with AM/PM breakdown
        if (this.charts.pie) {
            this.charts.pie.data.datasets[0].data = [
                this.attendanceData.summary.am_in,
                this.attendanceData.summary.am_out,
                this.attendanceData.summary.pm_in,
                this.attendanceData.summary.pm_out
            ];
            this.charts.pie.update();
        }
        
        // Update line chart based on period filter
        if (this.charts.line) {
            let dataToShow = [];
            
            if (this.filters.period === 'all') {
                dataToShow = this.attendanceData.daily.map(day => day.total_present);
                this.charts.line.data.datasets[0].label = 'Present Students (All)';
            } 
            else if (this.filters.period === 'am') {
                dataToShow = this.attendanceData.daily.map(day => day.am_present);
                this.charts.line.data.datasets[0].label = 'Present Students (AM)';
            }
            else if (this.filters.period === 'pm') {
                dataToShow = this.attendanceData.daily.map(day => day.pm_present);
                this.charts.line.data.datasets[0].label = 'Present Students (PM)';
            }
            
            this.charts.line.data.labels = this.attendanceData.daily.map(day => day.date);
            this.charts.line.data.datasets[0].data = dataToShow;
            this.charts.line.update();
        }
    }
    
    showLoading(isLoading) {
        const loadingElement = document.getElementById('chart-loading');
        if (loadingElement) {
            loadingElement.style.display = isLoading ? 'block' : 'none';
        }
    }
    
    generateMockData() {
        // Generate mock data with AM/PM breakdown
        const days = 7; // Show data for last 7 days
        
        const dailyData = [];
        for (let i = days; i >= 0; i--) {
            const date = new Date();
            date.setDate(date.getDate() - i);
            
            const dayOfWeek = date.getDay(); // 0 = Sunday, 6 = Saturday
            
            // Fewer students on weekends
            const dayMultiplier = dayOfWeek === 0 || dayOfWeek === 6 ? 0.3 : 1;
            
            // Random variation
            const randomVariation = Math.floor(Math.random() * 20) - 10;
            
            // Base numbers
            const basePresent = Math.max(10, Math.floor(100 * dayMultiplier + randomVariation));
            
            // AM/PM breakdown
            const am_in = Math.floor(basePresent * 0.95); // 95% of students check in AM
            const am_out = Math.floor(am_in * 0.9); // 90% of AM check-ins also check out
            const pm_in = Math.floor(basePresent * 0.7); // 70% check in PM
            const pm_out = Math.floor(pm_in * 0.85); // 85% of PM check-ins also check out
            
            dailyData.push({
                date: date.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' }),
                total_present: basePresent,
                am_present: am_in,
                pm_present: pm_in,
                am_in,
                am_out,
                pm_in,
                pm_out
            });
        }
        
        // Calculate summary totals
        const summary = dailyData.reduce((acc, day) => {
            acc.am_in += day.am_in;
            acc.am_out += day.am_out;
            acc.pm_in += day.pm_in;
            acc.pm_out += day.pm_out;
            return acc;
        }, { am_in: 0, am_out: 0, pm_in: 0, pm_out: 0 });
        
        return {
            summary,
            daily: dailyData
        };
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('attendancePieChart')) {
        new AttendanceCharts();
    }
});