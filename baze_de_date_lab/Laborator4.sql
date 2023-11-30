--Laboratorul 4

create table EMP_AAP as select * from employees;

select * from emp_aap;

rollback; -- nu are efect deoarece create executa commit implicit;

create table dept_aap as select * from departments;

desc emp_aap;
desc employees;
desc dept_aap;

alter table emp_aap
add constraint pk_emp_aap primary key (employee_id);

alter table dept_aap
add constraint pk_dept_aap primary key (department_id);

alter table emp_aap
add constraint fk_emp_dept foreign key (department_id)
references dept_aap (department_id);

alter table emp_aap
add constraint fk_emp_emp foreign key (manager_id)
references emp_aap (employee_id);

alter table dept_aap
add constraint fk_manager foreign key (manager_id)
references emp_aap (employee_id);

-- LABORATOR 4 - SAPTAMANA 7

--Daca nu ati fost prezenti in laboratorul anterior se ruleaza urmatoarele tranzactii

-- ATENTIE LA DENUMIREA FOLOSITA PENTRU CELE DOUA TABELE EMP SI DEPT

-- trebuie sa utilizati sirul (EMP_PNU/DEPT_PNU), unde pnu inseamna:
-- p - prima litera din prenume, iar nu - primele doua litere din nume

-- apoi se ruleaza cele doua comenzi

CREATE TABLE EMP_pnu AS SELECT * FROM employees;
CREATE TABLE DEPT_pnu AS SELECT * FROM departments;


 
-- IN CONTINUARE SE ADAUGA CONSTRANGERILE DE INTEGRITATE

ALTER TABLE emp_pnu
ADD CONSTRAINT pk_emp_pnu PRIMARY KEY(employee_id);

ALTER TABLE dept_pnu
ADD CONSTRAINT pk_dept_pnu PRIMARY KEY(department_id);

ALTER TABLE emp_pnu
ADD CONSTRAINT fk_emp_dept_pnu FOREIGN KEY(department_id) 
REFERENCES dept_pnu(department_id);
   

ALTER TABLE emp_pnu
ADD CONSTRAINT fk_emp_emp_pnu FOREIGN KEY(manager_id) 
REFERENCES emp_pnu(employee_id); -- managerul unui angajat

ALTER TABLE dept_pnu
ADD CONSTRAINT fk_dept_emp_pnu FOREIGN KEY(manager_id) 
REFERENCES emp_pnu(employee_id); -- managerul de departament


-- APOI SE REZOLVA, IN CADRUL LABORATORULUI CURENT, URMATOARELE EXERCITII


5.	S� se insereze departamentul 300, cu numele Programare �n DEPT_pnu.
Analiza�i cazurile, preciz�nd care este solu�ia corect� �i explic�nd erorile 
celorlalte variante. 
Pentru a anula efectul instruc�iunii(ilor) corecte, utiliza�i comanda ROLLBACK.
       
       

SELECT * FROM dept_aap;

--discutie tipuri de INSERT si erori posibile
--vezi laborator
                                                      
--a) inserare implicita
INSERT INTO DEPT_aap 
VALUES (300, 'Programare');

DESC DEPT_aap;
--b)inserare explicita	
INSERT INTO DEPT_aap (department_id, department_name)
VALUES (300, 'Programare');

SELECT * FROM dept_aap;



--c)	
INSERT INTO DEPT_aap (department_name, department_id)
VALUES (300, 'Programare');


--d)	
INSERT INTO DEPT_aap (department_id, department_name, location_id)
VALUES (300, 'Programare', null);	


-- varianta corecta
	
_____	


SELECT * FROM dept_aap;

--e)	
INSERT INTO DEPT_aap (department_name, location_id)
VALUES ('Programare', null);


-- Ce se intampla daca executam rollback?

_____


-- Executati varianta corecta si permanentizati modificarile.

_____

6.	S� se insereze un angajat corespunz�tor departamentului introdus anterior 
�n tabelul EMP_pnu, preciz�nd valoarea NULL pentru coloanele a c�ror valoare 
nu este cunoscut� la inserare (metoda implicit� de inserare). 
Determina�i ca efectele instruc�iunii s� devin� permanente.
Aten�ie la constr�ngerile NOT NULL asupra coloanelor tabelului!


-- inserare prin metoda IMPLICITA de inserare
-- dorim sa inseram un angajat in depart 300

DESC emp_aap;
SELECT * FROM emp_pnu;


INSERT INTO emp_aap
VALUES (250, NULL, 'nume250', 'email250', NULL, SYSDATE, 'IT_PROG', NULL, NULL, NULL, 300);

-- Cum parmanentizam efectul actiunii anterioare?

commit;

SELECT * FROM emp_aap;


