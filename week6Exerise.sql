--1. Εμφανίστε τα στοιχεία των πτήσεων με ημερομηνία αναχώρησης την 01/05/2018 και προορισμό το Τορόντο.
SELECT * 
FROM flights
WHERE depDate='2018-05-01'
AND toCity='Τορόντο'

--2. Εμφανίστε έναν κατάλογο με τα στοιχεία των πτήσεων των οποίων η απόσταση κυμαίνεται μεταξύ 900 και 1500 μιλίων. Ο κατάλογος θα πρέπει να είναι ταξινομημένος με βάση την απόσταση σε αύξουσα διάταξη.

SELECT *
FROM flights
WHERE distance BETWEEN 900 AND 1500
ORDER BY distance ASC

--3. Εμφανίστε έναν κατάλογο με τον συνολικό αριθμό των πτήσεων με ημερομηνία αναχώρησης μεταξύ 1/5/2018 μέχρι και 30/5/2018 ανά προορισμό.

SELECT toCity, COUNT(fno) AS TotalNumber
FROM flights
WHERE depDate BETWEEN '2018-05-01' AND '2018-05-30'
GROUP BY toCity

--4. Εμφανίστε έναν κατάλογο με τους προορισμούς και τον συνολικό αριθμό των πτήσεων ανά προορισμό. Στον κατάλογο θα πρέπει να εμφανίζονται μόνο οι προορισμοί για τους οποίους υπάρχουν τουλάχιστον τρείς πτήσεις.

SELECT toCity, COUNT(toCity) AS NoFlights
FROM flights
GROUP BY toCity
HAVING COUNT(toCity) >= 3

--5. Εμφανίστε έναν κατάλογο με το ονοματεπώνυμο των πιλότων που είναι πιστοποιημένοι στην λειτουργία τουλάχιστον τριών αεροσκαφών.

SELECT firstname, lastname
FROM employees E
JOIN certified C ON E.empid=C.empid
GROUP BY E.empid,E.firstname,E.lastname
HAVING COUNT(C.empid) > 3

--6. Εμφανίστε το συνολικό κόστος των μηνιαίων μισθών όλων των υπαλλήλων της εταιρείας

SELECT SUM(salary) FROM employees

--7. Εμφανίστε το συνολικό κόστος των μηνιαίων μισθών όλων των πιλότων της εταιρείας.

SELECT SUM(E.salary) AS TotalPilotSalaries
FROM employees E
WHERE E.empid IN (
	SELECT DISTINCT empid FROM certified
)

--8. Εμφανίστε το συνολικό κόστος των μηνιαίων μισθών των υπαλλήλων της εταιρείας που δεν είναι πιλότοι.

SELECT SUM(salary) AS TotalNotPilotsSalaries
FROM employees
where empid NOT IN (
	SELECT DISTINCT empid FROM certified
)

--9. Εμφανίστε έναν κατάλογο με τα ονόματα των αεροσκαφών που μπορούν να καλύψουν την πτήση από Αθήνα προς Μελβούρνη δίχως στάση για ανεφοδιασμό.

SELECT * 
FROM aircrafts 
WHERE crange >= (
	SELECT distance FROM flights WHERE fromCity='Αθήνα' AND toCity='Μελβούρνη'
)

--10. Εμφανίστε το ονοματεπώνυμο των πιλότων που είναι πιστοποιημένοι στην λειτουργία κάποιου αεροσκάφους τύπου Boeing (το όνομα του αεροσκάφους ξεκινάει με Boeing).

SELECT DISTINCT E.firstname, E.lastname 
FROM employees E
JOIN certified C ON C.empid=E.empid
JOIN aircrafts A ON A.aid=C.aid
WHERE C.empid IN (
	SELECT C.empid 
	FROM certified C
	WHERE C.aid IN (
		SELECT A.aid
		FROM aircrafts A
		WHERE aname LIKE 'Boeing%'
	)
)

--11. Βρείτε το ονοματεπώνυμο των πιλότων που είναι πιστοποιημένοι σε αεροσκάφη με δυνατότητα πτήσης μεγαλύτερης των 3000 μιλίων, αλλά δεν είναι πιστοποιημένοι σε κανένα αεροσκάφος τύπου Boeing.

