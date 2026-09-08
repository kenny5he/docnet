hadoop mapreduce 
	Streaming:
		优点:
			开发效率高: 只需采用标准输入数据向标准输出写数据即可
			原有的单机程序稍加改动几个在Hadoop上进行分布式处理
			程序运行效率高(C/C++语言)
			便于平台进行资源控制，可以灵活限制应用程序的内存资源
		缺点:
			默认只能处理文本数据，二进制数据需将数据的key和value进行base64编码转换成文本
			两次数据拷贝和解析(分割)效率慢
	运行mapreduce任务：
		Python方式：
			$HADOOP_HOME/bin/hadoop \
				-input /user/input \
				-output /user/output \
				-mapper "python mapper.py" \
				-reducer "puthon reducer.py" \
				-file maper.sh \
				-jobconf maperd.job.name
			解释:
				input: 作业输入文件的HDFS路径支持多个文件或目录  
				output: 作业输出文件HDSF路径	,路径必须存在，并且具备执行作业用户有创建该目录的权限
				mapper: 必选，
				reducer: 可选，
				file: 分发执行文件给任务执行节点，文件在本地
				cacheFile: 执行文件文件在HDFS上
				jobconf: 高版本采用-D方式，
					mapred.job.name 						作业名
					mapred.job.priority					作业优先级
					mapred.job.map.capacity				最多运行map任务数
					mapred.job.reduce.capacity			最多运行reduce任务数
					mapred.task.timeout					任务没有响应的最大时间
					mapred.compress.map.output			map的输出是否压缩
					mapred.map.output.compression.codec	map的输出压缩方式
					mapred.compress.output				reduce的输出是否压缩
					mapred.output.compression.codec		reduce的输出压缩方式
					stream.map.output.field.separator	输出分割符(默认以"\t"分割)
	任务执行顺序:
		Input  ->   Spliting  ->   Mapping  ->   Shuffling  ->  Redurce   -> Finnal Result
					
	单机调试:	
		cat input | mapper | sort | reducer > output		
	
	map(进程): 主要做数据处理和数据清洗
	reduce(进程): 主要做数据聚合操作，sum 生成记录	
	spark(线程)		
		
hadoop kill job: hadoop job -kill jobid