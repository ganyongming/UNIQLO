

别名是在字段后面用空格隔开后的一个连续的字符串，注意，不要是SQL关键字
若希望别名区分大小写，并且可以含有空格的话，需要使用双引号括起来。
SELECT ename,sal*12 "Annual Sal"
FROM emp

WHERE子句
用在SELECT语句中为了查询出满足条件的记录。WHERE是在查询过程中进行过滤使用。

SELECT * FROM emp
WHERE deptno = 10;

SELECT ename, sal, job 
FROM emp 
WHERE job = 'SALESMAN';

SELECT ename, sal 
FROM emp  
WHERE sal < 2000;

SELECT ename, sal, job 
FROM emp 
WHERE deptno <> 10;

SELECT ename, sal, hiredate 
FROM emp 
WHERE hiredate > 
      TO_DATE('1982-01-01',
              'YYYY-MM-DD');

SELECT ename, sal, job 
FROM emp 
WHERE sal > 1000 
AND   job = 'CLERK';

SELECT ename, sal, job 
FROM emp 
WHERE sal > 1000 
OR    job = 'CLERK';

查看工资高于1000，
职位是CLERK或SALESMAN的员工信息?
SELECT ename, sal, job 
FROM emp 
WHERE sal > 1000 
AND   (job = 'SALESMAN'
OR    job = 'CLERK')

AND的优先级高于OR，可以通过添加括号来提高OR的优先级。

LIKE用来模糊匹配字符串支持两个通配符_:任意一个字符%:0-任意个字符
查看名字第二个字母是A的员工信息
SELECT empno,ename,sal
FROM emp
WHERE ename LIKE '_A%'


IN(list)
判断指定内容是否等于列表中的其中之一

查看职位是MANAGER或CLERK的员工:
SELECT ename, job 
FROM emp  
WHERE job IN ('MANAGER', 'CLERK');

NOT IN
则是判断不在列表中
SELECT ename, job 
FROM emp  
WHERE job NOT IN ('MANAGER', 'CLERK');

IN与NOT IN常用来联合子查询使用，这是
OR不可取代的。

ANY与ALL也常用语判断子查询的结果。几乎不会在列表中写具体的值。
SELECT empno, ename, job, 
       sal, deptno
FROM emp
WHERE sal > ANY (3500,4000,4500);

WHERE中可以使用函数或者表达式的结果作为过滤条件
SELECT ename, sal, job 
FROM emp 
WHERE ename = UPPER('soctt');

SELECT ename, sal, job 
FROM emp 
WHERE sal * 12 > 50000;


DISTINCT去除重复行
DISTINCT必须紧跟在SELECT关键字之后作用是将指定的字段值相同的记录去除。
SELECT DISTINCT job
FROM emp

DISTINCT可以对多列去重:多个列值的组合没有重复的
SELECT DISTINCT job,deptno
FROM emp


ORDER BY子句
用于对查询结果集按照指定字段的值进行升序或者降序排列。
其中ASC表示升序，DESC表示降序。ASC通常不写，不写默认就是升序。

查看公司工资排名情况
SELECT ename,sal
FROM emp
ORDER BY sal DESC

ORDER BY也可以根据多个字段进行，排序严格按照第一个字段
的方式先进行排序，当第一个字段值相同时，才按照第二个字段的方式
进行排序，以此类推。

SELECT ename,deptno,sal
FROM emp
ORDER BY deptno DESC,sal DESC

当排序含有NULL值的字段时，NULL被视为最大值。
SELECT ename,comm
FROM emp
ORDER BY comm

ORDER BY必须写在SELECT最后一个
子句上。
ORDER BY是在查询出结果后，才进行
排序的。


聚合函数
又称为多行函数，组函数。聚合函数是用来统计的，会将多行
记录中指定的字段值进行统计，然后
得出一个结果。

MAX()和MIN()
统计最大值与最小值

查看公司最高工资与最低工资
SELECT MAX(sal),MIN(sal)
FROM emp

AVG()和SUM()
求平均值与总和
聚合函数忽略NULL值。

