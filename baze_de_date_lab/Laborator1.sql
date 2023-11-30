select * from emp_details_view;

desc countries;
desc departments;
desc employees;
desc job_grades;
desc job_history;
desc jobs;
desc locations;

select * from countries;

select first_name, last_name, job_id, hire_date from employees;

select unique job_id from employees;

select distinct job_id from employees;

select all job_id from employees;

select last_name || ',' || first_name || ',' || job_id as "Detalii angajat" from employees;

select last_name || ' ' || first_name as "Nume angajat", salary from employees
where salary >2850;

select last_name || ' ' || first_name as "Nume angajat", department_id as "Numar departament" from employees
where employee_id=104;

select last_name || ' ' || first_name as "Nume angajat", salary from employees
where salary between 3000 and 7000;

select last_name || ' ' || first_name as "Nume angajat", salary from employees
where salary >= 3000 and salary <= 7000;

select employees.last_name || ' ' || employees.first_name as "Nume angajat", jobs.job_title as "Nume Job", employees.hire_date as "Data angajarii"
from employees
join jobs on employees.job_id=jobs.job_id
where employees.hire_date >= '20-FEB-87' and employees.hire_date <= '01-MAY-89'
order by employees.hire_date;

select  last_name || ' ' || first_name as "Nume angajat", department_id as "Cod departament" from employees
where department_id in (10,30)
order by last_name, first_name;

select  last_name || ' ' || first_name as "Angajat", salary as "Salariu Lunar" from employees
where department_id in (10,30) and salary >= 1500 
order by last_name, first_name;

select sysdate
from dual;

select last_name || ' ' || first_name as "Nume angajat", hire_date as "Data angajarii" from employees
where hire_date like('%87%');

select last_name || ' ' || first_name as "Nume angajat", hire_date as "Data angajarii" from employees
where TO_CHAR(hire_date, 'YYYY')=1987;

--nu sunt obligatorii ghilimelele!!!!

select employees.last_name || ' ' || employees.first_name as "Nume angajat", jobs.job_title as "Nume Job"
from employees
join jobs on employees.job_id=jobs.job_id
where manager_id is null;

select  last_name || ' ' || first_name as "Nume angajat", salary, commission_pct from employees
where commission_pct is not null
order by salary DESC, commission_pct DESC;

select  last_name || ' ' || first_name as "Nume angajat", salary, commission_pct from employees
order by salary DESC, commission_pct DESC;

select last_name || ' ' || first_name as "Nume angajat" from employees
where last_name like('__a%');

select last_name || ' ' || first_name as "Nume angajat" from employees
where (last_name like('L%l%') or last_name like('%l%l%')) and (department_id =  30 or manager_id = 102);

--????? de ce nu merge??

select employees.last_name || ' ' || employees.first_name as "Nume angajat", jobs.job_title as "Nume Job", salary as "Salariu Lunar"
from employees
join jobs on employees.job_id=jobs.job_id
where (jobs.job_title like ('%Clerk%')  or jobs.job_title like ('%Rep%')) and employees.salary not in (1000,2000,3000);

commit;
