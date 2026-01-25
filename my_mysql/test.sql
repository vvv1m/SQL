select sno, sname, sage
from student
where Sdept = 'CS' or Sdept = 'MA';

select sno, sname, sage
from student
where sdept not in ('CS','MA');

select sno, sname, sage
from student
where Sdept != 'CS' and Sdept != 'MA';

select *
from student 
order by sage asc;

select sname,sage
from student
where sdept = 'CS' and sage >= 18 and sage <= 20;

select sname,sage
from student
where sdept = 'CS' and sage between 18 and  20;

select *
from student 
where sdept = 'CS' and sname like '李%';

select s.sno, s.sname, sc.grade
from student s
join sc on s.sno = sc.sno
join course c on sc.cno = c.cno
where c.cname = '数据库原理';

select s.sno, c.ccredit
from student s
join sc on s.sno = sc.sno
join course c on sc.cno = c.cno
where s.sno like '%5';

select s.sno, s.sname, sc.grade
from student s
join sc on s.sno = sc.sno
join course c on sc.cno = c.cno
where c.cname = '数据库原理' and sc.grade >= 80;

select s.sname, c.cname, sc.grade
from student s
join sc on s.sno = sc.sno
join course c on sc.cno = c.cno;

select c1.cno as '课程号', c2.cpno as '间接先行号'
from course c1
join course c2 on c1.cpno = c2.cno
where c2.cpno is not null;

select s.sname
from student s
left join sc on s.sno = sc.sno
where sc.sno is null;

select sno, avg(grade) as '平均成绩'
from sc
group by sno;

select sage, count(*) as '人数'
from student
where ssex = 'M'
group by sage
having count(*) >= 1;

select s.sname, s.sage
from student s
join (
	select sdept, max(sage) as max_age
    from student
    group by sdept
) as mage on s.sdept = mage.sdept and s.sage = mage.max_age;
    
select c.cname
from student s
join sc on s.sno = sc.sno
join course c on c.cno = sc.cno
where s.sdept = 'CS'
group by c.cno
having count(s.sno) > 5;

select sname
from student
where sno not in(
	select sno
    from sc
    join course c on sc.cno = c.cno
    where c.cname = '数据库原理');
    
select sno 
from student 
where not exists (
    select *
    from course
    where not exists (
        select *
        from sc
        where sc.sno = student.sno
        and sc.cno = course.cno
    )
);


-- 男生成绩最高
select s.sname,s.ssex,sc.grade,'highest man' as 类别
from student s
join sc on s.sno = sc.sno
where s.ssex = 'M'
    and sc.grade = (
        select max(sc2.grade)
        from student s2
        join sc sc2 on s2.sno = sc2.sno
        where s2.ssex = 'M'
    )
union all

select s.sname,s.ssex,sc.grade,'lowest man' as 类别
from student s
join sc on s.sno = sc.sno
where s.ssex = 'M'
    and sc.grade = (
        select min(sc2.grade)
        from student s2
        join sc sc2 on s2.sno = sc2.sno
        where s2.ssex = 'M'
    )
union all
select s.sname,s.ssex,sc.grade,'highest woman' as 类别
from student s
join sc on s.sno = sc.sno
where s.ssex = 'W'
    and sc.grade = (
        select max(sc2.grade)
        from student s2
        join sc sc2 on s2.sno = sc2.sno
        where s2.ssex = 'W'
    )
union all
select s.sname,s.ssex,sc.grade,'lowest woman' as 类别
from student s
join sc on s.sno = sc.sno
where s.ssex = 'W'
    and sc.grade = (
        select min(sc2.grade)
        from student s2
        join sc sc2 on s2.sno = sc2.sno
        where s2.ssex = 'W'
    );

select 
    c.c_name as 顾客名称,
    o.o_orderkey as 订单编号,
    o.o_totalprice as 订单总价,
    o.o_orderdate as 订单日期,
    l.l_partkey as 零件编号,
    l.l_quantity as 数量,
    l.l_extendedprice as 明细价格,
    l.l_discount as 折扣
from 
    tpch.customer c
join 
    tpch.orders o on c.c_custkey = o.o_custkey
join 
    tpch.lineitem l on o.o_orderkey = l.l_orderkey
where
    c.c_name = "Customer#000000084"
order by
    o.o_orderkey, l.l_linenumber;


select c_custkey as 顾客标号, c_name as 顾客姓名
from tpch.customer
order by c_custkey
limit 100;