SELECT DISTINCT E.firstname, E.lastname
FROM employees E
JOIN certified C ON E.empid=C.empid
WHERE aid IN  (
	--erotish 9
	SELECT aid 
	FROM aircrafts 
	WHERE crange >= (
		SELECT distance FROM flights WHERE fromCity='Αθήνα' AND toCity='Μελβούρνη'
	)
)
AND E.empid NOT IN (
	--erotish 10
	SELECT DISTINCT E.empid 
	FROM employees E
	JOIN certified C ON C.empid=E.empid
	JOIN aircrafts A ON A.aid=C.aid
	WHERE C.empid IN (
		SELECT C.empid 
		FROM certified C
		WHERE C.aid IN (
			SELECT A.aid
			FROM aircrafts A
			WHERE aname LIKE 'Boeing%'
		)
	)
)

--12. Βρείτε το ονοματεπώνυμο των υπαλλήλων με τον υψηλότερο μισθό.

SELECT TOP 10 firstname, lastname,salary
FROM employees
ORDER BY salary DESC

--13. Βρείτε το ονοματεπώνυμο των υπαλλήλων που έχουν τον δεύτερο υψηλότερο μισθό.

SELECT firstname, lastname, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE salary < (
		SELECT MAX(salary) FROM employees
	)
)

--14. Βρείτε τα ονόματα των αεροσκαφών για τα οποία όλοι οι πιστοποιημένοι στην λειτουργία τους πιλότοι έχουν μισθό τουλάχιστον 6000 ευρώ.

SELECT A.aname
FROM aircrafts A

JOIN certified C ON C.aid=A.aid
JOIN employees E ON E.empid=C.empid
WHERE E.empid IN (
	SELECT empid
	FROM employees
	WHERE salary >= 6000
) --είναι λάθος αλλα δεν το εχω διορθώσει

--αυτο ειναι gpt
SELECT A.aname
FROM aircrafts A
JOIN certified C ON C.aid = A.aid
JOIN employees E ON E.empid = C.empid
GROUP BY A.aname
HAVING MIN(E.salary) >= 6000;


-- 15. Για κάθε πιλότο που είναι πιστοποιημένος στην λειτουργία τουλάχιστον τριών αεροσκαφών, βρείτε τον κωδικό του και το μεγαλύτερο crange των αεροσκαφών στα οποία είναι πιστοποιημένος.

SELECT E.empid, MAX(A.crange) AS MAX
FROM employees E
JOIN certified C ON C.empid=E.empid
JOIN aircrafts A ON A.aid=C.aid
WHERE E.empid IN (
	SELECT  C.empid 
	FROM certified C
	GROUP BY C.empid
	HAVING COUNT(C.aid) > 3
)
GROUP BY E.empid

--16. Βρείτε το ονοματεπώνυμο των υπαλλήλων με μισθό μικρότερο από το κόστος της φθηνότερη πτήσης με προορισμό την Μελβούρνη.

SELECT FIRSTNAME, LASTNAME 
FROM EMPLOYEES 
WHERE SALARY <= (
    SELECT MIN(PRICE) 
    FROM FLIGHTS 
    WHERE TOCITY = 'Μελβούρνη'
);

-- 17. Βρείτε το ονοματεπώνυμο και τον μισθό των υπαλλήλων που δεν είναι πιλότοι και κερδίζουν πάνω από τον μέσο όρο του μισθού των πιλότων.

SELECT firstname, lastname 
FROM employees E
LEFT JOIN certified C ON C.empid = E.empid
WHERE C.empid IS NULL
AND E.salary > (
	SELECT AVG(E.salary)
	FROM employees E
	WHERE E.empid IN (
	    SELECT E.empid
	    FROM employees E
	    LEFT JOIN certified C ON C.empid = E.empid
	    WHERE C.empid IS NOT NULL
	)
)

--Ποιοι ειναι πιλοτοι
SELECT E.empid
FROM employees E
LEFT JOIN certified C ON C.empid = E.empid
WHERE C.empid IS NOT NULL

-- Ο μέσος όρος μισθών των πιλότων
SELECT AVG(E.salary)
FROM employees E
WHERE E.empid IN (
    SELECT E.empid
    FROM employees E
    LEFT JOIN certified C ON C.empid = E.empid
    WHERE C.empid IS NOT NULL
)

-- o misthos ton non certified
SELECT E.firstname, E.lastname, E.salary
FROM employees E
LEFT JOIN certified C ON C.empid = E.empid
WHERE C.empid IS NULL;
-- den girnaei tipota giati kaneiw den pernei pano apo ton meso oro ton piloton

