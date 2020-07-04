#sql99语法
/*
     语法：
         select 查询列表
         from 表1 别名 【连接类型】
         join 表2 别名
         on 连接条件
           【where 筛选条件】
           【group by 分组】
           【having 筛选条件】
           【order by 排序列表】
           
  分类：
      内连接 ：inner
      外链接
            左外 : left 【outer】
            右外 ：right 【outer】              
            全外 ：full 【outer】
       交叉连接 ：cross

*/


#1.内连接
/*
     等值连接
     非等值连接
     自连接
     
   特点：
      1、添加排序、分组、筛选
      2、inner可以省略
      3、筛选条件放在where后面，连接条件放在on后面，提高分离性，便于阅读
      4、inner join连接和sql92语法中的等值连接效果是一样的，都是查询多表的交集      
*/

#1、等值连接

#1、查询员工名、部门名（调换位置）
SELECT last_name,department_name
    FROM employees e 
    INNER JOIN departments d
    ON e.`department_id` = d.`department_id`


#2、查询名字中包含e的员工名和工种名
SELECT last_name,job_title
    FROM employees e
    INNER JOIN jobs j
    ON e.`job_id` = j.job_id
    WHERE last_name LIKE '%e%'

#3、查询部门个数>3的城市名和部门个数
SELECT COUNT(*) c,city
    FROM departments d
    INNER JOIN locations l
    ON d.`location_id` = l.location_id
    GROUP BY city
    HAVING c > 3 
    
#4、查询哪个部门的部门员工个数>3的部门名和员工个数，并按个数降序
SELECT department_name,COUNT(*) 员工个数,e.`department_id`
    FROM employees e
    INNER JOIN departments d
    ON e.`department_id` = d.`department_id`
    GROUP BY e.department_id
    HAVING 员工个数 > 3
    ORDER BY 员工个数 DESC


#5、查询员工名、部门名、工种名、并按部门名排序
SELECT 
     last_name,department_name,job_title
     FROM employees e
     INNER JOIN departments d ON e.`department_id` = d.`department_id`
     INNER JOIN jobs j ON e.`job_id` = j.job_id
     ORDER BY department_name DESC
       
       
       
#2.非等值连接

#查询员工的工资级别
   SELECT salary,grade_level
      FROM employees e
      INNER JOIN job_grades g
      ON e.`salary` BETWEEN lowest_sal AND highest_sal
       
#查询工资级别的个数>20的个数，并且按工资级别降序
   SELECT grade_level,COUNT(*) c,salary
      FROM employees e
      INNER JOIN job_grades g
      ON e.`salary` BETWEEN lowest_sal AND highest_sal
      GROUP BY grade_level
      HAVING c > 20
      ORDER BY grade_level DESC


# 自连接

#查询员工的名字、上级的名字
SELECT e.`last_name` 员工,m.last_name 上级
    FROM employees e
    INNER JOIN employees m
    ON e.`manager_id` = m.employee_id

#查询姓名中包含字符k的员工名字、上级名字
SELECT e.`last_name` 员工,m.last_name 上级
    FROM employees e
    INNER JOIN employees m
    ON e.`manager_id` = m.employee_id
    WHERE e.`last_name` LIKE '%k%'



# 外连接
/*
  应用场景：用于查询一个表中有，另一个表没有的记录
  特点：
  1、外连接的查询结果为主表中的所有记录
        如果从表中有和它匹配的，则显示匹配的值
        如果从表中没有和它匹配的，则显示null
        外连接查询结果=内连接结果+主表中有而从表中没有的记录
  2、左外连接，left join左边的是主表
     右外连接，right join右边的是主表
  3、左外和右外交换两个表的顺序，可以实现同样的效果
  4、全外连接 = 内连接的结果+表1中有但表2没有的+表2中有但表1没有的
*/
# 查询男朋友不在男神表的女神名
#右外连接
SELECT b.name
    FROM boys bo
    RIGHT OUTER JOIN beauty b
    ON b.boyfriend_id = bo.id
    WHERE bo.id IS NULL
    
#左外连接
SELECT b.name
    FROM beauty b
    LEFT OUTER JOIN boys bo
    ON b.boyfriend_id = bo.id
    WHERE bo.id IS NULL

SELECT * FROM beauty

SELECT * FROM boys


#案例1：查询哪个部门没有员工
#左外
SELECT d.department_id,e.`employee_id`
    FROM departments d
    LEFT OUTER JOIN employees e
    ON e.department_id = d.department_id
    WHERE e.`employee_id` IS  NULL
    
#右外
SELECT d.department_id,e.employee_id
  FROM employees e
  RIGHT OUTER JOIN departments d
  ON e.department_id = d.`department_id`
  WHERE e.`employee_id` IS NULL

#全外（Mysql不支持）
    SELECT b.*,bo.*
       FROM beauty b
       FULL OUTER JOIN boys bo
       ON b.boyfriend_id = bo.id 
  
#交叉连接
SELECT b.*,bo.*
  FROM beauty b
  CROSS JOIN boys bo
  
  
#sql92 与 sql99
  /*
      功能：sql99支持的较多
      可读性：sql99实现连接条件和筛选条件的分离，可读性较高
        
  */
  
  
#1、查询编号>3的女神的男朋友信息，如果有则列出详细信息，如果没有，用null填充
 
SELECT bo.*,b.id,b.name
   FROM boys bo
   RIGHT JOIN beauty b
   ON b.boyfriend_id = bo.id
   WHERE b.id > 3
  
SELECT bo.*,b.id,b.name
   FROM beauty b
   LEFT JOIN boys bo
   ON b.boyfriend_id = bo.id
   WHERE b.id > 3
   
#2、查询哪个城市没有部门
SELECT city,department_id
   FROM locations l 
   LEFT JOIN departments d
   ON d.`location_id` = l.location_id
   WHERE department_id IS NULL
   
SELECT city,department_id 
   FROM departments d
   RIGHT JOIN locations l
   ON d.`location_id` = l.location_id
   WHERE department_id IS NULL   

#3、查询部门名为sal或it的员工信息
SELECT e.*,department_name
   FROM departments d
   LEFT JOIN employees e
   ON d.`department_id` = e.`department_id`
   WHERE department_name = 'IT' OR department_name = 'sal'
   
SELECT e.*,department_name
   FROM employees e
   RIGHT JOIN departments d
   ON d.`department_id` = e.`department_id`
   WHERE department_name = 'IT' OR department_name = 'sal'
   
   
   
   
# 子查询
/*
   含义：
     出现在其他语句中的select语句，称为子查询或内查询
     外部的查询语句，称为主查询或外查询
     
   分类：
     按子查询出现的位置：
         select后面：
                仅仅支持标量子查询
         
         from后面
                支持表子查询
         
         where或having后面 （重点）
                标量子查询 （使用较多） 单行
                列子查询   （使用较多） 多行
                行子查询   （使用较少）
         
         exists后面(相关子查询)
                表子查询
     按结果集的行列数不同：
         标量子查询（结果集只有一行一列）
         列子查询（结果集只有一列多行）
         行子查询（结果集有一行多列）
         表子查询（结果集一般为多行多列）
*/


#1、where或having后面
#1、标量子查询（单行子查询）
#2、列子查询（多行子查询）
#3、行子查询（多列多行）
/*
   特点：
      1.子查询放在小括号内
      2.子查询一般放在条件右侧
      3.标量子查询，一般搭配着单行操作符使用    
      < > >= <= = <>
      4.列子查询，一般搭配着多行操作符使用  
      in any/some all
      5、子查询的执行优先于主查询执行，主查询的条件用到了子查询的结果
*/

#1.标量子查询
#案例1：谁的工资比abel高
SELECT last_name,salary
   FROM 
  employees
   WHERE salary > 
	(  SELECT 
	  salary
	 FROM employees
	 WHERE last_name = 'abel'
	 )
	  
#案例2：返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id和工资
SELECT last_name,job_id,salary
FROM employees
WHERE job_id = (
    SELECT job_id
    FROM employees 
    WHERE employee_id = 141
)
  AND salary > (
    SELECT salary 
    FROM employees
    WHERE employee_id = 143
 )


#案例3：返回公司工资最少的员工的last_name，job_id和salary
SELECT last_name,job_id,salary
FROM employees
WHERE salary =(
     SELECT MIN(salary)
     FROM employees
)
     
#案例4；查询最低工资大于50号部门最低工资的部门id和其最低工资
SELECT MIN(salary) s,department_id
FROM employees
GROUP BY department_id
HAVING s > (
	SELECT MIN(salary) 
	FROM employees
	WHERE  department_id = 50
)

#非法使用标量子查询





#列子查询（多行子查询）
/*
     操作符：
     in  等于列表中任意一个   ont in 不等于列表中任何一个
     any/some  和子查询返回的某一个值比较
     all 和子查询返回的所有值比较
*/
#案例1：返回location_id是1400或1700的部门中的所有员工姓名
SELECT last_name
   FROM employees
   WHERE department_id IN(
	   SELECT DISTINCT department_id
	   FROM departments 
	   WHERE location_id IN (1400,1700)
   )



#案例2：返回其它工种中比job_id为‘IT_PROG’工种任一工资低的员工的工号、姓名、job_id、salary
SELECT employee_id,last_name,job_id,salary
  FROM employees
  WHERE salary < ANY (
	SELECT DISTINCT salary
	FROM employees 
	WHERE job_id = 'IT_PROG'  
  
  )AND job_id <> 'IT_PROG'
	  
  
#或

SELECT employee_id,last_name,job_id,salary
  FROM employees
  WHERE salary < (
	SELECT DISTINCT MAX(salary)
	FROM employees 
	WHERE job_id = 'IT_PROG'  
  
  )AND job_id <> 'IT_PROG'


#案例3：返回其它部门中比job_id为‘IT_PROG’部门所有工资都低的员工的员工号、姓名、job_id以及salary
SELECT employee_id,last_name,job_id,salary
  FROM employees
  WHERE salary < ALL(
	  SELECT DISTINCT salary
	  FROM  employees
	  WHERE job_id = 'IT_PROG'
)

#或
SELECT employee_id,last_name,job_id,salary
 FROM employees
 WHERE salary < (
	  SELECT DISTINCT MIN(salary)
	  FROM employees
	  WHERE job_id = 'IT_PROG'
)



#3.行子查询（结果集一行多列或多行多列）
#案例 查询员工编号最小并且工资最高的员工信息
SELECT
    * FROM employees
    WHERE (employee_id,salary)=(
        SELECT MIN(employee_id),MAX(salary)
        FROM employees    
    )
    


# 放在select后面
/*
   仅仅支持标量子查询
*/
# 案例 查询每个部门的员工个数
SELECT 
   d.*,(
        SELECT COUNT(*) FROM employees e
        WHERE e.`department_id` = d.`department_id`     
   ) 个数
   FROM departments d



#案例 查询员工号=102的部门名
SELECT 
     (
          SELECT department_name
          FROM departments d
          INNER JOIN employees e
          ON d.`department_id` = e.`department_id`
          WHERE e.`employee_id` = 102        
     )部门名



# from后面
/*
     将子查询结果充当一张表，要求必须起别名
*/

# 案例 查询每个部门的平均工资的工资等级
SELECT
    department_id,AVG(salary)
    FROM employees 
    GROUP BY department_id 
    


