http://note.youdao.com/noteshare?id=a57f8dfb33f934634aef768f998ae129&sub=521A3210B49245918FB07BAF26626D97

安装Hadoop1.2.1
	0. Hadoop源码包下载
		http://mirror.bit.edu.cn/apache/hadoop/common/
	
	1. 集群环境
		Master 192.168.98.130
		Slave1 192.168.98.131
		Slave2 192.168.98.132
	
	2. 关闭系统防火墙及内核防火墙
		#Master、Slave1、Slave2
		#清空系统防火墙
		iptables -F
		#保存防火墙配置
		service iptables save
		#临时关闭内核防火墙
		setenforce 0
		#永久关闭内核防火墙
		vim /etc/selinux/config
		SELINUX=disabled
	
	3. 修改主机名
		#Master
		vim /etc/sysconfig/network
		NETWORKING=yes
		HOSTNAME=master
	
		#Slave1
		vim /etc/sysconfig/network
		NETWORKING=yes
		HOSTNAME=slave1
		
		#Slave2
		vim /etc/sysconfig/network
		NETWORKING=yes
		HOSTNAME=slave2
	
	
	4. 修改主机文件
		#Master、Slave1、Slave2
		vim /etc/hosts
		192.168.98.130 master
		192.168.98.131 slave1
		192.168.98.132 slave2
	
	5. SSH互信配置
		#Master、Slave1、Slave2
		#生成密钥对（公钥和私钥）
		ssh-keygen -t rsa
		#三次回车
		cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
		chmod 600 /root/.ssh/authorized_keys
		#相互追加Key
		#Master
		ssh slave1 cat /root/.ssh/authorized_keys >> /root/.ssh/authorized_keys
		ssh slave2 cat /root/.ssh/authorized_keys >> /root/.ssh/authorized_keys
		#Slave1
		ssh master cat /root/.ssh/authorized_keys > /root/.ssh/authorized_keys
		#Slave2
		ssh master cat /root/.ssh/authorized_keys > /root/.ssh/authorized_keys	
	
	6. 安装JDK
		http://www.oracle.com/technetwork/java/javase/downloads/index.html
		#Master
		cd /usr/local/src
		wget 
		tar zxvf jdk1.8.0_152.tar.gz
	
	7. 配置JDK环境变量
		#Master、Slave1、Slave2
		vim ~/.bashrc
		JAVA_HOME=/usr/local/src/jdk1.8.0_152
		JAVA_BIN=/usr/local/src/jdk1.8.0_152/bin
		JRE_HOME=/usr/local/src/jdk1.8.0_152/jre
		CLASSPATH=/usr/local/jdk1.8.0_152/jre/lib:/usr/local/jdk1.8.0_152/lib:/usr/local/jdk1.8.0_152/jre/lib/charsets.jar
		
		PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
	
	8. JDK拷贝到Slave主机
		#Master
		scp -r /usr/local/src/jdk1.8.0_152 root@slave1:/usr/local/src/jdk1.8.0_152
		scp -r /usr/local/src/jdk1.8.0_152 root@slave2:/usr/local/src/jdk1.8.0_152
		
	9. 下载Hadoop
		#Master
		wget http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz
		tar zxvf hadoop-1.2.1.tar.gz
		cd hadoop-1.2.1.tar.gz
		mkdir tmp
	
	10. 修改Hadoop配置文件
		#Master
		cd conf
		vim masters
		master
		
		vim slaves
		slave1
		slave2
		
		vim core-site.xml
		<configuration>
		    <property>
		        <name>hadoop.tmp.dir</name>
		        <value>/usr/local/src/hadoop-1.2.1/tmp</value>
		    </property>
		    <property>
		        <name>fs.default.name</name>
		        <value>hdfs://172.16.11.97:9000</value>
		    </property>
		</configuration>
		
		 vim mapred-site.xml
		<configuration>
		 	<property>
		        <name>mapred.job.tracker</name>
		        <value>http://172.16.11.97:9001</value>
		     </property>
		</configuration>
		
		vim hdfs-site.xml
		<configuration>
		    <property>
		        <name>dfs.replication</name>
		        <value>3</value>
		    </property>
		</configuration>
		
		vim hadoop-env.sh
		export JAVA_HOME=/usr/local/src/jdk1.8.0_152
		
		<!-- 进程存储文件，默认存储/tmp/pid(/tmp目录定时清理，导致无法关闭进程) -->
		export HADOOP_PID_DIR=/usr/local/src/hadoop-1.2.1/bin/pid
		
	11. 配置环境变量
		#Master、Slave1、Slave2
		vim ~/.bashrc
		HADOOP_HOME=/usr/local/src/hadoop-1.2.1
		export PATH=$PATH:$HADOOP_HOME/bin
		#刷新环境变量
		source ~/.bashrc
		
	12. 安装包拷贝到Slave主机
		#Master
		scp -r /usr/local/src/hadoop-1.2.1 root@slave1:/usr/local/src/hadoop-1.2.1
		scp -r /usr/local/src/hadoop-1.2.1 root@slave2:/usr/local/src/hadoop-1.2.1
		       
	13. 启动集群
		#Master
		#初始化NameNode
		hadoop namenode -format
		
		#启动Hadoop集群
		start-all.sh
		
	14. 集群状态
		jps
	
	15. 监控页面
		NameNode 
		http://master:50070/dfshealth.jsp
		SecondaryNameNode
		http://master:50090/status.jsp
		DataNode
		http://slave1:50075/
		http://slave2:50075/
		JobTracker
		http://master:50030/jobtracker.jsp
		TaskTracker
		http://slave1:50060/tasktracker.jsp
		http://slave2:50060/tasktracker.jsp
		
	16.关闭集群
		stop-all.sh
	
			