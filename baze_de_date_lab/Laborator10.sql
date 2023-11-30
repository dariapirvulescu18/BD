1. S� se creeze o vizualizare VIZ_EMP30_PNU, care con�ine codul, numele, email-ul 
si salariul angaja�ilor din departamentul 30. S� se analizeze structura �i 
con�inutul vizualiz�rii. 
Ce se observ� referitor la constr�ngeri? 
Ce se ob�ine de fapt la interogarea con�inutului vizualiz�rii? 
Insera�i o linie prin intermediul acestei vizualiz�ri. Comenta�i.

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


2.	Modifica�i VIZ_EMP30_PNU astfel �nc�t s� fie posibil� inserarea/modificarea 
con�inutului tabelului de baz� prin intermediul ei. 
Insera�i �i actualiza�i o linie (cu valoarea 601 pentru codul angajatului) 
prin intermediul acestei vizualiz�ri.

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

--Ce efect are urm�toarea opera�ie de actualizare?

UPDATE viz_emp30_pnu
SET hire_date = hire_date - 15
WHERE employee_id = 601; 

-- �terge�i angajatul av�nd codul 601 prin intermediul vizualiz�rii. 
-- Analiza�i efectul asupra tabelului de baz�.

DELETE FROM viz_emp30_pnu
WHERE employee_id = 601;

SELECT * FROM VIZ_EMP30_PNU;

SELECT * FROM EMP;

COMMIT;

-- Informatii despre vizualizari se pot gasi in dictionarul datelor 
SELECT *
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'EMP';


3. S� se creeze o vizualizare, VIZ_EMPSAL50_PNU, care contine coloanele 
cod_angajat, nume, email, functie, data_angajare si sal_anual corespunz�toare 
angaja�ilor din departamentul 50. 
Analiza�i structura �i con�inutul vizualiz�rii.

CREATE OR REPLACE VIEW VIZ_EMPSAL50_PNU AS
                SELECT employee_id, last_name, email, job_id, hire_date, 
                       salary*12 sal_anual
                FROM emp
                WHERE department_id = 50;
                        
DESC VIZ_EMPSAL50_PNU;

SELECT * FROM VIZ_EMPSAL50_PNU;


4.	a) Insera�i o linie prin intermediul vizualiz�rii precedente. Comenta�i.

desc emp; 

INSERT INTO VIZ_EMPSAL50_PNU(employee_id, last_name, email, job_id, hire_date)
VALUES(567, 'last_name_567', 'email_567', 'IT_PROG', sysdate);

SELECT * FROM EMP;

b) Care sunt coloanele actualizabile ale acestei vizualiz�ri? 
Verifica�i r�spunsul �n dic�ionarul datelor (USER_UPDATABLE_COLUMNS).
Analiza�i con�inutul vizualiz�rii viz_empsal50_pnu �i al tabelului emp_pnu.

SELECT * 
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'VIZ_EMPSAL50_PNU';

SELECT * 
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'EMP';


5.	a) S� se creeze vizualizarea VIZ_EMP_DEP30_PNU, astfel �nc�t aceasta 
s� includ� coloanele vizualiz�rii VIZ_EMP30_PNU, precum �i numele �i 
codul departamentului. S� se introduc� aliasuri pentru coloanele vizualiz�rii.
! Asigura�i-v� c� exist� constr�ngerea de cheie extern� �ntre tabelele de baz� 
ale acestei vizualiz�ri.

CREATE OR REPLACE VIEW VIZ_EMP_DEP30_PNU AS
    SELECT v.*, department_name  
    FROM VIZ_EMP30_PNU v JOIN departments d ON(d.department_id = v.department_id);

SELECT * FROM VIZ_EMP_DEP30_PNU;


b) Insera�i o linie prin intermediul acestei vizualiz�ri.
INSERT INTO VIZ_EMP_DEP30_PNU 
       (employee_id, last_name, email, salary, job_id, hire_date, department_id)
VALUES (358, 'lname', 'email', 15000, 'IT_PROG', sysdate, 30);

SELECT * FROM VIZ_EMP_DEP30_PNU;
SELECT * FROM VIZ_EMP30_PNU;
SELECT * FROM EMP;
SELECT * FROM departments;

c) Care sunt coloanele actualizabile ale acestei vizualiz�ri? 
Ce fel de tabel este cel ale c�rui coloane sunt actualizabile? 

SELECT * 
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'VIZ_EMP_DEP30_PNU';

d) Ce efect are o opera�ie de �tergere prin intermediul vizualiz�rii 
viz_emp_dep30_pnu? Comenta�i.

DELETE FROM VIZ_EMP_DEP30_PNU WHERE employee_id = 358;

SELECT * FROM VIZ_EMP_DEP30_PNU;
SELECT * FROM VIZ_EMP30_PNU;
SELECT * FROM EMP;

COMMIT;


6.	S� se creeze vizualizarea VIZ_DEPT_SUM_PNU, care con�ine codul departamentului 
�i pentru fiecare departament salariul minim, maxim si media salariilor. 
Ce fel de vizualizare se ob�ine (complexa sau simpla)? 
Se poate actualiza vreo coloan� prin intermediul acestei vizualiz�ri?

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

7.	Modifica�i vizualizarea VIZ_EMP30_PNU astfel �nc�t s� nu permit� modificarea 
sau inserarea de linii ce nu sunt accesibile ei. 
Vizualizarea va selecta �i coloana department_id. 
�ncerca�i s� modifica�i �i s� insera�i linii ce nu �ndeplinesc condi�ia department_id = 30.

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



9.	S� se selecteze numele, salariul, codul departamentului �i salariul maxim 
din departamentul din care face parte, pentru fiecare angajat. 
Este necesar� o vizualizare inline? Argumentati.

SELECT last_name, salary, department_id, 
                         (SELECT MAX(salary)
                          FROM employees
                          WHERE department_id = e.department_id
                          ) max_salary                
FROM employees e;


12.	Crea�i o secven�� pentru generarea codurilor de departamente, SEQ_DEPT_PNU. 
Secven�a va �ncepe de la 400, va cre�te cu 10 de fiecare dat� �i va avea valoarea 
maxim� 10000. Secventa nu va �nc�rca niciun num�r �nainte de cerere.

13.	�terge�i secven�a SEQ_DEPT_PNU.

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

12.	S� se afi�eze informa�ii despre departamente, �n formatul urm�tor: 
"Departamentul <department_name> este condus de {<manager_id> | nimeni} 
�i {are num�rul de salaria�i  <n> | nu are salariati}".




15.	S� se afi�eze:
a) codul jobului si suma salariilor, pentru job-urile care incep cu litera S;
b) codul jobului si media generala a salariilor, pentru job-ul avand salariul maxim;
c) codul jobului si salariul minim, pentru fiecare din celelalte job-uri;



16. Care sunt departamentele (cod si nume) care contin cel putin 
doua job-uri distincte?


17. Sa se afiseze salariatii care au fost angajati �n aceea�i zi a lunii 
�n care cei mai multi dintre salariati au fost angajati. 
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

