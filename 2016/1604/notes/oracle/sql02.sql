

DQL:查询语句
SELECT * FROM emp

SELECT empno,ename,job,sal
FROM emp

在SELECT字句中，除了直接使用表中的字段外，还可以将一个函数的
结果，表达式的结果作为一列显示。
SELECT empno,sal*12
FROM emp

字符串函数
1:连接字符串
CONCAT(char1, char2)
将给定的两个参数连接在一起返回，作用与java中的"+"一致。

SELECT CONCAT(ename,sal)
FROM emp

SELECT CONCAT(CONCAT(ename,':'),sal)
FROM emp

"||"也是用于连接字符串使用这个最常用。与java中的"+"作用一致
SELECT ename||':'||sal
FROM emp

2:LENGTH(char)
返回给定参数的字符串长度
SELECT ename,LENGTH(ename)
FROM emp

3:UPPER、LOWER和INITCAP
将字符串转换为全大写，全小写，首字母大写

伪表:dual
该表并不存在，当我们查询的数据与数据库中的表中数据无关时，为了满足SELECT语
法要求我们可以使用伪表，这样只会查询出一条记录。
SELECT UPPER('hello'),
       LOWER('HELLO'),
       INITCAP('HELLO world')
FROM dual

SELECT *
FROM emp
WHERE ename=UPPER('scott')


4:TRIM、LTRIM、RTRIM
去除字符串中两边的指定字符也可以单独去除左边或右边的字符

SELECT 
 TRIM('e' FROM 'eeeliteee')
FROM dual

SELECT 
 LTRIM('eeeliteee','e')
FROM dual


5:LPAD、RPAD
补位函数

SELECT ename, LPAD(sal, 6, ' ')
FROM emp 


6:截取字符串
SUBSTR(char, m[, n])
截取给定字符串，从m处开始，连续截取n个字符。
需要注意，数据库的下标都是从1开始的！
SELECT 
 SUBSTR('thinking in java',10,2)
FROM dual

7:查找位置
INSTR(char1, char2[, n [, m]])：
查看char2在char1中的位置
n:从第几个字符开始找起，不写默认为1
m:找第几次出现,不写默认为1
SELECT 
 INSTR('thinking in java','in',4,2)
FROM dual

数字函数
1:四舍五入
ROUND(n,m)
对n进行四舍五入，保存小数点后m位m为0时，保留到整数位，负数则是
十位以上的位数
SELECT ROUND(45.678, 2) FROM DUAL; 
SELECT ROUND(45.678, 0) FROM DUAL;
SELECT ROUND(45.678, -1) FROM DUAL;

2:TRUNC(n,m)
相比于ROUND，仅做截取工作。
SELECT TRUNC(45.678, 2) FROM DUAL; 
SELECT TRUNC(45.678, 0) FROM DUAL;
SELECT TRUNC(45.678, -1) FROM DUAL;

3:MOD(n,m)
求余数，若m为0，直接返回n
SELECT ename,sal,MOD(sal,1000)
FROM emp

4:CEIL(n)、FLOOR(n)
向上取整和向下取整

SELECT CEIL(45.678) FROM DUAL; 
SELECT FLOOR(45.678) FROM DUAL;

SELECT SYSTIMESTAMP FROM DUAL;

日期类型
DATE与TIMESTAMP
时间戳前7个字节与DATE一致，后4个字节用于保存秒以下的精度。

日期类型数据可以进行计算。对日期进行加减数字，等同于加减天数。
两个日期之间做减法，差为相差的天数。

查看每个员工入职至今共多少天?
SELECT ename,SYSDATE-hiredate
FROM emp

查看至今为止活了多少天?
SELECT 
 SYSDATE-TO_DATE('1992-07-03','YYYY-MM-DD')
FROM 
 dual

TO_CHAR
可以将日期按照指定格式转换为字符串

日期格式中，不是关键字符以及符号的其他
字符需要使用双引号括起来
SELECT
 TO_CHAR(SYSDATE,'YYYY"年"MM"月"DD"日"')
FROM
 dual

RR对世纪的判定

