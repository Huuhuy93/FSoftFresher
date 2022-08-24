CREATE DATABASE Ass3_Q2
go
USE Ass3_Q2
go

CREATE TABLE EMPLOYEE (
	EmployeeID int not null unique,
	EmployeeName nvarchar(20) not null,
	DepartmentID int not null,
	CONSTRAINT pk_Employee PRIMARY KEY(EmployeeID),
	CONSTRAINT fk_department FOREIGN KEY(DepartmentID) REFERENCES DEPARTMENT(DepartmentID)
)
go

CREATE TABLE DEPARTMENT (
	DepartmentID int not null unique,
	DepartmentName nvarchar(20) not null,
	CONSTRAINT pk_Department PRIMARY KEY(DepartmentID)
)
go

CREATE TABLE SKILL (
	SkillID int not null unique,
	SkillName nvarchar(20) not null,
	CONSTRAINT pk_Skill PRIMARY KEY(SkillID)
)
go

CREATE TABLE SKILL_EMPLOYEE (
	SkillID int not null,
	EmployeeID int not null,
	Date_Registered date not null,
	CONSTRAINT pk_SkillEmployee PRIMARY KEY(SkillID, EmployeeID),
	CONSTRAINT fk_skillE FOREIGN KEY(SkillID) REFERENCES SKILL(SkillID),
	CONSTRAINT fk_EmployeeS FOREIGN KEY(EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
)
go

INSERT INTO SKILL VALUES(1, 'Java'), (2, 'C++'), (3, '.Net'), (4, 'PHP')

INSERT INTO DEPARTMENT VALUES(1, 'Du an Nhat'), (2, 'Du An My'), (3, 'Du An Ios')

INSERT INTO EMPLOYEE VALUES(1, 'Nguyen Van A', 1), (2, 'Le Ngoc Chau', 3), (3, 'Nguyen Viet Hung', 3)
INSERT INTO EMPLOYEE VALUES(4, 'Nguyen Van B', 1), (5, 'Le Ngoc Hong', 3), (6, 'Le Viet Hung', 3)

INSERT INTO SKILL_EMPLOYEE VALUES(1, 2, '2021/11/10'), (4, 1, '2021/07/12'), (3, 3, '2021/10/27'), (1, 5, '2021/03/10')
INSERT INTO SKILL_EMPLOYEE VALUES(3, 2, '2021/08/10')

--2. Specify the names of the employees whore have skill of ‘Java’ – give >=2 solutions: 
--Use JOIN selection
SELECT e.EmployeeName FROM EMPLOYEE as e
INNER JOIN SKILL_EMPLOYEE as se ON e.EmployeeID = se.EmployeeID
INNER JOIN SKILL as s ON se.SkillID = s.SkillID
WHERE s.SkillName = 'Java'

--Use sub query

SELECT e.EmployeeName FROM EMPLOYEE as e
WHERE e.EmployeeID in (SELECT se.EmployeeID FROM SKILL_EMPLOYEE as se INNER JOIN SKILL as s ON se.SkillID = s.SkillID
WHERE s.SkillName = 'Java')

--3. Specify the departments which have >=3 employees, print out the list of departments’ employees right after each department.

SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName FROM EMPLOYEE as e
INNER JOIN DEPARTMENT as d ON e.DepartmentID = d.DepartmentID
WHERE  d.DepartmentID in (
SELECT d.DepartmentID FROM EMPLOYEE as e
INNER JOIN DEPARTMENT as d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID
HAVING COUNT(e.EmployeeID) >= 3
)

--4. Use SUB-QUERY technique to list out the different employees (include employee number and employee names) who have multiple skills.

SELECT e.EmployeeID, e.EmployeeName FROM EMPLOYEE as e WHERE e.EmployeeID 
in (SELECT e.EmployeeID FROM EMPLOYEE as e INNER JOIN SKILL_EMPLOYEE se ON e.EmployeeID = se.EmployeeID 
GROUP BY e.EmployeeID
HAVING COUNT(se.SkillID) >= 2)

--5. Create a view to show different employees (with following information: employee number and employee name, department name) who have multiple skills.

CREATE VIEW Employee_Department AS 
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName FROM EMPLOYEE as e
INNER JOIN DEPARTMENT as d ON e.DepartmentID = d.DepartmentID
WHERE  e.EmployeeID 
in (SELECT e.EmployeeID FROM EMPLOYEE as e INNER JOIN SKILL_EMPLOYEE se ON e.EmployeeID = se.EmployeeID 
GROUP BY e.EmployeeID
HAVING COUNT(se.SkillID) >= 2)

SELECT * FROM Employee_Department




