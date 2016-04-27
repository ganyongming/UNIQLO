作业一
1:
SELECT ename,deptno
FROM emp
WHERE deptno IN (20,30)

2:
SELECT ename,job
FROM emp
WHERE mgr IS NULL
ORDER BY job

3:
SELECT ename,sal,comm
FROM emp
WHERE comm IS NOT NULL
ORDER BY sal DESC

4:
SELECT ename
FROM emp
WHERE ename LIKE '__A%'

5:
SELECT ename||','||job||','||sal out_put
FROM emp

6:
SELECT empno,ename,sal,sal*1.2


子查询:
子查询是嵌套在外层SQL语句当中，为外层SQL语句的执行提供数据使用。
子查询常用语SELECT语句，但也可以用于DML,DDL语句。



查看比CLARK工资高的员工？
SELECT ename,sal
FROM emp
WHERE sal>(SELECT sal
           FROM emp
           WHERE ename='CLARK')

子查询应用于DML
删除和CLARK同部门的员工
DELETE FROM emp
WHERE deptno=(SELECT deptno
              FROM emp
              WHERE ename='CLARK')


子查询应用于DDL
基于查询结果快速构建一张表。

建立一张表，包含empno,ename,
job,sal,dname,loc字段

CREATE TABLE mytab
AS
SELECT e.empno,e.ename,e.job,
       e.sal,d.dname,d.loc
FROM emp e,dept d
WHERE e.deptno=d.deptno



查看与职位是'SALESMAN'相同部门的
员工?
SELECT ename,deptno
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE job='SALESMAN')

查看比20号部门员工工资都高的
员工信息?
SELECT ename,sal
FROM emp
WHERE sal>ALL(SELECT sal 
              FROM emp
              WHERE deptno=20)




EXISTS关键字的作用：只要其后面的子查询可以查询出
至少一条数据，就返回TRUE.查看有员工的部门信息?
SELECT deptno, dname 
FROM dept d
WHERE EXISTS 
      (SELECT * 
       FROM emp e
       WHERE d.deptno=e.deptno);


查询列出最低薪水高于部门30的最低薪水
的部门信息?
SELECT MIN(sal),deptno
FROM emp
GROUP BY deptno
HAVING MIN(sal)>(SELECT MIN(sal)
                 FROM emp
                 WHERE deptno=30)

查看平均工资高于CLARK工资的部门的
最高薪水?
SELECT MAX(sal),deptno
FROM emp
GROUP BY deptno
HAVING AVG(sal)>(SELECT sal
                 FROM emp
                 WHERE ename='CLARK')


查看比自己所在部门平均工资高的员工信息?
SELECT e.ename,e.sal,e.deptno
FROM emp e,
     (SELECT AVG(sal) avg_sal,
             deptno
      FROM emp
      GROUP BY deptno) t
WHERE e.deptno=t.deptno
AND e.sal>t.avg_sal

查看低于本职位平均工资的员工?
SELECT e.ename,e.job,e.sal
FROM emp e,(SELECT AVG(sal) avg_sal,job
            FROM emp
            GROUP BY job) t
WHERE e.sal<t.avg_sal
AND e.job=t.job

SELECT ename,sal,deptno
FROM emp

SELECT子句中使用子查询可以实现外连接效
果
SELECT 
 e.ename, e.sal, 
 (SELECT d.dname
  FROM dept d 
  WHERE d.deptno = e.deptno) dname
FROM emp e;


SELECT * FROM emp


分页
分页的作用是分批显示结果集中的数据，这样的好处可以提高系统响应速度，减少内存消耗，减少网络通讯等。

不同的数据库分页语句不同，ORACLE是依靠伪列"ROWNUM"为结果集每一条记录
编一个行号，然后获取对应范围的记录实现的。

ROWNUM:伪列，不存在于任何一张表中，但是每张表都可以查询该列，该列的值
时查询结果集而定，只要可以从表中查询出一条记录，ROWNUM就会从1开始为每一条记录编一个行号作为该字段的值。

SELECT ename,sal,deptno
FROM emp

查看emp表第5条以后的数据?
SELECT ROWNUM,ename,sal,deptno
FROM emp
WHERE ROWNUM>1

ROWNUM在第一次查询数据进行编行号的过程中不能使用>1以上的数字进行过滤
否则查不到任何结果。
SELECT *
FROM(SELECT ROWNUM rn,ename,
            sal,deptno
     FROM emp)
WHERE rn BETWEEN 6 AND 10


SELECT *
FROM (SELECT ROWNUM rn,t.*
      FROM(SELECT ename,sal,deptno
           FROM emp
           ORDER BY sal DESC
           ) t
      )
WHERE rn BETWEEN 6 AND 10     

page:页数
pageSize:每页显示的条目数

