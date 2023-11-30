select TO_CHAR(SYSDATE,'DD/MON/YYYY')
from dual;

select to_char(to_date('18/03/2022','DD/MM/YYYY'),'DD/MM/YYYY')
from dual;

--ex 2 cu like
select initcap(first_name) as "Prenume", upper(last_name) as "Nume", length(last_name) as "Lungime Nume"
from employees
where upper(last_name) like('J%') or upper(last_name) like ('M%') or upper(last_name) like ('__A%')
order by length(last_name) desc;

--ex 2 cu substr
select initcap(first_name) as "Prenume", upper(last_name) as "Nume", length(last_name) as "Lungime Nume"
from employees
where substr(upper(last_name),1,1) = 'J' or substr(upper(last_name),1,1) =  'M' or substr(upper(last_name),3,1) = 'A'
order by length(last_name) desc;

--ex 4 
select employee_id, last_name, length(last_name), instr(upper(last_name),'A',1,1) as "pozitie litera A"
from employees
where substr(lower(last_name),-1) = 'e';

--sfarsit lab 2 saptamana 3


--inceput lab 2 saptamana 4

--ex 5
select * from employees
where mod(round((sysdate-hire_date)),7) = 0;

--ex 6
select employee_id, last_name, salary,
        round(salary + 0.15 * salary, 2) as "Salariu nou",
        round((salary + 0.15 * salary) / 100 , 2) as "Numar sute"
from employees
where mod(salary, 1000) != 0;

--ex 7
select last_name as "Nume angajat", rpad(to_char(hire_date),20,'X') "Data Angajarii"
from employees
where commission_pct is not null;
--to charul e redundant aici pentru ca se face conversie automata spre to_char

--ex 8
SELECT TO_CHAR(SYSDATE+30, 'MONTH DD YYYY HH24:MI:SS') "Data"
FROM DUAL;

--ex 9
SELECT round(to_date('31-12-2023','dd-mm-yyyy') - sysdate)
FROM dual;

--ex 10 a
SELECT TO_CHAR(SYSDATE + 12/24, 'DD/MM HH24:MI:SS') "Data"
FROM DUAL;

--ex 10 b
select to_char(SYSDATE+ (5/60)/24, 'DD/MM HH24:MI:SS') "Data"
from dual;

--ex 11
SELECT concat(last_name, first_name), hire_date,
        NEXT_DAY(ADD_MONTHS(hire_date, 6), 'monday') "Negociere"
FROM employees;

--ex 12
--v1
SELECT last_name, round(months_between(sysdate, hire_date)) "Luni lucrate"
FROM employees
ORDER BY MONTHS_BETWEEN(SYSDATE, hire_date);
--v2
SELECT last_name, round(months_between(sysdate, hire_date)) "Luni lucrate"
FROM employees
ORDER BY 2;
--v3
SELECT last_name, round(months_between(sysdate, hire_date)) "Luni lucrate"
FROM employees
ORDER BY "Luni lucrate";

--ex 13
--varianta 1 cu NVL
select last_name, NVL(to_char(commission_pct),'Fara comision') as "Comision"
from employees

--ex 14
select last_name, salary, commission_pct
from employees
where salary + salary * nvl(commission_pct, 0) > 10000;
--aici grija la null, null*n = null, de asta se foloseste nvl

--ex 15

--CASE VARIANTA 1:
SELECT last_name, job_id, salary,
 CASE job_id WHEN 'IT_PROG' THEN salary * 1.1
 WHEN 'ST_CLERK' THEN salary * 1.15
 WHEN 'SA_REP' THEN salary * 1.2
 ELSE salary
 END "Salariu renegociat"
FROM employees;
-- CASE VARIANTA 2:
SELECT last_name, job_id, salary,
 CASE WHEN job_id = 'IT_PROG' THEN salary * 1.1
 WHEN job_id ='ST_CLERK' THEN salary * 1.15
 WHEN job_id ='SA_REP' THEN salary*1.2
 ELSE salary
 END "Salariu renegociat"
FROM employees;
-- DECODE:
SELECT last_name, job_id, salary,
 DECODE(job_id, 'IT_PROG', salary * 1.1,
 'ST_CLERK', salary * 1.15,
 'SA_REP', salary * 1.2,
 salary ) "Salariu renegociat"
FROM employees;

-- join in where
select employee_id, last_name, department_name, e.department_id
from employees e, departments d
where e.department_id = d.department_id;

--join in from cu on
select employee_id, last_name, department_name
from employees e join departments  d on (e.department_id = d.department_id);

--join in from cu using (daca cele doua coloane referite au acelasi nume)
select employee_id, last_name, department_name
from employees join departments using (department_id);

--afisam si angajatii care nu au departament
--(+) se plaseaza in partea deficitara de informatie -> angajatii fara departament
select employee_id, last_name, department_name
from employees e, departments d
where e.department_id = d.department_id (+);

--afisam departamentele care nu au angajat
select employee_id, last_name, department_name, d.department_id
from employees e, departments d
where e.department_id (+) = d. department_id;

--exercitiul 22

select ang.employee_id, ang.last_name as "Nume angajat", ang.department_id, coleg.last_name as "Nume Coleg", coleg.employee_id
from employees ang , employees coleg
where ang.department_id = coleg.department_id and ang.employee_id > coleg.employee_id;


