--18. Δημιουργείστε δύο όψεις. Η πρώτη όψη (pilots) θα περιέχει όλα τα στοιχεία των πιλότων και η δεύτερη (others) θα περιέχει όλα τα στοιχεία των υπαλλήλων που δεν είναι πιλότοι. Χρησιμοποιώντας τις όψεις που δημιουργήσατε και ξαναγράψτε τα ερωτήματα 7, 8 και 17.

--1η οψη
--DROP VIEW IF EXISTS pilots;
--go
CREATE VIEW pilots AS 
SELECT E.empid, E.lastname, E.firstname, E.salary, C.aid
FROM employees E
LEFT JOIN certified C ON C.empid = E.empid
WHERE C.empid IS NOT NULL

--2η όψη
--go
CREATE VIEW no_pilots AS 
SELECT E.empid, E.lastname, E.firstname, E.salary 
FROM employees E
LEFT JOIN certified C ON C.empid = E.empid
WHERE C.empid IS NULL;

--ξανα 7.  Εμφανίστε το συνολικό κόστος των μηνιαίων μισθών όλων των πιλότων της εταιρείας.

SELECT SUM(salary) AS TotalPilotSalaries
FROM pilots

-- ξανά 8. Εμφανίστε το συνολικό κόστος των μηνιαίων μισθών των υπαλλήλων της εταιρείας που δεν είναι πιλότοι.

SELECT SUM(salary) AS TotalNotPilotsSalaries
FROM no_pilots

-- Ξανά 17. Βρείτε το ονοματεπώνυμο και τον μισθό των υπαλλήλων που δεν είναι πιλότοι και κερδίζουν πάνω από τον μέσο όρο του μισθού των πιλότων.

SELECT firstname, lastname 
FROM no_pilots
WHERE salary > (
	SELECT AVG(salary)
	FROM pilots
)

--19. Δημιουργείστε μία όψη η οποία θα περιέχει τo όνομα κάθε αεροσκάφους και τα στοιχεία των πτήσεων (fno, fromCity, toCity) που το κάθε αεροσκάφος μπορεί να καλύψει δίχως ανεφοδιασμό. Χρησιμοποιώντας την όψη που δημιουργήσατε εμφανίστε έναν κατάλογο με τα ονόματα των αεροσκαφών και τον αριθμό των πτήσεων που κάθε αεροσκάφος μπορεί να εξυπηρετήσει.
CREATE VIEW plane_info AS
SELECT A.aname, F.fno, F.fromCity, F.toCity
FROM aircrafts A
JOIN flights F ON  A.crange >= distance

SELECT aname, COUNT(fno) AS NumberOfFlights
FROM plane_info
GROUP BY aname
ORDER BY NumberOfFlights

-- Γ. ΔΙΑΔΙΚΑΣΙΕΣ
/*
CREATE PROCEDURE PROC_Name
Input Parameters @Name type
Output parameters @Name type OUT
AS
BEGIN
--OUR LOGIC GOES HERE
END
*/
-- απλό παράδειγμα διαδικασίας
/*
DECLARE @Number INT;
SET @Number = 50;
IF @Number > 100
	PRINT 'The number is large.';
ELSE
BEGIN
	IF @Number < 10
	PRINT 'The number is small.';
ELSE
	PRINT 'The number is medium.';
END;
*/
--20. Δημιουργείστε μια διαδικασία η οποία θα εμφανίζει τον κωδικό κάθε πτήσης και δίπλα τον χαρακτηρισμό "Φθηνή", "Κανονική" ή "Ακριβή". Μία πτήση θεωρείται φθηνή αν το κόστος του εισιτηρίου είναι μέχρι και 500 ευρώ, κανονική αν το κόστος κυμαίνεται μεταξύ 501 και 1500 ευρώ και ακριβή αν το κόστος του εισιτηρίου ξεπερνάει τα 1500 ευρώ.

CREATE PROCEDURE price_ranker AS
	DECLARE @price INT
	DECLARE @fno VARCHAR(4)
	DECLARE @minfno VARCHAR(4)
	
	SELECT @minfno = MIN(fno) FROM flights

	WHILE @minfno is NOT NULL
	BEGIN
		SELECT @fno=fno, @price=price  FROM flights WHERE fno=@minfno
	
		IF (@price <= 500)
		BEGIN
		PRINT @fno + ' ' + CAST(@price AS VARCHAR) + ' Φθηνή'
		END

		ELSE IF (@price <= 1500 and @price > 500)
		BEGIN
		PRINT @fno + ' ' + CAST(@price AS VARCHAR) + ' Κανονική'
		END

		ELSE 
		BEGIN
		PRINT @fno + ' ' + CAST(@price AS VARCHAR) + ' Ακριβή'	
		END

		SELECT @minfno = MIN(fno) FROM flights WHERE fno > @minfno
	END

