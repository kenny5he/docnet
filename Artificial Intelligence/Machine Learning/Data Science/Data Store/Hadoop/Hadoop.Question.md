## 1.namenode format
- 问题: 
    - 频繁 hadoop namenode -format 会导致 datanode掉线以及 hbase 掉线
- 解决办法:
    1. 删除 hadoop 文件hdfs-site.xml配置的dfs.namenode.name.dir 与 dfs.datanode.data.dir目录文件
    2. 删除 hbase 文件hbase-site.xml配置的hbase.zookeeper.property.dataDir目录文件
    
    
		