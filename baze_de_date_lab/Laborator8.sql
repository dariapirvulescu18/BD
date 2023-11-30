--i.e. laborator 7 partea 2
-- LABORATOR 7 -- continuare


17.	Sã se obþinã numãrul departamentelor care au cel puþin 15 angajaþi.

--REZOLVATI
select count(count(employee_id)) as "Numar departamente"
from employees
where department_id is not null
group by department_id
having count(employee_id) > 15;


18.	Sã se obþinã codul departamentelor ºi suma salariilor angajaþilor care lucreazã în acestea, în ordine crescãtoare. 
Se considerã departamentele care au mai mult de 10 angajaþi ºi al cãror cod este diferit de 30.

-- Cand utilizand where? Cand se foloseste having?

select sum(salary), department_id
from employees
where department_id != 30
group by department_id
having count(employee_id) > 10
order by sum(salary);
_____



19.	Care sunt angajatii care au mai avut cel putin doua joburi?


select employee_id
from job_history
group by employee_id
having count(job_id)>=2;




20.	Sã se calculeze comisionul mediu din firmã, luând în considerare toate liniile din tabel.

select round(avg(nvl(commission_pct, 0)), 2) as "Comision mediu din firma"
from employees;



21.	Scrieþi o cerere pentru a afiºa job-ul, salariul total pentru job-ul respectiv pe departamente 
si salariul total pentru job-ul respectiv pe departamentele 30, 50, 80. 
Se vor eticheta coloanele corespunzãtor. Rezultatul va apãrea sub forma de mai jos:

--Job	   Dep30   Dep50   Dep80	Total
---------------------------------------

--forma generala;
-- DECODE(value, if1, then1, if2, then2, … , ifN, thenN, else);

-- METODA 1
SELECT job_id, SUM(DECODE(department_id, 30, salary)) Dep30,
               SUM(DECODE(department_id, 50, salary)) Dep50,
               SUM(DECODE(department_id, 80, salary)) Dep80,
               SUM(salary) Total
FROM employees
GROUP BY job_id;

-- METODA 2: (cu subcereri corelate în clauza SELECT)
SELECT job_id, (SELECT SUM(salary)
                FROM employees
                WHERE department_id = 30
                AND job_id = e.job_id
               ) Dep30,
               
               (SELECT SUM(salary)
                FROM employees
                WHERE department_id = 50
                AND job_id = e.job_id
               ) Dep50,
                
               (SELECT SUM(salary)
                FROM employees
                WHERE department_id = 80
                AND job_id = e.job_id
               ) Dep80,
               
              SUM(salary) Total
              
FROM employees e
GROUP BY job_id;



23.	Sã se afiºeze codul, numele departamentului ºi suma salariilor pe departamente.

-- Varianta fara subcerere
SELECT d.department_id, department_name, sum(salary)
FROM departments d join employees e ON (d.department_id = e.department_id)
GROUP BY d.department_id, department_name
ORDER BY d.department_id;


-- Varianta cu subcerere in from
SELECT d.department_id, department_name, a.suma
FROM departments d, (SELECT department_id ,SUM(salary) suma 
                     FROM employees
                     GROUP BY department_id) a
WHERE d.department_id = a.department_id; 
 


24.	Sã se afiºeze numele, salariul, codul departamentului si salariul mediu din departamentul respectiv.

-- Varianta fara subcerere -> discutati rezultatul
-- aceasta este varianta gresita
-- criteriul de grupare trebuie sa fie department_id


select last_name, salary, department_id, avg(salary), department_name
from employees join departments using(department_id)
group by last_name, salary, department_id, department_name;

-- varianta corecta:
select last_name, salary, e.department_id, department_name, sal_med, nr_ang
from employees e join departments d on (e.department_id = d.department_id)
                join (select department_id, round(avg(salary), 2) sal_med, count(employee_id) nr_ang from employees group by department_id) a 
                on (d.department_id = a.department_id);
                
                
--LABORATOR 8 - SAPTAMANA 11

1. 

a) Sã se afiºeze informaþii (numele, salariul si codul departamentului) 
despre angajaþii al cãror salariu depãºeºte valoarea medie a salariilor 
tuturor colegilor din companie.

select last_name, salary, department_id
from employees 
where salary > (select avg(salary) from employees);