page:2  pageSize:5
start:(page-1)*pageSize+1
end:page*pageSize

DECODE函数，可以实现分支效果的函数
SELECT ename, job, sal,
     DECODE(job,  
            'MANAGER', sal * 1.2,
            'ANALYST', sal * 1.1,
            'SALESMAN', sal * 1.05,
            sal
     ) bonus
FROM emp;

SELECT ename, job, sal,
     CASE job WHEN 'MANAGER' THEN sal * 1.2
              WHEN 'ANALYST' THEN sal * 1.1
              WHEN 'SALESMAN' THEN sal * 1.05
              ELSE sal END
     bonus
FROM emp;


ANALYST和MANAGER分作一组，剩下的
职位分作另一组，统计每组人数?
SELECT COUNT(*),DECODE(job,
                'ANALYST','VIP',
                'MANAGER','VIP',
                'OTHER')
FROM emp
GROUP BY DECODE(job,
                'ANALYST','VIP',
                'MANAGER','VIP',
                'OTHER')


SELECT deptno, dname, loc
FROM dept
ORDER BY 
      DECODE(dname, 
             'OPERATIONS',1,
             'ACCOUNTING',2,
             'SALES',3);

ROW_NUMBER()
该函数可以根据指定的字段分组，再按照指定的字段排序，然后生成组内
连续且唯一的数字。
查看每个部门工资的排名情况:
SELECT 
 ename,sal,deptno,
 ROW_NUMBER() OVER(
   PARTITION BY deptno
   ORDER BY sal DESC
 ) rank
FROM emp

RANK生成的是组内不连续也不唯一的
数字:
SELECT 
 ename,sal,deptno,
 RANK() OVER(
   PARTITION BY deptno
   ORDER BY sal DESC
 ) rank
FROM emp

DENSE_RANK()生成组内连续但不唯一的数字
SELECT 
 ename,sal,deptno,
 DENSE_RANK() OVER(
   PARTITION BY deptno
   ORDER BY sal DESC
 ) rank
FROM emp

CREATE TABLE sales_tab (
  year_id   NUMBER NOT NULL,
  month_id   NUMBER NOT NULL,
  day_id   NUMBER NOT NULL,
  sales_value NUMBER(10,2) NOT NULL
);
INSERT INTO sales_tab
SELECT TRUNC(DBMS_RANDOM.value(2010, 2012)) AS year_id,
       TRUNC(DBMS_RANDOM.value(1, 13)) AS month_id,
       TRUNC(DBMS_RANDOM.value(1, 32)) AS day_id,
       ROUND(DBMS_RANDOM.value(1, 100), 2) AS sales_value
FROM   dual
CONNECT BY level <= 1000;


SELECT year_id,month_id,day_id,sales_value
FROM sales_tab
ORDER BY year_id,month_id,day_id

每天营业额?
SELECT year_id,month_id,day_id,
       SUM(sales_value)
FROM sales_tab
GROUP BY year_id,month_id,day_id
ORDER BY year_id,month_id,day_id

每月营业额?
SELECT year_id,month_id,
       SUM(sales_value)
FROM sales_tab
GROUP BY year_id,month_id
ORDER BY year_id,month_id

每年营业额?
SELECT year_id,
       SUM(sales_value)
FROM sales_tab
GROUP BY year_id
ORDER BY year_id

总共的营业额?
SELECT SUM(sales_value)
FROM sales_tab

在一个结果集中，看每天的，每月的，
每年的，总共的营业额?
SELECT year_id,month_id,day_id,
       SUM(sales_value)
FROM sales_tab
GROUP BY ROLLUP(year_id,month_id,day_id)
ORDER BY year_id,month_id,day_id

ROLLUP的分组原则是参数逐个递减的形式
GROUP BY ROLLUP(a,b,c)
等同于
GROUP a,b,c
UNION
GROUP a,b
UNION 
GROUP a
UNION
全表看做一组


CUBE(a,b,c)
CUBE会将给定参数的每种组合进行一次分组
所以分组次数为:2的参数个数次方
a,b,c
a,b
a,c
b,c
a
b
c
全表一组

SELECT year_id,month_id,day_id,
       SUM(sales_value)
FROM sales_tab
GROUP BY CUBE(year_id,month_id,day_id)
ORDER BY year_id,month_id,day_id

查看每天与每月营业额？
GROUPING SETS()
该高级分组函数允许我们自定义分组方式，
然后将这几种分组函数的结果并在一个结果
集中显示，其中每一个参数是一种分组方式。
SELECT year_id,month_id,day_id,
       SUM(sales_value)
FROM sales_tab
GROUP BY GROUPING SETS(
          (year_id,month_id,day_id),
          (year_id,month_id)
          )
ORDER BY year_id,month_id,day_id





