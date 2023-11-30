 --Laboratorul 5

-- LABORATOR 5 - SAPTAMANA 7

-- Limbajul de definire a datelor (LDD) 

--COMENZI CARE FAC PARTE DIN LDD:

CREATE, ALTER, DROP, TRUNCATE, RENAME

--Ce comanda LCD se executa dupa instructiunile de tip LDD?

_____


1. Crearea tabelelor (vezi notiunile in laborator 5)

-- EXERCITII 

1. S� se creeze tabelul ANGAJATI_pnu 
(pnu se alcatuie�te din prima liter� din prenume �i primele dou� din numele studentului) 
corespunz�tor schemei rela�ionale:

ANGAJATI_pnu(cod_ang number(4), nume varchar2(20), prenume varchar2(20), email char(15), 
             data_ang date, job varchar2(10), cod_sef number(4), salariu number(8, 2), 
             cod_dep number(2)
            );
  
a) cu precizarea cheilor primare la nivel de coloan� 
si a constrangerilor NOT NULL pentru coloanele nume �i salariu;          

CREATE TABLE angajati_pnu
      ( cod_ang number(4) constraint pk_angajat primary key ,
        nume varchar2(20) constraint nume_ang not null,
        prenume varchar2(20),
        email char(15) unique,
        data_ang date default sysdate,
        job varchar2(10),
        cod_sef number(4),
        salariu number(8,2) not null,
        cod_dep number(2)
       );
 
SELECT * FROM angajati_pnu;
DESC angajati_pnu;
    
b) cu precizarea cheii primare la nivel de tabel 
si a constr�ngerilor NOT NULL pentru coloanele nume �i salariu.

DROP TABLE angajati_pnu;

CREATE TABLE angajati_pnu
      ( cod_ang number(4),
        nume varchar2(20) constraint nume_ang not null,
        prenume varchar2(20),
        email char(15)unique,
        data_ang date default sysdate,
        job varchar2(10),
        cod_sef number(4),
        salariu number(8, 2) constraint salariu_ang not null,
        cod_dep number(2),
        constraint pkey_ang primary key(cod_ang) --constrangere la nivel de tabel
       );
 
 
2. Ad�uga�i urm�toarele �nregistr�ri �n tabelul ANGAJATI_pnu:

-- 1
-- metoda explicita (se precizeaza coloanele)
INSERT INTO angajati_pnu(cod_ang, nume, prenume, data_ang, job, salariu, cod_dep)
VALUES(100, 'nume1', 'prenume1', null, 'Director', 20000, 10);

DE CE A FOST PRECIZATA COLOANA data_ang si nu a fost precizata coloana cod_sef?
R: _____


-- 2           
-- metoda implicita de inserare (nu se precizeaza coloanele)
INSERT INTO angajati_pnu
VALUES(101, 'nume2', 'prenume2', 'nume2', to_date('02-02-2004','dd-mm-yyyy'), 
       'Inginer', 100, 10000, 10);
   
-- 3          
INSERT INTO angajati_pnu
VALUES(102, 'nume3', 'prenume3', 'nume3', to_date('05-06-2000','dd-mm-yyyy'), 
       'Analist', 101, 5000, 20);

-- 4             
INSERT INTO angajati_pnu(cod_ang, nume, prenume, data_ang, job, cod_sef, salariu, cod_dep)
VALUES(103, 'nume4', 'prenume4', null, 'Inginer', 100, 9000, 20);

-- 5       
INSERT INTO angajati_pnu
VALUES(104, 'nume5', 'prenume5', 'nume5', null, 'Analist', 101, 3000, 30);

-- salvam inregistrarile
COMMIT;

SELECT * FROM angajati_pnu;


2. Modificarea (structurii) tabelelor (vezi notiunile din laborator)

-- EXERCITII

3. Introduceti coloana comision in tabelul ANGAJATI. 
Coloana va avea tipul de date NUMBER(4,2).

DESC angajati_pnu;

ALTER TABLE angajati_pnu
ADD comision number(4,2);

SELECT * FROM angajati_pnu;


4. Este posibil� modificarea tipului coloanei salariu �n NUMBER(6,2) � 6 cifre si 2 zecimale?

SELECT * FROM angajati_pnu;
DESC angajati_pnu;

ALTER TABLE angajati_pnu
MODIFY (salariu number(6,2));


5. Seta�i o valoare DEFAULT pentru coloana salariu.

SELECT * FROM angajati_pnu;
DESC angajati_pnu;

