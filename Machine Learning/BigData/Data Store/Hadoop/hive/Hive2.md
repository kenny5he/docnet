# Hive02
## 作业
### 作业1
#### 1、将orders，trains建表
1. 可以先在本地目录下查看数据：`head orders.csv`查看具体的数据的样子，还有列名
2. 因为csv文件一般都是列名的：`sed '1d' orders.csv`删除第一列的列名
```sql
-- 建表
create table orders
(
order_id string,
user_id string,
eval_set string,
order_number string,
order_dow string,  
order_hour_of_day string,
days_since_prior_order string
)
row format delimited fields terminated by ',' lines terminated by '\n';

-- 导入数据
load local data inpath '/home/badou/Documents/data/order_data/orders.csv' overwrite into table orders;
```
另外一个表字段和名字稍微做下变换。
#### 2、每个用户有多少个订单
```sql
select user_id,count(1) as orders_cnt
from orders group by user_id limit 10;
```
####3、每个用户平均每个订单平均是多少商品
因为orders表中只有用户和订单的数据，需要关联priors或者trains表，才能获得到订单的数据。因为trains表中的数据量比较少，但是trains中因为是作为标签的数据，只有一个订单的数据。
可以取部分的priors来作为进行代码调试计算。加`limit`
```sql
select ord.user_id,avg(pri.products_cnt) as avg_prod
from 
(select order_id,user_id from orders)ord 
join 
(select order_id,count(1) as products_cnt from priors group by order_id)pri 
on ord.order_id=pri.order_id
group by ord.user_id
limit 10; 
```
#### 每个用户在一周中的购买订单的分布
```sql
set hive.cli.print.header=true;
select 
user_id,
sum(case order_dow when '0' then 1 else 0 end) as dow_0,
sum(case order_dow when '1' then 1 else 0 end) as dow_1,
sum(case order_dow when '2' then 1 else 0 end) as dow_2,
sum(case order_dow when '3' then 1 else 0 end) as dow_3,
sum(case order_dow when '4' then 1 else 0 end) as dow_4,
sum(case order_dow when '5' then 1 else 0 end) as dow_5,
sum(case order_dow when '6' then 1 else 0 end) as dow_6
from orders
group by user_id
limit 20;
```

### 作业2
#### 1、平均每个购买天中，购买的商品数量：
比如有一个user ，有两天是购买商品的 ：
>day 1 ：两个订单，1订单：10个product，2订单：15个product ， 共25个
day 2：一个订单， 1订单：12个product
day 3： 没有购买

>这个user 平均每个购买天的商品数量：
(25+12)/2 ,这里是**2天**有购买行为，不是**三天**。

```sql
select ord.user_id,sum(pri.products_cnt)/ count(distinct ord.days_since_prior_order) as avg_prod
from 
(select order_id,user_id, if(days_since_prior_order='',0,days_since_prior_order) as days_since_prior_order from orders)ord 
join 
(select order_id,count(1) as products_cnt from priors group by order_id)pri 
on ord.order_id=pri.order_id
group by ord.user_id
limit 10; 
```

#### 2、每个用户最喜爱购买的三个product是什么，最终表结构可以是三个列，也可以是一个字符串
比如：其中一个用户user_1 经常买
>product_1：购买了10次
product_2：购买了4次
product_3：购买了2次
product_4：购买了1次

最终需要做到：

| user_id      |     product\_top1 |   product\_top2   |product\_top3
| :-------- | --------:| :------: |:------: |
| user_1    |  product\_1  |  product_2  |product\_3|