b) Sã se afiºeze informaþii (numele, salariul si codul departamentului) 
despre angajaþii al cãror salariu depãºeºte valoarea medie a salariilor 
colegilor sãi de departament.

select last_name, salary, department_id
from employees e
where salary > (select avg(salary) from employees where department_id = e.department_id);

c) Analog cu cererea precedentã, afiºându-se ºi numele departamentului 
ºi media salariilor acestuia ºi numãrul de angajaþi.

-- De ce varianta aceasta este gresita?
-- Argumentati

select last_name, salary, e.department_id, department_name, 
       round(avg(salary)), count(employee_id)
from employees e join departments d on (e.department_id = d.department_id)
group by last_name, salary, e.department_id, department_name;  


-- Discutati variantele incluse in laborator





2.	Sã se afiºeze numele ºi salariul angajaþilor al cãror salariu 
este mai mare decât salariile medii din toate departamentele. 
Se cer 2 variante de rezolvare: cu operatorul ALL sau cu funcþia MAX.

-- Varianta cu ALL
SELECT last_name, salary 
FROM employees 
WHERE salary > all (select round(avg(salary))
                    from employees 
                    group by department_id
                    ); -- subcererea calculeaza salariul mediu pentru fiecare departament


-- Varianta cu functia MAX
SELECT last_name, salary 
FROM employees 
WHERE salary > (select ROUND(max(avg(salary)))
                from employees 
                group by department_id
                );


3.	Sa se afiseze numele si salariul celor mai prost platiti angajati 
din fiecare departament.

-- Soluþia 1 (cu sincronizare):
SELECT last_name, salary, department_id
FROM employees e
WHERE ____


-- Soluþia 2 (fãrã sincronizare):
SELECT last_name, salary, department_id  
FROM employees
WHERE ____


-- Soluþia 3: Subcerere în clauza FROM 
               
SELECT last_name, salary, department_id  
FROM employees  ____



4.	Sa se obtina numele si salariul salariatilor care lucreaza intr-un departament 
in care exista cel putin 1 angajat cu salariul egal cu 
salariul maxim din departamentul 30.

-- METODA 1 - IN

___



-- METODA 2 - EXISTS

___


5.	Sã se afiºeze codul, numele ºi prenumele angajaþilor care au cel puþin doi subalterni. 

select employee_id, last_name, first_name
from employees mgr
where 1 > (select count(employee_id)
           from employees
           where mgr.employee_id = manager_id
          );

--SAU:
select employee_id, last_name, first_name
from employees e join (select manager_id, count(*) 
                       from employees 
                       group by manager_id
                       having count(*) >= 2
                       ) man
on e.employee_id = man.manager_id;



6.	Sã se determine locaþiile în care se aflã cel puþin un departament.

-- REZOLVATI
-- CEREREA TREBUIE SA AFISEZE 7 LOCATII 
-- VEZI IMAGINEAZA ATASATA IN LABORATOR

-- METODA 1 - IN (care este echivalent cu  = ANY )         


-- METODA 2 - EXISTS



7.	Sã se determine departamentele în care nu existã nici un angajat.

-- REZOLVATI
-- CEREREA TREBUIE SA RETURNEZE 16 DEPARTAMENTE
-- VEZI IMAGINEAZA ATASATA IN LABORATOR

-- METODA 1 - UTILIZAND NOT IN 



-- METODA 2 - UTILIZAND NOT EXISTS


LABORATOR 8 - SAPTAMANA 12



3.	Sa se afiseze numele si salariul celor mai prost platiti angajati 
din fiecare departament.

-- Soluþia 1 (cu sincronizare):
SELECT last_name, salary, department_id
FROM employees e
WHERE e.salary = (select min(salary) 
                    from employees 
                    where department_id = e.department_id
                );


-- Soluþia 2 (fãrã sincronizare):
SELECT last_name, salary, department_id  
FROM employees
WHERE (salary, department_id) in (select min(salary), department_id 
                                from employees 
                                group by department_id
                                ); 


-- Soluþia 3: Subcerere în clauza FROM 
               
SELECT e.last_name, e.salary, e.department_id  
FROM employees e join (select min(salary) as salariu_min, department_id
                        from employees
                        group by department_id
                        ) min_sal
                on (e.department_id = min_sal.department_id)
where e.salary = salariu_min;


