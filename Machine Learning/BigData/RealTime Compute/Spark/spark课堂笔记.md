df_seg = df.withColumn('seg',seg_udf(df.content))

最终的需求：预测，在test里面的用户下一个订单会购买哪些商品
比如：
user3，已经有了5月5号的订单（不公开）来评测模型的

我们有的是5月4号之前的历史数据
我们需要，通过历史（5月4号之前订单数据）
预测这个用户5月5号买了什么


product：
1.orders做product的数量统计（销售量）
hive: group by count
spark:
import spark.sql
var priors = sql("select * from badou.orders");
val productCnt = priors.groupBy("product_id").count()

2.统计product 被reordered的数量（再次购买）（这商品是不是消耗品）
product_id做group by(聚合)，统计一下sum（reorder）的值

当一个商品再次购买比率比较高，那下次购买的可能性更高

priors
.selectExpr("product_id","cast(reordered as int)")
.filter(col("reordered")===1)
.groupBy("product_id")
.count()

priors.selectExpr("product_id","cast(reordered as int)")
.groupBy("product_id").sum("reordered")

priors.selectExpr("product_id","cast(reordered as int)")
.groupBy("product_id").agg(sum("reordered"),avg("reordered"))
agg一般是搭配groupby这种聚合函数使用
和单独使用sum的差别，是在一次聚合中可以统计出来多个值

3.结合上面数量统计product购买的reordered 的比率avg("reordered")

val jproduct = productCnt.join(prodcutSumReorder,"product_id")


udf：
import org.apache.spark.sql.functions._
val avg_udf = udf((sm:Long,cnt:Long)=>sm.toDouble/cnt.toDouble)
udf的使用：
jproduct.withColumn("mean_re",avg_udf(col("sum_re"),col("count"))).show(5)
jproduct.selectExpr("*","sum_re/count as mean_re")

user 统计/特征 
1.每个用户平均购买订单的间隔周期

1)、用户的第一个订单没有间隔天数的，需要赋值为0

val ordersNew =orders.selectExpr("*","if(days_since_prior_order='',0,days_since_prior_order) as dspo")
.drop("days_since_prior_order").show()

ordersNew.selectExpr("user_id","cast(dspo as int)")
.groupBy("user_id").avg("dspo").show()

2.每个用户的总订单数量
orders.groupBy("user_id").count().show()

3.每个用户购买的product商品去重后的集合数据
val po = orders.join(priors,"order_id").select("user_id","product_id").show(5)

DataFrame转RDD处理：
val rddRecords=op.rdd.map(x=>(x(0).toString,x(1).toString))
.groupByKey()
.mapValues(_.toSet.mkString(","))

RDD转DataFrame：
需要隐式转换：
import spark.implicits._
rddRecords.toDF("user_id","product_records")

4.每个用户总商品数量以及去重后的商品数量
总商品数量:
orders.join(priors,"order_id").groupBy("user_id").count().show(5)

同时取到product去重的集合和集合的大小
val rddRecords=po.rdd.map(x=>(x(0).toString,x(1).toString))
      .groupByKey()
      .mapValues{record=>
        val rs = record.toSet
        (rs.size,rs.mkString(","))
      }.toDF("user_id","tuple")
      .selectExpr("user_id","tuple._1 as prod_dist_cnt","tuple._2 as prod_records")



5.每个用户购买的平均每个订单的商品数量

1）先求每个订单的商品数量【对订单做聚合count（）】
val ordProCnt = priors.groupBy("order_id").count()

2）求每个用户订单中商品个数的平均值【对user做聚合，avg（商品个数）】
orders.join(ordProCnt,"order_id").groupBy("user_id").avg("count")