SELECT ag_dp.*,g.grade_level
   FROM (
        SELECT department_id,AVG(salary) ag   
        FROM employees
        GROUP BY department_id
   ) ag_dp
   INNER JOIN job_grades g
   ON ag_dp.ag BETWEEN lowest_sal AND highest_sal



# 放在exists后面(相关子查询)
/*
	语法：
	  exists(完整的查询语句)
	  结果 1 或者 0
	  1代表存在  0代表不存在 即为布尔类型
*/

# 案例 查询有员工的部门名
SELECT 
     department_name
     FROM departments d
     WHERE d.`department_id` IN(
         SELECT department_id FROM employees e     
     )


#exists
SELECT 
    department_name 
    FROM departments d
    WHERE EXISTS(
         SELECT * FROM employees e
         WHERE e.`department_id` = d.`department_id`   
    
    )



# 案例 查询没有女朋友的男神信息
   SELECT 
       bo.*
       FROM boys bo
       WHERE bo.id NOT IN (
          SELECT boyfriend_id FROM 
              beauty b
       )

#exists
   SELECT 
      bo.*
      FROM boys bo
      WHERE  NOT EXISTS (
          SELECT * FROM beauty b
          WHERE b.`boyfriend_id` = bo.id
      )


# 查询和Zlotkey相同部门的员工姓名和工资
SELECT 
    last_name,salary
    FROM employees e
    WHERE department_id = (
        SELECT department_id FROM employees 
        WHERE last_name = 'Zlotkey'   
    )
    

# 查询工资比公司平均工资高的员工的员工号，姓名和工资
  SELECT 
      employee_id,last_name,salary
      FROM employees 
      WHERE salary > (
          SELECT AVG(salary)
             FROM employees      
      )

# 查询各部门中工资比本部门平均工资高的员工的员工号，姓名和工资
   SELECT 
       employee_id,last_name,salary
       FROM employees e
       INNER JOIN (
            SELECT AVG(salary) ag,department_id FROM employees
            GROUP BY department_id   
       ) ag_dep
       ON e.`department_id` = ag_dep.department_id
       WHERE  salary > ag_dep.ag
       

# 查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT 
     employee_id,last_name
     FROM employees e
     WHERE department_id IN (
          SELECT DISTINCT department_id
	  FROM employees
	  WHERE last_name LIKE '%u%'
     )


# 查询在部门的location_id为1700的部门工作的员工的员工号
SELECT 
     employee_id
     FROM employees 
     WHERE department_id IN (
         SELECT DISTINCT department_id 
         FROM departments 
         WHERE location_id = 1700
     
     )
     
      

# 查询管理者是King的员工姓名和工资
SELECT 
     last_name,salary
     FROM employees 
     WHERE manager_id IN (
	SELECT employee_id
	FROM employees 
        WHERE last_name = 'K_ing'
     
     ) 
     

# 查询工资最高的员工的姓名，要求first_name和last_name显示为一列；列名为姓.名

SELECT 
   MAX(salary),CONCAT(first_name,last_name) '姓.名'
    FROM employees


SELECT 
   CONCAT(first_name,last_name) '姓.名'
   FROM employees
   WHERE salary = (
        SELECT MAX(salary) FROM employees   
   )
    

# 分页查询(重要)
# limit offset,size
  #offset 要显示的条目起始索引(起始索引从0开始)
  #size 要显示的条目个数
  
# 案例 查询前五的员工信息

/*
       特点：
          limit语句放在查询语句的最后
          公式
          要显示的页数：page  每页的条目数：size
          select 查询列表
          from 表
          limit (page-1)*size,size; (需要重点掌握)
                     
          
          
*/
SELECT * FROM employees
LIMIT 0,5

SELECT * FROM employees
LIMIT 5
	
#案例 查询第11条-25条的员工信息
SELECT * FROM employees
LIMIT 10,15




#案例 有奖金的员工信息，并且工资较高的前十名显示出来 
SELECT * FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC
LIMIT 0,10









/*
  已知表stuinfo
  id学号
  name 姓名
  email 邮箱  jchn@126.com
  gradeId 年级编号
  sex 性别   男 女
  age 年龄
  
  
  已知表 grade
  id 年级编号
  gradeName 年级名称
  
*/

# 查询所有学员的邮箱的用户名(注 邮箱中@前面的字符)
SELECT 
   SUBSTRING_INDEX(email,'@',1) FROM stuinfo

SELECT SUBSTR(email,1,INSTR(email,'@')-1) FROM stuinfo
	
#查询男生和女生的个数
SELECT 
    SUM(CASE WHEN sex='男' THEN 1 ELSE 0 END )男生个数,
    SUM(CASE WHEN sex='女' THEN 1 ELSE 0 END )女生个数
       FROM stuinfo

SELECT COUNT(*) 个数,gender
 FROM student 
 GROUP BY gender


#查询年龄>18岁的所有学生的姓名和年级名称
SELECT 
      s.name,g.gradeName
      FROM stuinfo s
      INNER JOIN grade g
      ON s.gradeId = g.id
      WHERE age > 18


#查询哪个年级的学生最小年龄>20岁
    
    SELECT 
          gradeId
          FROM stuinfo 
          GROUP BY gradeId
          HAVING  MIN(age) > 20


#说出查询语句中涉及到的所有关键字，以及执行先后顺序
/*
       select 查询列表               7
       from  表                      1
       连接类型 join 表2             2
       on 连接条件                   3
       where 筛选条件                4
       group by 分组列表             5
       having 分组后筛选             6
       order by 排序列表             8
       limit 偏移,条目数             9

*/

#查询工资最低的员工信息 last_name,salary
SELECT 
    last_name,salary
    FROM employees
    WHERE salary = (
        SELECT MIN(salary) FROM employees      
    )

#查询平均工资最低的部门信息
#方式一
SELECT * FROM departments
WHERE department_id = (
   SELECT 
   department_id 
   FROM employees 
   GROUP BY department_id
   HAVING AVG(salary) = ( 
       SELECT MIN(ag)
       FROM (
	       SELECT AVG(salary) ag,department_id
	       FROM employees
	       GROUP BY department_id  
       ) ag_sal 
   )
)

#方式二
SELECT * FROM departments
WHERE department_id = (
	SELECT department_id FROM employees
	GROUP BY department_id 
	ORDER BY AVG(salary)
	LIMIT 1 

)

#查询平均工资最低的部门信息和该部门的平均工资
#方式一
SELECT d.*,AVG(salary) FROM departments d
INNER JOIN employees e
ON d.`department_id` = e.`department_id`
WHERE d.department_id = (
     SELECT 
     department_id 
     FROM employees
     GROUP BY department_id
     ORDER BY AVG(salary)
     LIMIT 1
) 

#方式二
SELECT d.*,ag
FROM departments d
JOIN  (
SELECT 
     department_id,AVG(salary) ag
     FROM employees
     GROUP BY department_id
     ORDER BY AVG(salary)
     LIMIT 1
)avg_sal
ON d.`department_id` = avg_sal.department_id
	

#查询平均工资最高的 job 信息
SELECT * FROM jobs
WHERE job_id = (
    SELECT 
    job_id
    FROM employees
    GROUP BY job_id
    ORDER BY AVG(salary) DESC
    LIMIT 1

)

#查询平均工资高于公司平均工资的部门有哪些
#方式一
SELECT department_id FROM 
    (
           SELECT 
	   AVG(salary) ag,department_id 
	   FROM employees
	   GROUP BY department_id   
    ) avg_sal
    WHERE avg_sal.ag > (
         SELECT AVG(salary) FROM employees    
    )
    
#方式二    
SELECT department_id FROM employees
GROUP BY department_id 
HAVING AVG(salary) > (
    SELECT AVG(salary) FROM employees
)


#查询出公司中所有manager的详细信息
SELECT 
    * FROM employees
    WHERE employee_id IN(
      SELECT DISTINCT manager_id FROM employees 
      WHERE manager_id IS NOT NULL
    )


#各个部门中 最高工资中最低的那个部门的 最低工资是多少
SELECT MIN(salary) FROM employees
WHERE department_id = (
     SELECT 
     department_id FROM employees
     GROUP BY department_id
     ORDER BY MAX(salary) ASC
     LIMIT 1
)


#查询平均工资最高的部门的manager的详细信息:last_name,department_id,email,salary
SELECT last_name,e.department_id,email,salary
FROM employees e
INNER JOIN departments d
ON d.`manager_id` = e.`employee_id`
WHERE d.department_id = (
   
   SELECT department_id
   FROM employees
   GROUP BY department_id
   ORDER BY AVG(salary) DESC
   LIMIT 1

)
#测试
SELECT 
   last_name,department_id,email,salary
   FROM employees
   WHERE manager_id IN (
	SELECT DISTINCT manager_id FROM employees
	WHERE department_id = (
             	SELECT department_id
		FROM employees
		GROUP BY department_id
		ORDER BY AVG(salary) DESC
		LIMIT 1
	)
	AND manager_id IS NOT NULL
   )

SELECT * FROM major
SELECT * FROM result
SELECT * FROM student

#一、查询每个专业的学生人数
SELECT 
    COUNT(*),majorid
    FROM student s
    GROUP BY majorid

#二、查询参加考试的学生中，每个学生的平均分、最高分   
SELECT 
   MAX(score),AVG(score),studentno
   FROM result 
   GROUP BY studentno

#三、查询姓张的每个学生的最低分大于60的学号、姓名

SELECT studentno,studentname
FROM student
WHERE studentno IN (
    SELECT 
    studentno
    FROM result 
    GROUP BY studentno
    HAVING MIN(score) > 60

) AND  studentname LIKE '张%'

#四、查询生日在“1988-1-1”后的学生姓名、专业名称(感觉有bug)
SELECT studentname,majorname
FROM student s
INNER JOIN major m
ON s.majorid = m.majorid
WHERE studentno IN(
  SELECT studentno FROM student
  WHERE borndate > '1988-1-1'
)

SELECT studentname,majorname
FROM student s
INNER JOIN major m
ON s.majorid = m.majorid
WHERE s.borndate > '1998-1-1' 

SELECT studentname,majorname
FROM student s
INNER JOIN major m
ON s.majorid = m.majorid
WHERE DATEDIFF(borndate,'1998-1-1') > 0


#五、查询每个专业的男生人数和女生人数分别是多少
#方式一
SELECT 
   COUNT(*) 个数,sex,majorid
   FROM student
   GROUP BY majorid,sex

#方式二
SELECT majorid,
(SELECT COUNT(*) FROM student WHERE sex='男' AND majorid = s.majorid)男,
(SELECT COUNT(*) FROM student WHERE sex='女' AND majorid = s.majorid)女
FROM student s
GROUP BY majorid

#六、查询专业和张翠山一样的学生的最低分
SELECT MIN(score) FROM result
WHERE studentno IN(
	  SELECT studentno FROM student
	  WHERE majorid =(
		SELECT majorid FROM student
		WHERE studentname = '张翠山'
	  )

)

#七、查询大于60分的学生的姓名、密码、专业名
SELECT 
   studentname,loginpwd,majorname
   FROM major m
   INNER JOIN student s 
   ON s.majorid = m.majorid
   INNER JOIN result r
   ON s.studentno = r.studentno
   WHERE score > 60

#八、按邮箱位数分组，查询每组的学生个数
SELECT 
     DISTINCT LENGTH(email),COUNT(*)
     FROM student 
     WHERE email IS NOT NULL
     GROUP BY LENGTH(email)

