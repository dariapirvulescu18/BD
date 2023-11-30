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
--b) Care este deosebirea dintre clauzele WHERE �i HAVING? 




2.	S� se afi�eze cel mai mare salariu, cel mai mic salariu, suma �i media salariilor tuturor angaja�ilor. 
Eticheta�i coloanele Maxim, Minim, Suma, respectiv Media. 
Sa se rotunjeasca media salariilor. 

SELECT MAX(salary) Maxim, MIN(salary) Minim, sum(Salary) Suma, avg(salary) Media
FROM employees;


3.	S� se modifice problema 2 pentru a se afi�a minimul, maximul, suma �i media salariilor pentru FIECARE job. 

SELECT job_title, MAX(salary) Maxim, MIN(salary) Minim, sum(Salary) Suma, avg(salary) Media
FROM employees e join jobs j on (e.job_id = j.job_id)
GROUP BY job_title; 


4.	S� se afi�eze num�rul de angaja�i pentru FIECARE  departament.

SELECT COUNT(employee_id) as "Numar angajati din", d.department_id
FROM   departments d join employees e on (d.department_id = e.department_id)
GROUP BY d.department_id;


5.	S� se determine num�rul de angaja�i care sunt �efi. 
Etichetati coloana �Nr. manageri�.

select count(distinct(manager_id)) as "Numar manageri"
from employees;


6.	S� se afi�eze diferen�a dintre cel mai mare si cel mai mic salariu. 
Etichetati coloana �Diferenta�.

select *from employees;

SELECT max(salary)-min(salary) Diferenta
FROM employees;


7.	Scrie�i o cerere pentru a se afi�a numele departamentului, loca�ia, num�rul de angaja�i 
�i salariul mediu pentru angaja�ii din acel departament. 
Coloanele vor fi etichetate corespunz�tor.
Se vor afisa si angajatii care nu au departament

!!!Obs: �n clauza GROUP BY se trec obligatoriu toate coloanele prezente �n clauza SELECT, 
care nu sunt argument al func�iilor grup.

SELECT department_name, location_id, count(employee_id), round(avg(salary))
FROM departments d right join employees e on (d.department_id = e.department_id)
GROUP BY department_name, location_id;


8.	S� se afi�eze codul �i numele angaja�ilor care au salariul mai mare dec�t salariul mediu din firm�.
Se va sorta rezultatul �n ordine descresc�toare a salariilor.

SELECT employee_id, first_name, last_name
FROM employees 
WHERE salary > (SELECT AVG(salary)
                FROM employees
                )
ORDER BY salary DESC;  


9.	Pentru fiecare �ef, s� se afi�eze codul s�u �i salariul celui mai prost platit subordonat. 
Se vor exclude cei pentru care codul managerului nu este cunoscut. 
De asemenea, se vor exclude grupurile �n care salariul minim este mai mic de 1000$. 
Sorta�i rezultatul �n ordine descresc�toare a salariilor.

select manager_id, min(salary)
from employees
where manager_id is not null
group by manager_id
having min(salary) >= 1000
order by min(salary) desc;




10.	Pentru departamentele in care salariul maxim dep�e�te 3000$, s� se ob�in� codul, 
numele acestor departamente �i salariul maxim pe departament.

SELECT department_id, department_name, MAX(salary)
FROM departments JOIN employees USING(department_id)
GROUP BY department_id,department_name
HAVING MAX(salary) >= 3000;


11.	Care este salariul mediu minim al job-urilor existente? 
Salariul mediu al unui job va fi considerat drept media aritmetic� a salariilor celor care �l practic�.

SELECT min(round(avg(salary))) as "Salariul mediu minim"
FROM employees
GROUP BY job_id;



12.	S� se afi�eze maximul salariilor medii pe departamente.

SELECT MAX(AVG(salary))
FROM employees
GROUP BY department_id;



13.	Sa se obtina codul, titlul �i salariul mediu al job-ului pentru care salariul mediu este minim. 

-- Rezolvati

select j.job_id, j.job_title, avg(e.salary)
from employees e join jobs j on (j.job_id = e.job_id)
group by j.job_id, job_title
having avg(e.salary) = (select min(avg(salary)) from employees group by job_id);




14.	S� se afi�eze salariul mediu din firm� doar dac� acesta este mai mare dec�t 2500.

SELECT AVG(salary)
FROM employees
having avg(salary) > 2500;


15.	S� se afi�eze suma salariilor pe departamente �i, �n cadrul acestora, pe job-uri.

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



17.	S� se ob�in� num�rul departamentelor care au cel pu�in 15 angaja�i.

--REZOLVATI
select count(department_id)
from employees
group by department_id
having count(employee_id) >= 15;

18.	S� se ob�in� codul departamentelor �i suma salariilor angaja�ilor care lucreaz� �n acestea, �n ordine cresc�toare. 
Se consider� departamentele care au mai mult de 10 angaja�i �i al c�ror cod este diferit de 30.


_____


19.	Care sunt angajatii care au mai avut cel putin doua joburi?

_____

