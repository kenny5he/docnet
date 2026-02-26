Spark基于弹性分布式数据集（RDD）模型，具有良好的通用性、容错性与并行处理数据的能力
	RDD（ Resilient Distributed Dataset ）：
		弹性分布式数据集（相当于集合），它的本质是数据集的描述（只读的、可分区的分布式数据集），而不是数据集本身
	RDD的关键特征：
		RDD使用户能够显式将计算结果保存在内存中，控制数据的划分，并使用更丰富的操作集合来处理
		使用更丰富的操作来处理，只读（由一个RDD变换得到另一个RDD，但是不能对本身的RDD修改）
		记录数据的变换而不是数据本身保证容错（lineage）
			通常在不同机器上备份数据或者记录数据更新的方式完成容错，但这种对任务密集型任务代价很高
			RDD采用数据应用变换（map,filter,join），若部分数据丢失，RDD拥有足够的信息得知这部分数据是如何计算得到的，可通过重新计算来得到丢失的数据
			恢复数据方法很快，无需大量数据复制操作，可以认为Spark是基于RDD模型的系统
		懒操作，延迟计算，action的时候才操作
		瞬时性，用时才产生，用完就释放
		宽依赖、窄依赖: 
			宽依赖：父RDD的分区被子RDD的多个分区使用   例如 groupByKey、reduceByKey、sortByKey等操作会产生宽依赖，会产生shuffle
			窄依赖：父RDD的每个分区都只被子RDD的一个分区使用  例如flatMap、map、filter、union等操作会产生窄依赖
			注意：
				join操作有两种情况：
					如果两个RDD在进行join操作时，一个RDD的partition仅仅和另一个RDD中已知个数的Partition进行join，那么这种类型的join操作就是窄依赖
					由于是需要父RDD的所有partition进行join的转换，这就涉及到了shuffle，因此这种类型的join操作也是宽依赖。
获取RDD的方式:
	Spark允许从以下四个方面构建RDD
		1) 从共享文件系统中获取，如从HDFS中读数据构建RDD
			例): val a = sc.textFile(“/xxx/yyy/file”)
		2) 通过现有RDD转换得到
			例): val b = a.map(x => (x, 1))
		3) 定义一个scala数组
			例): val c = sc.parallelize(1 to 10, 1)
		4) 有一个已经存在的RDD通过持久化操作生成
			例): val d = a.persist(), a. saveAsHadoopFile(“/xxx/yyy/zzz”)		

API:
	Transformations:(作为RDD之间的变换, 懒策略，仅在对相关RDD进行action提交时才触发计算)
		map(f:T=>U): RDD[T] => RDD[U] 
			对RDD中的每个元素进行操作
		filter(f:T=>U): RDD[T] => RDD[T]
			根据条件过滤RDD
		flatMap(f: T => Seq[U]) : RDD[T] => RDD[U]
			
		sample(fraction: Float) : RDD[T] -> RDD[T](Deterministic sampling)
			
		groupByKey() : RDD[(K,V)] => RDD[(K,Seq[V])]
			
		reduceByKey(f:(V,V) => V) : RDD[(K,V)] => RDD[(K,V)]
			
		union() : (RDD[T],RDD[T]) => RDD[T]
			rdd合并，不去重
		join() : (RDD[(K,V)],RDD[(K,W)]) => RDD[(K,V,W))]
			
		cogroup() : (RDD[(K,V)],RDD[(K,W)]) => RDD[(K,(Seq[V],Seq[W]))]
			
		crossProduct() : (RDD[T],RDD[U] => RDD[(T,U)]
			
		mapValues(f: V => W) : RDD[(K,V)] => RDD[(K,W)](Preserves partioning)
			
		sort(c:Comparator[K]) : RDD[(K,V)] => RDD[(K,V)]
			
		partitionBy(p:Partitioner[K]) : RDD[(K,V)] => RDD[(K,V)]
			
	Actions:(action会对数据执行一定的操作)
		count() : RDD[T] => Long
			统计元素数量
		collect() : RDD[T] => Seq[T]
			将rdd转换成数组
		reduce(f : (T,T) => T) : RDD[T] => T
			
		lookup(k : K) : RDD[(K,V)] => Seq[v] (On hash/range partitioned RDDs)
			
		save(path:String): Outputs RDD to a storage system
			
		