SELECT
  TO_CHAR(
    TO_DATE('50-08-01','RR-MM-DD'),
    'YYYY-MM-DD'
  )
FROM
  dual


日期常用函数

LAST_DAY(DATE)
返回给定日期所在月的月底日期

查看当前月月底是哪天？
SELECT LAST_DAY(SYSDATE)
FROM dual

查看每个员工入职所在月的月底?
SELECT 
 ename,LAST_DAY(hiredate)
FROM 
 emp



ADD_MONTHS(DATE,i)
对指定日期加上指定的月
当i是负数时，则是减去。

查看每个员工入职20周年纪念日
SELECT 
  ename,ADD_MONTHS(hiredate,12*20)
FROM
  emp


MONTHS_BETWEEN(DATE1,DATE2)
计算两个日期之间相差的月数
计算是根据date1-date2得出的

查看每个员工至今工作了多少个月?
SELECT 
 ename,
 TRUNC(
  MONTHS_BETWEEN(SYSDATE,hiredate)
 )
FROM
 emp

至今活了多少个月了?
SELECT 
 MONTHS_BETWEEN(
   SYSDATE,
   TO_DATE('1982-07-20','YYYY-MM-DD')
 )
FROM
 dual

NEXT_DAY(date,i)
i可以是字符串，描述周几，但由于
语言问题，建议使用数字。
1表示周日，2表示周一,以此类推

SELECT NEXT_DAY(SYSDATE,5)
FROM dual


GREATEST(expr1[, expr2[, expr3]]…)
LEAST(expr1[, expr2[, expr3]]…)
参数任意个，函数返回其中最大值或最小值
参数类型要一致，并且可以比较大小。
SELECT 
 LEAST(SYSDATE, 
       TO_DATE('2008-10-10',
               'YYYY-MM-DD')
 )
FROM DUAL;

EXTRACT函数
获取指定时间分量对应的值

获取当前系统时间所在年
SELECT 
  EXTRACT(YEAR FROM SYSDATE)
FROM DUAL;

查看1980年入职的员工?
SELECT ename,hiredate
FROM emp
WHERE EXTRACT(YEAR FROM hiredate)=1980


CREATE TABLE student
    (id NUMBER(4), name CHAR(20), gender CHAR(1));

INSERT INTO student VALUES(1000, '李莫愁', 'F');

INSERT INTO student VALUES(1001, '林平之', NULL);

INSERT INTO student(id, name) VALUES(1002, '张无忌');

SELECT * FROM student

更新为NULL值
UPDATE student 
SET gender=NULL
WHERE id=1000

判断字段值是否为NULL
不可以使用"="来判断，要使用IS NULL
SELECT * FROM student
WHERE gender IS NULL

判断不为空，则使用IS NOT NULL
SELECT * FROM student
WHERE gender IS NOT NULL


CREATE TABLE student
    (id NUMBER(4),
     name CHAR(20), 
    gender CHAR(1) NOT NULL)

INSERT INTO student
(id,name,gender)
VALUES
(1,'张无忌','M')

SELECT * FROM student

UPDATE student
SET gender = NULL
WHERE id=1

NULL值的运算
NULL与字符串连接，等于什么也没做
NULL与任何数字计算，结果还是NULL

查看每个员工的收入:
SELECT 
 ename,sal,comm,sal+comm
FROM
 emp


NVL(exp1,exp2)
替换NULL值。
当exp1为NULL时，函数返回exp2,
否则返回exp1

查看每个员工的收入:
SELECT 
 ename,sal,comm,sal+NVL(comm,0)
FROM
 emp

根据员工的奖金情况，有奖金的显示"有奖金"没有奖金的则显示"没有奖金"

当需要根据指定内容是否为NULL来返回不同结果时，需要使用NVL2函数
NVL2(exp1,exp2,exp3)
当exp1不为NULL时，函数返回exp2
当exp1为NULL时，函数返回exp3

SELECT 
 ename,comm,
 NVL2(comm,'有奖金','没有奖金')
FROM 
 emp

NVL2可以实现NVL的功能，但是反过来
不行。
SELECT 
 ename,NVL2(comm,sal+comm,sal)
FROM
 emp


