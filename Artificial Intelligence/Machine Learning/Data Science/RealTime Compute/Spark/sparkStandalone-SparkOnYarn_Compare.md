Spark standalon: 独立模式，类似MapReduce1.0采取的模式，完全由内部实现容错性和资源管理
Spark On Yarn: 让Spark运行在一个通用的资源管理系统之上，这样可以与其他计算框架共享资源

Yarn Client: 适用于交互与调试
	Driver在任务提交机上执行
	ApplicationMaster只负责向ResourceManager申请executor需要的资源
	基于yarn时，Spark-shell和pyspark必须使用yarn-client模式
	Client会和请求的container通信来调度任务，Client不能离开
Yarn Cluster: 适用于生产环境 (不适合交互型作业)
	Driver运行在AM中，负责向Yarn申请资源，并监督作业运行情况，
	当用户提交完作用后，就关掉Client,作业继续在Yarn上运行，
	
	
	
Yarn (Yet Another Resource Negotiator，另一种资源协调者)(通用)
	Master/Slave结构
		RM：全局资源管理器，负责系统的资源管理和分配
		NM：每个节点上的资源和任务管理器
		AM：每个应用程序都有一个，负责任务调度和监视，并与RM调度器协商为任务获取资源
Standalone（Spark自带）
	Master/Slave结构
		Master：类似Yarn中的RM(ResourceManager)
		Worker：类似Yarn中的NM	(NodeManager)