select
    p.p_partkey as 零件编号,
    p.p_name as 零件名称,
    p.p_mfgr as 制造商,
    p.p_brand as 品牌,
    p.p_type as 类型,
    p.p_size as 尺寸,
    p.p_retailprice as 零售价

from
    tpch.part p
where 
    p.p_partkey in (
        select ps_partkey
        from tpch.partsupp
        where ps_suppkey = (
            select s_suppkey
            from tpch.supplier
            where s_name = 'Supplier#000000084'
        )
    )
order by
    p.p_partkey;

select
    s.s_name as 供应商名称,
    p.p_partkey as 零件编号,
    p.p_name as 零件名称,
    p.p_mfgr as 制造商,
    p.p_brand as 品牌,
    p.p_type as 类型,
    p.p_size as 尺寸,
    p.p_retailprice as 零售价
from 
    tpch.supplier s
join 
    tpch.partsupp ps on s.s_suppkey = ps.ps_suppkey
join 
    tpch.part p on ps.ps_partkey = p.p_partkey
where
    s.s_name = 'Supplier#000000084'
order by 
    p.p_partkey;

select
    c.c_custkey as 顾客ID,
    c.c_name as 顾客姓名
from 
    tpch.customer c
where
    not exists(
        select 1
        from tpch.orders o
        join tpch.lineitem l on o.o_orderkey = l.l_orderkey
        join tpch.part p on l.l_partkey = p.p_partkey
        where o.o_custkey = c.c_custkey
            and p.p_brand = 'Brand#13'
    )
order by 
    c.c_custkey;

select distinct c.c_name as 姓名
from tpch.customer c
where not exists(
    select p.p_partkey
    from tpch.orders o1
    join tpch.lineitem l1 on o1.o_orderkey = l1.l_orderkey
    join tpch.part p on l1.l_partkey = p.p_partkey
    where o1.o_custkey = (
        select c_custkey
        from tpch.customer
        where c_name = 'Customer#000000084'
    )
    and not exists(
        select 1
        from tpch.orders o2
        join tpch.lineitem l2 on o2.o_orderkey = l2.l_orderkey
        where o2.o_custkey = c.c_custkey
        and l2.l_partkey = p.p_partkey
    )
)
and c.c_name != 'Customer#000000084'
order by c.c_name;

select 
    c.c_custkey as 顾客ID,
    c.c_name as 顾客姓名,
    c.c_address as 地址,
    c.c_phone as 电话,
    c.c_acctbal as 账户金额,
    avg_table.avgprice
from 
    tpch.customer c 
join 
    tpch.nation n on c.c_nationkey = n.n_nationkey
join(
    select
        o_custkey,
        avg(o_totalprice) as avgprice
    from 
        tpch.orders
    group by
        o_custkey
    having
        avg(o_totalprice) > 10000
    
) as avg_table on c.c_custkey = avg_table.o_custkey
where
    n.n_name = "FRANCE"
order by
    avg_table.avgprice desc;

insert into Student values('2023xxx1', '于x', 'M', 20, 'CS');
insert into Student values('2023xxx2', '周x', 'M', 20, 'CS');
insert into Student values('2023xxx3', '陈x', 'M', 20, 'CS');

update sc
set grade = 60
where cno = 'C4' and grade < 60;

select s.sno, s.sname, sc.cno, sc.grade
from student s
join sc sc on s.sno = sc.sno
where sc.cno = 'C4'
order by sc.grade;

update sc
set grade = grade + 10
where cno = 'C3'
    and sno in(
        select sno
        from student 
        where sdept = 'IS'
    );
select s.sno, s.sname, sc.cno, sc.grade
from student s
join sc sc on s.sno = sc.sno
where sc.cno = 'C3' and s.sdept = 'IS'
order by sc.grade;


select * from Student where sname = '李东';
select * from sc where sno in (select sno from Student where sname = '李东');

delete from sc 
where sno = (
    select sno 
    from student 
    where sname = '李东'
);
delete from student 
where sname = '李东';

select * from Student where sname = '李东';
select * from sc where sno in (select sno from Student where sname = '李东');


set profiling = 1;

select * 
from tpch.part 
where p_name='bisque tan cyan sky drab';
-- 查看执行时间
show profiles;

explain select * from tpch.part where p_brand='Brand#53';

explain 
SELECT * 
FROM  tpch.customer 
where c_name LIKE 'Customer#0001035%';
explain 
SELECT * 
FROM  tpch.customer 
where c_name LIKE '%500';