求公司平均工资与工资总和
SELECT AVG(sal),SUM(sal)
FROM emp

SELECT AVG(NVL(comm,0)),
       SUM(comm)
FROM emp


COUNT()
统计指定字段值不为NULL的记录条数

查看公司员工人数？
SELECT COUNT(ename)
FROM emp

统计表中总数据量，通常使用COUNT(*)


查看每个部门的最高工资与最低工资?
SELECT ename,sal,deptno
FROM emp
ORDER BY deptno

GROUP BY子句
GROUP BY子句允许根据指定的字段值
相同的记录进行分组，配合聚合函数使用，可以进行分组后统计每组的结果

当使用聚合函数进行统计时，凡不在聚合函数中的单独字段，必须出现在GROUP BY子句中
反过来没有要求。
SELECT MAX(sal),MIN(sal),deptno
FROM emp
GROUP BY deptno


查看每种职位的平均工资以及工资总和?
SELECT AVG(sal),SUM(sal),job
FROM emp
GROUP BY job


查看每个部门每种职位的最高工资与最低工资?

GROUP BY可以按照多个字段进行分组，分组
原则是按照指定的多个字段值的组合相同的
记录看做一组。
SELECT MAX(sal),MIN(sal),deptno,job
FROM emp
GROUP BY deptno,job

查看部门平均工资高于2000的那些
部门的平均工资具体是多少?
SELECT AVG(sal),deptno
FROM emp
GROUP BY deptno
HAVING AVG(sal)>2000

查看部门平均工资高于2000的那些部门的最高工资与最低工资
SELECT MAX(sal),MIN(sal)
FROM emp
GROUP BY deptno
HAVING AVG(sal)>2000

查看含有5人以上的部门的平均工资?
SELECT AVG(sal),deptno
FROM emp
GROUP BY deptno
HAVING COUNT(*)>=5

SELECT *
FROM dept

多表关联查询
最主要的工作就是建立关联
关系，指定好两张表中记录
是如何对应上的。这样的对
应条件，我们称为连接条件

N张表关联查询，至少要有
N-1个连接条件。


查看每个员工的名字以及所在部门的名字?
SELECT e.ename,e.deptno,d.dname
FROM emp e,dept d
WHERE e.deptno=d.deptno

当SELECT子句中查询的字段在两张表中都存在时，也需要指明具体来自那张表。
表可以起别名，来简化SQL的复杂度。

关连查询必须添加连接条件，否则会出现笛卡尔积，这通常是一个无意义的结果集结果集的条目数是参与关联查询表的记录
总数的乘积。
SELECT e.ename,d.dname
FROM emp e,dept d




内连接也可以实现关联查询
SELECT e.ename,d.dname
FROM emp e,dept d
WHERE e.deptno=d.deptno

内连接:
SELECT e.ename,d.dname
FROM emp e JOIN dept d
ON e.deptno=d.deptno

关键查询与内连接都忽略不满足连接条件的记录。
若希望将不满足连接条件的记录也显示出来，需要使用外连接

外连接分为左外连接，右外连接，和
全外连接
左外连接:以JOIN左侧的表为驱动表(主表) 该表所有记录都要显示出来，当
        该表中某条记录不满足连接条件 是，来自右边表中的字段取值为NULL。

SELECT e.ename,d.dname
FROM emp e 
  LEFT|RIGHT|FULL OUTER JOIN 
     dept d
ON e.deptno=d.deptno


SELECT e.ename,d.dname
FROM emp e,dept d
WHERE e.deptno(+)=d.deptno


SELECT empno,ename,mgr
FROM emp
自连接
当前表的一条数据与当前表的多条数据产生对应关系的设计方式称为自连接。
自连接的设计是用于保存相同信息的数据，而又存在上下级关系的树状结构。

查看每个员工，以及其上司的名字?
SELECT e.ename,m.ename
FROM emp e,emp m
WHERE e.mgr=m.empno

查看KING的下属?
SELECT e.ename
FROM emp e JOIN emp m
ON e.mgr=m.empno
WHERE m.ename='KING'








