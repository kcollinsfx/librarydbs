
/****************************************************************** CREATE A DATABASE *****************************************************************/
CREATE DATABASE library;
/*****************************************************************************************************************************************************/
/******************************************************************* CREATING TABLES ****************************************************************/
CREATE TABLE jobs (
	employee_id bigserial CONSTRAINT employee_key PRIMARY KEY,
	first_name varchar(50),
	last_name varchar(50),
	job_title varchar(25)
);

CREATE TABLE time_shifts (
	employee_id bigserial REFERENCES jobs(employee_id),
	work_day date,
	clock_in time, 
	clock_out time
);

CREATE TABLE salaries (
	employee_id bigserial REFERENCES jobs(employee_id),
	hourly_rate numeric(5,2),
	total_hours_worked numeric(5,2),
	previous_pay_day date,
	account_number varchar(16),
	next_pay_day date
);

CREATE TABLE members (
	member_id bigserial CONSTRAINT member_key PRIMARY KEY,
	first_name varchar(50),
	last_name varchar(50),
	email varchar (100),
	phone_number char(12),
	address varchar(100),
	city varchar (100),
	state_abbrev char(2),
	zip_code smallint,
	account_open_date timestamp
);

CREATE TABLE authors (
	author_id bigserial CONSTRAINT author_key PRIMARY KEY,
	first_name varchar(50),
	last_name varchar(50)
);

CREATE TABLE books (
	book_id bigserial CONSTRAINT book_key PRIMARY KEY,
	book_title varchar(200),
	number_of_copies smallint,
	author_id bigserial REFERENCES authors(author_id),
	book_edition smallint,
	genre varchar(50)
);

CREATE TABLE checkouts (
	checkout_id bigserial CONSTRAINT checkout_key PRIMARY KEY,
	member_id bigserial REFERENCES members(member_id),
	book_id bigserial REFERENCES books(book_id),
	check_out_date timestamp,
	due_date timestamp,
	check_in_date timestamp,
	bool_hold boolean 
);
/*******************************************************************************************************************************************************/
/***************************************************************** INSERT QUERIES **********************************************************************/

-- INSERTING VALUES TO TABLES
INSERT INTO jobs (first_name, last_name, job_title)
VALUES 
	('Mary', 'Haney', 'Head Librarian'),
	('Elizabeth', 'Sanders', 'Assistant Librarian'),
	('Mark', 'Jackson', 'Assistant Librarian'),
	('Spencer', 'Reid', 'Janitor');


INSERT INTO time_shifts (employee_id, work_day, clock_in, clock_out) 
VALUES
	(2, '2021-11-26', '09:00', '17:00'),
	(3, '2021-11-26', '09:00', '17:00'),
	(4, '2021-11-26', '08:00', '13:00'),
	(2, '2021-11-29', '09:00', '17:00'),
	(3, '2021-11-29', '09:00', '17:00'),
	(4, '2021-11-29', '08:00', '13:00'),
	(2, '2021-11-30', '09:00', '17:00'),
	(3, '2021-11-30', '09:00', '17:00'),
	(4, '2021-11-30', '08:00', '13:00'),
	(2, '2021-12-01', '09:00', '17:00'),
	(3, '2021-12-01', '09:00', '17:00'),
	(4, '2021-12-01', '08:00', '13:00');

/*
Notice that in the time_shifts table below we are only entering clock in and clock out values for the hourly employees
*/
	
INSERT INTO salaries (employee_id, hourly_rate,total_hours_worked, previous_pay_day, account_number)
VALUES
	(1, NULL, 38, '2021-11-26','4003830171874010'),
	(2, 12.00, 40, '2021-11-26','5496198584584760'),
	(3, 11.50, 39, '2021-11-26', '2223000048400010' ),
	(4, 9.00, 24, '2021-11-26', '2223520043560010');

/* Noticed that the salaries table also needed the salaries table also needed the bi_weekly_pay column and hence I added it later */
ALTER TABLE salaries
	ADD bi_weekly_pay numeric (12,2);
	
/* The members table was unable to store the zip_codes due to small int and hence I had to change it to integer before I could re enter the data */

ALTER TABLE members
ALTER COLUMN zip_code TYPE integer;	

INSERT INTO members (first_name, last_name, email, phone_number, address, city, state_abbrev, zip_code, account_open_date)
VALUES
	('Peter', 'Parker','spidey316@avengers.com','601-960-9762', '20 Ingram Street', 'Queens', 'NY', 11428, '1993-04-12' ),
	('King', 'TChalla','wakanda52@avengers.com','813-952-7447', 'Royal Palace of Wakanda', 'Central Wakanda', 'WK', 99999, '1968-05-03' ),
	('Anthony', 'Stark','ironman63@avengers.com','574-848-6524', '10880 Malibu Point', 'Queens', 'NY', 11428, '1993-04-12' ),
	('Bruce', 'Banner','hulk63@nwosu.edu','580-949-4098', '709 Oklahoma Blvd', 'Alva', 'OK', 73717, '1963-08-25' ),
	('Steven', 'Rogers','captain64@avengers.com','609-481-3634', '569 Leaman Palace', 'Brooklyn', 'NY', 11201, '1964-03-11' ),
	('Natalia', 'Romanova','blackW73@avengers.com','671-747-2062', '10880 Malibu Point', 'Malibu', 'CA', 90265, '1973-05-28' );

