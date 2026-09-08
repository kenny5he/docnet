hive mysql配置: https://blog.csdn.net/reesun/article/details/8556078

安装hive:
	0. Hive源码包下载
		http://mirror.bit.edu.cn/apache/hive/
	
	1. 集群环境
		Master 192.168.98.130
		Slave1 192.168.98.131
		Slave2 192.168.98.132
	
	2. 下载软件包
		#Master
		wget http://mirror.bit.edu.cn/apache/hive/hive-1.2.2/apache-hive-1.2.2-bin.tar.gz
		tar zxvf apache-hive-1.2.2-bin.tar.gz
		
	3. 修改Hive配置文件
		#Master
		cd apache-hive-1.2.2-bin/conf
		1)配置hive-site.xml
			vim hive-site.xml
			<configuration>
		        <property>
		                <name>javax.jdo.option.ConnectionURL</name>
		                <value>jdbc:mysql://master:3306/hive?createDatabaseIfNotExist=true</value>
		        </property>
		        <property>
		                <name>javax.jdo.option.ConnectionDriverName</name>
		                <value>com.mysql.jdbc.Driver</value>
		        </property>
		        <property>
		                <name>javax.jdo.option.ConnectionUserName</name>
		                <value>root</value>
		        </property>
		        <property>
		                <name>javax.jdo.option.ConnectionPassword</name>
		                <value>dmt.123</value>
		        </property>
		        <property>
		            <name>system:java.io.tmpdir</name>
		            <value>/tmp/hadoop/apache-hive-1.2.0-bin/iotmp</value>
		        </property>
		        <property>
		                <name>system:user.name</name>
		                <value>hive</value>
		        </property>
		        <!--  hive表的默认存储路径 -->
		        <property>
		                <name>hive.metastore.warehouse.dir</name>
		                <value>mkdir -p /home/apaye/Documents/hadoop/hive/warehouse</value>
		        			<description>location of default database for the warehouse</description>
		        </property>
			</configuration>
		2)配置hive 环境
			vi hive-env.sh
			#配置hadoop路径
			HADOOP_HOME=/usr/local/src/hadoop-2.8.3
			#配置hive conf路径
			export HIVE_CONF_DIR=/usr/local/src/apache-hive-1.2.2-bin/conf
			#配置hive lib路径
			export HIVE_AUX_JARS_PATH=/usr/local/src/apache-hive-1.2.2-bin/lib
	4.创建文件夹
		hadoop fs -mkdir /tmp/hive
		hadoop fs -chmod 733 /tmp/hive
	5.  增加环境变量
	#Master、Slave1、Slave2
	vim ~/.bashrc
	export HIVE_HOME=/usr/local/src/apache-hive-1.2.2-bin
	export PATH=$HIVE_HOME/bin:$PATH
	#刷新环境变量
	source ~/.bashrc
	
	6. 安装MySQL连接Jar 
	#Master
		1）下载安装包
		wget https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.44.tar.gz
		tar zxvf mysql-connector-java-5.1.44.tar.gz
		2）复制连接库文件
		cp mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar /usr/local/src/apache-hive-1.2.2-bin/lib
		
	7. 拷贝(避免报错: org/apache/hadoop/hive/cli/CliDriver : Unsupported major.minor version 51.0)
		把jline-2.12.jar拷贝到hadoop相应的目录下，替代jline-0.9.94.jar，否则启动会报错
		cp /home/hdpsrc/hive/lib/jline-2.12.jar /home/hdpsrc/hadoop-2.5.0/share/hadoop/yarn/lib/	
	8. 拷贝安装包
		#Master
		scp -r /usr/local/src/apache-hive-1.2.2-bin root@slave1:/usr/local/src/apache-hive-1.2.2-bin
		scp -r /usr/local/src/apache-hive-1.2.2-bin root@slave2:/usr/local/src/apache-hive-1.2.2-bin
		
	9. 初始化数据库（Master） 
		schematool -dbType mysql -initSchema
		
	10.	启动服务端（Master） 
		方式一: 
			后台启动metastore：hive --service metastore &
			后台启动hiveserver：hive --service hiveserver &
				(错误排查命令：hive-hiveconf hive.root.logger=DEBUG,console)

	    关闭Server:
	        jps --> RunJar
	        kill -9 xxx

	11. 启动Hive服务
		#Master
		hive
	12. hive 连接Mysql UTF-8字符问题处理
		use hive;
		/**修改字段注释字符集**/
		alter table COLUMNS_V2 modify column COMMENT varchar(256) character set utf8;
		/**修改表注释字符集**/
		alter table TABLE_PARAMS modify column PARAM_VALUE varchar(4000) character set utf8;
		/**修改分区注释字符集**/
		alter table PARTITION_KEYS modify column PKEY_COMMENT varchar(4000) character set utf8;
		/**查询字符编码集信息**/
		show variables like '%char%';	
	
	13.启动异常:
		启动hive时报的错误
			1）WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
				解决方案: export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=${HADOOP_HOME}/lib/native"
				blog: https://www.cnblogs.com/likui360/p/6558749.html
	14. 退出hive命令行
		quit;		
		
	15. ===常用的CLI命令
		--清屏：Ctrl + L 或者!clear
		--查看数据仓库中的表：show tables;
		--查看数据仓库中的内置函数：show functions;
		--查看表结构：desc 表名
		--查看HDFS上的文件：dfs -ls 目录，或者，dfs -lsr 目录（以递归的方式查看目录）
		--执行操作系统的命令：!命令
		--执行HQL语句：select * from test1;
		　注意：select * 的查询语句并不会转换成MapReduce作业。
		--执行SQL的脚本：source SQL文件
		*以上命令是在进入命令行模式下执行的，也可以不进入命令行模式来执行。hive -e 'show tables';
	
	16. ===CLI的静默模式命令
		通常在执行SQL等脚本的时候，会转换成MapReduce作业，所以在控制台中会出现大量的日志信息。
		如果不想关注这些日志信息，就可以启动CLI的静默模式。
		--启动方法：hive -S（S为大写）
			
			
			
		
