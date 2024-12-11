/*
1. Εμφανίστε ένα κατάλογο με το επώνυμο και το όνομα των ηθοποιών των οποίων το
επώνυμο αρχίζει με 'Κ'. Ο κατάλογος θα πρέπει να είναι ταξινομημένος αλφαβητικά με
βάση το επώνυμο.*/

SELECT lname, fname
FROM actors
WHERE lname LIKE 'Κ%' OR lname LIKE 'K%'
ORDER BY lname

/* 2. Εμφανίστε ένα κατάλογο με τον τίτλο και το έτος παραγωγής των ταινιών, των οποίων η
παραγωγή έγινε μεταξύ του 1990 και του 2007. Ο κατάλογος να είναι ταξινομημένος με
βάση το έτος παραγωγής σε φθίνουσα διάταξη. */

SELECT title, pyear
FROM movies
WHERE pyear BETWEEN 1990 AND 2007
ORDER BY pyear DESC

/* 3. Εμφανίστε ένα κατάλογο με τον τίτλο της ταινίας, το επώνυμο και το όνομα του σκηνοθέτη
για όλες τις ταινίες με χώρα παραγωγής την Ελλάδα (κωδικός Ελλάδας 'GRC'). Ο κατάλογος
πρέπει να είναι ταξινομημένος αλφαβητικά με βάση το επώνυμο των σκηνοθετών */


SELECT title, lname, fname
FROM movies M
JOIN directors D ON M.did=D.did
WHERE pcountry = 'GRC' --αν ήθελα όσες δεν είναι απο ελλάδα θα έπρεπε να παρω != αλλα θα έπρεπε και OR IS null
ORDER BY lname

/* 4. Εμφανίστε ένα κατάλογο με τον τίτλο και το έτος παραγωγής των ταινιών που σκηνοθέτησε
ο σκηνοθέτης με επώνυμο 'Σακελλάριος' */

SELECT title, pyear 
FROM movies M
JOIN directors D ON M.did=D.did
WHERE D.lname='Σακελλάριος'

/* 5. Εμφανίστε ένα κατάλογο με τους τίτλους και το έτος παραγωγής των ταινιών στις οποίες
έχει πρωταγωνιστεί ο ηθοποιός με επώνυμο 'Eastwood' */

SELECT title, pyear
FROM movies M
JOIN movie_actor MA ON M.mid=MA.mid
JOIN actors A On MA.actid=A.actid
WHERE A.lname ='Eastwood' 

/* 6. Εμφανίστε το επώνυμο και το όνομα των πρωταγωνιστών της ταινίας με τίτλο 'Amelie' */
SElECT lname, fname
FROM movies M, movie_actor MA, actors A
WHERE M.mid=MA.mid AND MA.actid=A.actid
AND M.title='Amelie'

/* 7. Υπολογίστε τον αριθμό των ταινιών που διαθέτουν αντίτυπο σε 'DVD' */
SELECT COUNT(M.mid)
FROM movies M
JOIN copies C ON M.mid=C.mid
WHERE C.cmedium='DVD' 
--H παρακάτω είναι η σωστή απάντηση γιατι δεν θέλει το σύνολο των αντιτύπων αλλά το πόσες ταινίες

Select COUNT (DISTINCT copies.mid)
FROM copies
WHERE cmedium='DVD'

/*8.Βρείτε το συνολικό αριθμό των αντιτύπων (όλων των ταινιών) που διατίθενται σε 'DVD'*/
--anarotieme gia to an apantithike sosta
SELECT COUNT(*)
FROM movies M
JOIN copies C ON M.mid=C.mid
WHERE C.cmedium='DVD'

/*9. Εμφανίστε την τιμή του ακριβότερου 'DVD'*/
SELECT MAX(price)
FROM copies C
WHERE C.cmedium='DVD'

/*10. Βρείτε την συνολική αξία όλων των αντιτύπων (όλων των ταινιών) που διατίθενται σε 'BLU
RAY'.*/
SELECT SUM(price)
FROM copies
WHERE cmedium='BLU RAY'

--11 Εμφανίστε έναν κατάλογο με το ονοματεπώνυμο των σκηνοθετώ και τον αριθμό των ταινιών που έχει σκηνοθετήσει ο κάθε ένας.
SELECT DISTINCT D.lname, D.fname, COUNT(M.mid) AS NoOfMovies
FROM directors D
JOIN movies M ON D.did = M.did 
GROUP BY D.lname, D.fname
-- αν είχα σκηνοθέτες χωρίς ταινίες και ήθελα να βγάλω 0 θα έπρεπε να κάνω left join

