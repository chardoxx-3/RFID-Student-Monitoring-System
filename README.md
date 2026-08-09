# 🎓 RFID Student Monitoring System

A web-based **Student Attendance Monitoring System** built to manage student records, RFID-based attendance logging, institute/course/section administration, attendance reporting, and optional Google Drive photo uploads.

## 🚀 Project Overview

The application is built with **Python**, **Django 4.2**, and **MySQL** (or MariaDB), following the Django MTV/MVC architecture. It provides an administrative dashboard for school staff and a kiosk interface for RFID attendance logging.

## 👥 User Roles

### 1. Administrator

Administrators can:

* Manage institutes, courses, and sections.
* Add, edit, import, export, and delete student records.
* Log RFID-based student attendance from the kiosk.
* View and print attendance reports.
* Send attendance notification emails to guardians.
* Configure email and system settings.
* Manage user accounts, profile, and password resets via OTP.
* Integrate with Google Drive for attendance photo uploads.

### 2. Kiosk / RFID Attendance

The kiosk interface can:

* Accept RFID tag input for student attendance.
* Log morning and afternoon attendance events.
* Capture attendance photo uploads.
* Display attendance records for the current day.
* Operate with quick or full logging flows.

## 🚘 Key Features

| **Feature**                  | **Description**                                                                                 |
| --------------------------- | ----------------------------------------------------------------------------------------------- |
| **Institute & Course Management** | Create and manage institutes, courses, and sections for students.                              |
| **Student Management**      | Add, edit, import, export, and delete student profiles, including RFID tag assignment.          |
| **RFID Attendance**         | Log attendance using RFID tags through a kiosk interface with both full and quick logging.     |
| **Attendance Reports**      | Generate, view, export, and print attendance reports and charts.                               |
| **Email Notifications**     | Send automated guardian notifications for attendance events.                                  |
| **Google Drive Integration**| Upload attendance photos to Google Drive and manage OAuth authentication.                       |
| **Authentication**          | Secure login, registration, profile update, password change, and OTP reset flows.               |
| **System Settings**         | Configure email templates, system title, logo, and other runtime settings.                     |
| **Import / Export**         | Bulk import students from spreadsheets and export student or attendance data to Excel.         |

## 🏗️ System Architecture

The project follows the **Model-View-Controller (MVC)** architecture as implemented by Django.

* **Models** – Define institutes, courses, sections, students, attendance records, email settings, and logs.
* **Views** – Handle authentication, admin dashboard flows, attendance logging, reports, and Google Drive OAuth.
* **Templates** – Render HTML for admin pages, kiosk, login, registration, and reports.
* **URLs** – Define routes for dashboard, student management, attendance APIs, kiosk, and authentication.

## 🗄️ Database

The system uses **MySQL / MariaDB** to manage its core data, including:

* Users
* Institutes
* Courses
* Sections
* Students
* AttendanceRecords
* SystemSettings
* EmailSettings
* SystemLog
* PasswordResetOTP

## 🔐 Demo Credentials

This project does not include default admin credentials in source control.
Create a Django superuser for local access:

```bash
python manage.py createsuperuser
```

> **Note:** Use this command locally to set your own admin username and password.

## 🛠️ Technologies Used

* **Python 3**
* **Django 4.2**
* **MySQL / MariaDB**
* **HTML**
* **CSS**
* **JavaScript**
* **Bootstrap**
* **Google Drive API**
* **Celery + Redis**
* **python-dotenv**

## 💻 How to Install & Run

### 1. Install the Requirements

Before running the project, install:

* **Python 3.11+**
* **MySQL / MariaDB**
* **Redis** (for Celery if used)
* **Git**

### 2. Clone the Project

```bash
git clone <your-repo-url>
cd rfid_student_monitoring
```

### 3. Create a Virtual Environment

```bash
python -m venv venv
venv\Scripts\activate
```

### 4. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 5. Configure Environment Variables

Copy the example file:

```bash
copy .env.example .env
```

Then open `.env` and configure your local database, email, and Google OAuth credentials.

### 6. Run Database Migrations

```bash
python manage.py migrate
```

### 7. Create a Superuser

```bash
python manage.py createsuperuser
```

### 8. Run the Development Server

```bash
python manage.py runserver
```

The application will normally be available at:

```text
http://127.0.0.1:8000
```

## 🔄 Attendance Workflow

**Register / Login → Manage Students → Assign RFID Tags → Use Kiosk → Log Attendance → Generate Reports → Send Notifications**

## 🎯 Project Purpose

This project was developed to demonstrate practical skills in **web application development, Django architecture, database management, RFID attendance systems, automated email workflows, Google Drive API integration, and reporting**.

## 📸 System Preview

### Login
![Login](screenshots/Login.png)