select distinct c.c_name as 顾客姓名
from tpch.customer c
join tpch.orders o on c.c_custkey = o.o_custkey
join tpch.lineitem l on o.o_orderkey = l.l_orderkey
where l.l_partkey = 123008
  and o.o_orderdate >= date '1995-11-01'
  and o.o_orderdate < date '1995-12-01'
order by c.c_name;

CREATE INDEX idx_lineitem_partkey_orderkey 
ON tpch.lineitem(l_partkey, l_orderkey);

explain 
Select S.S_name 
From tpch.supplier S Left outer join tpch.partsupp PS on PS.PS_suppkey= S.S_suppkey
Where PS.PS_suppkey is null;

avgGrade。
create view v_avg_grade (Sno, Name, avgGrade)
as
select SC. Sno, sname, avg (Grade)
from SC, Student
where SC. Sno=Student.Sno 
group by SC. Sno, sname

create view v_MA_Students
as
select *
from Student
where Sdept='MA'
with check option;

create view v_CS_Students
as
select *
from Student
where Sdept='CS';

create view v_C4_SC (sno, name, grade)
as
select SC.sno, sname, grade
from Student S, SC
where S.sno=SC.sno and cno='c4';

create view v_C4_HS
as
select *
from v_C4_SC
where grade>90;

Drop View v_C4_SC Restrict;
Drop View v_C4_SC Cascade;



-- ===========================
-- MySQL 物化视图模拟（推荐）
-- ===========================

-- 1. 创建物化表
DROP TABLE IF EXISTS mv_avg_grade;

CREATE TABLE mv_avg_grade(
    sno VARCHAR(20) PRIMARY KEY,
    name VARCHAR(50),
    avgGrade DECIMAL(5,2),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_grade (avgGrade)
) ENGINE=InnoDB;

-- 2. 刷新存储过程
DELIMITER //

DROP PROCEDURE IF EXISTS sp_refresh_mv_avg_grade //

CREATE PROCEDURE sp_refresh_mv_avg_grade()
BEGIN
    -- 清空表
    TRUNCATE TABLE mv_avg_grade;
    
    -- 重新填充数据
    INSERT INTO mv_avg_grade (sno, name, avgGrade)
    SELECT 
        sc.sno, 
        s.sname, 
        ROUND(AVG(sc.grade), 2)
    FROM 
        sc
    JOIN 
        student s ON sc.sno = s.sno
    GROUP BY 
        sc.sno, s.sname;
    
    -- 返回统计信息
    SELECT 
        CONCAT('物化视图已刷新，共 ', COUNT(*), ' 条记录') AS message,
        NOW() AS refresh_time
    FROM mv_avg_grade;
END //

DELIMITER ;

-- 3. 初始化数据
CALL sp_refresh_mv_avg_grade();

-- 4. 查询（速度快）
SELECT * FROM mv_avg_grade WHERE sno = '95528';

-- 5. 定期刷新（通过事件调度器）
-- 需要先启用事件调度器
SET GLOBAL event_scheduler = ON;

-- 创建定时刷新事件（每小时刷新一次）
DELIMITER //

DROP EVENT IF EXISTS evt_refresh_mv_avg_grade //

CREATE EVENT evt_refresh_mv_avg_grade
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    CALL sp_refresh_mv_avg_grade();
END //

DELIMITER ;


create view v_avg_grade (Sno, Name, avgGrade)
as
select SC. Sno, sname, avg (Grade)
from SC, Student
where SC. Sno=Student.Sno 
group by SC. Sno, sname

-- ===========================
-- 完整的用户管理示例
-- ===========================

-- 1. 删除已存在的用户（如果需要）
DROP USER IF EXISTS 'user2'@'localhost';
DROP USER IF EXISTS 'user3'@'localhost';
DROP USER IF EXISTS 'avguser'@'localhost';

-- 2. 创建用户
CREATE USER 'user2'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'user3'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'avguser'@'localhost' IDENTIFIED BY '123456';

-- 3. 授予权限

-- user2: 对 enrolled 数据库的所有表有查询权限
GRANT SELECT ON enrolled.* TO 'user2'@'localhost';

--user2实际权限
--授予在表Course上的所有权限
grant ALL PRIVILEGES on enrolled.course to 'user2'@'localhost';
--授予user2在表student上的查询权限
grant select on enrolled.student to 'user2'@'localhost';
--授予user2在表SC上的修改成绩权限
grant update (grade) on enrolled.sc to 'user2'@'localhost';
--级联授权，将查询student表的权限授权给user3
grant select on enrolled.student to 'user3'@'localhost';