INSERT INTO authors (first_name, last_name)
VALUES 
	('Janet', 'Pym'),
	('Thor', 'Oden'),
	('Wanda', 'Maximoff'),
	('Samuel', 'Wilson'),
	('Harris', 'Lang'),
	('Stan', 'Lee');
	
INSERT INTO books (book_title, number_of_copies, author_id, book_edition, genre)
VALUES
	('The Amazing Spider-Man', 5, 1, 120, 'Fiction'),
	('The Spectacular Spider-Man', 3, 2, 334, 'Narrative'),
	('Civil War', 7, 3, 678, 'Novel'),
	('The Invincible Iron Man', 1, 4, 443, 'Non-fiction'),
	('Black Panther', 2, 5, 789, 'Science-finction'),
	('The Incredible Hulk', 2, 6, 543, 'Mystery'),
	('Avengers', 12, 1, 1234, 'Historical-Fiction'),
	('Captain America', 9, 2, 789, 'Young-Adult-Fiction'),
	('The Adventures of Black Widow', 6, 3, 900, 'Poetry');
	
	
/* Adding the other missing columns into the checkouts table */
ALTER TABLE checkouts
ADD hold_duration interval,
ADD late_fee numeric (12,2);

INSERT INTO checkouts (member_id, book_id, check_out_date, check_in_date)
VALUES 
	(1, 1, '2021-12-02 01:09:01', '2021-12-08 03:12:56'),
	(1, 3, '2021-11-24 11:23:31', null),
	(2, 4, '2021-12-03 21:12:08', null ),
	(2, 6, '2021-11-24 23:56:07', null ),
	(3, 8, '2021-12-10 00:18:59', null ),
	(4, 9, '2021-11-30 04:16:41', '2021-12-07 00:18:59' ),
	(5, 7, '2021-12-06 17:09:01', null ),
	(5, 5, '2021-12-05 00:39:33', null ),
	(5, 2, '2021-11-20 00:13:22', null ),
	(6, 4, '2021-11-23 11:55:32', '2021-12-10 09:34:59' );
	

/*****************************************************************************************************************************************************/	
/********************************************************************** SPECIFIC QUERIES *************************************************************/
-- 1. This query will return the anniversary  dates of the members for the month of April (ie 4) so that the librarian can send the patrons their thank-you notes. 

SELECT * FROM members
WHERE EXTRACT (MONTH FROM account_open_date) = 4;
	
-- And returns all the information for patrons, Tony Stark and Peter Parker.
/********************************************************************************************************************************************************/
-- 2. Let's put the next_pay_day into the salaries table which is just the previous pay day plus 14 days

UPDATE salaries
SET next_pay_day = previous_pay_day + interval '14 days';
/********************************************************************************************************************************************************/
-- 3. Let's update Mary Hanley bi_weekly to her fixed biweekly salary of 2692.31 to the salaries table 
UPDATE salaries
SET bi_weekly_pay = 2692.31
WHERE employee_id = 1;

-- 4. Let's update the other employees bi weekly employees based on current worked currently right now, however, we need to wait the extra week so that they can receive their full pay. Hence the bi_weekly_pay only represents 1 week worth of pay.
UPDATE salaries
SET bi_weekly_pay = hourly_rate * total_hours_worked
WHERE employee_id > 1;
/*******************************************************************************************************************************************************/
-- 5. Lets update the corresponding due_dates of every book loaned in our checkouts table from each checkout_date

UPDATE checkouts
SET due_date = check_out_date + interval '14 days';

-- 6. Lets set the boolean of the bool_hold to True if the patrons have exceeded 14 days of the book loan
UPDATE checkouts
SET bool_hold = TRUE
WHERE check_in_date - check_out_date > interval '14 days';

--This returns one value. 

-- 7. Let's set the hold_duration in the column where the patron has exceeded their loan period 
UPDATE checkouts
SET hold_duration = check_in_date - due_date
WHERE bool_hold = TRUE;

-- 8. Let's calculate the late_fees for accumulated by the late patron ie 50 cents

UPDATE checkouts
SET late_fee = EXTRACT (DAY FROM hold_duration) * 0.50
WHERE bool_hold = TRUE;
/********************************************************************************************************************************************************/

