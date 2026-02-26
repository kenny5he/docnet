启动耗时:
	MapReduce
		MR: map 进程，reduce 进程
	Spark: excutor进程
		10个线程: 8 map task(线程) 2个reduce (线程)
存储:
	MapReduce
		map -> reduce的中间结果在磁盘
	Spark
		map -> reduce的中间结果也在磁盘(默认)，除非进行cache调用persist默认在内存中
书写：
	MapReduce
		需要通过脚本将map和Reduce串起来，
		如果项目中有较多数据处理，写脚本比较费劲
	Spark
		只需要通过代码就能把很多数据处理串在一起

执行任务占用资源
	MapReduce		
		8个 Map 1G ，2个Reduce 1G
		Map执行完，即释放资源
	Spark
		8个 Map 1G ，2个Reduce 1G	
		Map执行完后，资源未释放，等Reduce一同执行完后再释放
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
			
			
			
			
			
			