-- SAPTAMANA 9 - LABORATOR 6 - Subcereri Necorelate


1.	Folosind subcereri, s� se afi�eze numele �i data angaj�rii pentru salaria�ii 
care au fost angaja�i dup� Gates.

SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date
                   FROM employees
                   WHERE INITCAP(last_name)= 'Gates'
                   );


2.	Folosind subcereri, scrie�i o cerere pentru a afi�a numele �i salariul 
pentru to�i colegii (din acela�i departament) lui Gates. Se va exclude Gates. 

Se poate �nlocui operatorul IN cu = ???
R: ___

select last_name, salary
from employees
where department_id = (select department_id from employees where initcap(last_name) = 'Gates') 
and initcap(last_name) != 'Gates';

--Se va inlocui Gates cu King:

--sunt mai multi angajati King
--se va folosi in in loc de =

3.	Folosind subcereri, s� se afi�eze numele �i salariul angaja�ilor condu�i direct 
de pre�edintele companiei (acesta este considerat angajatul care nu are manager).

-- REZOLVATI INDIVIDUAL

select last_name, salary
from employees
where manager_id = (select employee_id from employees where manager_id is null); 


-- CEREREA TREBUIE SA RETURNEZE 14 ANGAJATI
-- VEZI IMAGINEA ATASATA IN LABORATOR


4.	Scrie?i o cerere pentru a afi�a numele, codul departamentului ?i salariul angaja?ilor 
al c�ror cod de departament ?i salariu coincid cu codul departamentului ?i salariul 
unui angajat care c�?tig� comision. 

SELECT last_name, department_id, salary
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, salary
                                  FROM employees
                                  WHERE commission_pct is not null
                                  );
                                                                       
5.	S� se afi?eze codul, numele ?i salariul tuturor angaja?ilor al c�ror salariu 
este mai mare dec�t salariul mediu.

SELECT employee_id, last_name, salary 
FROM employees 
WHERE salary > (SELECT AVG(salary) 
                FROM employees);


6.	Scrieti o cerere pentru a afi?a angaja?ii care c�?tig� 
(castiga = salariul plus comision din salariu) 
mai mult dec�t oricare func?ionar (job-ul con�ine �irul "CLERK"). 
Sorta?i rezultatele dupa salariu, �n ordine descresc�toare;

select last_name, nvl((salary + salary*commission_pct), salary) as "Castig"
from employees
where nvl((salary + salary*commission_pct), salary) > ALL (select nvl(salary + salary*commission_pct, salary) from employees where upper(job_id) like ('%CLERK%') )
order by nvl((salary + salary*commission_pct), salary) desc;


select *from employees;
7.	Scrie�i o cerere pentru a afi�a numele angajatilor, numele departamentului 
�i salariul angaja�ilor care c�tig� comision, dar al c�ror �ef direct nu c�tig� comision.	

-- REZOLVATI IN ECHIPA DE 2 PERSOANE

select last_name, department_id, salary
from employees
where commission_pct is not null and manager_id in (select employee_id from employees where commission_pct is null);

select e.last_name, d.department_name, e.salary
from employees e join departments d on (e.department_id = d.department_id)
where e.commission_pct is not null and e.manager_id in (select employee_id from employees where commission_pct is null);

-- CEREREA TREBUIE SA RETURNEZE 5 ANGAJATI
-- VEZI IMAGINEA ATASATA IN LABORATOR



8.	S� se afi�eze numele angaja�ilor, codul departamentului �i codul job-ului salaria�ilor 
al c�ror departament se afl� �n Toronto.

-- REZOLVATI IN ECHIPA DE 2 PERSOANE





-- CEREREA TREBUIE SA RETURNEZE 2 ANGAJATI
-- VEZI IMAGINEA ATASATA IN LABORATOR
select e.last_name, e.department_id, e.job_id
from employees e
where e.department_id in 
(select d.department_id from departments d join locations l on (d.location_id = l.location_id)
    where upper(l.city) = 'TORONTO');



9.	S� se ob?in� codurile departamentelor �n care nu lucreaza nimeni 
(nu este introdus nici un salariat �n tabelul employees). Sa se utilizeze subcereri;

select department_id
from departments
where department_id not in ( select department_id from employees where department_id is not null);



10.	Este posibil� introducerea de �nregistr�ri prin intermediul subcererilor (specificate �n locul tabelului). 
Ce reprezint�, de fapt, aceste subcereri? S� se analizeze urm�toarele comenzi INSERT:

INSERT INTO emp (employee_id, last_name, email, hire_date, job_id, salary, commission_pct) 
VALUES (252, 'Nume252', 'nume252@emp.com', SYSDATE, 'SA_REP', 5000, NULL);

SELECT employee_id, last_name, email, hire_date, job_id, salary, commission_pct 
FROM emp
WHERE employee_id = 252;

ROLLBACK;

INSERT INTO 
   (SELECT employee_id, last_name, email, hire_date, job_id, salary, commission_pct 
    FROM emp) 
VALUES (252, 'Nume252', 'nume252@emp.com', SYSDATE, 'SA_REP', 5000, NULL);


SELECT employee_id, last_name, email, hire_date, job_id, salary, commission_pct 
FROM emp
WHERE employee_id = 252;

ROLLBACK;


11. Sa se creeze tabelul SUBALTERNI care sa contina codul, numele si prenumele angajatilor 
care il au manager pe Steven King, alaturi de codul si numele lui King.
Coloanele se vor numi cod, nume, prenume, cod_manager, nume_manager.

DESC employees;

CREATE TABLE SUBALTERNI
    (
        cod number(6) constraint pk_subalterni primary key,
        nume varchar2(25) constraint nume_sub not null,
        prenume varchar2(25),
        cod_manager number(6),
        nume_manager varchar2(25) constraint nume_man not null
    );
     

INSERT INTO SUBALTERNI (cod, nume, prenume, cod_manager, nume_manager)
        (SELECT angajat.employee_id, angajat.last_name, angajat.first_name, angajat.manager_id, man.last_name
            from employees angajat join employees man on (angajat.manager_id = man.employee_id)
            where angajat.manager_id = (select employee_id 
                                        from employees 
                                        where lower(first_name || last_name) = 'stevenking')
        );
commit;