#九、查询学生名、专业名、分数
SELECT 
    studentname,score,majorname
    FROM  result r
    RIGHT JOIN  student s
    ON s.studentno = r.studentno  
    INNER JOIN major m
    ON s.majorid = m.majorid
    
#十、查询哪个专业没有学生，分别用左连接和右连接实现
SELECT 
    studentname,studentno,majorid
    FROM student 
    WHERE majorid IS NULL

SELECT m.majorid,majorname,studentno
FROM major m
LEFT JOIN student s ON m.majorid = s.majorid
WHERE studentno IS  NULL

SELECT m.majorid,majorname,studentno
FROM student s
RIGHT JOIN major m ON m.majorid = s.majorid
WHERE studentno IS  NULL


#十一、查询没有成绩的学生人数
#方式一
SELECT COUNT(*) 人数
FROM result  
WHERE studentno IN(
      SELECT 
      studentno 
      FROM student
)

#方式二
SELECT COUNT(*)
FROM student s
LEFT JOIN result r ON s.studentno = r.studentno
WHERE r.id IS NULL





# union联合查询
/*
    union 联合 合并:将多条查询语句的结果合并成一个结果
    
    语法:
      查询语句1
      union
      查询语句2
      union
      ...
      
      应用场景；
      要查询的结果来自于多个表,且多个表没有直接的连接关系，但
      查询的信息一致时
      
      特点:
      1、要求多条查询语句的查询列数是一致的
      2、要求多条查询语句的查询的每一列的类型和顺序最好一致
      3、union关键字默认去重,如果使用union all可以包含重复项
*/

# 引入案例：查询部门编号>90或邮箱包含a的员工信息
SELECT * FROM employees
WHERE department_id > 90 OR email LIKE '%a%'


SELECT * FROM employees WHERE department_id > 90
UNION
SELECT * FROM employees WHERE email LIKE '%a%'

SELECT * FROM employees WHERE department_id > 90
UNION ALL
SELECT * FROM employees WHERE email LIKE '%a%'



#DML语言
/*
    数据操作语言
    插入：insert
    修改：update
    删除：delete
*/

# 一 插入语句
/*
    方式一：
    (支持插入多行,支持子查询)
    语法：
    insert into 表名(列名,...) values(值1,...)
    
    方式二：(不支持插入多行,不支持子查询)
    语法：
    insert into 表名
    set 列名=值,列名=值,...

*/
INSERT INTO beauty
VALUES
(18,'唐易欣4','男','1989-10-27','18973732629',NULL,2),
(19,'唐易欣5','男','1989-10-27','18973732629',NULL,2),
(20,'唐易欣6','男','1989-10-27','18973732629',NULL,2)

INSERT INTO beauty
SET phone = 12345678910,NAME='李五'

# 二 修改语句
/*
   1.修改单表的记录
   语法：
   update 表名
   set 列名=新值,列名=新值,...
   where 筛选条件   
   
   2.修改多表的记录
   语法：
   sql92语法
   update 表1 别名,表2 别名
   set 列名=值,...
   where 连接条件
   and 筛选条件
   
   sql99语法
   update 表1 别名
   inner left right  join 表2 别名
   on 连接条件
   set 列名=值,...
   where 筛选条件
   
*/

#1.修改单标记录
#案例 修改beauty表中姓唐的女神的电话为13899888899
UPDATE beauty
SET phone = '13899888899'
WHERE NAME LIKE '唐%'


#案例 修改boys表中id号为2的名称为张飞,魅力值 10
UPDATE boys
SET boyName = '张飞',userCP = 10
WHERE id = 2

#2 修改多表的记录
#案例 1：修改张无忌的女朋友的手机号为114
UPDATE beauty b
INNER JOIN boys bo
ON b.boyfriend_id = bo.id
SET phone = '114'
WHERE bo.boyName = '张无忌'


# 案例 修改没有男朋友的女神的男朋友编号都为2号
UPDATE beauty b
LEFT JOIN boys bo
ON b.boyfriend_id = bo.id 
SET boyfriend_id = 2
WHERE boyfriend_id IS NULL


# 三 删除语句
/*
  方式一：delete
  语法：
  1.单表的删除
  delete from 表名 where 筛选条件

  2.多表的删除
  sql92语法
  delete 别名
  from 表1 别名,表2 别名
  where 连接条件
  and 筛选条件
  
  sql99语法
  delete 别名
  from 表1 别名
  inner left right  join表2 别名 on 连接条件
  where 筛选条件 
  
  方式二:truncate 不可以添加where
  语法:
  truncate table 表名
*/

#方式一：delete
# 单表的删除
#案例：删除手机号以9结尾的女神信息
DELETE FROM beauty
WHERE phone LIKE '%9'


#多表的删除
#案例 删除张无忌的女朋友的信息
DELETE b FROM beauty b
INNER JOIN boys bo
ON b.boyfriend_id = bo.id 
WHERE bo.boyName = '张无忌'



# 案例 删除黄晓明的信息以及他女朋友的信息(级联删除)
DELETE b,bo FROM beauty b
INNER JOIN boys bo
ON b.boyfriend_id = bo.id
WHERE bo.boyName = '黄晓明'


#delete 与 truncate 的区别(经典面试题)
/*
    1.delete可以加where条件,truncate不能加
    2.truncate删除,效率高一丢丢
    3.假如要删除的表中有自增长列，如果用
    delete删除后，再插入数据，自增长列的值从
    断点开始，而truncate删除后，再插入数据，自增长列的值从1开始
    4.truncate删除没有返回值，delete删除有返回值
    5.truncate删除不能回滚，delete删除可以回滚
*/



# DDL
/*
       数据库定义语言
       库和表的管理
       
       一、库的管理
       创建、修改、删除
       二、表的管理
       创建、修改、删除
       
       创建：create
       修改：alter
       删除：drop
*/

#一、库的管理
#1、库的创建
/*
    create database [if not exists]库名

*/
# 案例 创建库Books
# if not exists 没有就创建 有就不创建
CREATE DATABASE IF NOT EXISTS Books

#2、库的修改
# 更改库的字符集
ALTER DATABASE books CHARACTER SET gbk

#库的删除
DROP DATABASE IF EXISTS books



#二 表的管理
#表的创建
/*
       语法：
       create table 表名(
           列名 列的类型【(长度) 约束】,       
           列名 列的类型【(长度) 约束】,
           列名 列的类型【(长度) 约束】,
           ...
           列名 列的类型【(长度) 约束】
       )

*/

USE books
# 案例 创建表book
CREATE TABLE IF NOT EXISTS book(
     id INT ,# 编号
     bname VARCHAR(20),# 图书名字
     price DOUBLE , #价格
     authorId INT, # 作者编号
     publishDate DATETIME #出版日期
)

DESC book
DESC author 
# 案例 创建表author
CREATE TABLE author(
    id INT ,#作者编号
    au_name VARCHAR(20), #作者名字
    nation VARCHAR(10) #国籍
)



#2.表的修改
/*
       alter table 表名
       add、drop、 modify、 change column 列名[列类型 约束]
*/

#1.修改列名 (column可以省略)
ALTER TABLE book CHANGE COLUMN publishdate pubDate DATETIME 

#2.修改列的类型和约束
ALTER TABLE book MODIFY COLUMN pubdate TIMESTAMP

#3.添加新列
ALTER TABLE author ADD COLUMN annual DOUBLE 

#4.删除列
ALTER TABLE author DROP COLUMN annual

#5.修改表名
ALTER TABLE author RENAME TO book_author


#3.表的删除
DROP TABLE IF EXISTS book_author



   
#通用的写法：
DROP DATABASE IF EXISTS 旧库名
CREATE DATABASE 新库名

DROP TABLE 旧表名
CREATE TABLE 新表()
  

#表的复制
#1.仅仅复制表的结构
CREATE TABLE copy LIKE author 

#2.复制表的结构+数据
CREATE TABLE copy2
SELECT * FROM author 

#3.只复制部分数据
CREATE TABLE copy3
SELECT id,au_name
FROM author 
WHERE nation = '中国'


#仅仅复制某些字段
CREATE TABLE copy4
SELECT id,au_name
FROM author 
WHERE 1=2



#常见的数据类型
/*
    数值型：
        整型
        小数：
              定点数
              浮点数
     
     字符型：
         较短的文本：char、varchar
         较长的文本：text、blob(较长的二进制数据)
     
     日期型

*/
#一、整型
/*
      分类：
      tingyint 、 smallint 、mediumint、int/integer  、bigint
      1字节        2           3              4          5 

      特点：
      1.如果不设置无符号还是有符号、默认是有符号，如果想设置无符号
      需要添加unsigned
      2.如果插入的数值超出了整型的范围,会报out of range异常,并且插入临界值
      3.如果不设置长度,会有默认的长度
      长度代表了显示的最大宽度，如果不够会用0在左边填充,但必须搭配zerofill使用
*/

DESC tab_int



#二、小数
/*
     分类：
     1.浮点型
     float(M,D)
     double(M,D)
     
     2.定点型
     dec(M,D)
     decimal(M,D)
     
     特点：
     1.M D
     M：整数部分+小数部分
     D：小数部分
     
     2.
     M和D都可以省略
     如果是decimal,则M默认为10,D默认为0
     如果是float和double,则会根据插入的数值精度来决定精度
     
     3.
     定点型的精确度较高，如果要求插入数值的精度较高如货币运算则考虑使用
*/


#原则
/*
  所选择的类型越简单越好，能保存数值的类型越小越好

*/





#测试题
#创建表
CREATE TABLE my_employees(
     Id INT(10),
     First_name VARCHAR(10),
     Last_name VARCHAR(10),
     Userid VARCHAR(10),
     Salary DOUBLE(10,2)
)

CREATE TABLE users(
    id INT,
    userid VARCHAR(10),
    department_id INT

)

#2.显示表 my_employees的结构
DESC my_employees

#3.向my_employees表中插入下列数据
/*
  ID    First_name      last_name   userid  salary
  1     Patel           Ralph       Rpatel      895
  2     Dancs           Betty       Bdancs      860
  3     Biri            Ben         Bbiri       1100
  4     Newman          Chad        Cnewman     750
  5     Ropeburn        Audrey      Aropebur    1550

*/
INSERT INTO my_employees
VALUES(1,'patel','Ralph','Rpatel',895),
(2,'Dancs','Betty','Bdancs',860),
(3,'Biri','Ben','Bbiri',1100),
(4,'Newman','Chad','Cnewman',750),
(5,'Ropeburn','Audrey','Aropebur',1550)

#方式二
INSERT INTO my_employees
SELECT 1,'patel','Ralph','Rpatel',895 UNION
SELECT 2,'Dancs','Betty','Bdancs',860 UNION 
SELECT 3,'Biri','Ben','Bbiri',1100    UNION
SELECT 4,'Newman','Chad','Cnewman',750   UNION
SELECT 5,'Ropeburn','Audrey','Aropebur',1550

#4.向users表中插入数据
/*
  1     Rpatel   10
  2     Bdancs   10
  3     Bbiri    20
  4     Cnewman  30
  5     Aropebur 40

*/
INSERT INTO users 
VALUES(1,'Rpatel',10),
(2,'Bdancs',10),
(3,'Bbiri',20),
(4,'Cnewman',30),
(5,'Aropebur',40)


#5 将3号员工的last_name修改为Drelxer
UPDATE my_employees 
SET last_name = 'Drelxer'
WHERE Id = 3

