-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 22, 2020 at 09:29 AM
-- Server version: 8.0.17
-- PHP Version: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `osts`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LOGIN` (IN `_username` VARCHAR(50), IN `_password` INT(50))  READS SQL DATA
BEGIN

DECLARE _usertype INT DEFAULT 0;
DECLARE _userdetail INT DEFAULT 0;

SET _usertype=(SELECT login.login_type from login WHERE
            
              login.login_name=_username AND
               login.login_password=_password AND login.isActive=1
              );
              
    SET _userdetail=(SELECT login.login_detail_id from login WHERE
              
              login.login_name=_username AND
               login.login_password=_password AND
                     login.isActive=1
              );      
       IF _usertype=1 THEN
              
       SELECT  login.login_id,login.login_name,login.login_password,
       login.login_type,students.student_number,students.student_name,students.student_lastname,students.student_mail,students.student_class_id,classes.class_title from login 
       LEFT JOIN students on students.student_id=login.login_detail_id
       LEFT JOIN classes on students.student_class_id=classes.class_id  
       WHERE login.login_name=_username AND login.login_password=_password;
       
       END IF; 
              
        IF _usertype=2 THEN
              
       SELECT login.login_name,login.login_password,login.login_type,login.login_id,teachers.teacher_name,teachers.teacher_lastname,
       teachers.teacher_mail,teachers.teacher_phone,teachers.teacher_id
       from login left JOIN teachers  on teachers.teacher_id=login.login_detail_id WHERE login.isActive=1 And ateachers.isActive=1 And login.login_name=_username AND
       login.login_password=_password;
       
       END IF;      
       
       
       IF _usertype=3 THEN
              
       SELECT login.login_name,login.login_password,login.login_id,
ateachers.ateacher_id,ateachers.ateacher_name,login.login_type,ateachers.ateacher_lastname,ateachers.ateacher_phone,ateachers.ateacher_mail
from login left JOIN ateachers on login.login_detail_id=ateachers.ateacher_id WHERE login.isActive=1 And login.login_name=_username AND
       login.login_password=_password;
       
       END IF;    
       
       
       
      
   


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_STUDENT_ADD` (IN `_name` TEXT, IN `_lastname` TEXT, IN `_mail` TEXT, IN `_phone` TEXT, IN `_classid` INT, IN `_username` TEXT, IN `_password` TEXT)  BEGIN

DECLARE _studentid INT;
DECLARE _studentdetailid INT;

SET _studentid=(SELECT FLOOR(RAND() * 99999999.99));


INSERT INTO students
(students.student_number,
 students.student_name,
 students.student_lastname,
  students.student_phone,
 students.student_mail,
 students.student_class_id)
 VALUES
 (_studentid,
  _name,
  _lastname,
  _phone,
 _mail
  ,_classid);
 
SET _studentdetailid=LAST_INSERT_ID();
 
INSERT INTO login
(login.login_name,
 login.login_password,
 login.login_type,
 login.login_detail_id)
 VALUES
 (_username,
  _password,
  1,
  _studentdetailid);
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_STUDENT_DELETE` (IN `_id` INT)  MODIFIES SQL DATA
BEGIN

UPDATE students SET students.isActive=0 WHERE students.isActive=0;
UPDATE login SET login.isActive=0 WHERE 

login.login_detail_id=_id AND login.login_type=1;


END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ateachers`
--