-- De ce varianta urmatoare nu functioneaza?

INSERT INTO emp_aap
VALUES (250, NULL, 'nume251', 'email251', NULL, SYSDATE, 'IT_PROG', NULL, NULL, NULL, 300);


-- Anulati inserarea anterioara

rollback;

SELECT * FROM emp_aap;


-- De ce varianta urmatoare nu functioneaza?
desc emp_aap;
INSERT INTO emp_aap
VALUES (251, NULL, 'nume251', 'email251', NULL, to_date('03-10-2023','dd-mm-yyyy'), 
       'IT_PROG', NULL, NULL, NULL, 300);
       
SELECT * FROM emp_aap;

ROLLBACK;

-- De ce varianta urmatoare nu functioneaza?

INSERT INTO emp_pnu
VALUES (252, NULL, 'nume252', 'email252', NULL, SYSDATE, 
       'IT_PROG', NULL, NULL, NULL, 310);


-- IN CELE DIN URMA PASTRAM IN BAZA DE DATE ANGAJATUL CU ID-UL 250 IN DEPART. 300
rollback;

7.	S� se mai introduc� un angajat corespunz�tor departamentului 300, 
preciz�nd dup� numele tabelului lista coloanelor �n care se introduc valori 
(metoda explicita de inserare). 
Se presupune c� data angaj�rii acestuia este cea curent� (SYSDATE). 
Salva�i �nregistrarea.

desc emp_pnu;

--inserare prin metoda EXPLICITA de inserare
INSERT INTO emp_aap (hire_date, job_id, employee_id, last_name, email, department_id)
VALUES (sysdate, 'sa_man', 278, 'nume_278', 'email_278', 300);

COMMIT;

SELECT * FROM emp_aap;


8.	Crea�i un nou tabel, numit EMP1_PNU, care va avea aceea�i structur� ca �i EMPLOYEES, 
dar fara inregistrari. Copia�i �n tabelul EMP1_PNU salaria�ii (din tabelul EMPLOYEES) 
al c�ror comision dep�e�te 25% din salariu (se accepta omiterea constrangerilor).


-- crearea tabelului
CREATE TABLE emp1_pnu AS SELECT * FROM employees;

-- eliminarea inregistrarilor
DELETE FROM emp1_pnu;

-- adaugarea noilor valori (inserarea randurilor)
INSERT INTO emp1_pnu
    SELECT *
    FROM employees
    WHERE commission_pct > 0.25;

SELECT * FROM emp1_pnu;
drop table dept_pnu;

-- Ce se intampla daca executam un rollback? 

______




-- SA SE ANALIZEZE EXERCITIILE 9, 10 SI 11 

9.	S� se creeze un fi�ier (script file) care s� permit� introducerea de �nregistr�ri 
�n tabelul EMP_PNU �n mod interactiv. 
Se vor cere utilizatorului: codul, numele, prenumele si salariul angajatului. 
C�mpul email se va completa automat prin concatenarea primei litere din prenume 
�i a primelor 7 litere din nume.    
Executati script-ul pentru a introduce 2 inregistrari in tabel.


INSERT INTO emp_pnu (employee_id, first_name, last_name, email, hire_date, job_id, salary)
VALUES(&cod, '&&prenume', '&&nume', substr('&prenume',1,1) || substr('&nume',1,7), 
       sysdate, 'it_prog', &sal);
       
UNDEFINE prenume;
UNDEFINE nume;

SELECT * FROM emp_pnu;


10.	Crea�i 2 tabele emp2_pnu �i emp3_pnu cu aceea�i structur� ca tabelul EMPLOYEES, 
dar f�r� �nregistr�ri (accept�m omiterea constr�ngerilor de integritate). 
Prin intermediul unei singure comenzi, copia�i din tabelul EMPLOYEES:

-  �n tabelul EMP1_PNU salaria�ii care au salariul mai mic dec�t 5000;
-  �n tabelul EMP2_PNU salaria�ii care au salariul cuprins �ntre 5000 �i 10000;
-  �n tabelul EMP3_PNU salaria�ii care au salariul mai mare dec�t 10000.

Verifica�i rezultatele, apoi �terge�i toate �nregistr�rile din aceste tabele.

--VEZI INSERARI MULTI-TABEL IN LABORATORUL 4

CREATE TABLE emp1_pnu AS SELECT * FROM employees;

DELETE FROM emp1_pnu;

SELECT * FROM emp1_pnu; 

CREATE TABLE emp2_pnu AS SELECT * FROM employees;

DELETE FROM emp2_pnu;

CREATE TABLE emp3_pnu AS SELECT * FROM employees;

DELETE FROM emp3_pnu;

