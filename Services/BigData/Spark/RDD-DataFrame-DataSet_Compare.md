### RDD与DataFrame、DataSet的异同？ 
1. 相同点
    1. RDD、DataFrame、Dataset全都是spark平台下的分布式弹性数据集，为处理超大型数据提供便利
    2. 三者都有惰性机制，在进行创建、转换，如map方法时，不会立即执行，只有在遇到Action如foreach时，三者才会开始遍历运算，极端情况下，
如果代码里面有创建、转换，但是后面没有在Action中使用对应的结果，在执行时会被直接跳过.
    3. 三者都会根据spark的内存情况自动缓存运算，这样即使数据量很大，也不用担心会内存溢出
    4. 三者都有partition的概念
    5. 三者有许多共同的函数，如filter，排序等
    6. DataFrame和Dataset均可使用模式匹配获取各个字段的值和类型
2. 不同点
    1. RDD:
        1. RDD一般和spark mlib同时使用
        2. RDD不支持sparksql操作
    2. DataFrame:
        1. 与RDD和Dataset不同，DataFrame每一行的类型固定为Row，只有通过解析才能获取各个字段的值，
        2. DataFrame与Dataset均支持sparksql的操作，比如select，groupby之类，还能注册临时表/视窗，进行sql语句操作
        3. DataFrame与Dataset支持一些特别方便的保存方式，比如保存成csv，可以带上表头，这样每一列的字段名一目了然
    3. DataSet:
        1. DataFrame与DataSet主要区别在于每一行的数据类型不同,DataFrame也可以叫Dataset[Row].
             DataFrame每一行的类型是Row，不解析，每一行究竟有哪些字段，各个字段又是什么类型都无从得知，
             只能用上面提到的getAS方法或者共性中的第七条提到的模式匹配拿出特定字段

### RDD与DataFrame、DataSet直接的转换
1. DataFrame/Dataset转RDD：
    ```
    val rdd1 = dataFrame1.rdd
    ```
2. RDD转DataFrame：
    ``` 
    import spark.implicits._
    val testDF = rdd.map {line=>
          (line._1,line._2)
        }.toDF("col1","col2")
   ```
3. RDD转DataSet:
    ```
    import spark.implicits._
    case class Coltest(col1:String,col2:Int)extends Serializable //定义字段名和类型
    val testDS = rdd.map {line=>
          Coltest(line._1,line._2)
        }.toDS
    ```
4. DataFrame转Dataset：
    ```
    import spark.implicits._
    case class Coltest(col1:String,col2:Int)extends Serializable //定义字段名和类型
    val testDS = testDF.as[Coltest]
   ```