ALTER TABLE angajati_pnu
MODIFY (salariu number(8,2) default 100); 
                 -- atentie la tipul de date si dimensiunea coloanei


6. Modifica�i tipul coloanei comision �n NUMBER(2, 2) 
�i al coloanei salariu la NUMBER(10,2), �n cadrul aceleia�i instruc�iuni.

DESC angajati_pnu;

SELECT * FROM angajati_pnu;

ALTER TABLE angajati_pnu
MODIFY (comision number(2,2),
        salariu number(10,2)
        );

De ce au fost permise cele doua modificari de mai sus?



7. Actualizati valoarea coloanei comision, set�nd-o la valoarea 0.1 
pentru salaria�ii al c�ror job �ncepe cu litera A. (UPDATE)

UPDATE angajati_pnu
SET comision = 0.1
WHERE upper(job) LIKE 'A%';


SELECT * FROM angajati_pnu;

Comanda anterioara executa commit implicit?
____


8. Modifica�i tipul de date al coloanei email �n VARCHAR2.

DESC angajati_pnu;

ALTER TABLE angajati_pnu
MODIFY (email varchar2(15));


9. Ad�uga�i coloana nr_telefon �n tabelul ANGAJATI_pnu, set�ndu-i o valoare implicit�.

ALTER TABLE angajati_pnu
ADD (nr_telefon varchar2(10) default '0723234234');

SELECT * FROM angajati_pnu;


10. Vizualiza�i �nregistr�rile existente. Suprima�i coloana nr_telefon.

SELECT * FROM angajati_pnu;

ALTER TABLE angajati_pnu
DROP column nr_telefon;

ROLLBACK; -- ce efect are rollback?


11. Crea�i �i tabelul DEPARTAMENTE_pnu, corespunz�tor schemei rela�ionale:

DEPARTAMENTE_pnu (cod_dep# number(2), nume varchar2(15), cod_director number(4))

specific�nd doar constr�ngerea NOT NULL pentru nume 
(nu preciza�i deocamdat� constr�ngerea de cheie primar�);

CREATE TABLE departamente_pnu
    (cod_dep number(2),
     nume varchar2(15) constraint nume_dep not null,
     cod_director number(4)
    );
    
DESC departamente_pnu;

SELECT * FROM departamente_pnu;


12. Introduce�i urm�toarele �nregistr�ri �n tabelul DEPARTAMENTE

INSERT INTO departamente_pnu
VALUES (10, 'Administrativ', 100);

INSERT INTO departamente_pnu
VALUES (20, 'Proiectare', 101);

INSERT INTO departamente_pnu
VALUES (30, 'Programare', null);


13. Se va preciza apoi cheia primara cod_dep, f�r� suprimarea �i recrearea tabelului 
(comanda ALTER);

ALTER TABLE departamente_pnu
ADD CONSTRAINT pkey_dep PRIMARY KEY(cod_dep);

DESC departamente_pnu;

In acest punct mai este nevoie de comanda commit 
pentru salvarea celor 3 inserari anterioare?




--laborator 5 partea 2

-- Rezolvati urmatoarele exercitii:

2. Ad�uga�i urm�toarele �nregistr�ri �n tabelul ANGAJATI_pnu:

-- Analizati tabelul din Laborator 5

-- 1
-- metoda explicita (se precizeaza coloanele)
INSERT INTO angajati_pnu(cod_ang, nume, prenume, data_ang, job, salariu, cod_dep)
VALUES(100, 'nume1', 'prenume1', null, 'Director', 20000, 10);

SELECT * FROM angajati_pnu;

DE CE A FOST PRECIZATA COLOANA data_ang si nu a fost precizata coloana cod_sef?
R: _____


-- 2           
-- metoda implicita de inserare (nu se precizeaza coloanele)
INSERT INTO angajati_pnu
VALUES(101, 'nume2', 'prenume2', 'nume2', to_date('02-02-2004','dd-mm-yyyy'), 
       'Inginer', 100, 10000, 10);
   
-- 3          
INSERT INTO angajati_pnu
VALUES(102, 'nume3', 'prenume3', 'nume3', to_date('05-06-2000','dd-mm-yyyy'), 
       'Analist', 101, 5000, 20);

-- 4             
INSERT INTO angajati_pnu(cod_ang, nume, prenume, data_ang, job, cod_sef, salariu, cod_dep)
VALUES(103, 'nume4', 'prenume4', null, 'Inginer', 100, 9000, 20);

-- 5       
INSERT INTO angajati_pnu
VALUES(104, 'nume5', 'prenume5', 'nume5', null, 'Analist', 101, 3000, 30);

-- salvam inregistrarile
COMMIT;

SELECT * FROM angajati_pnu;


2. Modificarea (structurii) tabelelor (vezi notiunile din laborator - pagina 3)

-- EXERCITII

3. Introduceti coloana comision in tabelul ANGAJATI. 
Coloana va avea tipul de date NUMBER(4,2).

DESC angajati_pnu;

ALTER TABLE angajati_pnu
ADD comision number(4,2);

SELECT * FROM angajati_pnu;


4. Este posibil� modificarea tipului coloanei salariu �n NUMBER(6,2) � 6 cifre si 2 zecimale?

SELECT * FROM angajati_pnu;
DESC angajati_pnu;

ALTER TABLE angajati_pnu
MODIFY (salariu number(6,2));

--nu merge deoarece trebuie ca toata coloana sa fie necompletata pentru a face precizia mai mica

5. Seta�i o valoare DEFAULT pentru coloana salariu.

SELECT * FROM angajati_pnu;
DESC angajati_pnu;

ALTER TABLE angajati_pnu
MODIFY (salariu number(8,2) default 100); 
                 -- atentie la tipul de date si dimensiunea coloanei


6. Modifica�i tipul coloanei comision �n NUMBER(2, 2) 
�i al coloanei salariu la NUMBER(10,2), �n cadrul aceleia�i instruc�iuni.

DESC angajati_pnu;

SELECT * FROM angajati_pnu;

ALTER TABLE angajati_pnu
MODIFY (comision number(2,2),
        salariu number(10,2)
        );

De ce au fost permise cele doua modificari de mai sus?

R: _______



7. Actualizati valoarea coloanei comision, set�nd-o la valoarea 0.1 
pentru salaria�ii al c�ror job �ncepe cu litera A. (UPDATE)

UPDATE angajati_pnu
SET comision = 0.1
WHERE upper(job) LIKE 'A%';


SELECT * FROM angajati_pnu;

Comanda anterioara executa commit implicit?
--R: NU


8. Modifica�i tipul de date al coloanei email �n VARCHAR2.

DESC angajati_pnu;

ALTER TABLE angajati_pnu
MODIFY (email varchar2(15)); -- cititi observatiile din Laborator 5 - pagina 3


9. Ad�uga�i coloana nr_telefon �n tabelul ANGAJATI_pnu, set�ndu-i o valoare implicit�.

ALTER TABLE angajati_pnu
ADD (nr_telefon varchar2(10) default '0723234234');

SELECT * FROM angajati_pnu;


10. Vizualiza�i �nregistr�rile existente. Suprima�i coloana nr_telefon.

SELECT * FROM angajati_pnu;

ALTER TABLE angajati_pnu
DROP column nr_telefon;

ROLLBACK; -- ce efect are rollback?

--R: Nu are niciun efect


11. Crea�i �i tabelul DEPARTAMENTE_pnu, corespunz�tor schemei rela�ionale:

DEPARTAMENTE_pnu (cod_dep# number(2), nume varchar2(15), cod_director number(4))

specific�nd doar constr�ngerea NOT NULL pentru nume 
(nu preciza�i deocamdat� constr�ngerea de cheie primar�);

CREATE TABLE departamente_pnu
    (cod_dep number(2),
     nume varchar2(15) constraint nume_dep not null,
     cod_director number(4)
    );
    
DESC departamente_pnu;

SELECT * FROM departamente_pnu;


12. Introduce�i urm�toarele �nregistr�ri �n tabelul DEPARTAMENTE

INSERT INTO departamente_pnu
VALUES (10, 'Administrativ', 100);

INSERT INTO departamente_pnu
VALUES (20, 'Proiectare', 101);

INSERT INTO departamente_pnu
VALUES (30, 'Programare', null);


13. Se va preciza apoi cheia primara cod_dep, f�r� suprimarea �i recrearea tabelului 
(comanda ALTER);

ALTER TABLE departamente_pnu
ADD CONSTRAINT pkey_dep PRIMARY KEY(cod_dep);

DESC departamente_pnu;

-- In acest punct mai este nevoie de comanda commit 
-- pentru salvarea celor 3 inserari anterioare?

--R: nu, se face commit automat cand rulam alter table 


SELECT * FROM departamente_pnu;
SELECT * FROM angajati_pnu;

DESC departamente_pnu;
DESC angajati_pnu;

14. S� se precizeze constr�ngerea de cheie extern� pentru coloana cod_dep din ANGAJATI_pnu:

a) f�r� suprimarea tabelului (ALTER TABLE);

ALTER TABLE angajati_pnu
ADD CONSTRAINT fkey_ang_dep FOREIGN KEY(cod_dep) REFERENCES departamente_pnu(cod_dep);


b) prin suprimarea �i recrearea tabelului, cu precizarea noii constr�ngeri la nivel de coloan� 
({DROP, CREATE} TABLE). 