--12. Βρείτε τον αριθμό των ταινιών που έχει πρωταγωνιστεί ο ηθοποιός με επώνυμο 'Παπαγιαννόπουλος'.SELECT COUNT(M.mid) FROM movies MJOIN movie_actor MA ON M.mid = MA.midJOIN actors A ON MA.actid = A.actidWHERE A.lname = 'Παπαγιαννόπουλος'-- στο μαθημα έβαλε και group by αλλά βγάζουμε το ίδιο αποτέλεσμα--13. Εμφανίστε ένα κατάλογο με το επώνυμο και το όνομα των ηθοποιών που έχουν πρωταγωνιστεί σε ταινίες των οποίων η παραγωγή τους δεν έχει γίνει στην Ελλάδα (κωδικός Ελλάδας 'GRC').SELECT DISTINCT lname, fnameFROM actors AJOIN movie_actor MA ON A.actid = MA.actidJOIN movies M ON MA.mid = M.midWHERE M.pcountry != 'GRC' --θελει να λάβω υποψιν και το null. sthn τάξη αλλο αποτέλεσμα (22)--14. Εμφανίστε ένα κατάλογο με τους τίτλους των ταινιών στις οποίες έχουν συμπρωταγωνιστεί οι ηθοποιοί με επώνυμο 'Κούρκουλος' και 'Καρέζη' αντίστοιχα. Ο τίτλος κάθε ταινίας θα πρέπει να εμφανίζεται μόνο μία φορά στον κατάλογο.SELECT DISTINCT M.title FROM movies MJOIN movie_actor MA1 on M.mid = MA1.midJOIN actors A1 ON MA1.actid = A1.actidJOIN movie_actor MA2 on M.mid = MA2.midJOIN actors A2 ON MA2.actid = A2.actidWHERE A1.lname = 'Κούρκουλος'AND A2.lname = 'Καρέζη'--καλύτερα θα ήταν με intersect-- eg;v aυτό που έκανα ηταν να ΄κάνω join δύο φορές τον ίδιο πινακα γιατί ήθελα να κάνω δυο διαφορετικές αναζητήσεις απο τον ίδιο πίνακα--15. Εμφανίστε ένα κατάλογο με τους τίτλους των ταινιών στις οποίες έχει πρωταγωνιστεί η ηθοποιός με επώνυμο 'Καρέζη' και στις οποίες δεν συμμετείχε ο ηθοποιός με επώνυμο 'Κούρκουλος'.SELECT DISTINCT M.title FROM movies MJOIN movie_actor MA1 on M.mid = MA1.midJOIN actors A1 ON MA1.actid = A1.actidJOIN movie_actor MA2 on M.mid = MA2.midJOIN actors A2 ON MA2.actid = A2.actidWHERE A2.lname = 'Καρέζη'AND M.mid NOT in (	SELECT DISTINCT M.mid 	FROM movies M	JOIN movie_actor MA on M.mid = MA.mid	JOIN actors A ON MA.actid = A.actid	WHERE A.lname = 'Κούρκουλος')--θα έπρεπε να γίνει με except. ta αποτελέσματα σωστά ομως--16 Εμφανίστε ένα κατάλογο με τους τίτλους των ταινιών που ανήκουν τόσο στην κατηγορία 'Κωμωδία' όσο και στην κατηγορία 'Αισθηματική'. Ο τίτλος κάθε ταινίας θα πρέπει να εμφανίζεται μόνο μία φορά στον κατάλογο.--ιντερσεψτSELECT DISTINCT  M.titleFROM movies MJOIN movie_cat MC1 ON MC1.mid = M.midJOIN categories C1 ON C1.catid = MC1.catidJOIN movie_cat MC2 ON MC2.mid = M.midJOIN categories C2 ON C2.catid = MC2.catidWHERE C1.category = 'Αισθηματική'AND C2.category = 'Κωμωδία'--17. Εμφανίστε ένα κατάλογο με την κατηγορία και τον αριθμό των ταινιών ανά κατηγορία. Στον κατάλογο θα πρέπει να εμφανίζονται ΜΟΝΟ οι κατηγορίες για τις οποίες υπάρχουν τουλάχιστον 5 ταινίες.-- προσοχή στο ΗAVING εγινε γιατί είναι μετά το group bySELECT C.category, COUNT(MC.mid) AS NoCatFROM categories CJOIN movie_cat MC ON MC.catid=C.catidGROUP BY C.categoryHAVING COUNT(MC.mid) > 4-- 18. Εμφανίστε ένα κατάλογο με το ονοματεπώνυμο των σκηνοθετών και τον αριθμό των ταινιών που έχει σκηνοθετήσει ο κάθε ένας τους. Στον κατάλογο θα πρέπει να εμφανίζονται και τα ονόματα των σκηνοθετών για τους οποίους δεν υπάρχουν ταινίες

SELECT D.lname, D.fname, COUNT(M.mid) AS NoMo
FROM directors D
left JOIN movies M ON M.did=D.did
GROUP BY D.lname, D.fname

--19. Διαγράψτε από την βάση δεδομένων την κατηγορία Βιογραφία.

-- DELETE FROM categories WHERE category = 'Βιογραφία';

-- 20. Ενημερώστε την τιμή όλων των αντιτύπων DVD της ταινίας με τίτλο Amelie. Η νέα τιμή είναι 70 ευρώ για το κάθε αντίτυπο σε DVD.

UPDATE copies
SET price = 70.00
WHERE mid IN (
    SELECT C.mid
    FROM copies C
    JOIN movies M ON M.mid = C.mid
    WHERE M.title = 'Amelie'
);





SELECT DISTINCT cmedium FROM copies