写代码调试的时候记得加`limit`
```sql
select user_id, collect_list(product_id) as pro_top3,size(collect_list(product_id)) as top_size
from
(
select user_id,product_id, row_number() over(partition by user_id order by top_cnt desc) as row_num
from
(select ord.user_id as user_id,pri.product_id as product_id,count(1) over(partition by user_id,product_id) as top_cnt
from orders ord
join 
(select * from priors limit 1000)pri on ord.order_id=pri.order_id
-- group by ord.user_id,pri.product_id
)t 
)t1  where row_num <=3 group by user_id limit 10; 
```
## 1、内容
### 1.1、内部表与外部表
内部表与外部表的区别？
```sql
--内部表建表
create table  if not exists inner_test (
aisle_id string,                                      
aisle_name string     
)
row format delimited fields terminated by ',' lines terminated by '\n'  
stored as textfile  
location '/data/inner';

-- 或者单独的语句导入数据hdfs，本地 load data local
load data inpath '/data/inner' into table inner_test;
load data local inpath '/home/badou/Documents/data/order_data/aisle.csv' overwrite into table inner_test; 
--外部表建表，需要hdfs上面已经有对应的数据
create external table if not exists ext_test (
aisle_id string,                                      
aisle_name string      
)
row format delimited fields terminated by ',' lines terminated by '\n'  
stored as textfile  
location '/data/ext';

load data inpath '/data/ext' into table ext_test;

-- 删除内部表和外部表看看具体的数据的路径情况
drop table inner_test;
-- result : `/data/inner': No such file or directory
drop table ext_test;
-- result: /data/ext/aisles_copy_1.csv 数据还存在原来的目录中
```


### 1.2、分区表（动态分区）
- 动态分区指不需要为不同的分区添加不同的插入语句，分区不确定，需要从数据中获取。
`set hive.exec.dynamic.partition=true;`//使用动态分区
`set hive.exec.dynamic.partition.mode=nonstrict;`//无限制模式 
如果模式是strict，则必须有一个静态分区，且放在最前面。 

```sql
-- 建分区表
create table partition_test(
order_id string,                                      
user_id string,                                      
eval_set string,                                      
order_number string,                                                                            
order_hour_of_day string,                                      
days_since_prior_order string
)partitioned by(order_dow string)
row format delimited fields terminated by '\t';

--动态插入分区表
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
-- insert into table partition_test

insert overwrite table partition_test partition (order_dow='1')
select order_id,user_id,eval_set,order_number,order_hour_of_day,days_since_prior_order from orders where order_dow='1';

-- 分区表查询，必须是要加上where条件
select * from partition_test where order_dow='0' limit 10;

-- 查看表的分区
show partitions partition_test
```
### 1.3、Hive优化
#### 1.3.1、Reduce优化
每次在hive中启动sql的时候会出来一段话：
```sql
 Number of reduce tasks not specified. Estimated from input data size: 500  
In order to change the average load for a reducer (in bytes):  
  set hive.exec.reducers.bytes.per.reducer=<number>  
In order to limit the maximum number of reducers:  
  set hive.exec.reducers.max=<number>  
In order to set a constant number of reducers:  
  set mapreduce.job.reduces=<number>  
```
- `hive.exec.reducers.bytes.per.reducer`这个参数控制一个job会有多少个reducer来处理，依据多少的是输入文件的总大小。默认为1G。
- `hive.exec.reducers.max` 这个参数控制最大的reducer的数量，如果`input / bytes per reduce > max`则会启动这个参数所指定的reduce个数。这个并不会影响`mapreduce.job.reduces`参数的设置。default=999
- `mapreduce.job.reduces`这个参数如果设定了，hive就不会用它的estimation函数来自动计算reduce的个数，而是用这个参数来启动reducer。默认是-1.

为什么要有这么多参数围绕着reduce？
1. 如果reduce太少：数据量很大时，会导致这个reduce异常的慢，从而导致任务运行时间长，影响依赖任务执行延迟，也可能会OOM。
2. 如果reduce太多：产生的小文件太多，合并起来代价太高，namenode的内存占用也会增大

#### 1.3.2、reduce个数示例
```sql
-- 1KB= 1,024 bytes
-- 1MB= 1,048,576 bytes
-- 设置20k会有99个reduce
set hive.exec.reducers.bytes.per.reducer=20000;
--查询sql
select user_id,count(1) as cnt from udata group by user_id order by cnt desc limit 10;
--看一下具体的reduce个数，然后设置下具体值，增加reduce个数

-- 设置这个max会印象最终的reduce的数量么？
set hive.exec.reducers.max = 10;
set hive.exec.reducers.bytes.per.reducer=20000;
select user_id,count(1) as cnt from udata group by user_id order by cnt desc limit 10;
--最终的输出： number of mappers: 1; number of reducers: 10，reduce从99个变成最多10个

set hive.exec.reducers.max = 10;
set hive.exec.reducers.bytes.per.reducer=20000;
set mapreduce.job.reduces = 2;
select user_id,count(1) as cnt from udata group by user_id order by cnt desc limit 10;

--最终： number of mappers: 1; number of reducers: 2 

