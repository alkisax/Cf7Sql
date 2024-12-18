--1.1
checkpoint
dbcc dropcleanbuffers
set statistics io on
select title from movies where pyear between 1995 and 2005
set statistics io off

drop index idx_movies_pyear ON movies
CREATE INDEX idx_movies_pyear ON movies (pyear) INCLUDE (title);

--1.2
checkpoint
dbcc dropcleanbuffers
set statistics io on
select pyear, title from movies where pyear between 1995 and 2005

drop index idx_movies_pyear_title ON movies
CREATE INDEX idx_movies_pyear_title ON movies (pyear, title);


--1.3
checkpoint
dbcc dropcleanbuffers
set statistics io on
select title, pyear from movies where pyear between 1995 and 2005
order by pyear, title
set statistics io off

drop index idx_movies_pyear_title ON movies
CREATE INDEX idx_movies_pyear_title ON movies (pyear, title);

--2.1
-- a) Εμφανίστε ένα κατάλογο με τον τίτλο και το έτος κυκλοφορίας των ταινιών τις οποίες έχει σκηνοθετήσει ο σκηνοθέτης με επώνυμο «Zygadlo».

checkpoint
dbcc dropcleanbuffers
set statistics io on
--SELECT title, pyear FROM movies M JOIN movie_directors MD ON MD.mid=M.mid WHERE did IN ( 	SELECT did  FROM directors 	WHERE lastname='Zygadlo')
set statistics io off

checkpoint
dbcc dropcleanbuffers
set statistics io on
SELECT title, pyear 
FROM movies M
JOIN movie_directors MD ON MD.mid=M.mid
JOIN directors D ON D.did=MD.did
WHERE D.lastname='Zygadlo'
set statistics io off


drop index idx_movies_pyear_title ON movies
drop index idx_movies_directors ON movie_directors
drop index idx_directors ON directors
CREATE INDEX idx_movies_pyear_title ON movies (mid, pyear, title);
CREATE INDEX idx_movies_directors ON movie_directors (mid, did) 
CREATE INDEX idx_directors ON directors (lastname) INCLUDE (did)

--2.2 b) Εμφανίστε έναν κατάλογο με τον τίτλο, το έτος κυκλοφορίας και την κατάταξη (mrank) των ταινιών που ανήκουν στην κατηγορία “Comedy” και έχουν κατάταξη μεγαλύτερη του 7 .


checkpoint
dbcc dropcleanbuffers
set statistics io on
SELECT title, pyear, mrank 
FROM movies M
JOIN movies_genre MG ON MG.mid=M.mid
WHERE MG.genre='Comedy'
AND M.mrank > 7
set statistics io off

drop index idx_movies ON movies
CREATE INDEX idx_movies ON movies (mrank) INCLUDE (title, pyear)
drop index idx_movies_genre ON movies_genre
CREATE INDEX idx_movies_genre ON movies_genre (genre) INCLUDE (mid)

--2.3 c) Εμφανίστε ένα κατάλογο με τον τίτλο, και την κατάταξη (mrank) των ταινιών πουκυκλοφόρησαν το 2000 και έχουν κατάταξη μεγαλύτερη του 5.

checkpoint
dbcc dropcleanbuffers
set statistics io on
SELECT title, mrank 
FROM movies 
WHERE pyear = 2000
AND mrank > 5
set statistics io off


drop index idx_movies ON movies
CREATE INDEX idx_movies ON movies (title, mrank) INCLUDE (pyear)

--3. Να γράψετε τουλάχιστον δύο διαφορετικά επερωτήματα σε SQL που να εμφανίζουν τους τίτλους των ταινιών στις οποίες συμμετέχουν μόνο άντρες ηθοποιοί. Στη συνέχεια να δημιουργήσετε κατάλληλα ευρετήρια που να επιταχύνουν την εκτέλεση των επερωτημάτων. Το ζητούμενο είναι να καταλήξετε σε ένα επερώτημα, το οποίο σε συνδυασμό με κατάλληλα ευρετήρια, θεωρείτε ότι είναι το πλέον αποδοτικό (μικρότερο κόστος εκτέλεσης). Να αιτιολογήσετε την επιλογή σας.

checkpoint
dbcc dropcleanbuffers
set statistics io on
SELECT title
FROM movies M
JOIN movie_directors MD ON MD.mid=M.mid
JOIN roles R ON R.mid=MD.mid
JOIN actors A ON a.aid=R.aid
WHERE M.mid NOT IN (
	SELECT R.mid 
	FROM roles R
	JOIN actors A ON A.aid=R.aid
	WHERE gender = 'F'
)
GROUP BY M.title;
set statistics io off

checkpoint
dbcc dropcleanbuffers
set statistics io on
SELECT M.title
FROM movies M
JOIN movie_directors MD ON MD.mid=M.mid
JOIN roles R ON R.mid=MD.mid
JOIN actors A ON A.aid=R.aid
WHERE A.gender != 'F'
GROUP BY M.title
HAVING COUNT(DISTINCT A.gender) = 1;
set statistics io off

DROP INDEX idx_actors ON actors
DROP INDEX idx_roles ON roles
DROP INDEX idx_movies ON movies
DROP INDEX idx_movie_directors ON movie_directors
CREATE INDEX idx_actors ON actors(gender, aid);
CREATE INDEX idx_roles ON roles(mid, aid);
CREATE INDEX idx_movies ON movies(mid, title);
CREATE INDEX idx_movie_directors ON movie_directors(mid);

--4. Διατυπώστε δύο ερωτήματα σε φυσική γλώσσα και στην συνέχεια γράψτε κατάλληλες επερωτήσεις SQL που απαντούν στα ερωτήματα. Δημιουργείστε κατάλληλα ευρετήρια που να επιταχύνουν την εκτέλεση των επερωτήσεων.

--"Βρες τους τίτλους των ταινιών που έχουν σκηνοθετηθεί από σκηνοθέτες με το επώνυμο 'Nolan'."

checkpoint
dbcc dropcleanbuffers
set statistics io on
SELECT DISTINCT M.title
FROM movies M
JOIN movie_directors MD ON M.mid = MD.mid
JOIN directors D ON MD.did = D.did
WHERE D.lastname = 'Nolan';
set statistics io off

DROP INDEX idx_directors ON directors
DROP INDEX idx_movies ON movies
CREATE INDEX idx_directors ON directors(lastname, did);
CREATE INDEX idx_movies ON movies(title, mid);

-- Before Index: Table directors: 351 logical reads
-- After Index: Table directors: 2 logical reads

-- "Βρες τους τίτλους των ταινιών στις οποίες δεν έχει δοθεί βαθμολογία από κανένα χρήστη."

checkpoint
dbcc dropcleanbuffers
set statistics io on
SELECT M.title
FROM movies M
WHERE M.mid NOT IN (
    SELECT UM.mid
    FROM user_movies UM
);
set statistics io off

DROP INDEX idx_user_movies ON user_movies
DROP INDEX idx_movies ON movies
CREATE INDEX idx_user_movies ON user_movies(mid);
CREATE INDEX idx_movies ON movies(mid, title);

-- Improvement:user_movies: 2601 > 1730 (33.5% reduction) movies: 1918 > 1402 (26.9% reduction)






