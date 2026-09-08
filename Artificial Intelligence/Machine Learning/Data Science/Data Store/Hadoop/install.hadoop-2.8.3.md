http://note.youdao.com/noteshare?id=02a2a144f5b6462f8244140f091c5cf9&sub=B6CE02C1E3F64009A92FA5D916ED7251
## Hadoop 安装
0. Hadoop源码包下载
[下载地址](http://mirror.bit.edu.cn/apache/hadoop/common)

1. 集群环境

    Master 192.168.98.130
    
    Slave1 192.168.98.131
    
    Slave2 192.168.98.132

2. 下载安装包
    - Master
    ```
        wget http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-2.8.3/hadoop-2.8.3.tar.gz
        tar zxvf hadoop-2.8.3.tar.gz
    ```
3. 修改Hadoop配置文件
    - Master
        1. 解压安装、配置环境变量
            ```
            cd hadoop-2.8.3/etc/hadoop
            vim hadoop-env.sh 
            export JAVA_HOME=/usr/local/src/jdk1.8.0_152
            export HADOOP_PID_DIR=/usr/local/src/hadoop-2.8.3/bin/pid
            
            vim yarn-env.sh
            export JAVA_HOME=/usr/local/src/jdk1.8.0_152
            export YARN_PID_DIR=/usr/local/src/hadoop-2.8.3/bin/pid
            
            vim slaves
            slave1
            slave2
            ```
        2. 修改配置
            - core-site.xml
            ```
                vim core-site.xml
                <configuration>
                    <property>
                        <name>fs.defaultFS</name>
                        <value>hdfs://192.168.98.130:9000</value>
                    </property>
                    <property>
                        <name>hadoop.tmp.dir</name>
                        <value>file:/usr/local/src/hadoop-2.8.3/tmp</value>
                    </property>
                </configuration>
            ```
            - hdfs-site.xml
            ```
            vim hdfs-site.xml
            <configuration>
                <property>
                    <name>dfs.namenode.secondary.http-address</name>
                    <value>master:9001</value>
                </property>
                <property>
                    <name>dfs.namenode.name.dir</name>
                    <value>file:/usr/local/src/hadoop-2.8.3/dfs/name</value>
                </property>
                <property>
                    <name>dfs.datanode.data.dir</name>
                    <value>file:/usr/local/src/hadoop-2.8.3/dfs/data</value>
                </property>
                <property>
                    <name>dfs.repliction</name>
                    <value>3</value>
                </property>
            </configuration>
            ```
            - mapred-site.xml
            ``` 
            vim mapred-site.xml
            <configuration>
                <property>
                    <name>mapreduce.framework.name</name>
                    <value>yarn</value>
                </property>
            </configuration>
            ```
            - yarn-site.xml
            ```
            vim yarn-site.xml
            <configuration>
                <property>
                    <name>yarn.nodemanager.aux-services</name>
                    <value>mapreduce_shuffle</value>
                </property>
                    <property>
                    <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
                    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
                </property>
                    <property>
                    <name>yarn.resourcemanager.address</name>
                    <value>master:8032</value>
                </property>
                    <property>
                    <name>yarn.resourcemanager.scheduler.address</name>
                    <value>master:8030</value>
                </property>
                    <property>
                    <name>yarn.resourcemanager.resource-tracker.address</name>
                    <value>master:8035</value>
                </property>
                    <property>
                    <name>yarn.resourcemanager.admin.address</name>
                    <value>master:8033</value>
                </property>
                    <property>
                    <name>yarn.resourcemanager.webapp.address</name>
                    <value>master:8088</value>
                </property>
            </configuration>
            ```
    - 创建临时目录和文件目录
    ```
    mkdir /usr/local/src/hadoop-2.8.3/tmp
    mkdir -p /usr/local/src/hadoop-2.8.3/dfs/name
    mkdir -p /usr/local/src/hadoop-2.8.3/dfs/data
    ```
4. 配置环境变量
    1. Master、Slave1、Slave2
    ```
    vim ~/.bashrc
    HADOOP_HOME=/usr/local/src/hadoop-2.8.3
    export PATH=$PATH:$HADOOP_HOME/bin
   ```
    2. 刷新环境变量
    ```
    source ~/.bashrc
    ```
5. 拷贝安装包
    - Master
    ```
    scp -r /usr/local/src/hadoop-2.8.3 root@slave1:/usr/local/src/hadoop-2.8.3
    scp -r /usr/local/src/hadoop-2.8.3 root@slave2:/usr/local/src/hadoop-2.8.3
    ```
6. 启动集群
    - Master
    1. 初始化Namenode
    ```
        hadoop namenode -format
    ```
    2. 启动集群
    ```
        ./sbin/start-all.sh
    ```

6. 集群状态
    jps
    #Master
    
    #Slave1
    
    #Slave2

7.[监控网页](http://master:8088)

8. 操作命令
    - 和Hadoop1.0操作命令是一样的

9. 关闭集群
    ```
        ./sbin/hadoop stop-all.sh
	```	
## 问题:
1. DataNode 未启动的问题,DataNode总是掉:（NameNode 多次格式化）
    - 问题根因: 
    (当我们执行文件系统格式化时，会在namenode数据文件夹（即配置文件中dfs.name.dir在本地系统的路径）中保存一个current/VERSION文件，
       记录namespaceID，标志了所有格式化的namenode版本。如果我们频繁的格式化namenode，那么datanode中保存（即dfs.data.dir在本地系统的路径）
       的current/VERSION文件只是你地第一次格式化时保存的namenode的ID，因此就会造成namenode和datanode之间的ID不一致。
    https://blog.csdn.net/baidu_16757561/article/details/53698746		
	