#6 将所有工资少于900的员工的工资修改为1000
UPDATE my_employees
SET salary = 1000
WHERE salary < 1000

#7.将userid为Bbiri的Users表和my_employees表的记录全部删除
DELETE u,e
FROM users u
INNER JOIN my_employees e
ON u.Userid = e.userid
WHERE e.userid = 'Bbiri'


#8.删除所有数据
DELETE FROM users 
DELETE FROM my_employees

#清空表 my_employees
TRUNCATE TABLE  my_employees



/*
          #1.	创建表dept1
    NAME	NULL?	TYPE
    id		        INT(7)
    NAME		VARCHAR(25)

*/
USE myemployees
CREATE TABLE dept1(
    id INT(7),
    NAME  VARCHAR(25)
)
#2.将表departemns中的数据插入新表dept2中 
CREATE TABLE dept2
SELECT department_id,department_name FROM departments

/*
   3.创建表emp5   
   name      null     type
   id                 int(7)
   First_name         varchar(25)
   Last_name          varchar(25)
   Dept_id            int(7)

*/

CREATE TABLE emp5(
      id INT(7),
      First_name VARCHAR(25),
      last_name  VARCHAR(25),
      Dept_id    INT(7) 
)

#4.将列Last_name的长度增加到50
ALTER TABLE emp5 MODIFY COLUMN last_name VARCHAR(50)

#5.根据表employees创建employees2
CREATE TABLE employees2 LIKE employees


#6.删除表emp5
DROP TABLE IF EXISTS emp5


#7.将表employees2重命名为emp5
ALTER TABLE employees2 RENAME TO emp5

#8.在表dept和emp5中添加新列test_column并检查所作的操作
ALTER TABLE dept1 ADD test_column VARCHAR(25)
ALTER TABLE dept2 ADD test_column VARCHAR(25)
ALTER TABLE emp5 ADD test_column VARCHAR(25)

#9.直接删除表emp5中的列job_id 
ALTER TABLE emp5 DROP COLUMN job_id  





# 三、字符型
/*
     较短的文本:
     char
     varchar
     其他：
     binary和varbinary用于保存较短的二进制
     enum用于保存枚举
     set用于保存集合

     较长的文本:
     text
     blob(较大的二进制)
     
     特点： 
     写法：               M的意思                     特点             空间的耗费   效率
     char     char(M)     最大字符数可以省略 默认为1  固定长度的字符   比较耗费     高
     varchar  varchar(M)  最大字符数不可以省略        可变长度的字符   比较节省     低

*/

#四 日期型
/*
       date只保存日期
       time只保存时间
       year只保存年
       datetime保存日期+时间
       timestamp保存日期+时间
       
       特点:
                     字节         范围        时区等的影响
       datetime        8          1000-9999     不受
       timestamp       4          1970-2038     受

*/


# 常见约束
/*
    含义：一种限制，用于限制表中的数据，为了保证表中的数据的准确
    和可靠性
    分类：六大约束
    NOT NULL:非空,用于保证该字段的值不能为空,比如姓名、学号等
    DEFAULT:默认,用于保证该字段有默认值 比如性别等
    PRIMARY KEY：主键,用于保证该字段的值具有唯一性,并且非空,比如学号等
    UNIQUE：唯一,用于保证该字段的值具有唯一性,可以为空,比如座位号等
    CHECK：检查【mysql中不支持】,比如年龄、性别
    FOREIGN KEY：外键,用于限制两个表的关系,用于保证该字段的值必须来自
    于主表的关联列的值, 在从表添加外键约束,用于引用主表中某列的值
    比如 学生表的专业编号,员工表的部门编号,员工表的工种编号
    
    
    添加约束的时机：
         1.创建表时
         2.修改表时
    
    约束的添加分类：
         列级约束：
              六大约束语法上都支持,但外键约束没有效果
         表级约束：
              除了非空、默认,其他的都支持
              
              
    主键和唯一的大对比：
          保证唯一性     是否允许为空            一个表中可以有多少个   是否允许组合
    主键      能            否                      至多有一个            是  但不推荐
    唯一      能            是(只能有一个null)      可以有多个            是  但不推荐
    
    外键:
    1、要求在从表设置外键关系
    2、从表的外键列的类型和主表的关联列的类型要求一致或兼容,名称无要求
    3、主表的关联列必须是一个key(一般是主键或唯一)
    4、插入数据时,先插入主表,再插入从表,删除数据时,先删除从表,再删除主表
*/



#一、创建表时添加约束
#1.添加列级约束
/*
     语法:
     直接在字段名和类型后面追加约束即可,
     只支持,默认、非空、主键、唯一
 

*/
CREATE DATABASE students
USE students

CREATE TABLE stuinfo(
     id INT PRIMARY KEY,#主键
     stuName VARCHAR(20) NOT NULL,#非空
     gender CHAR(1) CHECK(gender = '男' OR gender = '女'),#检查
     seat INT UNIQUE,#唯一
     age INT DEFAULT 18, #默认
     majorId INT REFERENCES major(id)#外键
)

CREATE TABLE major(
     id INT PRIMARY KEY,
     majorName VARCHAR(20)
)

#查看stuinfo表中所有的索引,包含主键,外键,唯一
SHOW INDEX FROM stuinfo

#2.添加表级约束
/*
     语法：在各个字段的最下面
     【constraint 约束名】可省略  约束类型(字段名)

*/

#通用的写法(除外键外 一般约束都使用列级约束)
CREATE TABLE IF NOT EXISTS stuinfo(
       id INT PRIMARY KEY,
       stuname VARCHAR(20) NOT NULL,
       sex CHAR(1),
       age INT DEFAULT 18,
       majorid INT 
       seat INT UNIQUE, 
       CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)
)

DROP TABLE IF EXISTS major

CREATE TABLE stuinfo(
    id INT, 
    stuname VARCHAR(20),
    gender CHAR(1),
    seat INT,
    age INT,
    majorid INT,
    
    CONSTRAINT pk PRIMARY KEY(id),#主键
    CONSTRAINT uq UNIQUE(seat),#唯一键
    CONSTRAINT ck CHECK(gender='男' OR gender='女'),#检查
    CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)#外键

)


#二、修改表时添加约束
/*
  1、添加列级约束
  alter table 表名 modify column 字段名 字段类型  新约束
  
  2、添加表级约束
  alter table 表名 add 【constraint 约束名】 约束类型(字段名) 【外键的引用】

*/
USE students
DROP TABLE IF EXISTS stuinfo
CREATE TABLE stuinfo(
    id INT,
    stuname VARCHAR(20),
    gender CHAR(1),
    seat INT,
    age INT,
    majorid INT
)

DESC stuinfo
#1.添加非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NOT NULL

#2.添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 18;

#3.添加主键
#1.列级约束
ALTER TABLE stuinfo MODIFY COLUMN id PRIMARY KEY;
#2.标记约束
ALTER TABLE stuinfo ADD PRIMARY KEY(id);

#4.添加唯一
#1.列级约束
ALTER TABLE stuinfo MODIFY COLUMN seat INT UNIQUE;
#2.表级约束
ALTER TABLE stuinfo ADD UNIQUE(seat);

#5.添加外键
ALTER TABLE stuinfo ADD FOREIGN KEY(majorid) REFERENCES major(id)


#三、修改表时删除约束

#1.删除非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NULL;

#2.删除默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT;

#3.删除主键
ALTER TABLE stuinfo DROP PRIMARY KEY;

#4.删除唯一
ALTER TABLE stuinfo DROP INDEX seat;

#5.删除外键
ALTER TABLE stuinfo DROP FOREIGN KEY stuinfo_ibfk_1;

SHOW INDEX FROM stuinfo



#1.向表emp2的id列中添加primary key约束(my_emp_id_pk)
ALTER TABLE emp2 MODIFY COLUMN  id INT PRIMARY KEY 

ALTER TABLE emp2   ADD CONSTRAINT my_emp_id_pk PRIMARY KEY(id)

#2.向表dept2的id列中添加primary key约束(my_dept_id_pk)
ALTER TABLE dept2  ADD CONSTRAINT my_dept_id_pk PRIMARY KEY(id)

ALTER TABLE dept2 MODIFY COLUMN id INT PRIMARY KEY

#3.向表emp2中添加列dept_id,并在其中定义foreign key约束,与之相关联的列是dept2表中的id列
ALTER TABLE emp2 ADD COLUMN dept_id INT 
ALTER TABLE emp2 ADD FOREIGN KEY(dept_id) REFERENCES dept2(id)

/*
                 位置               支持的约束类型              是否可以起约束名
    列级约束：   列的后面           语法都支持,但外键没有效果      不可以
    表级约束：   所有列的下面       默认和非空不支持,其他支持      可以(主键没有效果)

*/

#标识列
/*

又称为自增长列
 含义:可以不用手动的插入值，系统提供默认的序列值

 特点：
    1、标识列必须和主键搭配吗？不一定，但要求是一个key 例如unique等
    2、一个表可以有几个标识列？至多一个
    3、标识列的类型只能是数值型(一般为int)
    4、标识列可以通过SET auto_increment_increment = 1设置步长
    可以通过 手动插入之,设置起始值
    

*/

#一、创建表时设置标识列
DROP TABLE IF EXISTS tab_identity;
CREATE TABLE tab_identity(
   id INT ,
   NAME VARCHAR(20)

)


SHOW VARIABLES LIKE '%auto_increment%'

SET auto_increment_increment = 1


#二、修改表时设置标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT


#三、修改表时删除标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT 




#TCL
/*
     事务控制语言
     
     事务:
     一个或一组sql语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行
     
     事务的特性
     ACID
     原子性 A：一个事务不可再分割，要么都执行要么都不执行
     一致性 C：一个事务执行会使数据从一个一致状态切换到另外一个一致状态
     隔离性 I：一个事务的执行不受其他事务的干扰
     持久性 D：一个事务一旦提交，则会永久的改变数据库的数据
     
     事务的创建
     隐式事务：事务没有明显的开启和结束的标记
     比如insert、update、delete、语句
     
     显示事务:事务具有明显的开启和结束的标记
     前提：必须先设置自动提交功能为禁用
     SET autocommit=0
     
     步骤1：开启事务
     SET autocommit=0;
     start transaction;可选的
     步骤2：编写事务中的sql语句(select insert update delete)
     语句1;
     语句2;
     ...
     步骤3：结束事务
     commit;提交事务
     rollback;回滚事务
     
     savepoint 节点名;设置保存点
     
     事务的隔离级别：
                        脏读      不可重复读        幻读
     read uncommitted： √           √                √
     read committed  :  ×           √                √
     repeatable read :  ×           ×                √
     serializable    :  ×           ×                × 
     mysql中默认   第三个隔离级别  repeatable read
     oracle中默认第二个隔离级别    read committed
     
     查看隔离级别
     select @@tx_isolation
     设置隔离级别
     set session|global transaction isolation level 隔离级别;
*/


#2.delete和truncate在事务使用时的区别
/*
    delete支持回滚
    truncate不支持回滚
*/










USE test;
CREATE TABLE account(
        id INT PRIMARY KEY AUTO_INCREMENT,
        NAME VARCHAR(20),
        salary DOUBLE
)
INSERT INTO account(id,NAME,salary) 
VALUE(1,'张三',222.00)
,(25,'李四',800.00)
,(28,'王五',750.00)

SELECT * FROM account 

SHOW ENGINES #查询存储引擎

