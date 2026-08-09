-- Create database
CREATE DATABASE cpsc_monitoring;

-- Create user
CREATE USER cpsc_admin WITH PASSWORD 'securepassword123';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE cpsc_monitoring TO cpsc_admin;

-- PostgreSQL extensions
\c cpsc_monitoring
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS hstore;

-- Tables for backup/restore tracking
CREATE TABLE IF NOT EXISTS database_backups (
    id SERIAL PRIMARY KEY,
    backup_file VARCHAR(255) NOT NULL,
    backup_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    backup_size BIGINT,
    status VARCHAR(50) DEFAULT 'completed'
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_student_rfid ON attendance_app_student(rfid_tag);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON attendance_app_attendancerecord(date);
CREATE INDEX IF NOT EXISTS idx_attendance_student ON attendance_app_attendancerecord(student_id);