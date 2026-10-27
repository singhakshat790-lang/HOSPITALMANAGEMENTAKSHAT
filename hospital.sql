
-- HOSPITAL PATIENT RECORD MANAGEMENT SYSTEM
-- MySQL

CREATE DATABASE IF NOT EXISTS HospitalDB;
USE HospitalDB;

-- 1. PATIENT TABLE
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(100),
    Address VARCHAR(200),
    CHECK (Age BETWEEN 0 AND 130)
);

-- 2. DOCTOR TABLE
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100),
    Phone VARCHAR(20)
);

-- 3. APPOINTMENT TABLE
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Reason VARCHAR(200),
    Status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    CHECK (Status IN
       ('Scheduled', 'Completed', 'Cancelled'))
);

-- INSERT SAMPLE PATIENTS
INSERT INTO Patients VALUES
(101, 'Arun Kumar', 35, '9876543210',
 'arun@example.com', 'Chennai'),
(102, 'Priya Sharma', 28, '9876501234',
 'priya@example.com', 'Coimbatore'),
(103, 'Ravi Kumar', 45, '9876512345',
 'ravi@example.com', 'Madurai');

-- INSERT SAMPLE DOCTORS
INSERT INTO Doctors VALUES
(201, 'Dr. Meena', 'Cardiology', '9000011111'),
(202, 'Dr. Rajesh', 'Orthopedics', '9000022222'),
(203, 'Dr. Anitha', 'General Medicine', '9000033333');

-- INSERT SAMPLE APPOINTMENTS
INSERT INTO Appointments VALUES
(301, 101, 201, '2026-11-02', '10:00:00',
 'Heart checkup', 'Scheduled'),
(302, 102, 202, '2026-11-02', '11:30:00',
 'Knee pain', 'Scheduled'),
(303, 103, 201, '2026-11-03', '09:30:00',
 'Regular checkup', 'Scheduled'),
(304, 101, 203, '2026-11-04', '14:00:00',
 'General consultation', 'Scheduled');

-- 1. DISPLAY ALL PATIENTS
SELECT * FROM Patients;

-- 2. DISPLAY ALL DOCTORS
SELECT * FROM Doctors;

-- 3. DISPLAY ALL APPOINTMENTS
SELECT * FROM Appointments;

-- 4. SEARCH PATIENT BY PATIENT ID
SELECT *
FROM Patients
WHERE PatientID = 101;

-- 5. DISPLAY PATIENT DETAILS WITH APPOINTMENTS
SELECT
    p.PatientID,
    p.PatientName,
    p.Age,
    p.Phone,
    d.DoctorName,
    d.Specialization,
    a.AppointmentDate,
    a.AppointmentTime,
    a.Reason,
    a.Status
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE p.PatientID = 101
ORDER BY a.AppointmentDate, a.AppointmentTime;

-- 6. DISPLAY APPOINTMENTS FOR A SELECTED DOCTOR
-- Change 201 to another DoctorID to select a different doctor.
SELECT
    d.DoctorID,
    d.DoctorName,
    d.Specialization,
    p.PatientID,
    p.PatientName,
    p.Phone,
    a.AppointmentDate,
    a.AppointmentTime,
    a.Reason,
    a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE d.DoctorID = 201
ORDER BY a.AppointmentDate, a.AppointmentTime;

-- 7. REGISTER A NEW PATIENT
INSERT INTO Patients
(PatientID, PatientName, Age, Phone, Email, Address)
VALUES
(104, 'Karthik Raj', 32, '9876598765',
 'karthik@example.com', 'Salem');

-- 8. SCHEDULE A NEW APPOINTMENT
INSERT INTO Appointments
(AppointmentID, PatientID, DoctorID,
 AppointmentDate, AppointmentTime, Reason, Status)
VALUES
(305, 104, 203, '2026-11-05', '15:00:00',
 'General checkup', 'Scheduled');

-- 9. UPDATE APPOINTMENT STATUS
UPDATE Appointments
SET Status = 'Completed'
WHERE AppointmentID = 301;

-- 10. COUNT APPOINTMENTS FOR EACH DOCTOR
SELECT
    d.DoctorID,
    d.DoctorName,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.DoctorName
ORDER BY d.DoctorID;