INSERT ALL
   WHEN salary < 5000 THEN
      INTO emp1_pnu					
   WHEN salary > = 5000 AND salary <= 10000 THEN
      INTO emp2_pnu
   ELSE 
      INTO emp3_pnu
SELECT * FROM employees;  


SELECT * FROM emp1_pnu;
SELECT * FROM emp2_pnu;
SELECT * FROM emp3_pnu;



11.	S� se creeze tabelul EMP0_PNU cu aceea�i structur� ca tabelul EMPLOYEES 
(f�r� constr�ngeri), dar f�r� inregistrari. 
Copia�i din tabelul EMPLOYEES:

-  �n tabelul EMP0_PNU salaria�ii care lucreaz� �n departamentul 80;
-  �n tabelul EMP1_PNU salaria�ii care au salariul mai mic dec�t 5000;
-  �n tabelul EMP2_PNU salaria�ii care au salariul cuprins �ntre 5000 �i 10000;
-  �n tabelul EMP3_PNU salaria�ii care au salariul mai mare dec�t 10000.

Dac� un salariat se �ncadreaz� �n tabelul emp0_pnu atunci acesta nu va mai fi inserat 
�i �n alt tabel (tabelul corespunz�tor salariului s�u);

CREATE TABLE emp0_pnu AS SELECT * FROM employees;

DELETE FROM emp0_pnu;


INSERT FIRST
    WHEN department_id = 80 THEN
        INTO emp0_pnu
    WHEN salary < 5000 THEN
        INTO emp1_pnu
    WHEN salary > = 5000 AND salary <= 10000 THEN
        INTO emp2_pnu
    ELSE 
        INTO emp3_pnu
SELECT * FROM employees;

SELECT * FROM emp0_pnu;
SELECT * FROM emp1_pnu;
SELECT * FROM emp2_pnu;
SELECT * FROM emp3_pnu;


-- COMANDA UPDATE - VEZI LABORATOR (pentru notiunile teoretice)

12.	M�ri�i salariul tuturor angaja�ilor din tabelul EMP_PNU cu 5%. 
Vizualizati, iar apoi anula�i modific�rile.

UPDATE emp_aap
SET salary = salary * 1.05;

SELECT * FROM emp_aap;

ROLLBACK;



13.	Schimba�i jobul tuturor salaria�ilor din departamentul 80 care au comision, �n 'SA_REP'. 
Anula�i modific�rile.

UPDATE emp_aap
SET job_id = 'SA_REP'
WHERE department_id = 80 and commission_pct IS NOT NULL;

SELECT * FROM emp_pnu;

ROLLBACK;


14.	S� se promoveze Douglas Grant la manager �n departamentul 20 (tabelul dept_pnu), 
av�nd o cre�tere de salariu cu 1000$. 


-- verificari

SELECT *
FROM emp_aap
WHERE lower(last_name||first_name) = 'grantdouglas';

SELECT * FROM dept_aap
WHERE department_id = 20;

-- solutia problemei
update dept_aap
set manager_id = (SELECT employee_id
                    FROM emp_aap
                    WHERE lower(last_name||first_name) = 'grantdouglas')
where department_id = 20;
___

update emp_aap
set salary = salary + 1000
WHERE lower(last_name||first_name) = 'grantdouglas';



-- COMANDA DELETE - VEZI LABORATOR (pentru notiunile teoretice)

15.	�terge�i toate �nregistr�rile din tabelul DEPT_PNU. 
Ce �nregistr�ri se pot �terge? Anula�i modific�rile. 

DELETE FROM dept_aap; 

SELECT * FROM dept_aap;

SELECT * FROM emp_aap;


16.	Suprima�i departamentele care nu au angajati. Anula�i modific�rile.

-- prima data afisam departamentele care nu au angajati


-- apoi stergem departamentele care nu au angajati



17. S� se mai introduc� o linie in tabelul DEPT_PNU.

desc dept_pnu;

INSERT INTO dept_pnu
VALUES(320, 'dept_nou', NULL, NULL);

SELECT * FROM dept_pnu;


18. S� se marcheze un punct intermediar in procesarea tranzac�iei (SAVEPOINT p).

SAVEPOINT p;


19. S� se �tearg� din tabelul DEPT_PNU departamentele care au codul de departament 
cuprins intre 160 si 200. Lista�i con�inutul tabelului.

DELETE FROM dept_pnu
WHERE department_id BETWEEN 160 AND 200; 

SELECT * FROM dept_pnu;


20. S� se renun�e la cea mai recent� opera�ie de �tergere, f�r� a renun�a 
la opera�ia precedent� de introducere. 
Determina�i ca modific�rile s� devin� permanente;

SELECT * FROM dept_pnu;

ROLLBACK TO p;

COMMIT;




