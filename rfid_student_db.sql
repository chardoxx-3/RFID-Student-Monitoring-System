-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 09, 2026 at 04:38 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rfid_student_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendance_app_attendancerecord`
--

CREATE TABLE `attendance_app_attendancerecord` (
  `id` bigint(20) NOT NULL,
  `date` date NOT NULL,
  `morning_in` time(6) DEFAULT NULL,
  `morning_out` time(6) DEFAULT NULL,
  `afternoon_in` time(6) DEFAULT NULL,
  `afternoon_out` time(6) DEFAULT NULL,
  `morning_in_photo_url` varchar(200) DEFAULT NULL,
  `morning_out_photo_url` varchar(200) DEFAULT NULL,
  `afternoon_in_photo_url` varchar(200) DEFAULT NULL,
  `afternoon_out_photo_url` varchar(200) DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL,
  `email_attempted` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `student_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attendance_app_course`
--

CREATE TABLE `attendance_app_course` (
  `id` bigint(20) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` longtext DEFAULT NULL,
  `institute_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_app_course`
--

INSERT INTO `attendance_app_course` (`id`, `code`, `name`, `description`, `institute_id`) VALUES
(4, 'BTCT', 'Bachelor of Technology Major in Civil Tecnology', '', 4),
(5, 'BSIT', 'Bachelor of Science in Information Technology', NULL, 5),
(6, 'BSEE', 'Bachelor of Science in Electrical Engineering', NULL, 4);

-- --------------------------------------------------------

--
-- Table structure for table `attendance_app_emailsettings`
--

