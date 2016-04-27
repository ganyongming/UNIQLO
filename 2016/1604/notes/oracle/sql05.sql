
视图:
CREATE VIEW v_emp_10
AS
SELECT empno, ename, sal, deptno 
FROM emp 
WHERE deptno = 10;

查询视图:
SELECT *
FROM v_emp_10

查看视图的结构
DESC v_emp_10

视图:
视图也是数据库对象，在SQL语句中体现的样子与表相同，但并不是真实
的表，但是视图中的数据是来自于表中的。视图仅仅对应一条SELECT语句
的查询结果集。
目的在于:
1:简化SQL语句复杂度，重用子查询
2:限制数据访问。
   
   
CREATE OR REPLACE VIEW v_emp_10
AS
SELECT empno id  , ename name , 
       sal salary , deptno 
FROM emp 
WHERE deptno = 10;   
   
DESC v_emp_10   
   
视图对应的SELECT语句中查询的字段可以使用别名，这样创建的视图中对应
的字段则使用的别名，但是需要注意，若字段中包含函数或者表达式，则该字段
必须给别名。
   
对视图进行DML操作:
只能对简单视图进行DML操作，并且对
视图进行DML操作就是对视图数据来源的
基表进行的操作。

INSERT:
INSERT INTO v_emp_10
(id,name,salary,deptno)
VALUES
(1001,'JACK',5000,10)
   
SELECT * FROM v_emp_10  
SELECT * FROM emp
   
向视图中插入数据，会将该数据插入到基表中，但是视图看不到的字段会插入
默认值，若视图看不到的字段有非空约束则会导致插入失败。

INSERT INTO v_emp_10
(id,name,salary,deptno)
VALUES
(1002,'ROSE',5000,20)
插入的数据有可能导致视图不可控，对
基表产生"数据污染"
   
UPDATE v_emp_10
SET name='JACKSON'
WHERE id=1001

修改视图数据也可能导致视图对数据不可控了   
UPDATE v_emp_10
SET deptno=20
   
可以为视图添加检查选项，这样对视图进行DML操作时，视图会进行合法性验证，当插入的数据视图不可见，或修改视图现有数据后视图对该数据不可见时，视图将禁止这个
DML操作。
CREATE OR REPLACE VIEW v_emp_10
AS
SELECT empno id  , ename name , 
       sal salary , deptno 
FROM emp 
WHERE deptno = 10
WITH CHECK OPTION
 
可以使用只读选项，这样视图就不允许
使用DML操作了。
CREATE OR REPLACE VIEW v_emp_10
AS
SELECT empno id  , ename name , 
       sal salary , deptno 
FROM emp 
WHERE deptno = 10
WITH READ ONLY
   
SELECT text FROM user_views 
WHERE view_name = 'V_EMP_10'
   

SELECT table_name 
FROM user_tables


复杂视图:
CREATE VIEW v_emp_salary
AS
SELECT d.deptno,d.dname, 
       avg(e.sal) avg_sal, 
       sum(e.sal) sum_sal, 
       max(e.sal) max_sal, 
       min(e.sal) min_sal 
FROM emp e JOIN dept d
ON e.deptno = d.deptno
GROUP BY d.deptno,d.dname;

SELECT * FROM v_emp_salary
查看高于自己所在部门平均工资的员工信息?
SELECT e.ename,e.sal
FROM emp e JOIN v_emp_salary v
ON e.deptno=v.deptno
WHERE e.sal>v.avg_sal  
  
删除视图
DROP VIEW v_emp_10

删除视图中的数据会对应删除基表中的数据，但是删除视图不会影响基表数据。
复杂视图不能进行DML操作
  
  
序列
该数据库对象用于生成一组数字。常用于为某张表的主键提供值使用。
  
CREATE SEQUENCE seq_emp_empno
START WITH 1
INCREMENT BY 1
  
序列提供了两个伪列:
NEXTVAL:获取序列的下一个数字
CURRVAL:获取序列当前数字
  
需要注意，刚创建出来的序列，至少要先调用一次NEXTVAL生成第一个数字
后才可以使用CURRVAL获取当前数字(最后一次调用NEXTVAL生成的数字)。
   
SELECT seq_emp_empno.NEXTVAL
FROM dual
   
当使用NEXTVAL生成下一个数字后，之前的数字就无法再通过序列获取到了。
可以多次调用CURRVAL来获取最后生成的数字，该伪列不会导致序列自增。

SELECT * FROM emp
 
INSERT INTO emp
(empno,ename,job,sal,deptno)
VALUES
(seq_emp_empno.NEXTVAL,'ROSE',
'CLERK',5000,10)
   
删除序列
DROP SEQUENCE seq_emp_empno
 
UUID的生成方式:
SELECT SYS_GUID()
FROM dual

索引:
该数据库对象用于提高检索效率索引的统计维护和应用都是自动的，
我们对索引的操作仅限于是否添加索引。

CREATE INDEX idx_emp_ename 
ON emp(ename);


DROP INDEX idx_emp_ename;



CREATE TABLE employees1 (
  eid NUMBER(6) UNIQUE,
  name VARCHAR2(30),
  email VARCHAR2(50),
  salary NUMBER(7, 2),
  hiredate DATE,
  CONSTRAINT employees_email_uk UNIQUE(email)
 );

INSERT INTO employees1
(eid,name,email,salary)
VALUES
(NULL,'jack',NULL,5000)

SELECT * FROM employees1


CREATE TABLE employees2 (
eid NUMBER(6) PRIMARY KEY,
name VARCHAR2(30),
email VARCHAR2(50),
salary NUMBER(7, 2),
hiredate DATE
);

INSERT INTO employees2
(eid,name)
VALUES
(null,'jack')




         