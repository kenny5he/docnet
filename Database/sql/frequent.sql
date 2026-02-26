/**
 * 常用 SQL语句
 */
/** 1.行专列／列转行 **/
	/** 1.1 行专列 **/
		/** 1.1.1 行专列 Case When 方式 （该方式不利于扩展，局限于数字类型） **/
			CREATE TABLE StudentScores
			(
			   userName         NVARCHAR(20) COMMENT '学生姓名',
			   subject          NVARCHAR(30) COMMENT '科目',
			   score            FLOAT COMMENT '成绩'
			);
			INSERT INTO StudentScores values('Nick', '语文', 80);
			INSERT INTO StudentScores values('Nick', '数学', 90);
			INSERT INTO StudentScores values('Nick', '英语', 70);
			INSERT INTO StudentScores values('Nick', '生物', 85);
			INSERT INTO StudentScores values('Kent', '语文', 80);
			INSERT INTO StudentScores values('Kent', '数学', 90);
			INSERT INTO StudentScores values('Kent', '英语', 70);
			INSERT INTO StudentScores values('Kent', '生物', 85);
			/** 查看学生科目得分情况 **/
			SELECT
			      UserName,
			      MAX(CASE Subject WHEN '语文' THEN Score ELSE 0 END) AS '语文',
			      MAX(CASE Subject WHEN '数学' THEN Score ELSE 0 END) AS '数学',
			      MAX(CASE Subject WHEN '英语' THEN Score ELSE 0 END) AS '英语',
			      MAX(CASE Subject WHEN '生物' THEN Score ELSE 0 END) AS '生物'
			FROM StudentScores
			GROUP BY UserName;
		/** 1.1.2 行专列 pivot 方式 **/
			create table demo(
				id int,
				name varchar(20),
				nums int
			);
			insert into demo values(1, '苹果', 1000);
			insert into demo values(2, '苹果', 2000);
			insert into demo values(3, '苹果', 4000);
			insert into demo values(4, '橘子', 5000);
			insert into demo values(5, '橘子', 3000);
			insert into demo values(6, '葡萄', 3500);
			insert into demo values(7, '芒果', 4200);
			insert into demo values(8, '芒果', 5500);
			select name, sum(nums) nums from demo group by name;--分组查询数据情况
			select * from (select name, nums from demo) pivot (sum(nums) for name in ('苹果' , '橘子', '葡萄', '芒果'));--统计各水果的数量
			--等同于piovt的sql方式
			select * from
				(select sum(nums) 苹果 from demo where name='苹果'),
				(select sum(nums) 橘子 from demo where name='橘子'),
	       		(select sum(nums) 葡萄 from demo where name='葡萄'),
	       		(select sum(nums) 芒果 from demo where name='芒果');
	/** 2.1 列转行 **/
		/** 2.1.1 列转行 unpivot **/
			create table Fruit(
				id int,
				name varchar(20),
				Q1 int,
				Q2 int,
				Q3 int,
				Q4 int
			);
			insert into Fruit values(1,'苹果',1000,2000,3300,5000);
			insert into Fruit values(2,'橘子',3000,3000,3200,1500);
			insert into Fruit values(3,'香蕉',2500,3500,2200,2500);
			insert into Fruit values(4,'葡萄',1500,2500,1200,3500);
		select id , name, jidu, xiaoshou from Fruit unpivot (xiaoshou for jidu in (q1, q2, q3, q4) );
        /** 2.1.2 列转行 union 方式 **/
		select id, name ,'Q1' jidu, (select q1 from fruit where id=f.id) xiaoshou from Fruit f
		union
		select id, name ,'Q2' jidu, (select q2 from fruit where id=f.id) xiaoshou from Fruit f
		union
		select id, name ,'Q3' jidu, (select q3 from fruit where id=f.id) xiaoshou from Fruit f
		union
		select id, name ,'Q4' jidu, (select q4 from fruit where id=f.id) xiaoshou from Fruit f;

/** 2. Select 查询条件 **/
/** 2.1 查询特定范围的数据 (有效防止数据放大) **/
select count(0)
from student
where (user_name,subject) in (('张三','语文'),('李四','数学'),('王五','英语'))