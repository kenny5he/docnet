Spark中：
	应用程序：由一个driver program和多个job构成
		Job：由多个stage组成
		Stage：对应一个taskset
		Taskset：对应一组关联的相互之间没有shuffle依赖关系的task组成
		Task：任务最小的工作单元
	Driver Program：（驱动程序）是Spark的核心组件
		构建SparkContext（Spark应用的入口，创建需要的变量，还包含集群的配置信息等）
		将用户提交的job转换为DAG图（类似数据处理的流程图）
		根据策略将DAG图划分为多个stage，根据分区从而生成一系列tasks
		根据tasks要求向RM申请资源
		提交任务并检测任务状态
	Executor：
		真正执行task的单元，一个Work Node上可以有多个Executor