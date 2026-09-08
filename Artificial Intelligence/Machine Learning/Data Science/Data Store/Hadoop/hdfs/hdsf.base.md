hdsf操作:
	显示文件信息: hadoop fs -text /file 
	显示文件列表: hadoop fs -ls /
	递归文件列表: hadoop fs -lsr /
	查看文件路径大小: hadoop fs -du /
	创建文件夹: hadoop fs -mkdir /Document
	删除文件: hadoop fs -rmr /output
	上传文件: hadoop fs -put file /remoteDir
	拷贝本地文件至hdsf: hadoop fs -copyFromLocal file /
	获取文件: hadoop fs -get /file
	获取文件(文件首尾拼接，明文读取)(将目录文件聚合至一起): hadoop fs -getmerge /dir
	获取文件(文件读取，支持压缩文件)：hadoop fs -text /fileordir
	查看文件前几行信息: hadoop fs -cat /output/part-r-00000 | head -10
	
NameNode: 管理DataNode
DataNode: 存储数据，数据备份
fsimage: 在NameNode启动时对整个文件系统的快照
edit logs: 在NameNode启动后，对文件系统的改动序列	
secondary NameNode :在文件系统设置检查点来帮助NameNode更好工作，而不是取代NameNode
DataBlockSanner: 定期检查数据块，防止物理顺坏。

写:
	DistributedFileSystem 类 create方法
	FSDataOutputStream 类 write方法
	FSDataInputStream 类 read方法
	
读取步骤:
	client -> NameNode -> block -> DataNode -> Block