SET autocommit=0
SHOW VARIABLES LIKE 'autocommit'


#3.显示savepoint的使用
SET autocommit =0
START TRANSACTION

DELETE FROM account WHERE id=25;
SAVEPOINT a;#设置保存点
DELETE FROM account WHERE id=28;
ROLLBACK TO a ;#回滚到保存点




#视图
/*
     含义:虚拟表，和普通表一样使用
     mysql5.1版本出现的新特性，是通过表动态生成的数据
     
                          是否实际占用物理空间   使用   
     视图 create view      只是保存了sql逻辑     增删改查(一般不能增删改)
     
     表   create table     保存了数据            增删改查

*/

# 案例 查询姓张的学生名和专业名
SELECT stuname,majorname FROM stuinfo s
INNER JOIN major m
ON s.`majorid` =  m.`id`
WHERE s.`stuname` LIKE '张%'

CREATE VIEW v1
AS
SELECT stuname,majorname FROM stuinfo s
INNER JOIN major m
ON s.`majorid` = m.`id`

SELECT * FROM v1 
WHERE stuname LIKE '张%'




#一 创建视图
/*
   语法： 
   create view 视图名
   as
   查询语句;

*/
USE myemployees

# 1.查询姓名中包含a字符的员工名、部门名和工种信息
#1创建
CREATE VIEW v2
AS
SELECT last_name,department_name,j.*
FROM departments d
INNER JOIN employees e ON d.department_id = e.department_id
INNER JOIN jobs j ON e.job_id = j.job_id

#2使用
SELECT * FROM v2 
WHERE last_name LIKE '%a%'

#查询各部门的平均工资级别
CREATE VIEW v3
AS
SELECT department_id,AVG(salary) ag
FROM employees e
GROUP BY department_id

SELECT v3.`ag`,g.grade_level FROM v3
INNER JOIN job_grades g
ON v3.`ag` BETWEEN lowest_sal AND highest_sal


# 3.查询平均工资最低的部门信息
CREATE VIEW v4
AS
SELECT * FROM departments
WHERE department_id = (
	SELECT department_id  FROM employees
	GROUP BY department_id 
	ORDER BY AVG(salary) 
	LIMIT 1
)

SELECT d.*
FROM v5 
INNER JOIN departments d
ON v5.`department_id` = d.department_id


#4.查询平均工资最低的部门名和工资
CREATE VIEW v5
AS 
SELECT *FROM v3
ORDER BY v3.`ag`
LIMIT 1

SELECT department_name,v5.`ag`
FROM v5 
INNER JOIN departments d
ON v5.`department_id` = d.department_id





SELECT (
   SELECT AVG(salary) ag_sal,department_id
   FROM employees e GROUP BY department_id
   )ag,grade_level 
   FROM job_grades 
WHERE 
   ag.ag_sal BETWEEN lowest_sal AND highest_sal




#二、视图的修改
 #方式一：
/*
   create or replace view 视图名
   as
   查询语句
*/

 #方式二；
/*
   语法：
   alter view 视图名
   as
   查询语句
*/

#三、删除视图
/*
   语法：drop view 视图名,视图名,....;

*/
USE myemployees

#四、查看视图
DESC v2

SHOW CREATE VIEW v2




#1.创建视图emp_v1,要求查询电话号码以‘011’开头的员工姓名和工资、邮箱
CREATE VIEW emp_v1
AS
SELECT last_name,salary,email
FROM employees
WHERE phone_number LIKE '011%'

SELECT * FROM emp_v1

#2.创建视图emp_v2,要求查询部门的最高工资高于12000的部门信息
CREATE VIEW emp_v2
AS
SELECT * FROM departments 
WHERE department_id IN (
   SELECT department_id FROM employees
   GROUP BY department_id
   HAVING MAX(salary) > 12000
)


SELECT * FROM emp_v2





#五、视图的更新
CREATE OR REPLACE VIEW myv1
AS
SELECT last_name,email,salary*12*(1+IFNULL(commission_pct,0)) "annual salary"
FROM employees

CREATE OR REPLACE VIEW myv1
AS
SELECT last_name,email
FROM employees

SELECT * FROM myv1
SELECT * FROM employees
#1.插入
INSERT INTO myv1 VALUES('张飞','zf@qq.com')

#2.修改
UPDATE myv1 SET last_name = '张无忌' WHERE last_name = '张飞'

#3.删除
DELETE FROM myv1 WHERE last_name = '张无忌'

#具备以下特点的视图不允许更新
/*
   1.包含以下关键字的sql语句：分组函数、distinct、group by 
   having、union或者union all
   2.常量视图
   3.select中包含子查询
   4.join
   5.from一个不能更新的视图
   6.where子句的子查询引用了from子句中的表
*/


#创建表Book表字段如下
/*
       bid整型 要求主键
       bname 字符型，要求设置唯一键,并非空
       price 浮点型，要求有默认值10
       btypeId  类型编号,要求引用bookType的id字段

*/
 DROP TABLE book
 CREATE TABLE book(
      bid INT PRIMARY KEY,
      bname VARCHAR(20) UNIQUE NOT NULL,
      price FLOAT DEFAULT 10,
      btypeId INT,
      CONSTRAINT bookType_fk FOREIGN KEY(btypeId) REFERENCES bookType(id)
 
 )

DROP TABLE booktype
CREATE TABLE bookType(
   id INT PRIMARY KEY,
   NAME VARCHAR(20)

)

SET autocommit=0;
START TRANSACTION;
INSERT INTO book VALUES(1,'Java学习',100,1);
COMMIT;

INSERT INTO booktype VALUES(1,'软件'),
(2,'科技'),


#3.创建视图，实现查询价格大于100的书名和类型名
USE test_demo
CREATE VIEW  myv1
AS
SELECT bname,NAME FROM book b
INNER JOIN booktype t
ON b.btypeid = t.id
WHERE price > 100

SELECT * FROM myv1

#4.修改视图，实现查询价格在90-120之间的书名和价格
CREATE OR REPLACE VIEW myv1
AS 
SELECT bname,price
FROM book
WHERE price BETWEEN 90 AND 120

#5.删除刚创建的视图
DROP VIEW myv1





#变量
/*
    系统变量：
        全局变量
        会话变量
        
    自定义变量：
        用户变量
        局部变量
*/

#一、系统变量
/*
      说明：变量由系统提供，不是用户定义，属于服务器层面
      注意：
   如果是全局级别，则需要global，如果是会话级别，则需要加session,
   如果不写，则默认session

1、查看所有的系统变量
 show global|[session] variables;

2、查看满足条件的部分系统变量
 show global|[session] variables like '%char%'
 
3、查看指定的某个系统变量的值
 select @@global|[session]. 系统变量名
 
4、为某个系统变量赋值
 方式一
 set global|[session]系统变量名 = 值
 方式二
 set @@global|[session].系统变量名 = 值
  
*/

#1、全局变量
/*
作用域：服务器每次启动将为所有的全局变量赋初始值，针对于
所有的会话(连接)有效,但不能跨重启(即重启服务)

*/
#查看所有的全局变量
SHOW GLOBAL VARIABLES;

#查看部分的全局变量
SHOW GLOBAL VARIABLES LIKE '%char%';

#查看指定的全局变量的值
SELECT @@global.autocommit;
SELECT @@tx_isolation;

#为某个指定的全局变量赋值
SET @@global.autocommit=0



#2.会话变量
/*
作用域：仅仅针对于当前会话（连接）有效

*/
#查看所有的会话变量
SHOW  SESSION VARIABLES;
SHOW VARIABLES;

#查看部分的会话变量
SHOW VARIABLES LIKE '%char%'

#查看指定的某个会话变量
SELECT @@tx_isolation;
SELECT @@session.tx_isolation

#为某个会话变量赋值
#方式一
SET @@session.tx_isolation='read-uncommitted';

#方式二
SET SESSION tx_isolation='read-committed'



#二、自定义变量
/*
    说明：变量是用户自定义的，不是由系统的
    使用步骤：
    声明
    赋值
    使用（查看、比较、运算等）
*/
#1.用户变量
/*
   作用域：针对于当前会话（连接）有效，同于会话变量的作用域
   应用在任何地方，也就是begin end里面或者begin end外面
*/

#赋值的操作符  =或:=
#1、声明并初始化
SET @用户变量名 = 值;
SET @用户变量名:=值;
SELECT @用户变量名:=值;


#2.赋值(更新用户变量的值)
方式一：通过 SET 或 SELECT
      SET @用户变量名 = 值;
      SET @用户变量名:=值;
      SELECT @用户变量名:=值;

方式二：通过select INTO
      SELECT 字段 INTO @变量
      FROM 表


#3.使用（查看用户变量的值）
SELECT @用户变量名;
SELECT @count

#案例
#声明并初始化
SET @name='join'
SET @name=100
SET @count=1

#赋值
SELECT COUNT(*) INTO @counts FROM employees

#查看
SELECT @count



#2.局部变量
/*
作用域：仅仅在定义它的begin end中有效
应用在 begin end中的第一句话(重点)
*/

#1.声明
DECLARE 变量名 类型
DECLARE 变量名 类型 DEFAULT 值 


#2.赋值
方式一：通过 SET 或 SELECT
      SET 局部变量名=值;
      SET 局部变量名:=值;
      SELECT @局部变量名:=值;

方式二：通过 SELECT INTO
      SELECT 字段 INTO 局部变量名
      FROM 表

#3.使用
SELECT 局部变量名;

对比用户变量和局部变量：
             作用域         定义和使用的位置                      语法
用户变量     当前会话       会话中的任何地方                    必须加@符号

局部变量     BEGIN END 中   只能在 BEGIN END 中,且为第一句话    一般不用加@符号,需要限定类型

#案例：声明两个变量并赋初始值，求和，并打印
SET @a = 1
SELECT @b:=1
SELECT @sum := @a+@b
SELECT @sum





#存储过程和函数
/*
    存储过程和函数：类似于java中的方法
    好处：
    1.提高代码的重用性
    2.简化操作

*/
#存储过程
/*
  含义：一组预先编译好的sql语句的集合，理解成批处理语句
  好处：
    1.提高代码的重用性
    2.简化操作
    3.减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率

*/


#一、创建语法
CREATE PROCEDURE 存储过程名(参数列表)
BEGIN 
     存储过程体(一组合法的 SQL 语句)
END

注意：
1、参数列表包含三部分
参数模式  参数名  参数类型
举例：
IN   stuname VARCHAR(20)

参数模式：
IN:该参数可以作为输入，也就是该参数需要调用方传入值
OUT:该参数可以作为输出，也就是该参数可以作为返回值
INOUT:该参数既可以作为输入又可以作为输出，也就是该参数既需要传入值，又可以返回值

2、如果存储过程体仅仅只有一句话， BEGIN END 可以胜率
存储过程体重每条sql语句的结尾要求必须加分号
存储过程的结尾可以使用 DELIMITER 重新设置
语法：
DELIMITER 结束标记

案例：
DELIMITER $



#二、调用语法
CALL 存储过程名(实参列表);


#1.空参列表
#案例：插入到admin表中五条记录

DELIMITER $
CREATE PROCEDURE myp1()
BEGIN 
     INSERT INTO admin(username,`password`) VALUES ('张三','123'),
     ('李四','456'),('王五','456'),('赵六','456'),('钱七','456');

END $

#调用
CALL myp1()$



