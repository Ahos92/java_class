-- 08_JOIN.sql
/*
    # 후보키 (Candidate Key)
        - 테이블 내에서 한 행을 유일하게 구분할 수 있는 모든 컬럼 (중복이 되지 않는)
    
    # 기본 키 (Primary Key, PK)
        - 후보키 중 테이블의 키로 선택된 것
        - 한 테이블당 기본키 하나밖에 설정할 수 없다.
    
    # 외래키 (Foreigh Key, FK)
        - 다른 테이블에서는 기본키(혹은 후보키) 이지만, 현재 테이블에서는 중복되는 값인 컬럼
            
            ex) employees테이블의 job_id > jobs테이블의 기본키
            
            ex2) employees테이블의 department_id > departments테이블의 기본키
            
        - 외래키가 설정된 테이블간에는 관계가 형성된다.
            (다른테이블의 기본키를 값으로 사용하는 것은 테이블간의 관계를 형성한다) 
                => 테이블을 나눠서 데이터의 중복을 최소화 
                => 기본키와 외래키로 두테이블 간의 연결점을 형성 (관계)
*/
SELECT * FROM employees;

SELECT * FROM departments;
SELECT * FROM jobs;
/*
    # 테이블 JOIN
        - 기본키와 외래키를 이용해 관계가 형성되어 있는 테이블들의 
            정보를 종합하여 조회하는 것
    
    # CROSS JOIN
        - 두 테이블의 데이터를 조합하여 나올 수 있는 모든 경우를 만드는 JOIN
        - 그냥 모든 경우를 조합한 쓸모없는 정보
*/
-- CROSS JOIN 
SELECT * FROM employees; -- 107 ROWS
SELECT * FROM departments; -- 27 ROWS
SELECT * FROM employees, departments; -- 107 * 27 ROWS

/*
    # EQUI JOIN
        - 두 테이블 간에 서로 동일한 값을 지닌 컬럼을 이용하여
            CROSS JOIN에서 의미 있는 데이터를 걸러내는 JOIN
            
*/
-- EQUI JOIN
SELECT 
    last_name, department_name 
FROM 
    employees, departments 
WHERE 
    employees.department_id = departments.department_id
ORDER BY
    last_name ASC;
    
-- 연습문제01 : last_name이 Bloom인 사람의 사원명과 부서명을 조회해보세요
SELECT 
    last_name, department_name 
FROM
    employees, departments
WHERE
    employees.department_id = departments.department_id 
    AND last_name = 'Bloom';
-- 연습문제02 : job_id가 IT_PROG인 사람들의 last_name, 부서번호, 부서명 조회해보세요
SELECT
    last_name, employees.department_id, department_name
FROM
    employees, departments
WHERE
    employees.department_id = departments.department_id 
    AND job_id = 'IT_PROG';

-- 연습문제03 : 시애틀에서 근무하는 모든 사원의 이름과 급여를 조회해보세요
SELECT
    first_name, last_name, salary
FROM
    employees, locations, departments
WHERE
    employees.department_id = departments.department_id 
    AND locations.location_id = departments.location_id 
    AND city = 'Seattle';

-- 연습문제04 : 직책이름에 Marketing이 들어간 모든 사원의 이름과 급여와 고용일을 조회해보세요
SELECT
    last_name, salary, hire_date
FROM 
    employees, jobs
WHERE
    employees.job_id = jobs.job_id 
    AND job_title LIKE '%Marketing%';
    
-- 테이블을 적절하게 잘 쪼개놓으면 필요할때 하나의 테이블로 합쳐서 사용할 수 있고
-- 데이터양을 줄일 수 있다 (대신 조회시 약간 느림)

/*
    # SELF JOIN
        - 하나의 테이블 내에서 자신과 JOIN하여 원하는 데이터를 얻어내는 것
        - manager_id 는 employees 테이블의 기본키만 들어갈 수 있는 외래키이다.
*/
-- 직원 이름과 해당 직원을 담당하는 매니저 이름 조회
SELECT 
    a.last_name AS "직원 이름", b.last_name AS "매니저 이름" 
FROM 
    employees a, employees b
WHERE
    a.manager_id = b.employee_id
ORDER BY
    a.last_name ASC;
    
-- 연습문제05 : 매니저가 King인 사원들의 이름과 job_title을 조회해보세요.
SELECT 
    a.last_name, job_title
FROM 
    employees a, employees b, jobs
WHERE 
    a.manager_id = b.employee_id
    AND a.job_id = jobs.job_id
    AND b.last_name = 'King';
    
-- 연습문제06 : Taylor 와 동일한 직책을 가진 사원의 정보를 모두 조회해보세요.
SELECT
    a.*
FROM 
    employees a, employees b
WHERE 
    a.job_id = b.job_id
    AND b.last_name = 'Taylor';


/*
    # OUTER JOIN
        - JOIN 조건을 만족하지 못해서 등장하지 못한 데이터들을 확인할 때 사용하는 JOIN
        - 등장하지 못한 행을 확인하고 싶은 쪽의 반대편 조건에 (+)를 붙인다
        - (+)를 붙인쪽의 행에 null을 추가하여 행을 확인한다.
*/
SELECT 
    a.last_name as "내 이름", b.last_name "매니저 이름"
FROM
    employees a, employees b
WHERE 
    a.manager_id = b.employee_id(+)
ORDER BY
    b.last_name DESC;
    
-- 연습문제07 : 사원명/부서번호/부서이름을 출력 하되 사원이 한명도 속하지 않은 부서를 조회해보세요.
SELECT
    last_name, e.department_id, department_name,location_id
FROM
    employees e, departments d
WHERE
    e.department_id(+) = d.department_id
ORDER BY
    e.department_id;
    
-- 연습문제08 : 사원명/직급ID/직급명을 출력하되 사원이 한명도 속하지 않은 직급도 함께 조회해보세요.
SELECT
    last_name, e.job_id, job_title
FROM
    employees e, jobs j
WHERE
    e.job_id(+) = j.job_id
ORDER BY
    e.job_id;
    
-- 연습문제09 : 부서명/주소/도시명을 출력하되 소속된 부서가 없는 도시도 조회해보세요.
SELECT 
    department_name, street_address, city
FROM
    departments d, locations l
WHERE
    d.location_id(+) = l.location_id
ORDER BY
    d.department_name;
