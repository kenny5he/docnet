product产品统计/特征
    1. 统计product被购买的数量
        //加载数据
        val orders  = sqlContext.sql("select * from badou.orders");
        val products = sqlContext.sql("select * from badou.products");
        val priors = sqlContext.sql("select * from badou.order_products_prior");
        priors.groupBy("product_id").count().show(10);
        //将product count 加入缓存中，方便下次使用不再重复计算
        val productCnt = priors.groupBy("product_id").count().cache;
    2. 统计product被reordered的数量(再次购买数量)
        //filter 与 where 作用一致
        orders.filter(col("eval_set")==="test").show(5)
        orders.where(col("eval_set")==="test").show(5)
        //agg 一般搭配groupBy 聚合函数使用和单独使用sum的差别，是在一次聚合可以统计出来
        priors.selectExpr("product_id","cast(reordered as int)").groupBy("product_id").sum("reordered")
        priors.selectExpr("product_id","cast(reordered as int)").groupBy("product_id").agg(sum("reordered"),avg("reordered"))
    3. 结合上面数量统计product购买reordered的比率
        val productSumReorder = priors.selectExpr("product_id","cast(reordered as int)")
            .groupBy("product_id").agg(sum("reordered"),avg("reordered"))
            .withColumnRenamed("sum(reordered)","sum_re").withColumnRenamed("avg(reordered)","avg_re")
        val jproduct = productCnt.join(productSumReorder,"product_id");
        //引入 function  udf 在function中
        import org.apache.spark.sql.functions._
        val avg_udf = udf((sm:Long,cnt:Long)=>sm.toDouble/cnt.toDouble);
        jproduct.withColumn("mean_re",avg_udf(col("sum_re"),col("count"))).show(10)

user 统计/特征
    1.每个用户平均购买订单的间隔周期
        //用户的第一个订单是没有时间间隔天数的
            //用if 判断 间隔时间列是否为空，如果为空则赋值为0，否则取间隔时间
            //使用drop 将列days_since_prior_order删除
        val ordersNew = orders.selectExpr("*","if(days_since_prior_order='',0,days_since_prior_order) as dspo")
            .drop("days_since_prior_order");
        ordersNew.selectExpr("user_id","cast(dspo as int)").groupBy("user_id").avg("dspo").show()
    2.每个用户的总订单数量
        orders.groupBy("user_id").count()
    3.每个用户购买的product商品去重后的集合数据
        val op = orders.join(priors,"order_id").select("user_id","product_id").cache;
        //DataFrame转RDD
        var rddRecord = op.rdd.map(x=>(x(0).toString,x(1).toString)).groupByKey()
            .mapValues{record => record.toSet.mkString(",")}
        //RDD转DataFrame
        rddRecord.toDF("user_id","product_records").show(5)
        rddRecord.toDF("user_id","product_records").selectExpr("user_id","size(split(product_records,",")) as pro_dist_cnt")

        //同时取 product去重集合size 和 结果集
        val rddRecord  = op.rdd.map(x=>(x(0).toString,x(1).toString)).groupByKey()
            .mapValues{record =>
                val rs = record.toSet
                (rs.size,rs.mkString(","))
            }.toDF("user_id","tuple")
            .selectExpr("user_id","tuple._1 as prod_dist_cnt","tuple._2 as product_record")
    4.每个用户总商品数量以及去重后的商品数量
        orders.join(priors,"order_id").groupBy("user_id").count().show(5)
    5.每个用户购买的平均每个订单的商品数量
        先求每个订单的商品数量
        val ordProCn = priors.groupBy("order_id").count()
        求每个用户订单商品个数的平均值，对user做聚合，avg 商品个数
        orders.join(ordProCn,"order_id").groupBy("user_id").avg("count")