De asemenea, se vor mai preciza constr�ngerile (la nivel de coloan�, dac� este posibil):
- PRIMARY KEY pentru cod_ang;
- FOREIGN KEY pentru cod_sef;
- UNIQUE pentru combina�ia nume + prenume;
- UNIQUE pentru email;
- NOT NULL pentru nume;
- verificarea cod_dep >0;
- verificarea ca salariul sa fie mai mare decat comisionul*100.

DROP TABLE angajati_pnu;

CREATE TABLE angajati_pnu
    (cod_ang number(4) constraint pkey_ang primary key,
     nume varchar2(20) constraint nume_ang not null,
     prenume varchar2(20),
     email char(15) constraint email_unic unique,
     data_ang date default sysdate,
     job varchar2(10),
     cod_sef number(4) constraint sef_ang references angajati_pnu(cod_ang), -- cheie externa
     salariu number(8, 2) constraint salariu_ang not null,
     cod_dep number(2) constraint fk_cod_dep references departamente_pnu(cod_dep)
                        constraint cod_dep_poz check(cod_dep > 0), -- -> cheie externa  _____ -> cod_dep pozitiv, ?
     comision number(2,2),
     --nume, prenume - unice, ?
     constraint nume_prenume_unice unique(nume, prenume),
     --salariu > 100*comision ?
     constraint verif_sal check(salariu > 100*comision)
     );
     

15. Suprima�i �i recrea�i tabelul, specific�nd toate constr�ngerile la nivel de tabel (�n m�sura �n care este posibil).


CREATE TABLE ANGAJATI_PNU
    (cod_ang number(4),
    nume varchar2(20) constraint nume_pnu not null,
    prenume varchar2(20),
    email char(15),
    data_ang date default sysdate,
    job varchar2(10),
    cod_sef number(4),
    salariu number(8, 2) constraint salariu_pnu not null,
    cod_dep number(2),
    comision number(2,2),
    constraint nume_prenume_unique_pnu unique(nume,prenume),
    constraint verifica_sal_pnu check(salariu > 100*comision),
    constraint pk_angajati_pnu primary key(cod_ang),
    constraint email_unic unique(email),
    constraint sef_pnu foreign key(cod_sef) references angajati_pnu(cod_ang),
    constraint fk_dep_pnu foreign key(cod_dep) references departamente_pnu (cod_dep),
    constraint cod_dep_poz check(cod_dep > 0)
    );


16. Reintroduce�i date �n tabel, utiliz�nd (�i modific�nd, dac� este necesar) comenzile salvate anterior.

INSERT INTO angajati_pnu
VALUES(100, 'nume1', 'prenume1', 'email1', sysdate, 'Director', null, 20000, 10, 0.1);

INSERT INTO angajati_pnu
VALUES(101, 'nume2', 'prenume2', 'email2', to_date('02-02-2004','dd-mm-yyyy'), 'Inginer', 100, 10000, 10, 0.2);

INSERT INTO angajati_pnu
VALUES(102, 'nume3', 'prenume3', 'email3', to_date('05-06-2000','dd-mm-yyyy'), 'Analist', 101, 5000, 20, 0.1);

INSERT INTO angajati_pnu
VALUES(103, 'nume4', 'prenume4', 'email4', sysdate, 'Inginer', 100, 9000, 20, 0.1);

INSERT INTO angajati_pnu
VALUES(104, 'nume5', 'prenume5', 'email5', sysdate, 'Analist', 101, 3000, 30, 0.1);


-- Ce comanda trebuie executata?

R: commit

commit;


19. Introduce�i constr�ngerea NOT NULL asupra coloanei email.

desc angajati_pnu;

ALTER TABLE angajati_pnu
MODIFY(email not null);


