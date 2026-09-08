Partition(分区):
	1.1 实现细节
		1、一个表可以拥有一个或者多个分区，每个分区以文件夹的形式单独存在表文件夹的目录下。 
		2、表和列名不区分大小写。 
		3、分区是以字段的形式在表结构中存在，通过describe table命令可以查看到字段存在， 但是该字段不存放实际的数据内容，仅仅是分区的表示（伪列） 。 
	1.2 语法
		1. 创建一个分区表，以 ds 为分区列： 
		create table invites (id int, name string) partitioned by (ds string) row format delimited fields terminated by 't' stored as textfile; 
		2. 将数据添加到时间为 2013-08-16 这个分区中： 
		load data local inpath '/home/hadoop/Desktop/data.txt' overwrite into table invites partition (ds='2013-08-16'); 
		3. 将数据添加到时间为 2013-08-20 这个分区中： 
		load data local inpath '/home/hadoop/Desktop/data.txt' overwrite into table invites partition (ds='2013-08-20'); 
		4. 从一个分区中查询数据： 
		select * from invites where ds ='2013-08-12'; 
		5.  往一个分区表的某一个分区中添加数据： 
		insert overwrite table invites partition (ds='2013-08-12') select id,max(name) from test group by id; 
		可以查看分区的具体情况，使用命令： 
			hadoop fs -ls /home/hadoop.hive/warehouse/invites 或者： show partitions tablename;

Bucket(分桶): 
	分桶理由: 
	（1）获得更高的查询处理效率。桶为表加上了额外的结构，Hive 在处理有些查询时能利用这个结构。具体而言，连接两个在（包含连接列的）相同列上划分了桶的表，
		可以使用 Map 端连接 （Map-side join）高效的实现。比如JOIN操作。对于JOIN操作两个表有一个相同的列，如果对这两个表都进行了桶操作。
	  	那么将保存相同列值的桶进行JOIN操作就可以，可以大大较少JOIN的数据量。
	（2）使取样（sampling）更高效。在处理大规模数据集时，在开发和修改查询的阶段，如果能在数据集的一小部分数据上试运行查询，会带来很多方便。

	1. 创建带桶的 table ：
		create table bucketed_user(id int,name string) 
		clustered by (id) sorted by(name) into 4 buckets row format delimited fields 
		terminated by '\t' stored as textfile; 
	2. 强制多个 reduce 进行输出：
		要向分桶表中填充成员，需要将 hive.enforce.bucketing 属性设置为 true。①这 样，Hive 就知道用表定义中声明的数量来创建桶。
		然后使用 INSERT 命令即可。需要注意的是： clustered by和sorted by不会影响数据的导入，这意味着，用户必须自己负责数据如何如何导入，包括数据的分桶和排序。 
		'set hive.enforce.bucketing = true' 可以自动控制上一轮reduce的数量从而适配bucket的个数，当然，
		用户也可以自主设置mapred.reduce.tasks去适配bucket个数，推荐使用'set hive.enforce.bucketing = true'  
	3. 往表中插入数据：
		INSERT OVERWRITE TABLE bucketed_users SELECT * FROM users; 
		物理上，每个桶就是表(或分区）目录里的一个文件。它的文件名并不重要，但是桶 n 是按照字典序排列的第 n 个文件。事实上，
		桶对应于 MapReduce 的输出文件分区：一个作业产生的桶(输出文件)和reduce任务个数相同。我们可以通过查看刚才 
		创建的bucketd_users表的布局来了解这一情况。运行如下命令：  
	4. 查看表的结构：
		dfs -ls /user/hive/warehouse/bucketed_users; 
	5. 读取数据，看每一个文件的数据：
		dfs -cat /user/hive/warehouse/bucketed_users/*0_0; 
		用TABLESAMPLE子句对表进行取样，我们可以获得相同的结果。这个子句会将 查询限定在表的一部分桶内，而不是使用整个表：
	6. 对桶中的数据进行采样：
		SELECT * FROM bucketed_users TABLESAMPLE(BUCKET 1 OUT OF 4 ON id); 
	7. 查询一半返回的桶数：
		SELECT * FROM bucketed_users TABLESAMPLE(BUCKET 1 OUT OF 2 ON id)； 
		
	查询Bucket的问题：
		tablesample是抽样语句，语法：TABLESAMPLE(BUCKET x OUT OF y)，y必须是table总bucket数的倍数或者因子。hive根据y的大小，决定抽样的比例。
			例如:table总共分了64份，当y=32时，抽取(64/32=)2个bucket的数据，当y=128时，抽取(64/128=)1/2个bucket的数据。
				x表示从哪个bucket开始抽取。例如，table总bucket数为32，tablesample(bucket 3 out of 16)，表示总共抽取（32/16=）2个bucket的数据，
				分别为第3个bucket和第（3+16=）19个bucket的数据。

		
		
		