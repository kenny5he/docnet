0. Spark源码包下载
	mirror.bit.edu.cn/apache/spark/

1. 集群环境
	Master 192.168.98.130
	Slave1 192.168.98.131
	Slave2 192.168.98.132

2. 下载软件包
	#Master
	wget http://mirror.bit.edu.cn/apache/spark/spark-1.6.3/spark-1.6.3-bin-hadoop2.6.tgz
	tar zxvf spark-1.6.3-bin-hadoop2.6.tgz
	
	wget https://downloads.lightbend.com/scala/2.12.4/scala-2.12.4.tgz
	tar zxvf scala-2.12.4.tgz

3. 修改Spark配置文件
	cd /usr/local/src/spark-1.6.3-bin-hadoop2.6/conf
	vim spark-env.sh
	export SCALA_HOME=/usr/local/src/scala-2.12.4
	export JAVA_HOME=/usr/local/src/jdk1.8.0_152
	export HADOOP_HOME=/usr/local/src/hadoop-2.8.2
	export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
	SPARK_MASTER_IP=master
	SPARK_LOCAL_DIRS=/usr/local/src/spark-1.6.3-bin-hadoop2.6
	SPARK_DRIVER_MEMORY=2G
	#防止 pid 文件被清理掉，进程无法关闭
	SPARK_PID_DIR=/usr/local/src/spark-1.6.3-bin-hadoop2.6/pid

	vim slaves
	slave1
	slave2

4. 拷贝安装包
	scp -r /usr/local/src/spark-1.6.3-bin-hadoop2.6 apaye@slave1:/usr/local/src/spark-1.6.3-bin-hadoop2.6
	scp -r /usr/local/src/spark-1.6.3-bin-hadoop2.6 apaye@slave2:/usr/local/src/spark-1.6.3-bin-hadoop2.6
	
	scp -r /usr/local/src/scala-2.12.4 apaye@slave1:/usr/local/src/scala-2.12.4
	scp -r /usr/local/src/scala-2.12.4 apaye@slave2:/usr/local/src/scala-2.12.4

5. 启动集群
	cd /usr/local/src/spark-1.6.3-bin-hadoop2.6/
	./sbin/start-all.sh

6. 网页监控面板
	master:8080

7. 验证
	#本地模式
	./bin/run-example SparkPi 10 --master local[2]
	
	#集群Standlone(独立模式)
		./bin/spark-submit --class org.apache.spark.examples.SparkPi --master spark://master:7077 lib/spark-examples-1.6.3-hadoop2.6.0.jar 100
		限定内存1G
		./bin/spark-submit --class org.apache.spark.examples.SparkPi --executor-memory 1024M --master spark://master:7077 lib/spark-examples-1.6.3-hadoop2.6.0.jar 100
	
	#集群
	Spark on Yarn
	./bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn-cluster lib/spark-examples-1.6.3-hadoop2.6.0.jar 10