#2.创建带in模式参数的存储过程
#案例1：创建存储过程实现 根据女神名，查询对应的男神信息

CREATE PROCEDURE myp2(IN beautyName VARCHAR(20))
BEGIN
      SELECT bo.* FROM boys bo
      RIGHT JOIN beauty b ON bo.id = b.boyfriend_id
      WHERE b.name = beautyName;
END $


#调用
CALL myp2('柳岩')$



#案例2 创建存储过程实现，用户是否登录成功
CREATE PROCEDURE myp4(IN username VARCHAR(20),IN PASSWORD VARCHAR(20))
BEGIN 
      DECLARE result INT DEFAULT 0;#声明并初始化
      SELECT COUNT(*) INTO result #赋值
      FROM admin
      WHERE admin.username = username
      AND admin.`password` = PASSWORD;
      
      SELECT IF(result>=1,'成功','失败');#使用
      
END $

#调用
CALL myp4('张三','888')$



#3、创建带out模式的存储过程

#案例1：根据女神名，返回对应的男神名
CREATE PROCEDURE myp5(IN beautyName VARCHAR(20),OUT boyName VARCHAR(20))
BEGIN 
        SELECT bo.boyname INTO boyname 
        FROM boys bo
        INNER JOIN beauty b 
        ON bo.id = b.boyfriend_id 
        WHERE b.name = beautyName;    

END $

#调用 
CALL myp5('柳岩',@bName)$
SELECT @bName$

#案例2.根据女神名，返回对应的男神名和男神魅力值
CREATE PROCEDURE myp6(
   IN beautyName VARCHAR(20),
   OUT boyName VARCHAR(20),
   OUT userCP INT
)
BEGIN 
   SELECT bo.boyName,bo.userCP INTO boyName,userCP
   FROM boys bo
   INNER JOIN beauty b
   ON bo.id = b.boyfriend_id
   WHERE b.name = beautyName;
END $

#调用
CALL myp6('柳岩',@bName,@userCP)$
SELECT @bName,@userCP$


#4.创建带inout模式参数的存储过程
#案例1.传入a和b两个值，最终a和b都翻倍并返回 
CREATE PROCEDURE myp7(
   INOUT a INT,
   INOUT b INT
)
BEGIN 
   SET a=a*2;
   SET b=b*2;

END $

#调用
SET @m=10$
SET @n=20$

CALL myp7(@m,@n)$
SELECT @m,@n$




#一、创建存储过程实现传入用户名和密码，插入到admin表中
CREATE PROCEDURE test_pro1(
     IN username VARCHAR(20),IN PASSWORD VARCHAR(20)
)
BEGIN 
     INSERT INTO admin (admin.username,admin.password)
     VALUES(username,`password`);

END $

CALL test_pro1('孙八','123')$
SELECT * FROM admin$

#二、创建存储过程实现传入女神编号，返回女神名称和女神电话
DELIMITER $
CREATE PROCEDURE test_pro2(
   IN id INT,
   OUT NAME VARCHAR(20),
   OUT phone VARCHAR(20) 
)
BEGIN 
   SELECT b.name,b.phone INTO NAME,phone
   FROM beauty b
   WHERE b.id = id;
END $

CALL test_pro2(1,@name,@phone)$
SELECT @name,@phone$


#三、创建存储过程实现传入两个女神生日，返回大小
CREATE PROCEDURE test_pro3(
   INOUT borndate1 VARCHAR(20),
   INOUT borndate2 VARCHAR(20)
)
BEGIN 
   SET borndate1=borndate1;
   SET borndate2=borndate2;
   SELECT IF(borndate1>borndate2,'大','小');
END $

SET @borndate1 = '1992-10-10'$
SET @borndate2 = '1993-09-02'$
CALL test_pro3(@borndate1,@borndate2)$


CREATE PROCEDURE test_pro4(
  IN birts1 DATETIME,
  IN birts2 DATETIME,
  OUT result INT
)
BEGIN 
  SELECT DATEDIFF(birts1,birts2) INTO result ;

END $

CALL test_pro4('1993-10-27',NOW(),@result)$

SELECT @result$

#四、创建存储过程或函数实现传入一个日期，格式化成XX年XX月XX日并返回
CREATE PROCEDURE test_pro5(
   INOUT `date` VARCHAR(20) 
)
BEGIN 
   SET `date` =  DATE_FORMAT(`date`,'%y年%m月%d日');

END $

SET @date = '1992-02-02'$
CALL test_pro5(@date)$

SELECT @date$


CREATE PROCEDURE test_pro8(
    IN datet DATETIME,
    OUT str VARCHAR(30)
)
BEGIN 
    SELECT DATE_FORMAT(datet,'%y年%m月%d日') INTO str;

END $

CALL test_pro8(NOW(),@str)$
SELECT @str$
DROP PROCEDURE test_pro8

#五、创建存储过程或函数实现传入女神名称,返回：女神 and 男神 格式的字符串
如 传入：小昭
返回： 小昭 AND 张无忌
CREATE PROCEDURE test_pro6(
     IN btname VARCHAR(20),
     OUT tname VARCHAR(20),
     OUT bname VARCHAR(20) 
)
BEGIN
     SELECT NAME,boyName INTO tname,bname
     FROM boys bo
     RIGHT JOIN beauty b
     ON bo.id = b.boyfriend_id
     WHERE b.name = btname;
END $

SET @and = 'and'$
CALL test_pro6('柳岩',@tname,@bname)$
SELECT @tname,@and,@bname$
CALL test_pro6('周冬雨',@tname,@bname)$


CREATE PROCEDURE test_pro7(
   IN btname VARCHAR(20),
   OUT str VARCHAR(50)
)
BEGIN
   SELECT CONCAT(btname,' AND ',IFNULL(boyName,'null')) INTO str
   FROM boys bo
   RIGHT JOIN beauty b
   ON bo.id = b.boyfriend_id
   WHERE NAME = btname;
 
END $

CALL test_pro7('柳岩',@str)$
SELECT @str$


#六、创建存储过程或函数，根据传入的条目数和起始索引，查询beauty表的记录
CREATE PROCEDURE test_pro9(
  IN size INT,
  IN startindex INT 
)
BEGIN
  SELECT * FROM beauty
  LIMIT startindex,size;

END $

CALL test_pro9(5,1)$




DROP PROCEDURE test_pro9;
#二、删除存储过程
#语法： drop procedure 存储过程名 
DROP PROCEDURE myp1;#只能一次删除一个存储过程
#三、查看存储过程的信息
SHOW CREATE PROCEDURE myp2;






#函数
/*
  含义：一组预先编译好的sql语句的集合，理解成批处理语句
  好处：
    1.提高代码的重用性
    2.简化操作
    3.减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率
  
  区别：
    存储过程：(一般做增删改操作)可以有0个返回，也可以有多个返回，适合做批量插入、批量更新
    函数：有且仅有1个返回，返回做处理数据后返回一个结果
*/

#一、创建语法
CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
BEGIN 
       函数体

END
/*
   注意：
   1.参数列表 包含两部分：
   参数名 参数类型
   
   2.函数体：肯定会有return语句，如果没有会报错
   如果return语句没有放在函数体的最后也不报错，但不建议
   
   return 值;
   3.函数体中仅有一句话,则可以省略begin end
   4.使用delimiter语句设置结束标记   
   
*/

#二、调用语法
SELECT 函数名(参数列表)


#案例演示
#1.无参有返回
#案例：返回公司的员工个数
USE myemployees
DELIMITER $
CREATE FUNCTION myf1() RETURNS INT
BEGIN
    DECLARE c INT DEFAULT 0;#定义局部变量
    SELECT COUNT(*) INTO c #赋值
    FROM employees;
    RETURN c; 
END $

#调用函数
SELECT myf1()$


#2.有参有返回
#案例1：根据员工名，返回它的工资
CREATE FUNCTION myf2(last_name VARCHAR(20)) RETURNS DOUBLE
BEGIN 
     DECLARE sal DOUBLE DEFAULT 0.00;
     SELECT salary INTO sal
     FROM employees e
     WHERE e.last_name = last_name;
     
     RETURN sal;
END $

SELECT myf2('kochhar')$

#案例2：根据部门名，返回该部门的平均工资
CREATE FUNCTION myf3(depaName VARCHAR(20)) RETURNS DOUBLE
BEGIN 
       SET @avg_sal=0;#定义用户变量
       SELECT AVG(salary) INTO @avg_sal
       FROM employees e
       INNER JOIN departments d
       ON e.department_id = d.department_id
       WHERE d.department_name = depaName;
       
       RETURN @avg_sal;
END $

SELECT myf3('it')$

#三、查看函数
SHOW CREATE FUNCTION myf3


#四、删除函数
DROP FUNCTION myf3;


#案例
#一、创建函数，实现传入两个float,返回二者之和
CREATE FUNCTION myf4(a FLOAT,b FLOAT) RETURNS FLOAT
BEGIN 
     SET @sum = a + b;
     
     RETURN @sum ;
END $


SELECT myf4(1.2,1.3)$


#流程控制结构
/*
   顺序结构：程序从上往下依次执行
   分支结构：程序从两条或多条路径中选择一条去执行
   循环结构：程序在满足一定条件的基础上，重复执行一段代码
*/


#一、分支结构
#1.if函数
/*
	功能：实现简单的双分支
	语法：
	select if(表达式1,表达式2,表达式3)
	执行顺序：
	如果表达式1成立，则if函数返回表达式2的值，否则返回表达式3的值
	
	应用：任何地方
*/

#2.case结构
/*
    情况1：类似于java中的switch语句，一般用于实现等值判断
    
    语法：
        case 变量|表达式|字段
        when 要判断的值 then 返回的值1或语句1;
        when 要判断的值 then 返回的值2或语句2;
        ...
        else 要返回的值n或语句n;
        end  case;      

    情况2：类似于java中的多重if语句，一般用于实现区间判断
    
    语法：
        case 
        when 要判断的条件1 then 返回的值1或语句1;
        when 要判断的条件2 then 返回的值2或语句2;
        ...
        else 要返回的值n或语句n;
        end case;
        
    特点：
    1.可以作为表达式，嵌套在其他语句中使用，可以放在任何地方，begin end中或begin end的外面
    可以作为独立的语句去使用，只能放在begin end中
    
    2.如果when中的值满足或条件成立，则执行对应的then后面的语句，并且结束case
    如果都不满足，则执行else中的语句或值
    
    3.else可以省略，如果else省略了，并且所有when条件都不满足，则返回null
*/


#案例
#创建存储过程，根据传入的成绩，来显示等级，比如传入的成绩：
#90-100 显示A，80-90 显示B，60-80 显示C，否则显示 D
CREATE PROCEDURE test_p1(
   IN score FLOAT
)
BEGIN 
   CASE 
        WHEN score BETWEEN 90 AND 100 THEN SELECT 'A';
        WHEN score BETWEEN 80 AND 90  THEN SELECT 'B';
        WHEN score BETWEEN 60 AND 80  THEN SELECT 'C';
        ELSE SELECT 'D';
        END CASE;
END $


CALL test_p1(85)$


