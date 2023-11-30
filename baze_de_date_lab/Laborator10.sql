1. Sã se creeze o vizualizare VIZ_EMP30_PNU, care conþine codul, numele, email-ul 
si salariul angajaþilor din departamentul 30. Sã se analizeze structura ºi 
conþinutul vizualizãrii. 
Ce se observã referitor la constrângeri? 
Ce se obþine de fapt la interogarea conþinutului vizualizãrii? 
Inseraþi o linie prin intermediul acestei vizualizãri. Comentaþi.

CREATE TABLE EMP AS SELECT * FROM employees;
CREATE TABLE DEPT AS SELECT * FROM departments;

ALTER TABLE emp
ADD CONSTRAINT pk_emp PRIMARY KEY(employee_id);

ALTER TABLE dept
ADD CONSTRAINT pk_dept PRIMARY KEY(department_id);

ALTER TABLE emp
ADD CONSTRAINT fk_emp_dept_l10 
FOREIGN KEY(department_id) REFERENCES dept(department_id);

ALTER TABLE dept 
ADD CONSTRAINT fk_dept_emp
FOREIGN KEY(manager_id) references emp(employee_id); -- managerul de departament 

ALTER TABLE emp
ADD CONSTRAINT fk_emp_emp_l10 
FOREIGN KEY(manager_id) references emp(employee_id); -- managerul unui angajat

SELECT * FROM emp;


CREATE OR REPLACE VIEW VIZ_EMP30_PNU AS
                        (SELECT employee_id, last_name, email, salary
                         FROM emp
                         WHERE department_id = 30
                         );
                         
DESC VIZ_EMP30_PNU;
SELECT * FROM VIZ_EMP30_PNU;


INSERT INTO VIZ_EMP30_PNU
VALUES(700,'nume700','email700',10000);

DROP VIEW VIZ_EMP30_PNU;


2.	Modificaþi VIZ_EMP30_PNU astfel încât sã fie posibilã inserarea/modificarea 
conþinutului tabelului de bazã prin intermediul ei. 
Inseraþi ºi actualizaþi o linie (cu valoarea 601 pentru codul angajatului) 
prin intermediul acestei vizualizãri.

CREATE OR REPLACE VIEW VIZ_EMP30_PNU AS
                    (SELECT employee_id, last_name, email, salary, 
                            hire_date, job_id, department_id
                     FROM emp
                     WHERE department_id = 30
                     );

DESC VIZ_EMP30_PNU;

SELECT * FROM VIZ_EMP30_PNU;

SELECT * FROM EMP;

INSERT INTO VIZ_EMP30_PNU
VALUES(601, 'last_name601', 'email601', 10000, SYSDATE, 'IT_PROG', 30);

SELECT * FROM VIZ_EMP30_PNU;

SELECT * FROM EMP;

--Ce efect are urmãtoarea operaþie de actualizare?

UPDATE viz_emp30_pnu
SET hire_date = hire_date - 15
WHERE employee_id = 601; 

-- ªtergeþi angajatul având codul 601 prin intermediul vizualizãrii. 
-- Analizaþi efectul asupra tabelului de bazã.

DELETE FROM viz_emp30_pnu
WHERE employee_id = 601;

SELECT * FROM VIZ_EMP30_PNU;

SELECT * FROM EMP;

COMMIT;

-- Informatii despre vizualizari se pot gasi in dictionarul datelor 
SELECT *
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'EMP';


3. Sã se creeze o vizualizare, VIZ_EMPSAL50_PNU, care contine coloanele 
cod_angajat, nume, email, functie, data_angajare si sal_anual corespunzãtoare 
angajaþilor din departamentul 50. 
Analizaþi structura ºi conþinutul vizualizãrii.

CREATE OR REPLACE VIEW VIZ_EMPSAL50_PNU AS
                SELECT employee_id, last_name, email, job_id, hire_date, 
                       salary*12 sal_anual
                FROM emp
                WHERE department_id = 50;
                        
DESC VIZ_EMPSAL50_PNU;

SELECT * FROM VIZ_EMPSAL50_PNU;


4.	a) Inseraþi o linie prin intermediul vizualizãrii precedente. Comentaþi.

desc emp; 

INSERT INTO VIZ_EMPSAL50_PNU(employee_id, last_name, email, job_id, hire_date)
VALUES(567, 'last_name_567', 'email_567', 'IT_PROG', sysdate);

SELECT * FROM EMP;

b) Care sunt coloanele actualizabile ale acestei vizualizãri? 
Verificaþi rãspunsul în dicþionarul datelor (USER_UPDATABLE_COLUMNS).
Analizaþi conþinutul vizualizãrii viz_empsal50_pnu ºi al tabelului emp_pnu.

SELECT * 
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'VIZ_EMPSAL50_PNU';

SELECT * 
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'EMP';


5.	a) Sã se creeze vizualizarea VIZ_EMP_DEP30_PNU, astfel încât aceasta 
sã includã coloanele vizualizãrii VIZ_EMP30_PNU, precum ºi numele ºi 
codul departamentului. Sã se introducã aliasuri pentru coloanele vizualizãrii.
! Asiguraþi-vã cã existã constrângerea de cheie externã între tabelele de bazã 
ale acestei vizualizãri.

CREATE OR REPLACE VIEW VIZ_EMP_DEP30_PNU AS
    SELECT v.*, department_name  
    FROM VIZ_EMP30_PNU v JOIN departments d ON(d.department_id = v.department_id);