CREATE TABLE `attendance_app_emailsettings` (
  `id` bigint(20) NOT NULL,
  `time_in_subject` varchar(100) NOT NULL,
  `time_in_template` longtext NOT NULL,
  `time_out_subject` varchar(100) NOT NULL,
  `time_out_template` longtext NOT NULL,
  `smtp_host` varchar(100) NOT NULL,
  `smtp_port` int(11) NOT NULL,
  `smtp_username` varchar(100) NOT NULL,
  `smtp_password` varchar(100) NOT NULL,
  `from_email` varchar(254) NOT NULL,
  `from_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_app_emailsettings`
--

INSERT INTO `attendance_app_emailsettings` (`id`, `time_in_subject`, `time_in_template`, `time_out_subject`, `time_out_template`, `smtp_host`, `smtp_port`, `smtp_username`, `smtp_password`, `from_email`, `from_name`) VALUES
(1, 'Your son {student_name} has arrived at school', 'Dear {guardian_name},\r\n\r\nYour child {student_name} (ID: {student_id}) has arrived at school at {time_in} on {date}.\r\nCourse: {course}\r\nSection: {section}\r\n\r\nThis is an automated notification. Please contact the school if you have any questions.\r\n\r\nThank you,\r\nSchool Administration', '{student_name} has left school', 'Dear {guardian_name},\r\n\r\nYour child {student_name} (ID: {student_id}) has left school at {time_out} on {date}.\r\nCourse: {course}\r\nSection: {section}\r\n\r\nThis is an automated notification. Please ensure your child arrives home safely.\r\n\r\nThank you,\r\nSchool Administration', 'smtp.gmail.com', 587, 'your email', 'ur password', 'noreply@school.edu', 'School Administration');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_app_institute`
--

CREATE TABLE `attendance_app_institute` (
  `id` bigint(20) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_app_institute`
--

INSERT INTO `attendance_app_institute` (`id`, `code`, `name`, `description`) VALUES
(4, 'IT', 'Institute of Technology', ''),
(5, 'IECS', 'Institute of Engineering and Computer Studies', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `attendance_app_passwordresetotp`
--

CREATE TABLE `attendance_app_passwordresetotp` (
  `id` bigint(20) NOT NULL,
  `otp_code` varchar(6) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `is_used` tinyint(1) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_app_passwordresetotp`
--

INSERT INTO `attendance_app_passwordresetotp` (`id`, `otp_code`, `created_at`, `expires_at`, `is_used`, `user_id`) VALUES
(4, '179530', '2025-12-02 04:48:42.062340', '2025-12-02 05:03:42.057349', 1, 4),
(5, '411363', '2025-12-02 08:30:00.827475', '2025-12-02 08:31:00.782382', 1, 4),
(6, '463390', '2025-12-02 08:31:05.630579', '2025-12-02 08:32:05.627346', 1, 4),
(7, '420076', '2025-12-02 08:33:26.007242', '2025-12-02 08:34:25.978005', 1, 4),
(8, '634192', '2025-12-02 08:34:22.219146', '2025-12-02 08:35:22.213796', 1, 4),
(9, '396219', '2025-12-02 08:34:59.688036', '2025-12-02 08:35:59.682728', 1, 4),
(10, '876886', '2025-12-02 08:36:55.457233', '2025-12-02 08:37:55.447226', 1, 4),
(11, '099202', '2025-12-02 08:38:45.679082', '2025-12-02 08:39:45.672079', 1, 4),
(12, '777709', '2025-12-02 08:40:33.996638', '2025-12-02 08:41:33.973467', 1, 4),
(13, '698550', '2025-12-02 08:41:36.901562', '2025-12-02 08:42:36.886184', 1, 4),
(14, '816717', '2025-12-02 08:45:33.730676', '2025-12-02 08:46:33.699399', 1, 4),
(15, '753297', '2025-12-03 01:36:02.570593', '2025-12-03 01:37:02.544027', 1, 4),
(16, '793712', '2026-08-07 11:37:06.690573', '2026-08-07 11:38:06.674876', 1, 4),
(17, '012494', '2026-08-07 11:38:21.207194', '2026-08-07 11:39:21.156129', 1, 4),
(18, '279121', '2026-08-07 11:43:29.410205', '2026-08-07 11:44:29.402330', 1, 4);

-- --------------------------------------------------------

--
-- Table structure for table `attendance_app_section`
--

CREATE TABLE `attendance_app_section` (
  `id` bigint(20) NOT NULL,
  `name` varchar(50) NOT NULL,
  `year_level` int(11) NOT NULL,
  `course_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_app_section`
--

INSERT INTO `attendance_app_section` (`id`, `name`, `year_level`, `course_id`) VALUES
(9, 'BSEE 1A', 1, 6),
(8, 'BSIT 1', 1, 5),
(10, 'BSIT 4A', 4, 5),
(7, 'BTCT 4A', 4, 4);

-- --------------------------------------------------------

--
-- Table structure for table `attendance_app_student`
--

CREATE TABLE `attendance_app_student` (
  `id` bigint(20) NOT NULL,
  `student_id` varchar(20) NOT NULL,
  `rfid_tag` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `birthday` date DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `year_level` int(11) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  `address` longtext DEFAULT NULL,
  `guardian_name` varchar(100) DEFAULT NULL,
  `guardian_email` varchar(254) DEFAULT NULL,
  `photo` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `section_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attendance_app_systemlog`
--

CREATE TABLE `attendance_app_systemlog` (
  `id` bigint(20) NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `log_type` varchar(10) NOT NULL,
  `message` longtext NOT NULL,
  `details` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_app_systemlog`
--

INSERT INTO `attendance_app_systemlog` (`id`, `timestamp`, `log_type`, `message`, `details`) VALUES
(1, '2025-12-02 03:15:36.174094', 'info', 'Student created: John Claire Abatayo', 'Student ID: 25-0916, Section: BSIT - BSIT 1 (Year 1)'),
(2, '2025-12-02 03:15:36.274159', 'info', 'Student created: Clyde Christian Acebes', 'Student ID: 25-0917, Section: BSIT - BSIT 1 (Year 1)'),
(3, '2025-12-02 03:15:36.309137', 'info', 'Student created: Jocelyn Acebes', 'Student ID: 24-1394, Section: BSIT - BSIT 1 (Year 1)'),
(4, '2025-12-02 03:15:36.359022', 'info', 'Student created: Catherine Awayan', 'Student ID: 25-0918, Section: BSIT - BSIT 1 (Year 1)'),
(5, '2025-12-02 03:15:36.535641', 'info', 'Student created: Patrick Pio Bagaloyos', 'Student ID: 25-0919, Section: BSIT - BSIT 1 (Year 1)'),
(6, '2025-12-02 03:15:36.571795', 'info', 'Student created: Zildjian Jay Bahala', 'Student ID: 25-0920, Section: BSIT - BSIT 1 (Year 1)'),
(7, '2025-12-02 03:15:36.673847', 'info', 'Student created: Romulo Muler Balatero', 'Student ID: 25-0921, Section: BSIT - BSIT 1 (Year 1)'),
(8, '2025-12-02 03:15:36.745359', 'info', 'Student created: Christopher Benega', 'Student ID: 25-0922, Section: BSIT - BSIT 1 (Year 1)'),
(9, '2025-12-02 03:15:36.780357', 'info', 'Student created: Mark Aaron Cabanas', 'Student ID: 25-0923, Section: BSIT - BSIT 1 (Year 1)'),
(10, '2025-12-02 03:15:36.812358', 'info', 'Student created: Chealsea Kaye Capagngan', 'Student ID: 24-0473, Section: BSIT - BSIT 1 (Year 1)'),
(11, '2025-12-02 03:15:36.844870', 'info', 'Student created: James Denver Cervantes', 'Student ID: 25-0924, Section: BSIT - BSIT 1 (Year 1)'),
(12, '2025-12-02 03:15:36.913871', 'info', 'Student created: Fritz Jr. Cuaresma', 'Student ID: 24-1189, Section: BSIT - BSIT 1 (Year 1)'),
(13, '2025-12-02 03:15:36.990245', 'info', 'Student created: Edward Cuizon', 'Student ID: 25-0925, Section: BSIT - BSIT 1 (Year 1)'),
(14, '2025-12-02 03:15:37.275137', 'info', 'Student created: Kurt Nicolmar Daleon', 'Student ID: 24-1397, Section: BSIT - BSIT 1 (Year 1)'),
(15, '2025-12-02 03:15:37.474353', 'info', 'Student created: Willard Doyugan', 'Student ID: 25-0926, Section: BSIT - BSIT 1 (Year 1)'),
(16, '2025-12-02 03:15:37.553701', 'info', 'Student created: Rex Benedict Guiltiano', 'Student ID: 22-9869, Section: BSIT - BSIT 1 (Year 1)'),
(17, '2025-12-02 03:15:37.902601', 'info', 'Student created: John Patrick Honculada', 'Student ID: 25-0929, Section: BSIT - BSIT 1 (Year 1)'),
(18, '2025-12-02 03:15:38.291462', 'info', 'Student created: Eroll Jae Laspona', 'Student ID: 24-1245, Section: BSIT - BSIT 1 (Year 1)'),
(19, '2025-12-02 03:15:38.645932', 'info', 'Student created: Nicollette Letejio', 'Student ID: 25-0930, Section: BSIT - BSIT 1 (Year 1)'),
(20, '2025-12-02 03:15:38.935620', 'info', 'Student created: Shandy Macabenlar', 'Student ID: 24-0630, Section: BSIT - BSIT 1 (Year 1)'),
(21, '2025-12-02 03:15:39.170956', 'info', 'Student created: Carstene Veljane Macamay', 'Student ID: 24-1395, Section: BSIT - BSIT 1 (Year 1)'),
(22, '2025-12-02 03:15:39.337993', 'info', 'Student created: Roasol Michael Jan', 'Student ID: 22-1055, Section: BSIT - BSIT 1 (Year 1)'),
(23, '2025-12-02 03:15:39.571822', 'info', 'Student created: Richard Miculob', 'Student ID: 22-0695, Section: BSIT - BSIT 4A (Year 4)'),
(24, '2025-12-02 03:15:39.816827', 'info', 'Student created: Jaypee Navarro', 'Student ID: 25-1393, Section: BSIT - BSIT 1 (Year 1)'),
(25, '2025-12-02 03:15:39.939589', 'info', 'Student created: Yzrah Hushneah Obsid', 'Student ID: 22-0875, Section: BSIT - BSIT 4A (Year 4)'),
(26, '2025-12-02 03:15:40.088996', 'info', 'Student created: Hanny Grace Pagaran', 'Student ID: 25-0933, Section: BSIT - BSIT 1 (Year 1)'),
(27, '2025-12-02 03:15:40.459762', 'info', 'Student created: Angelie Joyce Romanillios', 'Student ID: 22-0935, Section: BSIT - BSIT 1 (Year 1)'),
(28, '2025-12-02 03:15:40.807405', 'info', 'Student created: Chrisjun Sabote', 'Student ID: 25-9373, Section: BSIT - BSIT 4A (Year 4)'),
(29, '2025-12-02 03:15:41.162515', 'info', 'Student created: Rogen Semine', 'Student ID: 23-0558, Section: BSIT - BSIT 1 (Year 1)'),
(30, '2025-12-02 03:15:41.330942', 'info', 'Student created: Lorenzo Simbajon', 'Student ID: 25-0937, Section: BSIT - BSIT 1 (Year 1)'),
(31, '2025-12-02 03:15:41.449383', 'info', 'Student created: Clark Joey Solijon', 'Student ID: 25-0938, Section: BSIT - BSIT 1 (Year 1)'),
(32, '2025-12-02 03:15:41.714281', 'info', 'Student created: Japheth Somonod', 'Student ID: 25-0939, Section: BSIT - BSIT 1 (Year 1)'),
(33, '2025-12-02 03:15:42.067605', 'info', 'Student created: Emgie Tadlas', 'Student ID: 25-0940, Section: BSIT - BSIT 1 (Year 1)'),
(34, '2025-12-02 03:18:32.751713', 'info', 'Attendance recorded for Japheth Somonod', 'Date: 2025-12-02, Times: No times recorded'),
(35, '2025-12-02 03:18:41.140220', 'info', 'Attendance recorded for Fritz Jr. Cuaresma', 'Date: 2025-12-02, Times: No times recorded'),
(36, '2025-12-02 04:19:45.856774', 'info', 'Attendance recorded for James Denver Cervantes', 'Date: 2025-12-02, Times: No times recorded'),
(37, '2025-12-02 05:22:59.172393', 'info', 'Attendance recorded for Chealsea Kaye Capagngan', 'Date: 2025-12-02, Times: No times recorded'),
(38, '2025-12-02 05:23:03.052268', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 98e67ed59e1d1-3490960ddc2sm244821a91.9 - gsmtp\')'),
(39, '2025-12-02 05:23:03.606616', 'info', 'Attendance recorded for John Claire Abatayo', 'Date: 2025-12-02, Times: No times recorded'),
(40, '2025-12-02 05:23:06.999103', 'info', 'Attendance recorded for Rogen Semine', 'Date: 2025-12-02, Times: No times recorded'),
(41, '2025-12-02 05:23:07.942121', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bce442702sm142801745ad.35 - gsmtp\')'),
(42, '2025-12-02 05:23:11.468566', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bceb27804sm140619785ad.54 - gsmtp\')'),
(43, '2025-12-02 05:23:13.245877', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d2e1a72fcca58-7d15e9c3f79sm15222901b3a.42 - gsmtp\')'),
(44, '2025-12-02 05:23:18.952053', 'info', 'Attendance recorded for Shandy Macabenlar', 'Date: 2025-12-02, Times: No times recorded'),
(45, '2025-12-02 05:23:21.607058', 'info', 'Attendance recorded for Jaypee Navarro', 'Date: 2025-12-02, Times: No times recorded'),
(46, '2025-12-02 05:23:23.874919', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 41be03b00d2f7-be4fb24942dsm13646867a12.6 - gsmtp\')'),
(47, '2025-12-02 05:23:26.122576', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d2e1a72fcca58-7d1520a03a3sm15642865b3a.29 - gsmtp\')'),
(48, '2025-12-02 05:23:27.907336', 'info', 'Attendance recorded for John Patrick Honculada', 'Date: 2025-12-02, Times: No times recorded'),
(49, '2025-12-02 05:23:29.733732', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bce2e676esm138616515ad.0 - gsmtp\')'),
(50, '2025-12-02 05:23:31.222552', 'info', 'Attendance recorded for Jocelyn Acebes', 'Date: 2025-12-02, Times: No times recorded'),
(51, '2025-12-02 05:23:32.220481', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bceb7d4f4sm139357925ad.101 - gsmtp\')'),
(52, '2025-12-02 05:23:33.898024', 'info', 'Attendance recorded for Rex Benedict Guiltiano', 'Date: 2025-12-02, Times: No times recorded'),
(53, '2025-12-02 05:23:38.390409', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 98e67ed59e1d1-34909561b23sm314143a91.4 - gsmtp\')'),
(54, '2025-12-02 05:23:39.262801', 'info', 'Attendance recorded for Zildjian Jay Bahala', 'Date: 2025-12-02, Times: No times recorded'),
(55, '2025-12-02 05:23:40.321214', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d2e1a72fcca58-7d150b66c67sm15457222b3a.13 - gsmtp\')'),
(56, '2025-12-02 05:23:42.183141', 'info', 'Attendance recorded for Kurt Nicolmar Daleon', 'Date: 2025-12-02, Times: No times recorded'),
(57, '2025-12-02 05:23:44.757821', 'info', 'Attendance recorded for Romulo Muler Balatero', 'Date: 2025-12-02, Times: No times recorded'),
(58, '2025-12-02 05:23:45.060935', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bceb450dasm139399325ad.76 - gsmtp\')'),
(59, '2025-12-02 05:23:45.805200', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 98e67ed59e1d1-3477b7341d2sm14905830a91.11 - gsmtp\')'),
(60, '2025-12-02 05:23:48.695575', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 41be03b00d2f7-be4fbb0094dsm14053779a12.10 - gsmtp\')'),
(61, '2025-12-02 05:23:50.666246', 'info', 'Attendance recorded for Carstene Veljane Macamay', 'Date: 2025-12-02, Times: No times recorded'),
(62, '2025-12-02 05:23:53.190237', 'info', 'Attendance recorded for Richard Miculob', 'Date: 2025-12-02, Times: No times recorded'),
(63, '2025-12-02 05:23:57.752494', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 98e67ed59e1d1-34907d4a569sm580743a91.0 - gsmtp\')'),
(64, '2025-12-02 05:23:57.819139', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bce40acbbsm143410465ad.11 - gsmtp\')'),
(65, '2025-12-02 05:23:57.859423', 'info', 'Attendance recorded for Patrick Pio Bagaloyos', 'Date: 2025-12-02, Times: No times recorded'),
(66, '2025-12-02 05:24:01.936305', 'info', 'Attendance recorded for Christopher Benega', 'Date: 2025-12-02, Times: No times recorded'),
(67, '2025-12-02 05:24:06.521151', 'info', 'Attendance recorded for Angelie Joyce Romanillios', 'Date: 2025-12-02, Times: No times recorded'),
(68, '2025-12-02 05:24:06.906081', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bceb40021sm141693455ad.68 - gsmtp\')'),
(69, '2025-12-02 05:24:10.396041', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 41be03b00d2f7-be509f4ee3fsm13642064a12.34 - gsmtp\')'),
(70, '2025-12-02 05:24:11.298371', 'info', 'Attendance recorded for Nicollette Letejio', 'Date: 2025-12-02, Times: No times recorded'),
(71, '2025-12-02 05:24:14.056837', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bceb559d6sm141028125ad.94 - gsmtp\')'),
(72, '2025-12-02 05:24:14.686741', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d2e1a72fcca58-7d15fcfd0fbsm15469444b3a.66 - gsmtp\')'),
(73, '2025-12-02 05:35:14.465050', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d2e1a72fcca58-7d15e6e6e06sm15395326b3a.43 - gsmtp\')'),
(74, '2025-12-02 05:35:19.231486', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 98e67ed59e1d1-3476a54705csm18787431a91.2 - gsmtp\')'),
(75, '2025-12-02 05:35:26.086763', 'info', 'Attendance recorded for Eroll Jae Laspona', 'Date: 2025-12-02, Times: No times recorded'),
(76, '2025-12-02 05:35:26.151854', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 41be03b00d2f7-be4fb24872fsm13978531a12.1 - gsmtp\')'),
(77, '2025-12-02 05:35:28.790791', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bceb54438sm139466335ad.88 - gsmtp\')'),
(78, '2025-12-02 05:35:31.070699', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 98e67ed59e1d1-3476a55ed00sm18650204a91.5 - gsmtp\')'),
(79, '2025-12-02 05:35:36.772800', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d2e1a72fcca58-7d151ad71a3sm15301331b3a.25 - gsmtp\')'),
(80, '2025-12-02 05:35:38.916053', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials 41be03b00d2f7-be509f4ee3fsm13677750a12.34 - gsmtp\')'),
(81, '2025-12-02 05:35:43.204809', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bceb7f69asm138649765ad.102 - gsmtp\')'),
(82, '2025-12-02 05:35:47.150319', 'error', 'Failed to send attendance email', '(535, b\'5.7.8 Username and Password not accepted. For more information, go to\\n5.7.8  https://support.google.com/mail/?p=BadCredentials d9443c01a7336-29bceb54915sm141301445ad.92 - gsmtp\')'),
(83, '2025-12-03 01:07:14.140977', 'warning', 'Student deleted: Emgie Tadlas', 'Student ID: 25-0940'),
(84, '2025-12-03 01:07:14.196105', 'warning', 'Student deleted: Japheth Somonod', 'Student ID: 25-0939'),
(85, '2025-12-03 01:07:14.208620', 'warning', 'Student deleted: Clark Joey Solijon', 'Student ID: 25-0938'),
(86, '2025-12-03 01:07:14.212348', 'warning', 'Student deleted: Lorenzo Simbajon', 'Student ID: 25-0937'),
(87, '2025-12-03 01:07:14.216347', 'warning', 'Student deleted: Rogen Semine', 'Student ID: 23-0558'),
(88, '2025-12-03 01:07:14.221971', 'warning', 'Student deleted: Chrisjun Sabote', 'Student ID: 25-9373'),
(89, '2025-12-03 01:07:14.225974', 'warning', 'Student deleted: Angelie Joyce Romanillios', 'Student ID: 22-0935'),
(90, '2025-12-03 01:07:14.229961', 'warning', 'Student deleted: Hanny Grace Pagaran', 'Student ID: 25-0933'),
(91, '2025-12-03 01:07:14.233970', 'warning', 'Student deleted: Yzrah Hushneah Obsid', 'Student ID: 22-0875'),
(92, '2025-12-03 01:07:14.240862', 'warning', 'Student deleted: Jaypee Navarro', 'Student ID: 25-1393'),
(93, '2025-12-03 01:07:14.346765', 'warning', 'Student deleted: Richard Miculob', 'Student ID: 22-0695'),
(94, '2025-12-03 01:07:14.374941', 'warning', 'Student deleted: Roasol Michael Jan', 'Student ID: 22-1055'),
(95, '2025-12-03 01:07:14.390344', 'warning', 'Student deleted: Carstene Veljane Macamay', 'Student ID: 24-1395'),
(96, '2025-12-03 01:07:14.402819', 'warning', 'Student deleted: Shandy Macabenlar', 'Student ID: 24-0630'),
(97, '2025-12-03 01:07:14.409933', 'warning', 'Student deleted: Nicollette Letejio', 'Student ID: 25-0930'),
(98, '2025-12-03 01:07:14.419825', 'warning', 'Student deleted: Eroll Jae Laspona', 'Student ID: 24-1245'),
(99, '2025-12-03 01:07:14.428897', 'warning', 'Student deleted: John Patrick Honculada', 'Student ID: 25-0929'),
(100, '2025-12-03 01:07:14.443345', 'warning', 'Student deleted: Rex Benedict Guiltiano', 'Student ID: 22-9869'),
(101, '2025-12-03 01:07:14.450107', 'warning', 'Student deleted: Willard Doyugan', 'Student ID: 25-0926'),
(102, '2025-12-03 01:07:14.460108', 'warning', 'Student deleted: Kurt Nicolmar Daleon', 'Student ID: 24-1397'),
(103, '2025-12-03 01:07:14.462376', 'warning', 'Student deleted: Edward Cuizon', 'Student ID: 25-0925'),
(104, '2025-12-03 01:07:14.465896', 'warning', 'Student deleted: Fritz Jr. Cuaresma', 'Student ID: 24-1189'),
(105, '2025-12-03 01:07:14.473909', 'warning', 'Student deleted: James Denver Cervantes', 'Student ID: 25-0924'),
(106, '2025-12-03 01:07:14.475913', 'warning', 'Student deleted: Chealsea Kaye Capagngan', 'Student ID: 24-0473'),
(107, '2025-12-03 01:07:14.477915', 'warning', 'Student deleted: Mark Aaron Cabanas', 'Student ID: 25-0923'),
(108, '2025-12-03 01:07:14.479926', 'warning', 'Student deleted: Christopher Benega', 'Student ID: 25-0922'),
(109, '2025-12-03 01:07:14.481445', 'warning', 'Student deleted: Romulo Muler Balatero', 'Student ID: 25-0921'),
(110, '2025-12-03 01:07:14.483456', 'warning', 'Student deleted: Zildjian Jay Bahala', 'Student ID: 25-0920'),
(111, '2025-12-03 01:07:14.485453', 'warning', 'Student deleted: Patrick Pio Bagaloyos', 'Student ID: 25-0919'),
(112, '2025-12-03 01:07:14.490336', 'warning', 'Student deleted: Catherine Awayan', 'Student ID: 25-0918'),
(113, '2025-12-03 01:07:14.496441', 'warning', 'Student deleted: Jocelyn Acebes', 'Student ID: 24-1394'),
(114, '2025-12-03 01:07:14.503986', 'warning', 'Student deleted: Clyde Christian Acebes', 'Student ID: 25-0917'),
(115, '2025-12-03 01:07:14.513098', 'warning', 'Student deleted: John Claire Abatayo', 'Student ID: 25-0916'),
(116, '2025-12-03 01:09:00.607593', 'info', 'Student created: John Claire Abatayo', 'Student ID: 25-0916, Section: BSIT - BSIT 1 (Year 1)'),
(117, '2025-12-03 01:09:00.662328', 'info', 'Student created: Clyde Christian Acebes', 'Student ID: 25-0917, Section: BSIT - BSIT 1 (Year 1)'),
(118, '2025-12-03 01:09:00.693976', 'info', 'Student created: Jocelyn Acebes', 'Student ID: 24-1394, Section: BSIT - BSIT 1 (Year 1)'),
(119, '2025-12-03 01:09:00.717520', 'info', 'Student created: Catherine Awayan', 'Student ID: 25-0918, Section: BSIT - BSIT 1 (Year 1)'),
(120, '2025-12-03 01:09:00.743552', 'info', 'Student created: Patrick Pio Bagaloyos', 'Student ID: 25-0919, Section: BSIT - BSIT 1 (Year 1)'),
(121, '2025-12-03 01:09:00.769584', 'info', 'Student created: Zildjian Jay Bahala', 'Student ID: 25-0920, Section: BSIT - BSIT 1 (Year 1)'),
(122, '2025-12-03 01:09:00.791644', 'info', 'Student created: Romulo Muler Balatero', 'Student ID: 25-0921, Section: BSIT - BSIT 1 (Year 1)'),
(123, '2025-12-03 01:09:00.817698', 'info', 'Student created: Christopher Benega', 'Student ID: 25-0922, Section: BSIT - BSIT 1 (Year 1)'),
(124, '2025-12-03 01:09:00.846818', 'info', 'Student created: Mark Aaron Cabanas', 'Student ID: 25-0923, Section: BSIT - BSIT 1 (Year 1)'),
(125, '2025-12-03 01:09:00.876271', 'info', 'Student created: Chealsea Kaye Capagngan', 'Student ID: 24-0473, Section: BSIT - BSIT 1 (Year 1)'),
(126, '2025-12-03 01:09:00.903583', 'info', 'Student created: James Denver Cervantes', 'Student ID: 25-0924, Section: BSIT - BSIT 1 (Year 1)'),
(127, '2025-12-03 01:09:00.931439', 'info', 'Student created: Fritz Jr. Cuaresma', 'Student ID: 24-1189, Section: BSIT - BSIT 1 (Year 1)'),
(128, '2025-12-03 01:09:00.959720', 'info', 'Student created: Edward Cuizon', 'Student ID: 25-0925, Section: BSIT - BSIT 1 (Year 1)'),
(129, '2025-12-03 01:09:00.987275', 'info', 'Student created: Kurt Nicolmar Daleon', 'Student ID: 24-1397, Section: BSIT - BSIT 1 (Year 1)'),
(130, '2025-12-03 01:09:01.015807', 'info', 'Student created: Willard Doyugan', 'Student ID: 25-0926, Section: BSIT - BSIT 1 (Year 1)'),
(131, '2025-12-03 01:09:01.066510', 'info', 'Student created: Rex Benedict Guiltiano', 'Student ID: 22-9869, Section: BSIT - BSIT 1 (Year 1)'),
(132, '2025-12-03 01:09:01.105625', 'info', 'Student created: John Patrick Honculada', 'Student ID: 25-0929, Section: BSIT - BSIT 1 (Year 1)'),
(133, '2025-12-03 01:09:01.153331', 'info', 'Student created: Eroll Jae Laspona', 'Student ID: 24-1245, Section: BSIT - BSIT 1 (Year 1)'),
(134, '2025-12-03 01:09:01.186141', 'info', 'Student created: Nicollette Letejio', 'Student ID: 25-0930, Section: BSIT - BSIT 1 (Year 1)'),
(135, '2025-12-03 01:09:01.217287', 'info', 'Student created: Shandy Macabenlar', 'Student ID: 24-0630, Section: BSIT - BSIT 1 (Year 1)'),
(136, '2025-12-03 01:09:01.252253', 'info', 'Student created: Carstene Veljane Macamay', 'Student ID: 24-1395, Section: BSIT - BSIT 1 (Year 1)'),
(137, '2025-12-03 01:09:01.283276', 'info', 'Student created: Roasol Michael Jan', 'Student ID: 22-1055, Section: BSIT - BSIT 1 (Year 1)'),
(138, '2025-12-03 01:09:01.338479', 'info', 'Student created: Richard Miculob', 'Student ID: 22-0695, Section: BSEE - BSEE 1A (Year 1)'),
(139, '2025-12-03 01:09:01.387413', 'info', 'Student created: Jaypee Navarro', 'Student ID: 25-1393, Section: BSIT - BSIT 1 (Year 1)'),
(140, '2025-12-03 01:09:01.436632', 'info', 'Student created: Yzrah Hushneah Obsid', 'Student ID: 22-0875, Section: BSIT - BSIT 4A (Year 4)'),
(141, '2025-12-03 01:09:01.473338', 'info', 'Student created: Hanny Grace Pagaran', 'Student ID: 25-0933, Section: BSIT - BSIT 1 (Year 1)'),
(142, '2025-12-03 01:09:01.518484', 'info', 'Student created: Angelie Joyce Romanillios', 'Student ID: 22-0935, Section: BSIT - BSIT 1 (Year 1)'),
(143, '2025-12-03 01:09:01.558343', 'info', 'Student created: Chrisjun Sabote', 'Student ID: 25-9373, Section: BSIT - BSIT 4A (Year 4)'),
(144, '2025-12-03 01:09:01.600387', 'info', 'Student created: Rogen Semine', 'Student ID: 23-0558, Section: BSIT - BSIT 1 (Year 1)'),
(145, '2025-12-03 01:09:01.723375', 'info', 'Student created: Lorenzo Simbajon', 'Student ID: 25-0937, Section: BSIT - BSIT 1 (Year 1)'),
(146, '2025-12-03 01:09:01.778414', 'info', 'Student created: Clark Joey Solijon', 'Student ID: 25-0938, Section: BSIT - BSIT 1 (Year 1)'),
(147, '2025-12-03 01:09:01.895784', 'info', 'Student created: Japheth Somonod', 'Student ID: 25-0939, Section: BSIT - BSIT 1 (Year 1)'),
(148, '2025-12-03 01:09:02.184263', 'info', 'Student created: Emgie Tadlas', 'Student ID: 25-0940, Section: BSIT - BSIT 1 (Year 1)'),
(149, '2025-12-03 01:09:27.896766', 'warning', 'Student deleted: Richard Miculob', 'Student ID: 22-0695'),
(150, '2025-12-03 01:10:06.641138', 'info', 'Student created: Richard Miculob', 'Student ID: 22-0695, Section: BSEE - BSEE 4A (Year 4)'),
(151, '2025-12-03 01:11:04.206112', 'info', 'Student updated: Richard Miculob', 'Student ID: 22-0695, Section: BSEE - BSEE 4A (Year 4)'),
(152, '2025-12-03 01:11:33.794305', 'warning', 'Student deleted: Richard Miculob', 'Student ID: 22-0695'),
(153, '2025-12-03 01:12:05.300332', 'info', 'Student created: Richard Miculob', 'Student ID: 22-0695, Section: BSIT - BSIT 4A (Year 4)'),
(154, '2025-12-03 01:13:17.887394', 'warning', 'Student deleted: Richard Miculob', 'Student ID: 22-0695'),
(155, '2025-12-03 01:14:13.264275', 'info', 'Student created: Richard Miculob', 'Student ID: 22-0695, Section: BSEE - BSEE 4A (Year 4)'),
(156, '2025-12-03 01:17:29.616425', 'warning', 'Student deleted: Emgie Tadlas', 'Student ID: 25-0940'),
(157, '2025-12-03 01:17:29.623092', 'warning', 'Student deleted: Japheth Somonod', 'Student ID: 25-0939'),
(158, '2025-12-03 01:17:29.624092', 'warning', 'Student deleted: Clark Joey Solijon', 'Student ID: 25-0938'),
(159, '2025-12-03 01:17:29.626710', 'warning', 'Student deleted: Lorenzo Simbajon', 'Student ID: 25-0937'),
(160, '2025-12-03 01:17:29.627710', 'warning', 'Student deleted: Rogen Semine', 'Student ID: 23-0558'),
(161, '2025-12-03 01:17:29.629944', 'warning', 'Student deleted: Chrisjun Sabote', 'Student ID: 25-9373'),
(162, '2025-12-03 01:17:29.634003', 'warning', 'Student deleted: Angelie Joyce Romanillios', 'Student ID: 22-0935'),
(163, '2025-12-03 01:17:29.636072', 'warning', 'Student deleted: Hanny Grace Pagaran', 'Student ID: 25-0933'),
(164, '2025-12-03 01:17:29.637067', 'warning', 'Student deleted: Yzrah Hushneah Obsid', 'Student ID: 22-0875'),
(165, '2025-12-03 01:17:29.639065', 'warning', 'Student deleted: Jaypee Navarro', 'Student ID: 25-1393'),
(166, '2025-12-03 01:17:29.639968', 'warning', 'Student deleted: Roasol Michael Jan', 'Student ID: 22-1055'),
(167, '2025-12-03 01:17:29.642099', 'warning', 'Student deleted: Carstene Veljane Macamay', 'Student ID: 24-1395'),
(168, '2025-12-03 01:17:29.643089', 'warning', 'Student deleted: Shandy Macabenlar', 'Student ID: 24-0630'),
(169, '2025-12-03 01:17:29.644967', 'warning', 'Student deleted: Nicollette Letejio', 'Student ID: 25-0930'),
(170, '2025-12-03 01:17:29.647116', 'warning', 'Student deleted: Eroll Jae Laspona', 'Student ID: 24-1245'),
(171, '2025-12-03 01:17:29.648049', 'warning', 'Student deleted: John Patrick Honculada', 'Student ID: 25-0929'),
(172, '2025-12-03 01:17:29.649098', 'warning', 'Student deleted: Rex Benedict Guiltiano', 'Student ID: 22-9869'),
(173, '2025-12-03 01:17:29.651081', 'warning', 'Student deleted: Willard Doyugan', 'Student ID: 25-0926'),
(174, '2025-12-03 01:17:29.652088', 'warning', 'Student deleted: Kurt Nicolmar Daleon', 'Student ID: 24-1397'),
(175, '2025-12-03 01:17:29.653086', 'warning', 'Student deleted: Edward Cuizon', 'Student ID: 25-0925'),
(176, '2025-12-03 01:17:29.655086', 'warning', 'Student deleted: Fritz Jr. Cuaresma', 'Student ID: 24-1189'),
(177, '2025-12-03 01:17:29.656070', 'warning', 'Student deleted: James Denver Cervantes', 'Student ID: 25-0924'),
(178, '2025-12-03 01:17:29.657089', 'warning', 'Student deleted: Chealsea Kaye Capagngan', 'Student ID: 24-0473'),
(179, '2025-12-03 01:17:29.659072', 'warning', 'Student deleted: Mark Aaron Cabanas', 'Student ID: 25-0923'),
(180, '2025-12-03 01:17:29.660076', 'warning', 'Student deleted: Christopher Benega', 'Student ID: 25-0922'),
(181, '2025-12-03 01:17:29.661970', 'warning', 'Student deleted: Romulo Muler Balatero', 'Student ID: 25-0921'),
(182, '2025-12-03 01:17:29.663627', 'warning', 'Student deleted: Zildjian Jay Bahala', 'Student ID: 25-0920'),
(183, '2025-12-03 01:17:29.665517', 'warning', 'Student deleted: Patrick Pio Bagaloyos', 'Student ID: 25-0919'),
(184, '2025-12-03 01:17:29.666509', 'warning', 'Student deleted: Catherine Awayan', 'Student ID: 25-0918'),
(185, '2025-12-03 01:17:29.667509', 'warning', 'Student deleted: Jocelyn Acebes', 'Student ID: 24-1394'),
(186, '2025-12-03 01:17:29.669609', 'warning', 'Student deleted: Clyde Christian Acebes', 'Student ID: 25-0917'),
(187, '2025-12-03 01:17:29.670614', 'warning', 'Student deleted: John Claire Abatayo', 'Student ID: 25-0916'),
(188, '2025-12-03 01:17:35.822948', 'warning', 'Student deleted: Richard Miculob', 'Student ID: 22-0695'),
(189, '2025-12-03 01:20:48.132275', 'info', 'Student created: John Claire Abatayo', 'Student ID: 25-0916, Section: BSIT - BSIT 1 (Year 1)'),
(190, '2025-12-03 01:20:48.169280', 'info', 'Student created: Clyde Christian Acebes', 'Student ID: 25-0917, Section: BSIT - BSIT 1 (Year 1)'),
(191, '2025-12-03 01:20:48.197062', 'info', 'Student created: Jocelyn Acebes', 'Student ID: 24-1394, Section: BSIT - BSIT 1 (Year 1)'),
(192, '2025-12-03 01:20:48.226840', 'info', 'Student created: Catherine Awayan', 'Student ID: 25-0918, Section: BSIT - BSIT 1 (Year 1)'),
(193, '2025-12-03 01:20:48.257953', 'info', 'Student created: Patrick Pio Bagaloyos', 'Student ID: 25-0919, Section: BSIT - BSIT 1 (Year 1)'),
(194, '2025-12-03 01:20:48.282224', 'info', 'Student created: Zildjian Jay Bahala', 'Student ID: 25-0920, Section: BSIT - BSIT 1 (Year 1)'),
(195, '2025-12-03 01:20:48.305660', 'info', 'Student created: Romulo Muler Balatero', 'Student ID: 25-0921, Section: BSIT - BSIT 1 (Year 1)'),
(196, '2025-12-03 01:20:48.330371', 'info', 'Student created: Christopher Benega', 'Student ID: 25-0922, Section: BSIT - BSIT 1 (Year 1)'),
(197, '2025-12-03 01:20:48.357157', 'info', 'Student created: Mark Aaron Cabanas', 'Student ID: 25-0923, Section: BSIT - BSIT 1 (Year 1)'),
(198, '2025-12-03 01:20:48.393975', 'info', 'Student created: Chealsea Kaye Capagngan', 'Student ID: 24-0473, Section: BSIT - BSIT 1 (Year 1)'),
(199, '2025-12-03 01:20:48.418497', 'info', 'Student created: James Denver Cervantes', 'Student ID: 25-0924, Section: BSIT - BSIT 1 (Year 1)'),
(200, '2025-12-03 01:20:48.444384', 'info', 'Student created: Fritz Jr. Cuaresma', 'Student ID: 24-1189, Section: BSIT - BSIT 1 (Year 1)'),
(201, '2025-12-03 01:20:48.471942', 'info', 'Student created: Edward Cuizon', 'Student ID: 25-0925, Section: BSIT - BSIT 1 (Year 1)'),
(202, '2025-12-03 01:20:48.498255', 'info', 'Student created: Kurt Nicolmar Daleon', 'Student ID: 24-1397, Section: BSIT - BSIT 1 (Year 1)'),
(203, '2025-12-03 01:20:48.526157', 'info', 'Student created: Willard Doyugan', 'Student ID: 25-0926, Section: BSIT - BSIT 1 (Year 1)'),
(204, '2025-12-03 01:20:48.620379', 'info', 'Student created: Rex Benedict Guiltiano', 'Student ID: 22-9869, Section: BSIT - BSIT 1 (Year 1)'),
(205, '2025-12-03 01:20:48.645951', 'info', 'Student created: John Patrick Honculada', 'Student ID: 25-0929, Section: BSIT - BSIT 1 (Year 1)'),
(206, '2025-12-03 01:20:48.676232', 'info', 'Student created: Eroll Jae Laspona', 'Student ID: 24-1245, Section: BSIT - BSIT 1 (Year 1)'),
(207, '2025-12-03 01:20:48.705011', 'info', 'Student created: Nicollette Letejio', 'Student ID: 25-0930, Section: BSIT - BSIT 1 (Year 1)'),
(208, '2025-12-03 01:20:48.731144', 'info', 'Student created: Shandy Macabenlar', 'Student ID: 24-0630, Section: BSIT - BSIT 1 (Year 1)'),
(209, '2025-12-03 01:20:48.758157', 'info', 'Student created: Carstene Veljane Macamay', 'Student ID: 24-1395, Section: BSIT - BSIT 1 (Year 1)'),
(210, '2025-12-03 01:20:48.786182', 'info', 'Student created: Roasol Michael Jan', 'Student ID: 22-1055, Section: BSIT - BSIT 1 (Year 1)'),
(211, '2025-12-03 01:20:48.816433', 'info', 'Student created: Richard Miculob', 'Student ID: 22-0695, Section: BSEE - BSEE 1A (Year 1)'),
(212, '2025-12-03 01:20:48.841499', 'info', 'Student created: Jaypee Navarro', 'Student ID: 25-1393, Section: BSIT - BSIT 1 (Year 1)'),
(213, '2025-12-03 01:20:48.864564', 'info', 'Student created: Yzrah Hushneah Obsid', 'Student ID: 22-0875, Section: BSIT - BSIT 4A (Year 4)'),
(214, '2025-12-03 01:20:48.891495', 'info', 'Student created: Hanny Grace Pagaran', 'Student ID: 25-0933, Section: BSIT - BSIT 1 (Year 1)'),
(215, '2025-12-03 01:20:48.918095', 'info', 'Student created: Angelie Joyce Romanillios', 'Student ID: 22-0935, Section: BSIT - BSIT 1 (Year 1)'),
(216, '2025-12-03 01:20:48.939020', 'info', 'Student created: Chrisjun Sabote', 'Student ID: 25-9373, Section: BSIT - BSIT 4A (Year 4)'),
(217, '2025-12-03 01:20:48.964061', 'info', 'Student created: Rogen Semine', 'Student ID: 23-0558, Section: BSIT - BSIT 1 (Year 1)'),
(218, '2025-12-03 01:20:49.004580', 'info', 'Student created: Lorenzo Simbajon', 'Student ID: 25-0937, Section: BSIT - BSIT 1 (Year 1)'),
(219, '2025-12-03 01:20:49.030765', 'info', 'Student created: Clark Joey Solijon', 'Student ID: 25-0938, Section: BSIT - BSIT 1 (Year 1)'),
(220, '2025-12-03 01:20:49.054349', 'info', 'Student created: Japheth Somonod', 'Student ID: 25-0939, Section: BSIT - BSIT 1 (Year 1)'),
(221, '2025-12-03 01:20:49.081522', 'info', 'Student created: Emgie Tadlas', 'Student ID: 25-0940, Section: BSIT - BSIT 1 (Year 1)'),
(222, '2025-12-03 01:21:15.594348', 'warning', 'Student deleted: Richard Miculob', 'Student ID: 22-0695'),
(223, '2025-12-03 01:22:11.078871', 'info', 'Student created: Richard Miculob', 'Student ID: 22-0695, Section: BTCT - BTCT 4A (Year 4)'),
(224, '2025-12-03 01:22:51.419227', 'info', 'Student updated: Richard Miculob', 'Student ID: 22-0695, Section: BTCT - BTCT 4A (Year 4)'),
(225, '2025-12-03 01:31:01.975103', 'info', 'Attendance recorded for Richard Miculob', 'Date: 2025-12-03, Times: No times recorded'),
(226, '2025-12-03 01:32:31.648798', 'info', 'Attendance recorded for Chealsea Kaye Capagngan', 'Date: 2025-12-03, Times: No times recorded'),
(227, '2025-12-03 01:37:29.288963', 'info', 'Attendance recorded for Carstene Veljane Macamay', 'Date: 2025-12-03, Times: No times recorded'),
(228, '2025-12-03 01:37:32.484315', 'info', 'Attendance recorded for Kurt Nicolmar Daleon', 'Date: 2025-12-03, Times: No times recorded'),
(229, '2025-12-03 01:37:35.725618', 'info', 'Attendance recorded for Patrick Pio Bagaloyos', 'Date: 2025-12-03, Times: No times recorded'),
(230, '2026-08-09 02:18:48.762037', 'warning', 'Student deleted: Richard Miculob', 'Student ID: 22-0695'),
(231, '2026-08-09 02:18:48.823177', 'warning', 'Student deleted: Emgie Tadlas', 'Student ID: 25-0940'),
(232, '2026-08-09 02:18:48.825178', 'warning', 'Student deleted: Japheth Somonod', 'Student ID: 25-0939'),
(233, '2026-08-09 02:18:48.826299', 'warning', 'Student deleted: Clark Joey Solijon', 'Student ID: 25-0938'),
(234, '2026-08-09 02:18:48.829043', 'warning', 'Student deleted: Lorenzo Simbajon', 'Student ID: 25-0937'),
(235, '2026-08-09 02:18:48.830533', 'warning', 'Student deleted: Rogen Semine', 'Student ID: 23-0558'),
(236, '2026-08-09 02:18:48.832620', 'warning', 'Student deleted: Chrisjun Sabote', 'Student ID: 25-9373'),
(237, '2026-08-09 02:18:48.834650', 'warning', 'Student deleted: Angelie Joyce Romanillios', 'Student ID: 22-0935'),
(238, '2026-08-09 02:18:48.835651', 'warning', 'Student deleted: Hanny Grace Pagaran', 'Student ID: 25-0933'),
(239, '2026-08-09 02:18:48.837641', 'warning', 'Student deleted: Yzrah Hushneah Obsid', 'Student ID: 22-0875'),
(240, '2026-08-09 02:18:48.838542', 'warning', 'Student deleted: Jaypee Navarro', 'Student ID: 25-1393'),
(241, '2026-08-09 02:18:48.840048', 'warning', 'Student deleted: Roasol Michael Jan', 'Student ID: 22-1055'),
(242, '2026-08-09 02:18:48.841056', 'warning', 'Student deleted: Carstene Veljane Macamay', 'Student ID: 24-1395'),
(243, '2026-08-09 02:18:48.843799', 'warning', 'Student deleted: Shandy Macabenlar', 'Student ID: 24-0630'),
(244, '2026-08-09 02:18:48.844910', 'warning', 'Student deleted: Nicollette Letejio', 'Student ID: 25-0930'),
(245, '2026-08-09 02:18:48.846810', 'warning', 'Student deleted: Eroll Jae Laspona', 'Student ID: 24-1245'),
(246, '2026-08-09 02:18:48.847903', 'warning', 'Student deleted: John Patrick Honculada', 'Student ID: 25-0929'),
(247, '2026-08-09 02:18:48.848904', 'warning', 'Student deleted: Rex Benedict Guiltiano', 'Student ID: 22-9869'),
(248, '2026-08-09 02:18:48.850507', 'warning', 'Student deleted: Willard Doyugan', 'Student ID: 25-0926'),
(249, '2026-08-09 02:18:48.851515', 'warning', 'Student deleted: Kurt Nicolmar Daleon', 'Student ID: 24-1397'),
(250, '2026-08-09 02:18:48.853618', 'warning', 'Student deleted: Edward Cuizon', 'Student ID: 25-0925'),
(251, '2026-08-09 02:18:48.854564', 'warning', 'Student deleted: Fritz Jr. Cuaresma', 'Student ID: 24-1189'),
(252, '2026-08-09 02:18:48.856514', 'warning', 'Student deleted: James Denver Cervantes', 'Student ID: 25-0924'),
(253, '2026-08-09 02:18:48.857584', 'warning', 'Student deleted: Chealsea Kaye Capagngan', 'Student ID: 24-0473'),
(254, '2026-08-09 02:18:48.858638', 'warning', 'Student deleted: Mark Aaron Cabanas', 'Student ID: 25-0923'),
(255, '2026-08-09 02:18:48.861247', 'warning', 'Student deleted: Christopher Benega', 'Student ID: 25-0922'),
(256, '2026-08-09 02:18:48.863356', 'warning', 'Student deleted: Romulo Muler Balatero', 'Student ID: 25-0921'),
(257, '2026-08-09 02:18:48.864305', 'warning', 'Student deleted: Zildjian Jay Bahala', 'Student ID: 25-0920'),
(258, '2026-08-09 02:18:48.865358', 'warning', 'Student deleted: Patrick Pio Bagaloyos', 'Student ID: 25-0919'),
(259, '2026-08-09 02:18:48.867353', 'warning', 'Student deleted: Catherine Awayan', 'Student ID: 25-0918'),
(260, '2026-08-09 02:18:48.868365', 'warning', 'Student deleted: Jocelyn Acebes', 'Student ID: 24-1394'),
(261, '2026-08-09 02:18:48.870359', 'warning', 'Student deleted: Clyde Christian Acebes', 'Student ID: 25-0917'),
(262, '2026-08-09 02:18:48.870936', 'warning', 'Student deleted: John Claire Abatayo', 'Student ID: 25-0916');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_app_systemsettings`
--

CREATE TABLE `attendance_app_systemsettings` (
  `id` bigint(20) NOT NULL,
  `system_title` varchar(100) NOT NULL,
  `footer_text` varchar(100) NOT NULL,
  `logo` varchar(100) DEFAULT NULL,
  `version` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_app_systemsettings`
--

INSERT INTO `attendance_app_systemsettings` (`id`, `system_title`, `footer_text`, `logo`, `version`) VALUES
(1, 'Camiguin Polytechnic State College', 'CPSC © 2025', '', '1.0.0');

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add course', 7, 'add_course'),
(26, 'Can change course', 7, 'change_course'),
(27, 'Can delete course', 7, 'delete_course'),
(28, 'Can view course', 7, 'view_course'),
(29, 'Can add email settings', 8, 'add_emailsettings'),
(30, 'Can change email settings', 8, 'change_emailsettings'),
(31, 'Can delete email settings', 8, 'delete_emailsettings'),
(32, 'Can view email settings', 8, 'view_emailsettings'),
(33, 'Can add institute', 9, 'add_institute'),
(34, 'Can change institute', 9, 'change_institute'),
(35, 'Can delete institute', 9, 'delete_institute'),
(36, 'Can view institute', 9, 'view_institute'),
(37, 'Can add section', 10, 'add_section'),
(38, 'Can change section', 10, 'change_section'),
(39, 'Can delete section', 10, 'delete_section'),
(40, 'Can view section', 10, 'view_section'),
(41, 'Can add system log', 11, 'add_systemlog'),
(42, 'Can change system log', 11, 'change_systemlog'),
(43, 'Can delete system log', 11, 'delete_systemlog'),
(44, 'Can view system log', 11, 'view_systemlog'),
(45, 'Can add system settings', 12, 'add_systemsettings'),
(46, 'Can change system settings', 12, 'change_systemsettings'),
(47, 'Can delete system settings', 12, 'delete_systemsettings'),
(48, 'Can view system settings', 12, 'view_systemsettings'),
(49, 'Can add student', 13, 'add_student'),
(50, 'Can change student', 13, 'change_student'),
(51, 'Can delete student', 13, 'delete_student'),
(52, 'Can view student', 13, 'view_student'),
(53, 'Can add password reset otp', 14, 'add_passwordresetotp'),
(54, 'Can change password reset otp', 14, 'change_passwordresetotp'),
(55, 'Can delete password reset otp', 14, 'delete_passwordresetotp'),
(56, 'Can view password reset otp', 14, 'view_passwordresetotp'),
(57, 'Can add attendance record', 15, 'add_attendancerecord'),
(58, 'Can change attendance record', 15, 'change_attendancerecord'),
(59, 'Can delete attendance record', 15, 'delete_attendancerecord'),
(60, 'Can view attendance record', 15, 'view_attendancerecord');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(4, 'pbkdf2_sha256$600000$uxjpqUlJ3PX71i7sDgzTUC$EoqHVJS60il+JrV3xD56YADx8zxI38aiZk8nFBiZPDg=', '2026-08-09 02:10:01.216090', 0, 'chardoxx', 'Richard', 'Miculob', 'miculobrichardvictor@gmail.com', 0, 1, '2025-12-02 04:47:46.770917');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(15, 'attendance_app', 'attendancerecord'),
(7, 'attendance_app', 'course'),
(8, 'attendance_app', 'emailsettings'),
(9, 'attendance_app', 'institute'),
(14, 'attendance_app', 'passwordresetotp'),
(10, 'attendance_app', 'section'),
(13, 'attendance_app', 'student'),
(11, 'attendance_app', 'systemlog'),
(12, 'attendance_app', 'systemsettings'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-12-02 03:07:28.177838'),
(2, 'auth', '0001_initial', '2025-12-02 03:07:28.437983'),
(3, 'admin', '0001_initial', '2025-12-02 03:07:28.497001'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-12-02 03:07:28.502998'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-12-02 03:07:28.510231'),
(6, 'attendance_app', '0001_initial', '2025-12-02 03:07:28.750368'),
(7, 'contenttypes', '0002_remove_content_type_name', '2025-12-02 03:07:28.845494'),
(8, 'auth', '0002_alter_permission_name_max_length', '2025-12-02 03:07:28.881839'),
(9, 'auth', '0003_alter_user_email_max_length', '2025-12-02 03:07:28.896559'),
(10, 'auth', '0004_alter_user_username_opts', '2025-12-02 03:07:28.906385'),
(11, 'auth', '0005_alter_user_last_login_null', '2025-12-02 03:07:28.938636'),
(12, 'auth', '0006_require_contenttypes_0002', '2025-12-02 03:07:28.943792'),
(13, 'auth', '0007_alter_validators_add_error_messages', '2025-12-02 03:07:28.954994'),
(14, 'auth', '0008_alter_user_username_max_length', '2025-12-02 03:07:28.967972'),
(15, 'auth', '0009_alter_user_last_name_max_length', '2025-12-02 03:07:28.980088'),
(16, 'auth', '0010_alter_group_name_max_length', '2025-12-02 03:07:28.994086'),
(17, 'auth', '0011_update_proxy_permissions', '2025-12-02 03:07:29.006097'),
(18, 'auth', '0012_alter_user_first_name_max_length', '2025-12-02 03:07:29.017071'),
(19, 'sessions', '0001_initial', '2025-12-02 03:07:29.043219');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('3vantt87uw45zv8xmzfjgjvsjlankoco', '.eJxVjssKwyAURP_FdZD4qKlddt9vEPVeG_vQoAZaSv-9CQRKljNzZpgPKVixmbliMRHISXabY1vD59QqOfUdMXZu4x8ikuw8Z_0d0xrAzaZrpj6nVqKjK0K3tNJLBnycN3Y3MNo6Lu2gvUcppBCgmOLcC2BBBa-0lt65Hp1FcEIfORtg0IHBENQiUB44Z8KuoxVrjTkZfE2xvJf33x9tOkxe:1vQIWS:biHZPFcFU0lNlNYPjee77-5ijSH_TNiyiFXzV0l1K_o', '2025-12-16 05:01:56.947485'),
('c96vyq9a8m3q9otil9ocz8tgz5v70uid', '.eJxVjMsOgyAURP-FtSGoRcRl9_0Gcr1cKn2AAUzaNP33amLSuJjNnDPzYYkyFbNkSsZbNjTV3kAp9JxLZkNdMQNLmf4Sa9ihGwHvFDZgbxCukWMMJfmRbwrfaeaXaOlx3t3DwQR5Wtd91yFpS6SErGVLaB1JrSU6AQ5gRY3FNVpJ0TtwrSREJfBE5DqtcDvNlLOPwdBr9unNBvH9AbDzTfk:1vQGr9:kzyi5vD-CMzpszl34YEmf2saQ3hdWZmuZtSlsQPzId8', '2025-12-16 03:15:11.536183'),
('oz6ztwzzj4nvw6vaqui6r30pu5zf2vno', '.eJxVjMsOwiAQRf-FtSE82-LSvd9AGGawqAFT2kRj_HfbpAvdnnPufTMflnn0S6PJZ2RHZtjhl0GINyqbwGsol8pjLfOUgW8J323j54p0P-3t38EY2riug0ALEZIhhJTkoDrdWyVDsOC6lWsS0rjeKDegVlK4Xg8IGizZiF1S22mj1nItnp6PPL3YUXy-r1Q_bQ:1wsszB:HJegs6ly8LwjQcIIdrdgKAsbKDZRhDKGft4hSkwEZQ4', '2026-08-23 02:10:01.361384'),
('rmvq32i2asss2evshivywtlq51jmgr3k', '.eJxVjMsOwiAQRf-FtSE82-LSvd9AGGawqAFT2kRj_HfbpAvdnnPufTMflnn0S6PJZ2RHZtjhl0GINyqbwGsol8pjLfOUgW8J323j54p0P-3t38EY2riug0ALEZIhhJTkoDrdWyVDsOC6lWsS0rjeKDegVlK4Xg8IGizZiF1S22mj1nItnp6PPL3YUXy-r1Q_bQ:1wsJ0O:wP5SyjNL4AldgelOWwQM7CS2WJs---UkCvIx9_bmcBI', '2026-08-21 11:44:52.378987'),
('yhtsybk5eqi39axp21wo4n88fqzbzmms', '.eJxVjEEOwiAURO_C2hCgUKRL956BAP9jUQMG2kRjvLsl6UI3s5h5897EunWZ7dqw2gRkIpIcfjvvwg1zH-Dq8qXQUPJSk6cdofva6LkA3k87-yeYXZu3t9BKCq8AGYAxCIbHQWk8GqY4aO64hC2i0uDiEDFKZjhqYQIIPcZRdWnD1lLJFp-PVF9kYp8vi50_JQ:1vQg4T:SrZyW5IkofBW6Ej6zhCA_nheR_t6urDb_hBjSU3Hzzc', '2025-12-17 06:10:37.991449');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance_app_attendancerecord`
--
ALTER TABLE `attendance_app_attendancerecord`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attendance_app_attendancerecord_student_id_date_d69a4a85_uniq` (`student_id`,`date`);

--
-- Indexes for table `attendance_app_course`
--
ALTER TABLE `attendance_app_course`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `attendance_app_cours_institute_id_66c40f44_fk_attendanc` (`institute_id`);

--
-- Indexes for table `attendance_app_emailsettings`
--
ALTER TABLE `attendance_app_emailsettings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attendance_app_institute`
--
ALTER TABLE `attendance_app_institute`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `attendance_app_passwordresetotp`
--
ALTER TABLE `attendance_app_passwordresetotp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attendance_app_passwordresetotp_user_id_73cb171e_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `attendance_app_section`
--
ALTER TABLE `attendance_app_section`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attendance_app_section_name_course_id_year_level_a84f10ab_uniq` (`name`,`course_id`,`year_level`),
  ADD KEY `attendance_app_secti_course_id_7a0bafd7_fk_attendanc` (`course_id`);

--
-- Indexes for table `attendance_app_student`
--
ALTER TABLE `attendance_app_student`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`),
  ADD UNIQUE KEY `rfid_tag` (`rfid_tag`),
  ADD KEY `attendance_app_stude_section_id_67169396_fk_attendanc` (`section_id`);

--
-- Indexes for table `attendance_app_systemlog`
--
ALTER TABLE `attendance_app_systemlog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attendance_app_systemsettings`
--
ALTER TABLE `attendance_app_systemsettings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance_app_attendancerecord`
--
ALTER TABLE `attendance_app_attendancerecord`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `attendance_app_course`
--
ALTER TABLE `attendance_app_course`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `attendance_app_emailsettings`
--
ALTER TABLE `attendance_app_emailsettings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `attendance_app_institute`
--
ALTER TABLE `attendance_app_institute`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `attendance_app_passwordresetotp`
--
ALTER TABLE `attendance_app_passwordresetotp`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `attendance_app_section`
--
ALTER TABLE `attendance_app_section`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `attendance_app_student`
--
ALTER TABLE `attendance_app_student`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT for table `attendance_app_systemlog`
--
ALTER TABLE `attendance_app_systemlog`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=263;

--
-- AUTO_INCREMENT for table `attendance_app_systemsettings`
--
ALTER TABLE `attendance_app_systemsettings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance_app_attendancerecord`
--
ALTER TABLE `attendance_app_attendancerecord`
  ADD CONSTRAINT `attendance_app_atten_student_id_4497dd97_fk_attendanc` FOREIGN KEY (`student_id`) REFERENCES `attendance_app_student` (`id`);

--
-- Constraints for table `attendance_app_course`
--
ALTER TABLE `attendance_app_course`
  ADD CONSTRAINT `attendance_app_cours_institute_id_66c40f44_fk_attendanc` FOREIGN KEY (`institute_id`) REFERENCES `attendance_app_institute` (`id`);

--
-- Constraints for table `attendance_app_passwordresetotp`
--
ALTER TABLE `attendance_app_passwordresetotp`
  ADD CONSTRAINT `attendance_app_passwordresetotp_user_id_73cb171e_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `attendance_app_section`
--
ALTER TABLE `attendance_app_section`
  ADD CONSTRAINT `attendance_app_secti_course_id_7a0bafd7_fk_attendanc` FOREIGN KEY (`course_id`) REFERENCES `attendance_app_course` (`id`);

--
-- Constraints for table `attendance_app_student`
--
ALTER TABLE `attendance_app_student`
  ADD CONSTRAINT `attendance_app_stude_section_id_67169396_fk_attendanc` FOREIGN KEY (`section_id`) REFERENCES `attendance_app_section` (`id`);

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
