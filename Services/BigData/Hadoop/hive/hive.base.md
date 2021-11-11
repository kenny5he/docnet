hive快捷键:
	清空记录: 
	
	Ctrl + C 不能结束Job，只能退出窗口:
		 Ctrl + C 的方法只是退出客户端，hive的job仍在后台运行。kill掉job，需要执行指令 hadoop job -kill job_id 指令
	展示Hadoop Job任务:
		hadoop job -list	 
		 
hive操纵数据库
	1. 创建shema/databese
		CREATE DATABASE|SCHEMA [IF NOT EXISTS] <database name>
		例: create schema badou;
	2. 使用数据库	
		use badou;
	3. 显示所有数据库
		SHOW DATABASES;		
	4.查看数据库的描述信息和文件目录位置路径信息(加上数据库键值对的属性信息)
		describe database extended badou;	
	5.创建数据库表
		1)创建内部表
			create table article(sentence String) row format delimited fields terminated by '\n';
	6.导入文件数据至表中
		--导入txt数据
		load data local inpath '/home/apaye/data/The_man_of_property.txt' overwrite into table article;
		-- 导入csv数据
		load data local inpath '/home/apaye/data/orders.csv' overwrite into table orders;
	7.hive查询wordcount
		select word, count(*) from (select explode(split(sentence, ' ')) as word from article) t group by word limit 10;
		--select explode(split(sentence,"")) as word from article;
	8.通过java 加载jdbc驱动操作hive
		blog: https://www.yiibai.com/hive/hive_create_database.html
	9.将hive的数据头显示出来
		set 	hive.cli.print.header=true;
	10.设置hive分桶
		set hive.enforce.bucketing=true;
	11.执行sql文件
		source initbadou.sql	
	
hive的数据结构:
	Table (内部表)
		Hive 本身不存储数据，数据存储在 hdsf上，hive的本质是mapreduce，通过封装mapreduce简化操作
	External Table(外部表)
	Partition(分区表)(相当于Oracle里面的Partition)
		例如: 按照季度分单(ideal2c)、按照性别分区
		不同的分区会产生不同的hdsf文件夹
	Bucket(分桶)
		分桶按照hash取模的方式将不同的数据插入到不同的桶中
		
	分桶与分区的区别:

			
		
hive支持的数据类型:
	TINYINT		1-byte signed integer, from -128 to 127
	SMALLINT		2-byte signed integer, from -32,768 to 32,767
	INT/INTEGER	4-byte signed integer, from -2,147,483,648 to 2,147,483,647
	BIGINT		8-byte signed integer, from -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
	FLOAT		4-byte single precision floating point number
	DOUBLE		8-byte double precision floating point number
	DOUBLE		PRECISION
	DECIMAL		Decimal datatype was introduced in Hive 0.11.0 (HIVE-2693) and revised in Hive 0.13.0 (HIVE-3976)
	TIMESTAMP	(HIVE 0.8版本后支持，时间戳)
	BINARY      (HIVE 0.8版本后支持)
	DECIMAL	 	从Hive0.11.0开始支持
	CHAR			从Hive0.13.0开始支持
	VARCHAR		从Hive0.12.0开始支持
	DATE			从Hive0.12.0开始支持
	
hive 优化:
	map优化:
		set mapred.max.split.size=100000000;
		set mapred.min.split.size.per.node=100000000;
		set mapred.min.split.size.per.rack=100000000;
		set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
		增加map数量
		set mapred.map.tasks=10;
		Map端聚合,Mr中的Combiners
		hive.map.aggr=true
	reduce优化	
		reduce任务处理的数据量(bytes)
		hive.exec.reducers.bytes.per.reducer=1048576;
		最大reducers量
		set hive.exec.reducers.max=10;
		设置reduce量()
		  1) set mapreduce.job.reduces=15;
		  2) set mapred.reduce.tasks=10;
	
数据倾斜
	定位Key发生倾斜
	采样、
	随机分发到不同的reduce节点，进行聚合（count）
	set hive.groupby.skewindata=true;
			  
		