-- user3: 对 enrolled 数据库的所有权限
GRANT ALL PRIVILEGES ON enrolled.* TO 'user3'@'localhost';

-- avguser: 只能访问视图 v_avg_grade
GRANT SELECT ON enrolled.v_avg_grade TO 'avguser'@'localhost';
--授予avguser在视图v_avg_grade上的查询权限
grant 


-- 4. 刷新权限
FLUSH PRIVILEGES;

-- 5. 验证用户创建
SELECT 
    User, 
    Host, 
    plugin,
    authentication_string
FROM 
    mysql.user
WHERE 
    User IN ('user2', 'user3', 'avguser');

-- 6. 查看用户权限
SHOW GRANTS FOR 'user2'@'localhost';
SHOW GRANTS FOR 'user3'@'localhost';
SHOW GRANTS FOR 'avguser'@'localhost';

--回收user2在表SC上的修改成绩权限
revoke update (grade) on enrolled.sc from 'user2'@'localhost';
--受限回收
REVOKE SELECT ON enrolled.student FROM 'user2'@'localhost' RESTRICT;
--级联回收
REVOKE SELECT ON enrolled.student FROM 'user2'@'localhost' CASCADE;

CREATE TABLE Department ( 
Dept varchar (30),
Name varchar (30),
Address varchar (50));

Insert into Department values('MA','数学系','南湖校区');
Insert into Department values('CS','计算机系','浑南校区');
Insert into Department values('IS','信息系','浑南校区');
Insert into Department values('SE','软件工程系','浑南校区');
Insert into Department values('EE','电气工程系','南湖校区');
Insert into Department values('CS','计算机系','南湖校区');

ALTER TABLE Department ADD CONSTRAINT pk_department PRIMARY KEY(Dept,address);

ALTER TABLE Student 
ADD CONSTRAINT fk_sdepartment FOREIGN KEY (sdept) REFERENCES Department (Dept) ON DELETE CASCADE ON UPDATE SET NULL;
insert into Student values('96010', '杜明', 'M', 19,'SE');  
insert into Student values('96011', '孙翔', 'M', 18,'SE');
insert into Student values('96012', '郑璇', 'W', 19,'EE');

Delete FROM Student WHERE sno= '95010';
Delete FROM Department WHERE dept='EE';

SELECT *
From Student
Where sdept='EE';

SELECT *
From Student
Where sno='96010';

CREATE TABLE Department2 ( 
Dept varchar(30) Primary Key,
Name varchar(30) NOT NULL UNIQUE,
Address varchar(50) DEFAULT '南湖校区'
);

Insert into Department2 values('MA', '数学系', '南湖校区');
Insert into Department2 values('CS', '计算机系', '浑南校区');
Insert into Department2 values('IS',NULL, '浑南校区');

CREATE TABLE Department3 ( 
Dept varchar(30) Primary Key,
Name varchar(30) NOT NULL UNIQUE,
Address varchar(50) CHECK(Address  IN ('南湖校区', '浑南校区'))
);
Insert into Department3 values('MA', '数学系', '南湖校区');

start transaction;
INSERT INTO course VALUES('c7', '生产实习',96,'3','c4');
COMMIT;


start transaction;
UPDATE course SET cpno='c5' WHERE cno='c7';
rollback;

START TRANSACTION;
INSERT INTO course VALUES('c8', '数据库系统实现技术',40,'2.5','c4');
SAVEPOINT sp1;
INSERT INTO course VALUES('c9', '数据库系统实践',40,'2.5','c4');
SAVEPOINT sp2;
INSERT INTO course VALUES('c10', '分布式数据库',48,'3','c8');
SELECT * FROM course;

start TRANSACTION;
DELETE FROM course WHERE cno='c21';
DELETE FROM course WHERE cno='c22';
COMMIT;
--多事务并发
--事务a
start TRANSACTION;
SELECT * FROM course;
SELECT * FROM course;
SELECT * FROM course;
COMMIT;
--事务b
start TRANSACTION;
INSERT INTO course VALUES('c15', '生产实习',96,'3','c4');

--a
start TRANSACTION;
SELECT * FROM COURSE FOR UPDATE;
--b
start TRANSACTION;
UPDATE course SET ccredit=4 WHERE cno='c4';


--b
start TRANSACTION;
UPDATE course SET ccredit=4 WHERE cno='c4';

--a
start TRANSACTION;
SELECT * FROM COURSE FOR UPDATE;