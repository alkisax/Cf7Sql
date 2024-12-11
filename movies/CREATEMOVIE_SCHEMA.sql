CREATE TABLE actors
 (actid INTEGER PRIMARY KEY, 
  lname VARCHAR(30) NOT NULL,
  fname VARCHAR(20)
  );

 CREATE TABLE directors
  (did INTEGER PRIMARY KEY, 
   lname VARCHAR (30) NOT NULL,
   fname VARCHAR(20)
   );
   

 CREATE TABLE categories
   ( catid INTEGER PRIMARY KEY,
     category VARCHAR(50) NOT NULL
   );

CREATE TABLE movies
( mid INTEGER PRIMARY KEY, 
  title VARCHAR(200) NOT NULL,
  pyear INTEGER, 
  pcountry VARCHAR(3),
  duration INTEGER,
  did  INTEGER,
  CONSTRAINT fk_did FOREIGN KEY (did) REFERENCES directors(did)
);

CREATE TABLE copies
( barcode INTEGER PRIMARY KEY, 
  mid     INTEGER, 
  cmedium  VARCHAR(10), 
  price   NUMERIC(5,2),
          CONSTRAINT fk_mid FOREIGN KEY (mid) REFERENCES movies(mid)
);

CREATE TABLE movie_actor 
(
  mid INTEGER, 
  actid INTEGER,
        PRIMARY KEY(mid,actid),
        CONSTRAINT fk1_mid FOREIGN KEY (mid) REFERENCES movies(mid),
        CONSTRAINT fk_actid FOREIGN KEY (actid) REFERENCES actors (actid)
);

CREATE TABLE movie_cat 
(
  mid INTEGER, 
  catid INTEGER,
        PRIMARY KEY(mid,catid),
        CONSTRAINT fk2_mid FOREIGN KEY (mid) REFERENCES movies(mid),
        CONSTRAINT fk_catid FOREIGN KEY (catid) REFERENCES categories (catid)
);
   