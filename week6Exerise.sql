--1. ��������� �� �������� ��� ������� �� ���������� ���������� ��� 01/05/2018 ��� ��������� �� �������.
SELECT * 
FROM flights
WHERE depDate='2018-05-01'
AND toCity='�������'

--2. ��������� ���� �������� �� �� �������� ��� ������� ��� ������ � �������� ���������� ������ 900 ��� 1500 ������. � ��������� �� ������ �� ����� ������������� �� ���� ��� �������� �� ������� �������.

SELECT *
FROM flights
WHERE distance BETWEEN 900 AND 1500
ORDER BY distance ASC

--3. ��������� ���� �������� �� ��� �������� ������ ��� ������� �� ���������� ���������� ������ 1/5/2018 ����� ��� 30/5/2018 ��� ���������.

SELECT toCity, COUNT(fno) AS TotalNumber
FROM flights
WHERE depDate BETWEEN '2018-05-01' AND '2018-05-30'
GROUP BY toCity

--4. ��������� ���� �������� �� ���� ����������� ��� ��� �������� ������ ��� ������� ��� ���������. ���� �������� �� ������ �� ������������ ���� �� ���������� ��� ���� ������� �������� ����������� ����� �������.

SELECT toCity, COUNT(toCity) AS NoFlights
FROM flights
GROUP BY toCity
HAVING COUNT(toCity) >= 3

--5. ��������� ���� �������� �� �� ������������� ��� ������� ��� ����� �������������� ���� ���������� ����������� ����� ����������.

SELECT firstname, lastname
FROM employees E
JOIN certified C ON E.empid=C.empid
GROUP BY E.empid,E.firstname,E.lastname
HAVING COUNT(C.empid) > 3

--6. ��������� �� �������� ������ ��� �������� ������ ���� ��� ��������� ��� ���������

SELECT SUM(salary) FROM employees

--7. ��������� �� �������� ������ ��� �������� ������ ���� ��� ������� ��� ���������.

SELECT SUM(E.salary) AS TotalPilotSalaries
FROM employees E
WHERE E.empid IN (
	SELECT DISTINCT empid FROM certified
)

--8. ��������� �� �������� ������ ��� �������� ������ ��� ��������� ��� ��������� ��� ��� ����� �������.

SELECT SUM(salary) AS TotalNotPilotsSalaries
FROM employees
where empid NOT IN (
	SELECT DISTINCT empid FROM certified
)

--9. ��������� ���� �������� �� �� ������� ��� ���������� ��� ������� �� �������� ��� ����� ��� ����� ���� ��������� ����� ����� ��� �����������.

SELECT * 
FROM aircrafts 
WHERE crange >= (
	SELECT distance FROM flights WHERE fromCity='�����' AND toCity='���������'
)

--10. ��������� �� ������������� ��� ������� ��� ����� �������������� ���� ���������� ������� ����������� ����� Boeing (�� ����� ��� ����������� �������� �� Boeing).

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

--11. ������ �� ������������� ��� ������� ��� ����� �������������� �� ��������� �� ���������� ������ ����������� ��� 3000 ������, ���� ��� ����� �������������� �� ������ ���������� ����� Boeing.

