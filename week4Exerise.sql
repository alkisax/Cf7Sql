/*
1. ��������� ��� �������� �� �� ������� ��� �� ����� ��� �������� ��� ������ ��
������� ������� �� '�'. � ��������� �� ������ �� ����� ������������� ���������� ��
���� �� �������.*/

SELECT lname, fname
FROM actors
WHERE lname LIKE '�%' OR lname LIKE 'K%'
ORDER BY lname

/* 2. ��������� ��� �������� �� ��� ����� ��� �� ���� ��������� ��� �������, ��� ������ �
�������� ����� ������ ��� 1990 ��� ��� 2007. � ��������� �� ����� ������������� ��
���� �� ���� ��������� �� �������� �������. */

SELECT title, pyear
FROM movies
WHERE pyear BETWEEN 1990 AND 2007
ORDER BY pyear DESC

/* 3. ��������� ��� �������� �� ��� ����� ��� �������, �� ������� ��� �� ����� ��� ���������
��� ���� ��� ������� �� ���� ��������� ��� ������ (������� ������� 'GRC'). � ���������
������ �� ����� ������������� ���������� �� ���� �� ������� ��� ���������� */


SELECT title, lname, fname
FROM movies M
JOIN directors D ON M.did=D.did
WHERE pcountry = 'GRC' --�� ����� ���� ��� ����� ��� ������ �� ������ �� ���� != ���� �� ������ ��� OR IS null
ORDER BY lname

/* 4. ��������� ��� �������� �� ��� ����� ��� �� ���� ��������� ��� ������� ��� �����������
� ���������� �� ������� '�����������' */

SELECT title, pyear 
FROM movies M
JOIN directors D ON M.did=D.did
WHERE D.lname='�����������'

/* 5. ��������� ��� �������� �� ���� ������� ��� �� ���� ��������� ��� ������� ���� ������
���� ������������� � �������� �� ������� 'Eastwood' */

SELECT title, pyear
FROM movies M
JOIN movie_actor MA ON M.mid=MA.mid
JOIN actors A On MA.actid=A.actid
WHERE A.lname ='Eastwood' 

/* 6. ��������� �� ������� ��� �� ����� ��� ������������� ��� ������� �� ����� 'Amelie' */
SElECT lname, fname
FROM movies M, movie_actor MA, actors A
WHERE M.mid=MA.mid AND MA.actid=A.actid
AND M.title='Amelie'

/* 7. ���������� ��� ������ ��� ������� ��� ��������� �������� �� 'DVD' */
SELECT COUNT(M.mid)
FROM movies M
JOIN copies C ON M.mid=C.mid
WHERE C.cmedium='DVD' 
--H �������� ����� � ����� �������� ����� ��� ����� �� ������ ��� ��������� ���� �� ����� �������

Select COUNT (DISTINCT copies.mid)
FROM copies
WHERE cmedium='DVD'

/*8.������ �� �������� ������ ��� ��������� (���� ��� �������) ��� ����������� �� 'DVD'*/
--anarotieme gia to an apantithike sosta
SELECT COUNT(*)
FROM movies M
JOIN copies C ON M.mid=C.mid
WHERE C.cmedium='DVD'

/*9. ��������� ��� ���� ��� ����������� 'DVD'*/
SELECT MAX(price)
FROM copies C
WHERE C.cmedium='DVD'

/*10. ������ ��� �������� ���� ���� ��� ��������� (���� ��� �������) ��� ����������� �� 'BLU
RAY'.*/
SELECT SUM(price)
FROM copies
WHERE cmedium='BLU RAY'

--11 ��������� ���� �������� �� �� ������������� ��� ��������� ��� ��� ������ ��� ������� ��� ���� ������������ � ���� ����.
SELECT DISTINCT D.lname, D.fname, COUNT(M.mid) AS NoOfMovies
FROM directors D
JOIN movies M ON D.did = M.did 
GROUP BY D.lname, D.fname
-- �� ���� ���������� ����� ������� ��� ����� �� ����� 0 �� ������ �� ���� left join