4.	Sa se obtina numele si salariul salariatilor care lucreaza intr-un departament 
in care exista cel putin 1 angajat cu salariul egal cu 
salariul maxim din departamentul 30.

-- METODA 1 - IN

select max(salary)
from employees
where department_id = 30;
--salariul maxim din departmentul 30;

select department_id
from employees
where salary = (select max(salary)
                from employees
                where department_id = 30
                );
                
select last_name, salary
from employees
where department_id in (select department_id
                        from employees
                        where salary = (select max(salary)
                                        from employees
                                        where department_id = 30
                                        )
                        );

-- METODA 2 - EXISTS

select last_name, salary
from employees e
where EXISTS (select 1
              from employees
              where e.department_id = department_id and
              salary = (select max(salary)
                        from employees
                        where department_id = 30
                        )
             );


5.	Sã se afiºeze codul, numele ºi prenumele angajaþilor care au cel puþin doi subalterni. 

a)

select employee_id, last_name, first_name
from employees mgr
where 1 < (select count(employee_id)
           from employees
           where mgr.employee_id = manager_id
          );

--SAU:
select employee_id, last_name, first_name
from employees e join (select manager_id, count(*) 
                       from employees 
                       group by manager_id
                       having count(*) >= 2
                       ) man
on e.employee_id = man.manager_id;


b) Cati subalterni are fiecare angajat? Se vor afisa codul, numele, prenumele si numarul de subalterni.
Daca un angajat nu are subalterni, o sa se afiseze 0 (zero).

select employee_id, last_name, first_name, nvl(subalterni,0) as "Numar subalterni"
from employees e left join (select count(d.employee_id) subalterni , d.manager_id
                            from employees d
                            group by d.manager_id
                            ) s
                on (e.employee_id = s.manager_id);



6.	Sã se determine locaþiile în care se aflã cel puþin un departament.

-- REZOLVATI
-- CEREREA TREBUIE SA AFISEZE 7 LOCATII 
-- VEZI IMAGINEAZA ATASATA IN LABORATOR

-- METODA 1 - IN (care este echivalent cu  = ANY )         

select location_id
from locations
where location_id in (select location_id from departments group by location_id);
-- METODA 2 - EXISTS

select location_id
from locations l
where exists (select 1 from departments where location_id = l.location_id);

7.	Sã se determine departamentele în care nu existã niciun angajat.

-- REZOLVATI
-- CEREREA TREBUIE SA RETURNEZE 16 DEPARTAMENTE
-- VEZI IMAGINEAZA ATASATA IN LABORATOR

-- METODA 1 - UTILIZAND NOT IN 

select department_id, department_name
from departments
where department_id not in (select department_id 
                            from employees 
                            where department_id is not null 
                            group by department_id 
                            having count(employee_id) > 0
                            );

-- METODA 2 - UTILIZAND NOT EXISTS

SELECT department_id, department_name
FROM departments d
WHERE not exists(SELECT 1
                 FROM employees
                 where department_id = d.department_id
                );



9. Sã se afiºeze codul, prenumele, numele ºi data angajãrii, pentru angajatii condusi de Steven King 
care au cea mai mare vechime dintre subordonatii lui Steven King. 
Rezultatul nu va conþine angajaþii din anul 1970. 
--subordonatii lui king
with subord as (select employee_id, hire_date 
                from employees 
                where manager_id = (select employee_id 
                                    from employees 
                                    where lower(last_name||first_name) = 'kingsteven'
                                    )
                ),
subord_vechime as (select employee_id
                    from subord
                    where hire_date = (select min(hire_date)
                                        from subord
                                       )
                  )
select employee_id, last_name, first_name, hire_date
from employees
where employee_id in (select employee_id from subord_vechime)
        and to_char(hire_date,'yyyy') != '1970';


10. Sa se obtina numele primilor 10 angajati avand salariul maxim. 
Rezultatul se va afiºa în ordine crescãtoare a salariilor. 

-- Solutia 1: subcerere sincronizatã

-- numaram cate salarii sunt mai mari decat linia la care a ajuns

select last_name, salary, rownum 
from employees e
where 10 >
     (select count(salary) 
      from employees
      where e.salary < salary
     );




-- Solutia 2: analiza top-n 
-- ESTE CORECTA VARIANTA URMATOARE?

select employee_id, last_name, salary, rownum
from employees
where rownum <= 10
order by salary desc;