SELECT DISTINCT E.firstname, E.lastname
FROM employees E
JOIN certified C ON E.empid=C.empid
WHERE aid IN  (
	--erotish 9
	SELECT aid 
	FROM aircrafts 
	WHERE crange >= (
		SELECT distance FROM flights WHERE fromCity='�����' AND toCity='���������'
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

--12. ������ �� ������������� ��� ��������� �� ��� ��������� �����.

SELECT TOP 10 firstname, lastname,salary
FROM employees
ORDER BY salary DESC

--13. ������ �� ������������� ��� ��������� ��� ����� ��� ������� ��������� �����.

SELECT firstname, lastname, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE salary < (
		SELECT MAX(salary) FROM employees
	)
)

--14. ������ �� ������� ��� ���������� ��� �� ����� ���� �� �������������� ���� ���������� ���� ������� ����� ����� ����������� 6000 ����.

SELECT A.aname
FROM aircrafts A

JOIN certified C ON C.aid=A.aid
JOIN employees E ON E.empid=C.empid
WHERE E.empid IN (
	SELECT empid
	FROM employees
	WHERE salary >= 6000
) --����� ����� ���� ��� �� ��� ���������

--���� ����� gpt
SELECT A.aname
FROM aircrafts A
JOIN certified C ON C.aid = A.aid
JOIN employees E ON E.empid = C.empid
GROUP BY A.aname
HAVING MIN(E.salary) >= 6000;


-- 15. ��� ���� ������ ��� ����� �������������� ���� ���������� ����������� ����� ����������, ������ ��� ������ ��� ��� �� ���������� crange ��� ���������� ��� ����� ����� ��������������.

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

--16. ������ �� ������������� ��� ��������� �� ����� ��������� ��� �� ������ ��� ��������� ������ �� ��������� ��� ���������.

SELECT FIRSTNAME, LASTNAME 
FROM EMPLOYEES 
WHERE SALARY <= (
    SELECT MIN(PRICE) 
    FROM FLIGHTS 
    WHERE TOCITY = '���������'
);

-- 17. ������ �� ������������� ��� ��� ����� ��� ��������� ��� ��� ����� ������� ��� ��������� ���� ��� ��� ���� ��� ��� ������ ��� �������.

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

--����� ����� �������
SELECT E.empid
FROM employees E
LEFT JOIN certified C ON C.empid = E.empid
WHERE C.empid IS NOT NULL

-- � ����� ���� ������ ��� �������
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

--18. ������������� ��� �����. � ����� ��� (pilots) �� �������� ��� �� �������� ��� ������� ��� � ������� (others) �� �������� ��� �� �������� ��� ��������� ��� ��� ����� �������. ��������������� ��� ����� ��� ������������� ��� ���������� �� ��������� 7, 8 ��� 17.

--1� ���
--DROP VIEW IF EXISTS pilots;
--go
CREATE VIEW pilots AS 
SELECT E.empid, E.lastname, E.firstname, E.salary, C.aid
FROM employees E
LEFT JOIN certified C ON C.empid = E.empid
WHERE C.empid IS NOT NULL

--2� ���
--go
CREATE VIEW no_pilots AS 
SELECT E.empid, E.lastname, E.firstname, E.salary 
FROM employees E
LEFT JOIN certified C ON C.empid = E.empid
WHERE C.empid IS NULL;

--���� 7.  ��������� �� �������� ������ ��� �������� ������ ���� ��� ������� ��� ���������.

SELECT SUM(salary) AS TotalPilotSalaries
FROM pilots

-- ���� 8. ��������� �� �������� ������ ��� �������� ������ ��� ��������� ��� ��������� ��� ��� ����� �������.

SELECT SUM(salary) AS TotalNotPilotsSalaries
FROM no_pilots

-- ���� 17. ������ �� ������������� ��� ��� ����� ��� ��������� ��� ��� ����� ������� ��� ��������� ���� ��� ��� ���� ��� ��� ������ ��� �������.

SELECT firstname, lastname 
FROM no_pilots
WHERE salary > (
	SELECT AVG(salary)
	FROM pilots
)

--19. ������������� ��� ��� � ����� �� �������� �o ����� ���� ����������� ��� �� �������� ��� ������� (fno, fromCity, toCity) ��� �� ���� ���������� ������ �� ������� ����� �����������. ��������������� ��� ��� ��� ������������� ��������� ���� �������� �� �� ������� ��� ���������� ��� ��� ������ ��� ������� ��� ���� ���������� ������ �� ������������.
CREATE VIEW plane_info AS
SELECT A.aname, F.fno, F.fromCity, F.toCity
FROM aircrafts A
JOIN flights F ON  A.crange >= distance

SELECT aname, COUNT(fno) AS NumberOfFlights
FROM plane_info
GROUP BY aname
ORDER BY NumberOfFlights

-- �. �����������
/*
CREATE PROCEDURE PROC_Name
Input Parameters @Name type
Output parameters @Name type OUT
AS
BEGIN
--OUR LOGIC GOES HERE
END
*/
-- ���� ���������� �����������
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
--20. ������������� ��� ���������� � ����� �� ��������� ��� ������ ���� ������ ��� ����� ��� ������������ "�����", "��������" � "������". ��� ����� ��������� ����� �� �� ������ ��� ���������� ����� ����� ��� 500 ����, �������� �� �� ������ ���������� ������ 501 ��� 1500 ���� ��� ������ �� �� ������ ��� ���������� ��������� �� 1500 ����.

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
		PRINT @fno + ' ' + CAST(@price AS VARCHAR) + ' �����'
		END

		ELSE IF (@price <= 1500 and @price > 500)
		BEGIN
		PRINT @fno + ' ' + CAST(@price AS VARCHAR) + ' ��������'
		END

		ELSE 
		BEGIN
		PRINT @fno + ' ' + CAST(@price AS VARCHAR) + ' ������'	
		END

		SELECT @minfno = MIN(fno) FROM flights WHERE fno > @minfno
	END

-- testing
EXEC price_ranker;


/*
21. ������������� ��� ���������� � ����� �� ������� �� ����������� �� ����� ��� ��� ������ ���� ������� ����� ������ ��� �� ����� ��� ��� ������ ���� �����������. � ���������� �� ���������� ��� ������ ��� ������������ ����������. �� � ������� � �� ���������� ��� �������� ���� ���� ��������� � ���������� �� ������ �� �� ���������. �� ��������� ��� � ������� ����� ��� �������������� ���� ���������� ��� ������������� ����������� � ���������� �� ��������� ��������� ������.
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

--22. ������������� ���� �������� � ������ �� �������������� ���� ���� ��� ���� ������� ������������� ���� ���������� ���� �����������. �� �� �� ��� ����������� � ������� ������ ��� �����, � ��������� �� ������� ��� ����� ��� ���� 10%.

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
	--���� �� ��������������. �� ����� ���� ������ ��������� ��� �������
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