-- testing
EXEC price_ranker;


/*
21. Δημιουργείστε μια διαδικασία η οποία θα δέχεται ως παραμέτρους το όνομα και τον κωδικό ενός πιλότου καθώς επίσης και το όνομα και τον κωδικό ενός αεροσκάφους. Η διαδικασία θα πιστοποιεί τον πιλότο στο συγκεκριμένο αεροσκάφος. Αν ο πιλότος ή το αεροσκάφος δεν υπάρχουν στην βάση δεδομένων η διαδικασία θα πρέπει να τα εισαγάγει. Σε περίπτωση που ο πιλότος είναι ήδη πιστοποιημένος στην λειτουργία του συγκεκριμένου αεροσκάφους η διαδικασία θα εμφανίζει κατάλληλο μήνυμα.
*/
CREATE PROCEDURE Insert_Certified
@empid INT,
@lastname VARCHAR(30),
@aid INT,
@aname VARCHAR(50)
AS

DECLARE @EmployeeExists INT
DECLARE @planeNotListed INT
DECLARE @isCertified INT

SELECT @EmployeeExists = COUNT(*) FROM employees WHERE empid=@empid
SELECT @planeNotListed = COUNT(*) FROM aircrafts WHERE aid=@aid
SELECT @isCertified = COUNT(*) FROM certified WHERE aid=@aid AND empid=@empid

IF (@planeNotListed = 0)
	BEGIN
		INSERT INTO aircrafts (aid, aname) VALUES (@aid, @aname)
		PRINT 'plane added ' + @aname
	END
IF (@EmployeeExists = 0)
	BEGIN 
		INSERT INTO employees (lastname, empid, firstname, salary) VALUES (@lastname, @empid, 'unknown', 1000)
		PRINT 'Employee added ' + @lastname
	END
IF (@isCertified > 0)
	BEGIN
		PRINT 'Employee' + @lastname + ' is already certified for aircraft ' + CAST(@aid AS VARCHAR)
		RETURN
	END

	INSERT INTO certified (empid,aid) VALUES (@empid, @aid)
	PRINT 'Employee ' + @lastname + ' is now registered as certified for plane id ' + CAST(@aid AS VARCHAR) 


--gpt testlines
EXEC Insert_Certified @empid = 1001, @lastname = 'Doe', @aid = 2001, @aname = 'Boeing 737';
EXEC Insert_Certified @empid = 1002, @lastname = 'Smith', @aid = 2002, @aname = 'Airbus A320';
EXEC Insert_Certified @empid = 1001, @lastname = 'Doe', @aid = 2003, @aname = 'Boeing 747';
EXEC Insert_Certified @empid = 1001, @lastname = 'Doe', @aid = 2001, @aname = 'Boeing 737';

--22. Δημιουργείστε έναν πυροδότη ο οποίος θα ενεργοποιείται κάθε φορά που ένας πιλότος πιστοποιείται στην λειτουργία ενός αεροσκάφους. Αν με τη νέα πιστοποίηση ο πιλότος φθάνει τις τρείς, ο πυροδότης θα αυξάνει τον μισθό του κατά 10%.

/*
CREATE TRIGGER trigger_customers
ON customers
AFTER INSERT, UPDATE, DELETE
AS PRINT ('You made one DML operation');
*/
CREATE TRIGGER trigger_update_salary
ON certified
AFTER INSERT AS
BEGIN
	UPDATE employees
	SET salary = salary + (salary * 10 / 100)
	WHERE empid IN (
		SELECT empid
		FROM certified
		GROUP BY empid 
		HAVING COUNT(*) = 3
	)
	--μονο οι νεοεισαχθεντες. το βλέπω στον πίνακα ινσερτιντ του τριγκερ
	AND empid IN (
		SELECT empid
		FROM INSERTED
	)
END








BEGIN
	DECLARE @empid INT;
	DECLARE @countEmpid INT;

	SELECT @countEmpid = COUNT(*) FROM certified WHERE empid=@empid
	IF (@countEmpid > 3) 
	BEGIN
		UPDATE employees.salary = (employees.salary*10)/100 + employees.salary
	END
END



