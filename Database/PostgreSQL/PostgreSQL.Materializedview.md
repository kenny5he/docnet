## Materialized View 物化视图
### 理解物化视图
1. 什么是物化视图？
2. 物化视图与视图的区别？
3. 物化视图的使用场景？
    1. 将复杂查询视图化，提高检索的能力，作用于实时性(数据同步至雾化视图的实时性)不是非常高，例如非秒级实时场景，分钟级以上皆可，因为同步上存在延迟
    2. 远程视图本地化，用于有些查询需要消耗非常高的远程IO，导致查询时间非常缓慢的场景，可通过物化视图实现本地查询的效果，快速返回结果
    3. 可以当作是一张独立的表，可以与其他表进行关联查询，减小查询io，快速返回结果
    4. 可独立构建特定查询字段的索引，以此达到快速检索的目的
### 使用雾化视图
1. 创建雾化视图
   ```sql
   CREATE MATERIALIZED VIEW ten_month_goods AS
   select
      GSID,
      NO,
      TYPE,
      STATUS,
      GOODS_NAME,
      GOODS_BIG_TYPE_ID_INT,
      GOODS_TYPE_NAME,
      START_PROVINCE,
      START_CITY,
      START_DISTRICT,
      START_LOCATION,
      END_PROVINCE,
      END_CITY,
      END_DISTRICT,
      END_LOCATION,
      RELEASE_TIME,
      CONTACT,
      USE_VC_TYPE,
      USE_VC_LENGTH
   from
      tra_goods_source
   where
      1 = 1
     and release_time >=(now() - interval '10 month')
   ```
2. 刷新物化视图
   ```sql
   -- 全量刷新视图，但是这个时候，视图会被锁住，导致所有查询都无法正常查询,全量刷新，速度较快,400万条数据大概耗时大概在 30s左右
   REFRESH MATERIALIZED VIEW ten_month_goods;
   ```
3. 增量刷新物化视图
   ```sql
   -- 唯一索引构建，必须至少有一个唯一索引，才能使用增量物化视图
   CREATE UNIQUE INDEX uni_ten_month_goods
   on ten_month_goods (gsid);
   -- 根据唯一索引刷新视图,但是速度非常慢,7倍左右的时间消耗，400万条数据大概耗时大概在 150s左右
   REFRESH  MATERIALIZED VIEW CONCURRENTLY ten_month_goods;
   ```
4. 在查询语句中创建并使用临时雾化视图
   ```sql
   with ten_month_goods as materialized(
   select
      gsid,
      no,
      type,
      status,
      goods_name,
      goods_big_type_id_int,
      goods_type_name,
      start_province,
      start_city,
      start_district,
      start_location,
      end_province,
      end_city,
      end_district,
      end_location,
      release_time,
      contact,
      use_vc_type,
      use_vc_length
   from
      tra_goods_source
   where
      1 = 1
     and release_time >=(now() - interval '10 month'))
   select
      *
   from
      tra_goods_source tgs,
      ten_month_goods tmg
   where
      tgs.gsid = tmg.gsid
   ```