20. (Incerca�i s�) ad�uga�i o nou� �nregistrare �n tabelul ANGAJATI_pnu, 
care s� corespund� codului de departament 50. Se poate?

INSERT INTO angajati_pnu
VALUES(105, 'nume6', 'prenume6', 'email6', sysdate, 'Analist', 101, 3000, 50, 0.1);

De ce nu se poate insera?

R: ____

SELECT * FROM angajati_pnu;


21. Ad�uga�i un nou departament, cu numele Analiza, codul 60 �i 
directorul null �n DEPARTAMENTE_pnu. Salvati inregistrarea. 

INSERT INTO departamente_pnu
VALUES (60, 'Analiza', null);

SELECT * FROM departamente_pnu;

COMMIT;


22. (Incerca�i s�) �terge�i departamentul 20 din tabelul DEPARTAMENTE. Comenta�i.

DELETE FROM departamente_pnu
WHERE cod_dep = 20;

-- De ce nu se poate sterge?

R: ____



23. �terge�i departamentul 60 din DEPARTAMENTE. ROLLBACK;

DELETE FROM departamente_pnu
WHERE cod_dep = 60;  

-- De ce putem sterge departamentul 60?
R: _____


SELECT * FROM departamente;

ROLLBACK;


24. Se dore�te �tergerea automat� a angaja�ilor dintr-un departament, odat� cu 
suprimarea departamentului. Pentru aceasta, este necesar� introducerea clauzei 
ON DELETE CASCADE �n definirea constr�ngerii de cheie extern�. 

Suprima�i constr�ngerea de cheie extern� asupra tabelului ANGAJATI_pnu 
�i reintroduce�i aceast� constr�ngere, specific�nd clauza ON DELETE CASCADE.

SELECT * 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'ANGAJATI_PNU'; -- dorim sa aflam numele constrangerii


-- stergem constrangerea 
ALTER TABLE angajati_pnu
DROP CONSTRAINT FK_DEP_PNU;

--adaugam constrangerea utilizand clauza ON DELETE CASCADE
ALTER TABLE angajati_pnu
ADD CONSTRAINT FK_DEP_PNU FOREIGN KEY(cod_dep)
REFERENCES departamente_pnu(cod_dep) ON DELETE CASCADE;


25. �terge�i departamentul 20 din DEPARTAMENTE. Ce se �nt�mpl�? Rollback;

-- Inainte de stergere analizati datele, atat din angajati, cat si din departamente

SELECT * FROM angajati_pnu; 

-- Cati angajati lucreaza in departamentul 20?

R: _____

-- Ce este cod_dep in angajati_pnu?

R: ____

SELECT * FROM departamente_pnu;

-- Ce este cod_dep in departamente_pnu?

R: ____


-- Stergeti departamentul din departamente_pnu si analizati din nou datele din BD

DELETE FROM departamente_pnu
WHERE cod_dep = 20; 

SELECT * FROM departamente_pnu;

SELECT * FROM angajati_pnu; 

-- Ce se intampla daca executam ROLLBACK?

R: ____

ROLLBACK;


26. Introduce�i constr�ngerea de cheie extern� asupra coloanei cod_director 
a tabelului DEPARTAMENTE. 
Se dore�te ca �tergerea unui angajat care este director de departament s� atrag� dup� sine 
setarea automat� a valorii coloanei cod_director la null.

DESC departamente_pnu;
desc angajati_pnu;
alter table departamente_pnu
add constraint fk_cod_director foreign key(cod_director) references angajati_pnu(cod_ang) on delete set null;

27. Actualiza�i tabelul DEPARTAMENTE, astfel �nc�t angajatul av�nd codul 102 
s� devin� directorul departamentului 30. 
�terge�i angajatul av�nd codul 102 din tabelul ANGAJATI_pnu. 
Analiza�i efectele comenzii. Rollback;

UPDATE departamente_PNU
SET cod_director = 102
WHERE cod_dep = 30;

SELECT * FROM departamente_pnu;

SELECT * FROM angajati_pnu;

DELETE FROM angajati_pnu
WHERE cod_ang = 102; 
      -- avand constrangerea on delete set null pe cheia externa cod_director din departamente
      -- observam ca stergerea angajatului 102 din angajati, 
      -- care era sef de departament in tabelul departamente
      -- a dus la setarea valorii cod_director din tabelul departamente la null

-- Cititi notiunile din Laborator 5 - paginile 4 si 5
-- Studiati exercitiile rezolvate in laborator - exercitiile 28 si 29






______