SELECT * FROM VIZ_EMP_DEP30_PNU;


b) Inseraþi o linie prin intermediul acestei vizualizãri.
INSERT INTO VIZ_EMP_DEP30_PNU 
       (employee_id, last_name, email, salary, job_id, hire_date, department_id)
VALUES (358, 'lname', 'email', 15000, 'IT_PROG', sysdate, 30);

SELECT * FROM VIZ_EMP_DEP30_PNU;
SELECT * FROM VIZ_EMP30_PNU;
SELECT * FROM EMP;
SELECT * FROM departments;

c) Care sunt coloanele actualizabile ale acestei vizualizãri? 
Ce fel de tabel este cel ale cãrui coloane sunt actualizabile? 

SELECT * 
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'VIZ_EMP_DEP30_PNU';

d) Ce efect are o operaþie de ºtergere prin intermediul vizualizãrii 
viz_emp_dep30_pnu? Comentaþi.

DELETE FROM VIZ_EMP_DEP30_PNU WHERE employee_id = 358;

SELECT * FROM VIZ_EMP_DEP30_PNU;
SELECT * FROM VIZ_EMP30_PNU;
SELECT * FROM EMP;

COMMIT;


6.	Sã se creeze vizualizarea VIZ_DEPT_SUM_PNU, care conþine codul departamentului 
ºi pentru fiecare departament salariul minim, maxim si media salariilor. 
Ce fel de vizualizare se obþine (complexa sau simpla)? 
Se poate actualiza vreo coloanã prin intermediul acestei vizualizãri?

CREATE OR REPLACE VIEW VIZ_DEPT_SUM_PNU AS
        ( SELECT department_id, MIN(salary) min_sal, 
                 MAX(salary) max_sal, round(AVG(salary))  med_sal
          FROM employees RIGHT JOIN departments USING (department_id)
          GROUP BY department_id
        );

SELECT * FROM VIZ_DEPT_SUM_PNU;

SELECT * 
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'VIZ_DEPT_SUM_PNU';

7.	Modificaþi vizualizarea VIZ_EMP30_PNU astfel încât sã nu permitã modificarea 
sau inserarea de linii ce nu sunt accesibile ei. 
Vizualizarea va selecta ºi coloana department_id. 
Încercaþi sã modificaþi ºi sã inseraþi linii ce nu îndeplinesc condiþia department_id = 30.

CREATE OR REPLACE VIEW VIZ_EMP30_PNU  AS
          (SELECT employee_id, last_name, email, salary, 
                  hire_date, job_id, department_id
           FROM emp
           WHERE department_id = 30
           )
WITH READ ONLY CONSTRAINT verific;

INSERT INTO VIZ_EMP30_PNU
VALUES(600, 'last_name', 'eemail', 10000, SYSDATE, 'IT_PROG', 50);


SELECT * FROM VIZ_EMP30_PNU;



9.	Sã se selecteze numele, salariul, codul departamentului ºi salariul maxim 
din departamentul din care face parte, pentru fiecare angajat. 
Este necesarã o vizualizare inline? Argumentati.

SELECT last_name, salary, department_id, 
                         (SELECT MAX(salary)
                          FROM employees
                          WHERE department_id = e.department_id
                          ) max_salary                
FROM employees e;


12.	Creaþi o secvenþã pentru generarea codurilor de departamente, SEQ_DEPT_PNU. 
Secvenþa va începe de la 400, va creºte cu 10 de fiecare datã ºi va avea valoarea 
maximã 10000. Secventa nu va încãrca niciun numãr înainte de cerere.

13.	ªtergeþi secvenþa SEQ_DEPT_PNU.

CREATE SEQUENCE SEQ_test
INCREMENT BY 10 
START WITH 400
MAXVALUE 10000
NOCYCLE
NOCACHE;

SELECT * FROM dept;

INSERT INTO dept
VALUES (SEQ_test.nextval, 'DeptNou', null, null);

delete from dept where department_id = 410;


DROP SEQUENCE SEQ_test;


-- EXERCITII - LABORATOR 8

12.	Sã se afiºeze informaþii despre departamente, în formatul urmãtor: 
"Departamentul <department_name> este condus de {<manager_id> | nimeni} 
ºi {are numãrul de salariaþi  <n> | nu are salariati}".




15.	Sã se afiºeze:
a) codul jobului si suma salariilor, pentru job-urile care incep cu litera S;
b) codul jobului si media generala a salariilor, pentru job-ul avand salariul maxim;
c) codul jobului si salariul minim, pentru fiecare din celelalte job-uri;



16. Care sunt departamentele (cod si nume) care contin cel putin 
doua job-uri distincte?


17. Sa se afiseze salariatii care au fost angajati în aceeaºi zi a lunii 
în care cei mai multi dintre salariati au fost angajati. 
(ziua lunii insemnand numarul zilei, indiferent de luna si an)


select max(count(employee_id))
from employees
group by (to_char(hire_date, 'dd'));

select * from employees
where to_char(hire_date, 'dd') in (select to_char(hire_date,'dd') from employees
                                        group by to_char(hire_date,'dd') 
                                        having count(employee_id) = (select max(count(employee_id)) from employees
                                                                        group by to_char(hire_date, 'dd')
                                                                    )
                                )