#3.if结构
/*
    功能：实现多重分支
    语法：
    if 条件1 then 语句1;
    elseif 条件2 then 语句2;
    ...
    【else 语句n;】
    end if;
    应用场合：应用在begin end中
*/
#案例
#创建函数，根据传入的成绩，来返回等级，比如传入的成绩：
#90-100 返回A，80-90 返回B，60-80 返回C，否则返回 D
DELIMITER $
CREATE PROCEDURE test_p3(IN score FLOAT,OUT grade CHAR)
BEGIN   
        DECLARE grade CHAR DEFAULT 'a';
        IF score BETWEEN 90 AND 100     THEN SELECT 'A' INTO grade;
        ELSEIF score BETWEEN 80 AND 90  THEN SELECT 'B' INTO grade;
        ELSEIF score BETWEEN 60 AND 80  THEN SELECT 'C' INTO grade;
        ELSE SELECT 'D' INTO grade;
        END IF ;
END $

CALL test_p2(50,@grade)$

SELECT @grade$



CREATE FUNCTION test_f2(score FLOAT ) RETURNS CHAR
BEGIN 
        IF score BETWEEN 90 AND 100     THEN RETURN 'A';
        ELSEIF score BETWEEN 80 AND 90  THEN RETURN 'B';
        ELSEIF score BETWEEN 60 AND 80  THEN RETURN 'C';
        ELSE RETURN 'D';
        END IF ;

END $




#二、循环结构
/*
   分类：
   while、loop、repeat
   
   循环控制：
   iterate类似于 continue 继续,结束本次循环，继续下一次
   leave类似于 break,跳出，结束当前所在的循环
*/

#1.while
/*    
      语法：
     【标签:】 while 循环条件 do
          循环体;
      end while 【标签】;
     
*/

#2.loop
/*    语法：
     【标签:】 loop
         循环体;
      end loop 【标签】;
      可以用来模拟简单的死循环
*/
 
#3.repeat
/*
    语法：
    【标签:】repeat
         循环体;
     until 结束循环的条件
     end repeat 【标签】; 

*/

#没有添加循环控制语句
#案例：批量插入，根据次数插入到admin表中多条记录
DROP PROCEDURE pro_test
CREATE PROCEDURE pro_test1(IN number INT)
BEGIN 
       DECLARE num INT DEFAULT 0;
       a:WHILE  num < number DO
       INSERT INTO admin(username,PASSWORD)   
       VALUES('张三','111');
       SET num = num+1;
       END WHILE a;
END $


#添加leave语句
#案例：批量插入，根据次数插入到admin表中多条记录，如果次数>20则停止
DROP PROCEDURE pro_test2
CREATE PROCEDURE pro_test2(IN number INT)
BEGIN 
     DECLARE num INT DEFAULT 1;
     a:WHILE num < number DO
	INSERT INTO admin (username,PASSWORD)
        VALUES ('张三','123');
        IF num>=20 THEN LEAVE a;
        END IF;	
	SET num = num+1;
     END WHILE a;
END $




#添加iterate语句
#案例：批量插入，根据次数插入到admin表中多条记录，只插入偶数次
TRUNCATE TABLE admin
CREATE PROCEDURE pro_test3(IN number INT)
BEGIN 
      DECLARE num INT DEFAULT -1;
      a:WHILE num < number DO
      SET num = num+1;
      IF num MOD 2 != 0 THEN ITERATE a;
      END IF;  
      INSERT INTO admin(username,PASSWORD) 
      VALUES('张三','123');
      END WHILE a;
END $



/*
 一、已知表stringcontent
	其中字段
        id 自增长
	content varchar(20)
        向该表插入指定个数的随机的字符串

*/

CREATE TABLE stringcontent(
   id INT PRIMARY KEY AUTO_INCREMENT,
   content VARCHAR(20)
)











#案例  查询员工的工种编号是 IT_PROG AD_VP AD_PRES中的一个员工名和工种编号
SELECT 
     last_name, job_id
     FROM 
   employees
     WHERE job_id IN('IT_PROG','AD_VP','AD_PRES')

#案例 查询员工号为176的员工的姓名和部门号和年薪
SELECT 
     last_name,department_id, salary * 12 *(1+IFNULL(commission_pct,0)) 年薪
   FROM 
        employees
  WHERE 
     employee_id = 176

SELECT department_id,salary * 12,last_name
   FROM employees
   WHERE last_name = 'Russell'
   
   
SELECT last_name,commission_pct,0,salary,employee_id
 FROM employees
   
   
# 查询没有奖金，且工资小于18000的salary，last_name
SELECT 
    last_name,salary
  FROM employees
 WHERE 
 commission_pct IS NULL
      AND 
  salary < 18000    
    

#查询employees表中,job_id不为it 或者工资为 12000的员工信息
SELECT job_id FROM 
   employees
  WHERE 
    job_id <>'IT' OR salary = 12000
#或者   job_id not in('IT')

#奖金不为空
SELECT * FROM employees
   WHERE commission_pct LIKE '%%'

USE myemployees



#案例  查询部门编号>=90的员工信息，并按入职时间的先后进行排序

 SELECT * FROM employees
   WHERE department_id >= 90
   ORDER BY hiredate 

#案例 按年薪的高低显示员工的信息和年薪 按表达式排序
SELECT *,salary*12+salary*12*(IFNULL(commission_pct,0)) 年薪 FROM employees
   ORDER BY 年薪 DESC



#案例 按姓名的长度显示员工的姓名和工资   按函数排序
 SELECT last_name,LENGTH(last_name) 姓名 ,salary
    FROM employees
    ORDER BY LENGTH(last_name) DESC

#案例 查询员工信息，要求先按工资排序，再按员工编号排序

SELECT * FROM
   employees
   ORDER BY salary DESC,employee_id



#length  字节个数
SHOW VARIABLES LIKE '%char%'



SELECT CONCAT(UPPER(last_name),LOWER(first_name)) 姓名
   FROM  
       employees

#注意  索引从1开始
#substr substring 截取字符


#案例：姓名中首字符大写，其他字符小写然后用_拼接 显示出来
SELECT CONCAT(UPPER(SUBSTR(last_name,1,1)),'_',LOWER(SUBSTR(last_name,2))) 姓名 
FROM employees

    






 SELECT NOW();


 
SELECT STR_TO_DATE('1998-08-02','%Y-%m-%d') 日期


#查询入职日期为1992-4-3的员工信息
SELECT hiredate
 FROM employees
 WHERE 
    hiredate = STR_TO_DATE('4-3 1992','%c-%d %Y')
    
    
    
    
#查询有奖金的员工名和入职日期（XX月/XX日  XX年）
SELECT last_name,DATE_FORMAT(hiredate,'%m月/%d日 %y年') 入职日期
   FROM employees
   WHERE commission_pct IS NOT NULL
   
SELECT VERSION();
SELECT DATABASE();
SELECT USER();

#if 函数
SELECT last_name,commission_pct,
 IF(commission_pct>0,'有奖金','没奖金')
  FROM  employees



#case 函数
/*
   案例 查询员工的工资，要求
部门号=30，显示的工资为1.1倍
部门号=40，显示的工资为1.2倍
部门号=50，显示的工资为1.3倍


*/

SELECT salary,department_id,
   CASE department_id
   WHEN 30 THEN salary * 1.1
   WHEN 40 THEN salary * 1.2
   WHEN 50 THEN salary * 1.3
   ELSE salary
   END 新工资
  FROM employees
 

#案例 ：查询员工的工资情况
/*
如果工资>20000,显示A级别
如果工资>15000,显示B级别
如果工资>10000,显示C级别
否则，显示D级别

*/
SELECT salary,
   CASE
   WHEN salary >= 20000 THEN 'A'
   WHEN salary >= 15000 THEN 'B'
   WHEN salary >= 10000 THEN 'C'
      ELSE 'D' 
   END 级别
FROM employees










#显示系统时间
SELECT NOW()

#查询员工号，姓名，工资，以及工资提高百分之20后的结果（new salary）
SELECT employee_id,last_name,salary,salary*1.2 'new salary'
 FROM employees


SELECT salary,salary+salary*0.2
   FROM employees


#将员工的姓名按首字符排序，并写出姓名的长度
SELECT last_name,SUBSTR(last_name,1,1) 首字符,LENGTH(last_name) 长度
  FROM employees
  ORDER BY 首字符
  
SELECT last_name,job_id job,
   CASE job_id
   WHEN  'AD_PRES'   THEN   'A'
   WHEN  'ST_MAN'    THEN   'B'
   WHEN  'IT_PROG'   THEN   'C'
   WHEN  'SA_REP'    THEN   'D'
   WHEN  'ST_CLERK'  THEN   'E'
   END grade
   FROM employees
   WHERE job_id = 'AD_PRES'










#查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary) 最大值, MIN(salary) 最小值,
       AVG(salary) 平均值, SUM(salary) 总和
    FROM employees


#查询员工表中的最大值入职时间和最小值入职时间的相差天数
SELECT  DATEDIFF(MAX(hiredate),MIN(hiredate)) diffrence FROM employees


#查询部门编号为90的员工个数
SELECT COUNT(*) FROM employees
  WHERE department_id = 90
  
  
  
  

#查询每个部门的平均工资
SELECT AVG(salary),department_id FROM employees
 GROUP BY department_id 
 
 
#查询每个工种的最高工资
SELECT MAX(salary),job_id
  FROM employees
  GROUP BY job_id
  
#查询每个位置上的部门个数
SELECT COUNT(*),location_id FROM departments
  GROUP BY location_id 
  


#案例邮箱中包含a字符的，每个部门的平均工资
SELECT AVG(salary),department_id,email
  FROM employees
  WHERE email LIKE '%a%'
  GROUP BY department_id
  

# 查询有奖金的每个领导手下员工的最高工资
SELECT MAX(salary),manager_id
  FROM employees
  WHERE commission_pct IS NOT NULL
  GROUP BY manager_id
  
  
SELECT DISTINCT manager_id FROM employees 



#案例 查询哪个部门的员工个数 > 2
SELECT COUNT(*) 个数,department_id
 FROM employees
 GROUP BY department_id
 HAVING 个数 > 2


#案例 查询每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
SELECT job_id,MAX(salary)
  FROM employees 
  WHERE commission_pct IS NOT NULL
  GROUP BY job_id
  HAVING MAX(salary) > 12000
  
# 案例 查询领导编号>102的每个领导手下的最低工资>5000的领导编号是哪个
#以及其最低工资

SELECT MIN(salary),manager_id
FROM employees
WHERE manager_id > 102
GROUP BY manager_id 
HAVING MIN(salary) > 5000









#案例 按员工姓名的长度分组，查询每一组的员工个数，筛选员工
#个数>5的有哪些

SELECT LENGTH(last_name),COUNT(*)
   FROM employees
   GROUP BY LENGTH(last_name)
   HAVING COUNT(*) > 5
   



#案例 查询每个部门每个工种的员工的平均工资
SELECT AVG(salary),department_id,job_id
    FROM employees
    GROUP BY department_id,job_id




#查询各job_id的员工工资的最大值，最小值，平均值，总和，并按job_id升序
SELECT 
    MAX(salary),MIN(salary),AVG(salary),SUM(salary),job_id
    FROM employees
    GROUP BY job_id
    ORDER BY job_id

#查询员工最高工资和最低工资的差距
SELECT 
    MAX(salary) - MIN(salary) DIFFERENCE
    FROM employees

#查询各个管理者手下员工的最低工资，其中最低工资不能低于6000
#没有管理者的员工不计算在内

SELECT 
     MIN(salary),manager_id
     FROM employees
     WHERE manager_id IS NOT NULL
     GROUP BY manager_id
     HAVING MIN(salary) >= 6000