set hive.exec.reducers.max = 10;
set hive.exec.reducers.bytes.per.reducer=20000;
set mapreduce.job.reduces = 20;
select user_id,count(1) as cnt from udata group by user_id order by cnt desc limit 10;
--最终： number of mappers: 1; number of reducers: 20 证明max这个值不能限制具体reduce设定的数量
```
##### 什么情况下只有一个reduce
不管数据量多大，不管有没有设置调整reduce个数的参数，任务中一直保持只有一个reduce任务。
除了数据量未达到`hive.exec.recudcer.bytes.per.reducer`情况外，还有别的可能：
1. 进行`group by`操作但是没有进行group by 汇总，属于写代码问题,做全局统计数据量只有一个reduce：
```sql
create table if not exists tmp as
select user_id,count(1) as cnt from udata where user_id='405' group by user_id order by cnt desc limit 100;

drop table if exists tmp;

insert overwrite table tmp 
select user_id,count(1) as cnt from udata where user_id='405' group by user_id order by cnt desc limit 100;
```
2. 用了order by ，如上
3. 有笛卡尔积
什么是笛卡尔积？
```sql
create table if not exists tmp_d as
select distinct user_id from udata where cast(user_id as int) < 6;

select * from tmp_d;
select * from tmp_d join (select * from tmp_d)t;
```
##### Map jion
`/*+ MAPJOIN(tablelist) */`,必须是小表，不要超过1G
怎么设置driver内存，然后让出来的结果oom

```sql
select /*+ MAPJOIN(aisles) */ a.aisle as aisle,p.product_id as product_id 
from aisles a join products p 
on a.aisle_id=p.aisle_id limit 10;
```
#### Union 和 Union all + distinct 性能比较
在大数据量的情况下distinct + union all  性能大于 UNION 的性能
##### 1、distinct + union all场景 69s 2个job
```sql	
-- distinct + union all
select count(*) from(
select distinct * from (
select order_id,user_id,order_dow from orders where order_dow='0' union all
select order_id,user_id,order_dow from orders where order_dow='0' union 
all 
select order_id,user_id,order_dow from orders where order_dow='1'
)t
)t1;
```
##### 2、union场景 126s 3个job

```sql
-- union 
select count(*) from(
select order_id,user_id,order_dow from orders where order_dow='0' union 
select order_id,user_id,order_dow from orders where order_dow='0' union 
select order_id,user_id,order_dow from orders where order_dow='1')t;
```

#### hive中join的优化
- 一个MR任务：Total jobs = 1
```sql
-- 一个MRjob 
select ord.order_id order_id,tra.product_id product_id,pri.reordered reordered
from orders ord 
join trains tra on ord.order_id=tra.order_id
join priors pri on ord.order_id=pri.order_id
limit 10; 
```
两个MR任务：
```sql
select ord.order_id,tra.product_id,pro.aisle_id
from orders ord
join trains tra on ord.order_id=tra.order_id
join products pro on tra.product_id=pro.product_id
limit 10;
```
#### Join优化-表顺序连接
##### STREAMTABLE指定大表
最后一个表尽量是大表，因为join前一阶段生成的数据会存在于Reduce的Buffer中
```sql
select /*+STREAMTABLE(ord)*/ ord.order_id,tra.product_id,pro.aisle_id
from orders ord
join trains tra on ord.order_id=tra.order_id
join products pro on tra.product_id=pro.product_id
limit 10;
```
指定最大的表
` Starting to launch local task to process map join;      maximum memory = 477102080`

剩余的表会放到最后执行，会把<阈值的小表，map join到内存中。

##### Left Join 左连接
- 什么是左连接？
图标说明
```sql
select ord.order_id,tra.product_num
from orders ord 
left outer join (
select order_id,count(1) as product_num
from trains
-- from priors
group by order_id
)tra on ord.order_id=tra.order_id
limit 10;
```

- 左连接-表的顺序连接
```sql
--效率比较低
select ord.order_id,tra.product_id
from orders ord
left outer join
trains tra on tra.order_id=ord.order_id where ord.order_dow='0'
limit 10;

--效率比较高
select ord.order_id,tra.product_id
from orders ord
left outer join
trains tra (on tra.order_id=ord.order_id where ord.order_dow='0')
limit 10;
```
#### 数据倾斜
- `hive.groupby.skewindata`
	- 当选项设置为true：生成两个MR job。
	- 第一个MR job中，Map的输出结果集合会随机分布到Reduce中，每个Reduce做部分聚合操作，并输出结果，这样处理的结果是相同的Group By Key有可能被分到不同的Reduce中，从而达到**负载均衡**的目的；
	- 第二个MR job再根据预处理的数据结果按照Group By Key分布到Reduce中（这个过程可以保证相同的Group By Key 被分配到相同的reduce中），最终完成聚合的操作。
```sql
set hive.groupby.skewindata=true;
select product_id,count(1)
from priors
group by product_id
limit 10;
```
