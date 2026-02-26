## 通用表表达式（Common Table Expressions）
### With 语句
#### 普通 Select 语句
```sql
WITH result AS (
    SELECT d.user_id
    FROM documents d
    GROUP BY d.user_id
),info as(
    SELECT t.*,json_build_object('id', ur.id, 'name', ur.name) AS user_info
    FROM result t
    LEFT JOIN users ur on ur.id = t.user_id
    WHERE ur.id IS NOT NULL
)select * from info
```

#### 递归查询中使用
```sql
select 
    coalesce(a."count",0) count,
    b.dt
from (
    -- 查最近7天的日期信息
    with recursive tep(dt) as (
        select 
            date_trunc('day',now()) 
        union all 
        select 
            dt - interval '1 day' dt
        from tep where dt > date_trunc('day',now() + interval '1 day') - interval '7 day' 
    )
    select 
        * 
    from tep
) b
-- 以日期为主表，保证每个日期即使未关单，也能显示数据 0
left join (
    -- 取最近7天的数据，按 日期(day) 进行分组，查询每天的关单数量
    select 
        count(1) "count", 
        date_trunc('day',t.creation_date) "sum"
    from sr.cs_incidents_t t
    where 1 = 1
    and t.creation_date >= current_date - (select 7 || 'day')::interval 
    and t.created_by = 10001
    and t.incident_status_id != 100
    group by date_trunc('day',t.creation_date)
) a on a."sum" = b.dt
```

#### 物化视图
````sql
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
````


### WITH使用注意事项
1. WITH中的数据修改语句会被执行一次，并且肯定会完全执行，无论主语句是否读取或者是否读取所有其输出。而WITH中的SELECT语句则只输出主语句中所需要记录数。
2. WITH中使用多个子句时，这些子句和主语句会并行执行，所以当存在多个修改子语句修改相同的记录时，它们的结果不可预测。
3. 所有的子句所能“看”到的数据集是一样的，所以它们看不到其它语句对目标数据集的影响。这也缓解了多子句执行顺序的不可预测性造成的影响。
4. 如果在一条SQL语句中，更新同一记录多次，只有其中一条会生效，并且很难预测哪一个会生效。
5. 如果在一条SQL语句中，同时更新和删除某条记录，则只有更新会生效。
6. 目前，任何一个被数据修改CTE的表，不允许使用条件规则，和ALSO规则以及INSTEAD规则。