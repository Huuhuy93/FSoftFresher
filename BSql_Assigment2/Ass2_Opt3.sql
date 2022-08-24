CREATE DATABASE Ass2_Opt3
go
USE Ass2_Opt3
go

CREATE TABLE Movie (
	Movie_Code int not null unique,
	Movie_Name nvarchar(50) not null,
	Duration int not null,
	Amount_Of_Money float not null,
	Comments nvarchar(100),
	Genre_Code int not null,
	CONSTRAINT pk_Movie PRIMARY KEY(Movie_code),
	CONSTRAINT fk_Genre FOREIGN KEY(Genre_Code) REFERENCES Genre(Genre_Code)
)
go

CREATE TABLE Genre(
	Genre_Code int not null unique,
	Genre_Name nvarchar(20) not null,
	CONSTRAINT pk_Genre PRIMARY KEY(Genre_Code)
)
go

CREATE TABLE Actor(
	Actor_Code int not null unique,
	Actor_Name nvarchar(20) not null,
	Age int not null,
	Salary float not null,
	Nationality nvarchar(20),
	CONSTRAINT pk_Actor PRIMARY KEY(Actor_Code)
)
go

CREATE TABLE ActedIn(
	Movie_Code int not null,
	Actor_Code int not null,
	CONSTRAINT pk_ActedIn PRIMARY KEY(Movie_Code, Actor_Code),
	CONSTRAINT fk_movie_ActedIn FOREIGN KEY(Movie_Code) REFERENCES Movie(Movie_Code),
	CONSTRAINT fk_actor_ActedIn FOREIGN KEY(Actor_Code) REFERENCES Actor(Actor_Code)
)
go

-------Q2--------

--a. Add an ImageLink field to Movie table and make sure that the database will not allow the value for
--ImageLink to be inserted into a new row if that value has already been used in another row.

ALTER TABLE Movie ADD Image_Link char(100)

--b. Populate your tables with some data using the INSERT statement. Make sure you have at least 5 tuples per table.

INSERT INTO Genre VALUES (001, 'Hành động'), (002, 'Phiêu lưu'), (003, 'Hài'), (004, 'Tội phạm'), (005, 'Phim truyền hình'),
						(006, 'Kinh dị'), (007, 'Ca nhạc / khiêu vũ'), (008, 'Chiến tranh')

INSERT INTO Movie VALUES (01, 'Avengers', 180, 200000000, 'Phim rất gay cấn', 001, 'link'), (02, 'Tèo Em', 90, 80000000, 'Phim rất vui vẻ', 003, 'link'),
						 (03, 'Fast and Furious', 180, 300000000, 'Phim rất hấp dẫn', 001, 'link'), (04, 'Tây du ký', 150, 70000000, 'Phim rất hay', 003, 'link'),
						 (05, 'Mười', 120, 50000000, 'Phim rất sợ', 006, 'link')

INSERT INTO Actor VALUES (001, 'John Wich', 39, 100000, 'America'), (002, 'Walker', 30, 20000, 'America'), (003, 'Neymar', 30, 40000, 'Brazil'),
						 (004, 'Messi', 32, 30000, 'Argentina'), (005, 'Ronaldo', 35, 8000, 'Brazil'), (006, 'Linh Đồng', 30, 5000, 'China'),
						 (007, 'Thái Hòa', 34, 5000, 'VN'), (008, 'Ngọc Trinh', 29, 10000, 'VN')

INSERT INTO ActedIn VALUES (01, 001), (01, 002), (02, 007), (02, 008), (03, 003), (03, 005), (04, 006), (04, 005), (05, 007), (05, 008)
INSERT INTO ActedIn VALUES (05, 003), (05, 001)
INSERT INTO ActedIn VALUES (01, 004), (01, 005)

--You accidentally mis-typed one of the actors' names. Fix your typo by using an UPDATE statement.

UPDATE dbo.Actor SET Actor_Name = 'Lục Tiểu Linh Đồng' WHERE Actor_Name = 'Linh Đồng'

UPDATE dbo.Actor SET Age = 55 WHERE Actor_Code = 001


--Q3--
--c. Write a query to retrieve all the data in the Actor table for actors that are older than 50.

SELECT * FROM Actor WHERE Age > 50

--d. Write a query to retrieve all actor names and average salaries from ACTOR and sort the results by average salary.

SELECT Actor_Name, Salary FROM Actor
ORDER BY Salary ASC

--e. Using an actor name from your table, write a query to retrieve the names of all the movies that actor has acted in.

SELECT Actor.Actor_Code, Actor.Actor_Name, Movie.Movie_Name FROM Actor
INNER JOIN ActedIn ON Actor.Actor_Code = ActedIn.Actor_Code
INNER JOIN Movie ON ActedIn.Movie_Code = Movie.Movie_Code

--f. Write a query to retrieve the names of all the action movies that amount of actor be greater than 3

SELECT m.Movie_Name  FROM Movie as m
INNER JOIN ActedIn ON m.Movie_Code = ActedIn.Movie_Code
INNER JOIN Genre as g ON m.Genre_Code = g.Genre_Code
WHERE g.Genre_Code = 001 AND m.Movie_Code
in 
(SELECT m.Movie_Code FROM Movie as m
INNER JOIN ActedIn ON m.Movie_Code = ActedIn.Movie_Code
GROUP BY m.Movie_Code
HAVING Count(ActedIn.Actor_Code) >= 3)
GROUP BY m.Movie_Name
