-- Chun-Wei Chen
-- 1267040
-- mijc0517@cs
-- CSE344 HW7
-- 03/06/14

--------------------------------------------------------------------------------
-- setup.sql
--------------------------------------------------------------------------------

CREATE TABLE RentalPlan(
  pid INT PRIMARY KEY,
  pname VARCHAR(50) UNIQUE NOT NULL,
  monthly_fee DECIMAL(5, 2) NOT NULL,
  hyk INT NOT NULL);

CREATE TABLE Customer(
  cid INT PRIMARY KEY,
  pid INT REFERENCES RentalPlan(pid),
  login VARCHAR(50) NOT NULL,
  password VARCHAR(50) NOT NULL,
  fname VARCHAR(50) NOT NULL,
  lname VARCHAR(50) NOT NULL);

CREATE TABLE Rental(
  cid INT REFERENCES Customer(cid),
  mid INT NOT NULL,
  date_and_time DATETIME NOT NULL,
  status VARCHAR(6) CHECK(status = 'closed' or status = 'open'));

-- I was going to create a clustered index for each table, but it seems
-- like RentalPlan and Customer are created with clustered index since
-- the primary key is specified.
-- CREATE CLUSTERED INDEX planIdx on RentalPlan(pid);
-- CREATE CLUSTERED INDEX customerIdx on Customer(cid);
CREATE CLUSTERED INDEX rentalIdx on Rental(mid);

INSERT INTO RentalPlan VALUES(1, 'Basic', 9.99, 1);
INSERT INTO RentalPlan VALUES(2, 'Rental Plus', 14.99, 5);
INSERT INTO RentalPlan VALUES(3, 'Super Access', 19.99, 10);
INSERT INTO RentalPlan VALUES(4, 'Ultra Access', 24.99, 20);

INSERT INTO Customer VALUES(1, 3, 'mchen', 'chenpw', 'Michael', 'Chen');
INSERT INTO Customer VALUES(2, 2, 'timli', 'tl1010', 'Tim', 'Li');
INSERT INTO Customer VALUES(3, 4, 'hyk0829', 'H19930829', 'Howard', 'Kong');
INSERT INTO Customer VALUES(4, 1, 'jhawk215', 'J0215H', 'James', 'Hawk');

INSERT INTO Rental VALUES(3, 1001000, '2014-02-28 15:28:39', 'closed');
INSERT INTO Rental VALUES(3, 234567, '2014-03-05 12:34:56', 'open');
INSERT INTO Rental VALUES(2, 1001000, '2014-03-04 10:19:32', 'open');
INSERT INTO Rental VALUES(1, 1231231, '2014-03-06 19:47:14', 'closed');