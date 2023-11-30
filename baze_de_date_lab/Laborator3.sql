--Laboratorul 3

--Chestii cu Join

--exercitiul 2
select emp.employee_id as "Id angajat", emp.last_name as "Nume Angajat", coleg.employee_id as "Id coleg", dep.department_name
from employees emp join employees coleg on (emp.department_id = coleg.department_id)
                    join departments dep on (emp.department_id = dep.department_id)
where lower(coleg.last_name) like('%t%') and emp.employee_id != coleg.employee_id
order by emp.last_name;

--exercitiul 3
select emp.last_name as "Name", emp.salary as "Salary", j.job_title as "Job Title", l.city as "City", c.country_name as "Country Name"
from employees emp join jobs j on (emp.job_id = j.job_id)
                   join departments d on (emp.department_id = d.department_id)
                   join locations l on (d.location_id = l.location_id)
                   join countries c on (c.country_id = l.country_id);

--exercitiul 6


--varianta cu union
select department_id 
from departments
where lower(department_name) like '%re%'

union

select e.department_id
from employees e 
where upper(e.job_id) = 'SA_REP';


--varianta cu join

select distinct d.department_id 
from employees e right join departments d on(e.department_id = d.department_id)
where lower(d.department_name) like '%re%' or upper(e.job_id) = 'SA_REP';

--exercitiul 8

--rezolvare cu operatori pe multimi

select department_id
from departments

minus

select department_id
from employees;

--rezolvare cu join

select d.department_id
from employees e right join departments d on(e.department_id = d.department_id)
where e.employee_id is null;
















