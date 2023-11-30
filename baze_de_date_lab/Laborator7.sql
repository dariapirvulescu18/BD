-- LABORATOR 7 

--exemplu grupare

create table grupare (id number(5) primary key,
                      nume varchar2(10) not null,
                      salariu number(10) not null,
                      manager_id number(5) not null
                      );
                      
select * from grupare;

insert into grupare values (1, 'user1', 1000, 1);

insert into grupare values (2, 'user2', 1400, 1);

insert into grupare values (3, 'user3', 700, 2);

insert into grupare values (4, 'user4', 300, 2);

insert into grupare values (5, 'user5', 1600, 2);

insert into grupare values (6, 'user6', 1200, 2);

commit;

--exemplu folosind clauza where
select *
from grupare
where salariu < 1100;

--exemplu folosind where si grupare
select manager_id, salariu
from grupare
where salariu < 1100
group by manager_id, salariu;

--exemplu folosind where, iar gruparea realizata doar dupa coloana manager_id
select manager_id
from grupare
where salariu < 1100
group by manager_id
having count(manager_id) < 2;

--exemplu folosind having
select max(salariu)
from grupare
having max(salariu) < 10000;

--group by si having
select manager_id, min(salariu)
from grupare
group by manager_id
having min(salariu) <= 1000;

------------------------------------------------

--1. 
--a) Functiile grup includ valorile NULL in calcule?
--functiile grup nu includ si valorile null
--singura functie care include null este count(*)
--count(expresie) nu include null
--b) Care este deosebirea dintre clauzele WHERE ºi HAVING? 




2.	Sã se afiºeze cel mai mare salariu, cel mai mic salariu, suma ºi media salariilor tuturor angajaþilor. 
Etichetaþi coloanele Maxim, Minim, Suma, respectiv Media. 
Sa se rotunjeasca media salariilor. 

SELECT MAX(salary) Maxim, MIN(salary) Minim, sum(Salary) Suma, avg(salary) Media
FROM employees;


3.	Sã se modifice problema 2 pentru a se afiºa minimul, maximul, suma ºi media salariilor pentru FIECARE job. 

SELECT job_title, MAX(salary) Maxim, MIN(salary) Minim, sum(Salary) Suma, avg(salary) Media
FROM employees e join jobs j on (e.job_id = j.job_id)
GROUP BY job_title; 


4.	Sã se afiºeze numãrul de angajaþi pentru FIECARE  departament.

SELECT COUNT(employee_id) as "Numar angajati din", d.department_id
FROM   departments d join employees e on (d.department_id = e.department_id)
GROUP BY d.department_id;


5.	Sã se determine numãrul de angajaþi care sunt ºefi. 
Etichetati coloana “Nr. manageri”.

select count(distinct(manager_id)) as "Numar manageri"
from employees;


6.	Sã se afiºeze diferenþa dintre cel mai mare si cel mai mic salariu. 
Etichetati coloana “Diferenta”.

select *from employees;

SELECT max(salary)-min(salary) Diferenta
FROM employees;


7.	Scrieþi o cerere pentru a se afiºa numele departamentului, locaþia, numãrul de angajaþi 
ºi salariul mediu pentru angajaþii din acel departament. 
Coloanele vor fi etichetate corespunzãtor.
Se vor afisa si angajatii care nu au departament

!!!Obs: În clauza GROUP BY se trec obligatoriu toate coloanele prezente în clauza SELECT, 
care nu sunt argument al funcþiilor grup.

SELECT department_name, location_id, count(employee_id), round(avg(salary))
FROM departments d right join employees e on (d.department_id = e.department_id)
GROUP BY department_name, location_id;


8.	Sã se afiºeze codul ºi numele angajaþilor care au salariul mai mare decât salariul mediu din firmã.
Se va sorta rezultatul în ordine descrescãtoare a salariilor.

SELECT employee_id, first_name, last_name
FROM employees 
WHERE salary > (SELECT AVG(salary)
                FROM employees
                )
ORDER BY salary DESC;  


9.	Pentru fiecare ºef, sã se afiºeze codul sãu ºi salariul celui mai prost platit subordonat. 
Se vor exclude cei pentru care codul managerului nu este cunoscut. 
De asemenea, se vor exclude grupurile în care salariul minim este mai mic de 1000$. 
Sortaþi rezultatul în ordine descrescãtoare a salariilor.

select manager_id, min(salary)
from employees
where manager_id is not null
group by manager_id
having min(salary) >= 1000
order by min(salary) desc;




10.	Pentru departamentele in care salariul maxim depãºeºte 3000$, sã se obþinã codul, 
numele acestor departamente ºi salariul maxim pe departament.

SELECT department_id, department_name, MAX(salary)
FROM departments JOIN employees USING(department_id)
GROUP BY department_id,department_name
HAVING MAX(salary) >= 3000;


11.	Care este salariul mediu minim al job-urilor existente? 
Salariul mediu al unui job va fi considerat drept media aritmeticã a salariilor celor care îl practicã.

SELECT min(round(avg(salary))) as "Salariul mediu minim"
FROM employees
GROUP BY job_id;



12.	Sã se afiºeze maximul salariilor medii pe departamente.

SELECT MAX(AVG(salary))
FROM employees
GROUP BY department_id;



13.	Sa se obtina codul, titlul ºi salariul mediu al job-ului pentru care salariul mediu este minim. 

-- Rezolvati

select j.job_id, j.job_title, avg(e.salary)
from employees e join jobs j on (j.job_id = e.job_id)
group by j.job_id, job_title
having avg(e.salary) = (select min(avg(salary)) from employees group by job_id);




14.	Sã se afiºeze salariul mediu din firmã doar dacã acesta este mai mare decât 2500.

SELECT AVG(salary)
FROM employees
having avg(salary) > 2500;


15.	Sã se afiºeze suma salariilor pe departamente ºi, în cadrul acestora, pe job-uri.

SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY department_id, job_id; 


16.	Sa se afiseze codul, numele departamentului si numarul de angajati care lucreaza in acel departament pentru:

a)	departamentele in care lucreaza mai putin de 4 angajati;

SELECT d.department_id, d.department_name, COUNT(employee_id)
FROM employees e right JOIN departments d ON (d.department_id = e.department_id )
GROUP BY d.department_id, d.department_name
HAVING COUNT(employee_id) < 4; 


b)	departamentul care are numarul maxim de angajati.

--REZOLVATI

SELECT e.department_id, d.department_name, COUNT(*)
FROM employees e JOIN departments d ON (d.department_id = e.department_id )
GROUP BY e.department_id, d.department_name
HAVING COUNT(*) = (select max(count(*)) from employees group by department_id);



17.	Sã se obþinã numãrul departamentelor care au cel puþin 15 angajaþi.

--REZOLVATI
select count(department_id)
from employees
group by department_id
having count(employee_id) >= 15;

18.	Sã se obþinã codul departamentelor ºi suma salariilor angajaþilor care lucreazã în acestea, în ordine crescãtoare. 
Se considerã departamentele care au mai mult de 10 angajaþi ºi al cãror cod este diferit de 30.


_____


19.	Care sunt angajatii care au mai avut cel putin doua joburi?

_____