CREATE TABLE `ateachers` (
  `ateacher_id` int(11) NOT NULL,
  `ateacher_name` varchar(75) NOT NULL,
  `ateacher_lastname` varchar(75) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ateacher_phone` varchar(50) NOT NULL,
  `ateacher_mail` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `classes`
--

CREATE TABLE `classes` (
  `class_id` int(11) NOT NULL,
  `class_year` int(11) NOT NULL,
  `class_title` varchar(75) NOT NULL,
  `class_detail` text NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `classes`
--

INSERT INTO `classes` (`class_id`, `class_year`, `class_title`, `class_detail`, `isActive`) VALUES
(1, 2020, '1. Sınıf', '1. Sınıflar burada yer almaktadır.', 1),
(2, 2020, '2. Sınıf', '2. Sınıflar burada yer almaktadır.', 1),
(3, 2020, '3. Sınıf', '3. Sınıflar burada yer almaktadır.', 1),
(4, 2020, '4. Sınıf', '4. Sınıflar burada yer almaktadır.', 1),
(5, 2020, '5. Sınıf', '5. Sınıflar burada yer almaktadır.', 1),
(6, 2020, '6. Sınıf', '6. Sınıflar burada yer almaktadır.', 1),
(7, 2020, '7. Sınıf', '7. Sınıflar burada yer almaktadır.', 1),
(8, 2020, '8. Sınıf', '8. Sınıflar burada yer almaktadır.', 1);

-- --------------------------------------------------------

--
-- Table structure for table `homeworks`
--

CREATE TABLE `homeworks` (
  `homework_id` int(11) NOT NULL,
  `homework_title` varchar(75) NOT NULL,
  `homework_detail` text NOT NULL,
  `homework_create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `homework_assigner_id` int(11) NOT NULL,
  `homework_assigned_class_id` int(11) NOT NULL,
  `homework_last_publish_date` datetime NOT NULL,
  `isActive` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `homework_publishs`
--

CREATE TABLE `homework_publishs` (
  `publish_id` int(11) NOT NULL,
  `homework_id` int(11) NOT NULL,
  `publisher_id` int(11) NOT NULL,
  `publisher_text` text NOT NULL,
  `has_file` tinyint(1) NOT NULL,
  `file_path` varchar(75) NOT NULL,
  `publish_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lectures`
--

CREATE TABLE `lectures` (
  `lecture_id` int(11) NOT NULL,
  `lecture_year` int(11) NOT NULL,
  `lecture_title` varchar(75) NOT NULL,
  `lecture_detail` text NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lectures`
--

INSERT INTO `lectures` (`lecture_id`, `lecture_year`, `lecture_title`, `lecture_detail`, `isActive`) VALUES
(1, 2020, 'Fen Bilgisi', 'Fen Eğitimi verilmektedir', 1),
(2, 2020, 'Türk Edebiyatı', 'Yeni nesil Türk Edebiyatından bahsedilir.', 1),
(3, 2020, 'Matematik', 'Limit ve Türev konuları ele alınmaktadır.', 1);

-- --------------------------------------------------------

--
-- Table structure for table `lecture_teachers`
--

CREATE TABLE `lecture_teachers` (
  `lecture_teacher_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `lecture_id` int(11) NOT NULL,
  `isActive` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `login_id` int(11) NOT NULL,
  `login_name` varchar(50) NOT NULL,
  `login_password` varchar(50) NOT NULL,
  `login_detail_id` int(11) NOT NULL,
  `login_type` tinyint(4) NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`login_id`, `login_name`, `login_password`, `login_detail_id`, `login_type`, `isActive`) VALUES
(1, 'kullanici_adi', 'sifre', 1, 1, 1),
(2, 'ahmet_bey', 'ahmet123', 1, 2, 1),
(3, 'hakann', 'hakan123', 2, 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `student_number` varchar(20) NOT NULL,
  `student_name` varchar(75) NOT NULL,
  `student_lastname` varchar(75) NOT NULL,
  `student_mail` varchar(75) NOT NULL,
  `student_phone` varchar(75) NOT NULL,
  `student_class_id` int(11) NOT NULL,
  `isActive` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `student_number`, `student_name`, `student_lastname`, `student_mail`, `student_phone`, `student_class_id`, `isActive`) VALUES
(1, '62244414', 'Test', 'Test', 'test@mail.com', '5312456123', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `teacher_id` int(11) NOT NULL,
  `teacher_name` varchar(75) NOT NULL,
  `teacher_lastname` varchar(75) NOT NULL,
  `teacher_mail` varchar(50) NOT NULL,
  `teacher_phone` varchar(50) NOT NULL,
  `teacher_detail` text NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`teacher_id`, `teacher_name`, `teacher_lastname`, `teacher_mail`, `teacher_phone`, `teacher_detail`, `isActive`) VALUES
(1, 'Ahmet Hoca', 'Bey', 'ahmetmail@mail.com', '5325520', 'Matematik ve Fen alanlarında uzman ayrıca edebiyat eğitimi almış.', 1),
(2, 'Hakan', 'Hoca', 'hakan@mail.com', '02132102', 'Hakan bey Edebiyat uzmanıdır.', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ateachers`
--
ALTER TABLE `ateachers`
  ADD PRIMARY KEY (`ateacher_id`);

--
-- Indexes for table `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`class_id`);

--
-- Indexes for table `homeworks`
--
ALTER TABLE `homeworks`
  ADD PRIMARY KEY (`homework_id`);

--
-- Indexes for table `homework_publishs`
--
ALTER TABLE `homework_publishs`
  ADD PRIMARY KEY (`publish_id`);

--
-- Indexes for table `lectures`
--
ALTER TABLE `lectures`
  ADD PRIMARY KEY (`lecture_id`);

--
-- Indexes for table `lecture_teachers`
--
ALTER TABLE `lecture_teachers`
  ADD PRIMARY KEY (`lecture_teacher_id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`login_id`),
  ADD UNIQUE KEY `login_name` (`login_name`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `student_number` (`student_number`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`teacher_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ateachers`
--
ALTER TABLE `ateachers`
  MODIFY `ateacher_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `classes`
--
ALTER TABLE `classes`
  MODIFY `class_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `homeworks`
--
ALTER TABLE `homeworks`
  MODIFY `homework_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `homework_publishs`
--
ALTER TABLE `homework_publishs`
  MODIFY `publish_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lectures`
--
ALTER TABLE `lectures`
  MODIFY `lecture_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `lecture_teachers`
--
ALTER TABLE `lecture_teachers`
  MODIFY `lecture_teacher_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `login_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;