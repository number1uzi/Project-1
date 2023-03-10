DROP TABLE IF EXISTS faculties CASCADE;
DROP TABLE IF EXISTS programs CASCADE;
DROP TABLE IF EXISTS instructors CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS courses_programs CASCADE;
DROP TABLE IF EXISTS pre_requisites CASCADE;



CREATE TABLE faculties (
 faculty_id VARCHAR(4) PRIMARY KEY,
 faculty_name VARCHAR(100) NOT NULL,
 faculty_description TEXT  NOT NULL
);

CREATE TABLE programs (
  program_id CHAR(4) PRIMARY KEY,
  faculty_id VARCHAR(4) REFERENCES faculties(faculty_id),
  Program_name VARCHAR(250) NOT NULL,
  program_location VARCHAR(200) NOT NULL,
  program_description TEXT NOT NULL
);

CREATE TABLE instructors (
  instructor_id INT PRIMARY KEY,
  instructor_email VARCHAR (50),
  instructor_name VARCHAR (50),
  office_location VARCHAR (50),
  telephone CHAR (20),
  degree VARCHAR(250)
  
);

CREATE TABLE courses (
  course_id INT PRIMARY KEY,
  code CHAR ( 8 ) NOT NULL,
  year INT NOT NULL,
  semester INT NOT NULL,
  section VARCHAR (10) NOT NULL,
  title VARCHAR ( 100 ) NOT NULL,
  credits INT NOT NULL,
  modality VARCHAR ( 50 ) NOT NULL,
  modality_type VARCHAR(20) NOT NULL,
  instructor_id INT NOT NULL,
  class_venue	VARCHAR(100),
  communicatioin_tool	VARCHAR(25),
  course_platform	VARCHAR(25),
  field_trips	VARCHAR(3) check(field_trips in ('Yes','No')),
  resources_required TEXT NOT NULL,
  resources_recommended TEXT NOT NULL,
  resources_other TEXT NOT NULL,
  course_description TEXT NOT NULL,
  course_outline_url TEXT NOT NULL,
  UNIQUE (code, year, semester, section),
  FOREIGN KEY (instructor_id)
    REFERENCES instructors (instructor_id)
);

CREATE TABLE courses_programs (
  course_id INT NOT NULL,
  program_id CHAR(4) NOT NULL,
  FOREIGN KEY (program_id)
    REFERENCES programs (program_id),
  FOREIGN KEY (course_id)
    REFERENCES courses (course_id)
);


CREATE TABLE pre_requisites (
 course_id INT REFERENCES courses(course_id),
 Pre_requisites VARCHAR(8) NOT NULL
);




COPY faculties
FROM '/home/matthew/Downloads/course/faculties.csv'
DELIMITER ','
CSV HEADER;

COPY programs
FROM '/home/matthew/Downloads/course/programs.csv'
DELIMITER ','
CSV HEADER;

COPY instructors
FROM '/home/matthew/Downloads/course/instructors.csv'
DELIMITER ','
CSV HEADER;

COPY courses
FROM '/home/matthew/Downloads/course/courses.csv'
DELIMITER ','
CSV HEADER;

COPY courses_programs
FROM '/home/matthew/Downloads/course/courses_programs.csv'
DELIMITER ','
CSV HEADER;

COPY pre_requisites
FROM '/home/matthew/Downloads/course/pre_reqs.csv'
DELIMITER ','
CSV HEADER;

--What faculties at UB end in S?

SELECT faculty_id   
FROM faculties
WHERE faculty_id LIKE '%S';


--What programs are offered in Belize City?

SELECT program_name 
FROM programs
WHERE program_location = 'Belize City';


--What courses does Mrs. Vernelle Sylvester teach?

SELECT course_id, title, code, year, semester, section
FROM courses
WHERE instructor_id = (SELECT instructor_id FROM instructors WHERE instructor_name = 'Vernelle Sylvester');


--Which instructors have a Masters Degree?

SELECT instructor_name
FROM instructors 
WHERE degree =  'M.Sc.';


--What are the prerequisites for Programming 2?

SELECT p.Pre_requisites, c.title
FROM pre_requisites p
INNER JOIN courses c ON p.course_id = c.course_id
WHERE c.title = 'Priciples of Programming 2';


--list the  code, year, semester section and title for all courses.

SELECT code, year, semester, section, title
FROM courses;


--List the program_name and code, year, semester section and title for all courses in the AINT program.

SELECT programs.Program_name, courses.code, courses.year, courses.semester, courses.section, courses.title
FROM programs
JOIN courses_programs ON programs.program_id = courses_programs.program_id
JOIN courses ON courses_programs.course_id = courses.course_id
WHERE programs.program_id = 'AINT';


--List the faculty_name and code, year, semester section and title for all courses offered by FST.


SELECT f.faculty_name, c.code, c.year, c.semester, c.section, c.title, f.faculty_id
FROM faculties f
JOIN programs p ON f.faculty_id = p.faculty_id
JOIN courses_programs cp ON p.program_id = cp.program_id
JOIN courses c ON cp.course_id = c.course_id
WHERE f.faculty_id = 'FST';




