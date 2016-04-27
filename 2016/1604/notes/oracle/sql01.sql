SELECT SYSDATE FROM dual

CREATE TABLE employee_fancq(
	id NUMBER(4),
  name VARCHAR2(20),
	gender CHAR(1),
	birth DATE,
  salary NUMBER(6,2),
  job VARCHAR2(30),
  deptno NUMBER(2)
)

查看表结构
DESC employee_fancq

DEFAULT关键字允许为字段指定默认值，这样当向该表插入数据时，这个字段没有指定值时，就会将默认值设置到该字段上。没有指定默认值的字段，默认值
为NULL。无论该字段是什么类型。

在数据库中，字符串字面量使用单引号。SQL语句本身不却分大小写，但是
字符串字面量区分！
CREATE TABLE employee(
	id NUMBER(4),
	name VARCHAR2(20),
	gender CHAR(1) DEFAULT 'M',
	birth DATE,
  salary NUMBER(6,2),
  job VARCHAR2(30),
  deptno NUMBER(2)
);

删除现有的表
DROP TABLE employee_xxx


修改表
1:修改表明
RENAME old_name TO new_name
例如:
RENAME employee_fancq TO myemp_fancq

DESC myemp_fancq

2:修改表结构
2.1:向表中添加新的字段，需要注意的是只能在末尾追加新字段，不能在现有字段间
插入一个字段。
ALTER TABLE myemp_fancq ADD(
  hiredate DATE DEFAULT SYSDATE
)
DESC myemp_fancq

2.2:删除表中现有字段
ALTER TABLE myemp DROP(hiredate)

2.3:修改表中现有字段
可以修改字段的类型，长度，添加默认值等建议不要在表中有数据的情况下修改，若要修改，尽量不要修改类型，长度尽量不要减少，否则可能修改不成功。
ALTER TABLE myemp MODIFY(
 job VARCHAR2(40) DEFAULT 'CLERK' 
);

DML操作
DML是操作表中数据使用的SQL语句
DML是伴随事物的

1:INSERT语句
向表中插入记录使用

INSERT INTO table_name
(colname1,colname2,...)
VALUES
(value1,value2,...)

向myemp表中插入数据
INSERT INTO myemp_fancq
(id,name,gender,job,deptno)
VALUES
(1,'jack','M','CLERK',10)

SELECT * FROM myemp_fancq

INSERT语句是可以不指定列名的若不指定，则认为是全列插入数据
那么在VALUES后面要将所有字段的值全部指定。不建议这样做。
INSERT INTO myemp_fancq
VALUES
(1,'jack',...)

插入日期类型数据时，建议使用TO_DATE函数将指定的日期转换为DATE类型数据
INSERT INTO myemp 
(id, name, job,birth) 
VALUES
(1003, 'donna', 'MANAGER', 
TO_DATE('2009-09-01', 
        'YYYY-MM-DD')
);


CREATE TABLE myemp_fancq(
	id NUMBER(4),
	name VARCHAR2(20)  NOT NULL,
	gender CHAR(1) DEFAULT 'M',
	birth DATE,
 salary NUMBER(6,2),
 comm NUMBER(6,2),
 job VARCHAR2(30),
 manager NUMBER(4),
 deptno NUMBER(2)
);
INSERT INTO myemp_fancq (id, name, job,birth) 
VALUES(2, 'rose', 'MANAGER', 
TO_DATE('2009-09-01', 'YYYY-MM-DD'));

SELECT * FROM myemp_fancq

2:修改表中数据
UPDATE table_name
SET col1=value1,col2=value2,..
[WHERE condition]
修改表中数据时，通常要添加WHERE字句来限定条件，这样只会将满足条件的记录做修改，否则是全表所有记录都修改!

UPDATE myemp_fancq
SET gender='F',salary=3000
WHERE name='rose'

SELECT * FROM myemp_fancq