--12. ������ ��� ������ ��� ������� ��� ���� ������������� � �������� �� ������� '����������������'.SELECT COUNT(M.mid) FROM movies MJOIN movie_actor MA ON M.mid = MA.midJOIN actors A ON MA.actid = A.actidWHERE A.lname = '����������������'-- ��� ������ ����� ��� group by ���� �������� �� ���� ����������--13. ��������� ��� �������� �� �� ������� ��� �� ����� ��� �������� ��� ����� ������������� �� ������� ��� ������ � �������� ���� ��� ���� ����� ���� ������ (������� ������� 'GRC').SELECT DISTINCT lname, fnameFROM actors AJOIN movie_actor MA ON A.actid = MA.actidJOIN movies M ON MA.mid = M.midWHERE M.pcountry != 'GRC' --����� �� ���� ������ ��� �� null. sthn ���� ���� ���������� (22)--14. ��������� ��� �������� �� ���� ������� ��� ������� ���� ������ ����� ���������������� �� �������� �� ������� '����������' ��� '������' ����������. � ������ ���� ������� �� ������ �� ����������� ���� ��� ���� ���� ��������.SELECT DISTINCT M.title FROM movies MJOIN movie_actor MA1 on M.mid = MA1.midJOIN actors A1 ON MA1.actid = A1.actidJOIN movie_actor MA2 on M.mid = MA2.midJOIN actors A2 ON MA2.actid = A2.actidWHERE A1.lname = '����������'AND A2.lname = '������'--�������� �� ���� �� intersect-- eg;v a��� ��� ����� ���� �� ����� join ��� ����� ��� ���� ������ ����� ����� �� ���� ��� ������������ ����������� ��� ��� ���� ������--15. ��������� ��� �������� �� ���� ������� ��� ������� ���� ������ ���� ������������� � �������� �� ������� '������' ��� ���� ������ ��� ���������� � �������� �� ������� '����������'.SELECT DISTINCT M.title FROM movies MJOIN movie_actor MA1 on M.mid = MA1.midJOIN actors A1 ON MA1.actid = A1.actidJOIN movie_actor MA2 on M.mid = MA2.midJOIN actors A2 ON MA2.actid = A2.actidWHERE A2.lname = '������'AND M.mid NOT in (	SELECT DISTINCT M.mid 	FROM movies M	JOIN movie_actor MA on M.mid = MA.mid	JOIN actors A ON MA.actid = A.actid	WHERE A.lname = '����������')--�� ������ �� ����� �� except. ta ������������ ����� ����--16 ��������� ��� �������� �� ���� ������� ��� ������� ��� ������� ���� ���� ��������� '�������' ��� ��� ���� ��������� '�����������'. � ������ ���� ������� �� ������ �� ����������� ���� ��� ���� ���� ��������.--���������SELECT DISTINCT  M.titleFROM movies MJOIN movie_cat MC1 ON MC1.mid = M.midJOIN categories C1 ON C1.catid = MC1.catidJOIN movie_cat MC2 ON MC2.mid = M.midJOIN categories C2 ON C2.catid = MC2.catidWHERE C1.category = '�����������'AND C2.category = '�������'--17. ��������� ��� �������� �� ��� ��������� ��� ��� ������ ��� ������� ��� ���������. ���� �������� �� ������ �� ������������ ���� �� ���������� ��� ��� ������ �������� ����������� 5 �������.-- ������� ��� �AVING ����� ����� ����� ���� �� group bySELECT C.category, COUNT(MC.mid) AS NoCatFROM categories CJOIN movie_cat MC ON MC.catid=C.catidGROUP BY C.categoryHAVING COUNT(MC.mid) > 4-- 18. ��������� ��� �������� �� �� ������������� ��� ���������� ��� ��� ������ ��� ������� ��� ���� ������������ � ���� ���� ����. ���� �������� �� ������ �� ������������ ��� �� ������� ��� ���������� ��� ���� ������� ��� �������� �������

SELECT D.lname, D.fname, COUNT(M.mid) AS NoMo
FROM directors D
left JOIN movies M ON M.did=D.did
GROUP BY D.lname, D.fname

--19. ��������� ��� ��� ���� ��������� ��� ��������� ����������.

-- DELETE FROM categories WHERE category = '���������';

-- 20. ���������� ��� ���� ���� ��� ��������� DVD ��� ������� �� ����� �Amelie�. � ��� ���� ����� 70 ���� ��� �� ���� �������� �� DVD.

UPDATE copies
SET price = 70.00
WHERE mid IN (
    SELECT C.mid
    FROM copies C
    JOIN movies M ON M.mid = C.mid
    WHERE M.title = 'Amelie'
);





SELECT DISTINCT cmedium FROM copies