#查询所有部门的编号，员工数量和工资平均值，并按平均工资降序
SELECT department_id,COUNT(*),AVG(salary)
 FROM employees
 GROUP BY department_id
 ORDER BY AVG(salary) DESC
 
#选择具有各个job_id的员工人数
SELECT job_id,COUNT(*)
 FROM employees
 GROUP BY job_id
 




# sq 92标准
#查询女神名和对应的男神名
SELECT bo.boyName,b.name FROM  beauty b, boys bo
WHERE b.boyfriend_id = bo.id

#案例 查询员工名和对应的部门名
SELECT last_name,department_name
   FROM employees e,departments d
   WHERE e.department_id = d.department_id

# 查询员工名、工种号、工种名
SELECT 
     e.last_name,e.job_id,j.job_title
     FROM employees e,jobs j
     WHERE e.job_id = j.job_id   
     
#查询有奖金的员工名、部门名
SELECT 
    last_name,department_name
    FROM employees e,departments d
    WHERE e.department_id = d.department_id
    AND commission_pct IS NOT NULL
    
#查询城市名中第二个字符为o的部门名和城市名
SELECT
      department_name,city
      FROM departments d,locations l
      WHERE d.location_id = l.location_id
      AND SUBSTR(city,2,1) = 'o'
     #AND city like '_o%'

# 查询每个城市的部门个数

SELECT city,COUNT(*)
  FROM departments d,locations l
  WHERE d.location_id = l.location_id
  GROUP BY city
  
# 查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
SELECT MIN(salary),d.department_name,
       d.manager_id
       FROM employees e,departments d
       WHERE e.department_id = d.department_id
       AND commission_pct IS NOT NULL
       GROUP BY d.department_name,d.manager_id
       

#查询每个工种的工种名和员工的个数，并且按员工个数降序
SELECT 
    job_title,COUNT(*)
    FROM employees e,jobs j
    WHERE e.job_id = j.job_id
    GROUP BY j.job_title
    ORDER BY COUNT(*) DESC

#案例 查询员工名、部门名和所在的城市
SELECT 
    last_name,department_name,city
    FROM employees e,departments d,locations l
    WHERE e.department_id = d.department_id
    AND d.location_id = l.location_id
    
# 查询员工的工资和工资级别
SELECT salary,grade_level
   FROM employees e,job_grades j
   WHERE salary BETWEEN lowest_sal AND highest_sal
   
   
   
   
#自连接
# 查询 员工名和上级名称
SELECT e.employee_id,e.last_name,m.employee_id,m.last_name
  FROM employees e,employees m
  WHERE e.manager_id = m.employee_id 



#显示员工表的最大工资，工资平均值
SELECT 
     MAX(salary),AVG(salary)
     FROM employees 


#查询员工表的employee_id job_id last_name按department_id降序，salary升序
SELECT 
     employee_id,job_id,last_name
     FROM employees
     ORDER BY department_id DESC,salary ASC
 
#查询员工表的job_id中包含a和e的,并且a在e的前面
 SELECT 
      job_id
      FROM employees
      WHERE job_id LIKE '%a%e%'


/*
  select s.name,gname,r.score
  from student s,grade g,result r
  where s.gradeId = g.id
  and s.id = r.studentNo 
*/  
  
#显示当前日期，以及去前后空格，截取子字符串的函数
SELECT 
       TRIM(NOW())

SELECT NOW();



#显示所有员工的姓名，部门号和部门名称
SELECT last_name,e.department_id,d.department_name
     FROM employees e,departments d
     WHERE e.`department_id` =  d.`department_id`


#查询90号部门员工的job_id和90号部门的location_id
SELECT 
      job_id,location_id
      FROM employees e,departments d
      WHERE e.`department_id` = d.`department_id`
      AND e.`department_id` = '90'

#  选择所有有奖金的员工的
# last_name,department_name,location_id,city

SELECT 
    last_name,d.department_name,d.location_id,city
    FROM employees e,departments d,locations l
    WHERE e.`department_id` = d.`department_id`
    AND d.`location_id` = l.location_id
    AND e.`commission_pct` IS NOT NULL
    
# 选择city在Toronto工作的员工的
# last_name,job_id,department_id,department_name

SELECT 
    last_name,job_id,d.department_id,department_name
    FROM employees e,departments d,locations l
    WHERE e.`department_id` = d.`department_id`
    AND d.`location_id` = l.location_id
    AND city =  'Toronto'  

#查询每个工种、每个部门的部门名、工种名和最低工资
SELECT
    e.job_id,department_name,job_title,MIN(salary)
    FROM employees e,departments d,jobs j
    WHERE e.`department_id` = d.`department_id`
    AND e.`job_id` = j.job_id
    GROUP BY e.`job_id`,d.`department_name`

#查询每个国家下的部门个数大于2的国家编号
SELECT
      country_id,COUNT(*)
      FROM departments d,locations l
      WHERE d.`location_id` = l.location_id
      GROUP BY country_id
      HAVING COUNT(*) > 2

#选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号
SELECT 
     e.last_name,e.employee_id,m.last_name,m.employee_id
     FROM employees e,employees m
     WHERE  e.manager_id = m.`employee_id` 
     AND e.`last_name` = 'kochhar'

     



#sql 99标准
#内连接

# 案例 查询员工名、部门名
SELECT last_name,department_name
  FROM employees e INNER JOIN departments d
  ON e.`department_id` = d.`department_id`



#案例 查询名字中包含e的员工名和工种名
SELECT last_name,job_title
    FROM employees e
    INNER JOIN jobs j
    ON e.`job_id` = j.job_id
    WHERE last_name LIKE '%e%'

#案例 查询部门个数>3的城市名和部门个数
SELECT 
      COUNT(*) 部门个数,city
      FROM departments d 
      INNER JOIN locations l
      ON d.`location_id` = l.location_id
      GROUP BY city
      HAVING COUNT(*) > 3

#案例 查询哪个部门的员工个数>3的部门名和员工个数，并按个数降序
SELECT d.department_id,department_name,COUNT(*)
    FROM employees e
    INNER JOIN departments d
    ON e.`department_id` = d.`department_id`
    GROUP BY d.department_id
    HAVING COUNT(*) > 3
    ORDER BY COUNT(*) DESC


#案例 查询员工名、部门名、工种名，并按部门名降序
SELECT
     last_name,department_name,job_title
     FROM employees e
     INNER JOIN departments d ON e.`department_id` = d.`department_id`
     INNER JOIN jobs j ON e.`job_id` = j.job_id
     ORDER BY department_name DESC


#非等值连接
# 查询员工的工资级别
SELECT 
      salary,grade_level
      FROM employees e
      JOIN job_grades g
      ON e.`salary` BETWEEN lowest_sal AND highest_sal


# 查询每个工资级别的个数>20的个数，并且按工资级别降序
SELECT 
      COUNT(*),grade_level
      FROM employees e
      JOIN job_grades g
      ON e.`salary` BETWEEN lowest_sal AND highest_sal
      GROUP BY grade_level
      HAVING COUNT(*) > 20
      ORDER BY grade_level DESC
      
      
# 自连接
#查询员工的名字、上级的名字
SELECT 
      e.last_name,m.last_name
      FROM employees e
      JOIN employees m
      ON e.`manager_id` = m.employee_id


#二 外连接

# 查询男朋友 不在男神表的女神名 
#左外
SELECT 
     b.name,bo.*
     FROM beauty b
     LEFT JOIN boys bo
     ON b.boyfriend_id = bo.id
     WHERE bo.id IS NULL


# 右外
SELECT 
    b.name,bo.*
    FROM boys bo
    RIGHT JOIN beauty b
    ON b.boyfriend_id = bo.id
    WHERE bo.id IS NULL


#案例 查询哪个部门没有员工
SELECT 
     d.*,e.employee_id
     FROM employees e
     RIGHT JOIN departments d
     ON e.department_id = d.department_id
     WHERE e.`employee_id` IS NULL












# 查询编号>3的女神的男朋友信息，如果有则列出
#详细信息，如果没有则用null填充
SELECT 
   bo.*,b.id,b.name
   FROM boys bo
   RIGHT JOIN beauty b
   ON bo.id = b.boyfriend_id
   WHERE b.id > 3


#查询哪个城市没有部门
SELECT 
    city,d.department_id
    FROM locations l
    LEFT JOIN departments d
    ON d.`location_id` = l.location_id
    WHERE d.`department_id` IS NULL

#查询部门名为sal或it的员工信息
SELECT 
   e.*,department_name
   FROM employees e
   RIGHT JOIN departments d
   ON e.`department_id` = d.`department_id`
   WHERE d.`department_name` IN ('SAL','IT')
   








#子查询
# 标量子查询（单行子查询）
# 案例 谁的工资比able高

  SELECT last_name FROM employees
  WHERE salary > (
      SELECT salary FROM employees
      WHERE last_name = 'Abel'
 );

# 案例 返回job_id与141号员工相同，salary比143号员工多的
#员工 姓名，job_id和工资
SELECT last_name,job_id,salary
      FROM employees
      WHERE job_id = (
         SELECT 
         job_id
         FROM employees
         WHERE employee_id = 141

      ) AND salary > (
	 SELECT salary FROM employees
         WHERE employee_id = 143
      )
           

#案例 返回公司工资最少的员工的last_name,job_id和salary
SELECT last_name,job_id,salary
   FROM employees
   WHERE salary = (
       SELECT MIN(salary) FROM employees 
   
   )

# 案例 查询最低工资大于50号部门 最低工资的部门id和其最低工资
SELECT MIN(salary) FROM employees
  WHERE department_id = 50



SELECT MIN(salary),department_id FROM employees
GROUP BY department_id
 HAVING MIN(salary) > (
    SELECT MIN(salary) FROM employees
    WHERE department_id = 50 
 
 )

SELECT DISTINCT department_id FROM employees

# 列子查询  （多行子查询）
#案例 返回location_id是1400或1700的部门中的所有员工姓名
SELECT 
      last_name
      FROM employees e
      WHERE department_id IN (
          SELECT DISTINCT department_id
          FROM departments
          WHERE location_id = 1400 OR location_id = 1700   
      )

# 案例 返回其它工种中比job_id为‘IT_PROG’任一工资低的员工的员工号
#姓名、job_id以及salary

SELECT 
     employee_id,last_name,job_id,salary
     FROM employees
     WHERE salary  < ANY(
         SELECT DISTINCT salary FROM employees
         WHERE job_id = 'IT_PROG'     
     ) 
     AND job_id <> 'IT_PROG'
       
#或
  SELECT 
     employee_id,last_name,job_id,salary
     FROM employees
     WHERE salary  < (
         SELECT MAX(salary) FROM employees
         WHERE job_id = 'IT_PROG'     
     ) 
     AND job_id <> 'IT_PROG'

# 案例 返回其它部门中比job_id为’IT_PROG‘部门所有工资都低的员工
#的员工号，姓名，job_id以及salary

SELECT  
    employee_id,last_name,job_id,salary
    FROM employees
    WHERE salary < ALL(
        SELECT DISTINCT salary 
          FROM employees
          WHERE job_id = 'IT_PROG'    
    ) 
       AND job_id <> 'IT_PROG'


#或
   SELECT 
      employee_id,last_name,job_id,salary
      FROM employees
      WHERE salary < (
           SELECT MIN(salary)
             FROM employees
             WHERE job_id = 'IT_PROG'      
      )  
        AND job_id <> 'IT_PORG'
