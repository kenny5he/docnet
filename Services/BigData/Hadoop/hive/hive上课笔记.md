1.表字段说明
aisles.csv  departments.csv  order_products__prior.csv  order_products__train.csv  orders.csv  products.csv
1）aisles 通道 货架的编号 （二级类别） 维度表
aisle_id,aisle
1,prepared soups salads
2,specialty cheeses
3,energy granola bars
4,instant foods
5,marinades meat preparation
6,other
7,packaged meat
8,bakery desserts
9,pasta sauce

2)departments 部门 比如厨房类 （一级类别）维度表
department_id,department
1,frozen
2,other
3,bakery
4,produce
5,alcohol
6,international
7,beverages
8,pets
9,dry goods pasta

3)orders  订单表 （在hive中属于行为表）
eval_set：prior历史行为，
train训练（test中user已经购买了的其中一个商品），
test（最终我们要预测的数据集，包含哪个用户他可能会购买的商品）

order_number:这个user订单的编号，体现订单的先后顺序
order_dow:(day of week)，订单在星期几
order_hour_of_day：一天中的哪个小时（分成24小时）
days_since_prior_order：order_number后面一个订单与前面一个订单相隔天数（注意第一个订单没有）

order_id,user_id,eval_set,order_number,order_dow,order_hour_of_day,days_since_prior_order
2539329,1,prior,1,2,08,
2398795,1,prior,2,3,07,15.0
473747,1,prior,3,3,12,21.0
2254736,1,prior,4,4,07,29.0
431534,1,prior,5,4,15,28.0
3367565,1,prior,6,2,07,19.0
550135,1,prior,7,1,09,20.0
3108588,1,prior,8,1,14,14.0
2295261,1,prior,9,1,16,0.0

4)order_products__prior（500M）   order_products__train
一个订单：订单记录（33120,28985）explode 
（在hive中属于行为表）
add_to_cart_order：加购物车的位置 
reordered：这个订单是否被再次购买（是否）bool
order_id,product_id,add_to_cart_order,reordered  
2,33120,1,1
2,28985,2,1
2,9327,3,0
2,45918,4,1
2,30035,5,0
2,17794,6,1
2,40141,7,1
2,1819,8,1
2,43668,9,0

5）products 在数据库中（如果落到hive中是维度表）
product_id,product_name,aisle_id,department_id
1,Chocolate Sandwich Cookies,61,19
2,All-Seasons Salt,104,13
3,Robust Golden Unsweetened Oolong Tea,94,7
4,Smart Ones Classic Favorites Mini Rigatoni With Vodka Cream Sauce,38,1
5,Green Chile Anytime Sauce,5,13
6,Dry Nose Oil,11,11
7,Pure Coconut Water With Orange,98,7
8,Cut Russet Potatoes Steam N Mash,116,1
9,Light Strawberry Blueberry Yogurt,120,16

u.data:
user id | item id | rating | timestamp  以/t为分割

2.作业讲解
1）将orders，trains建表

 scala a.split(",").map(_+" string").mkString(",")
--order_id string,user_id string,eval_set string,order_number string,order_dow string,order_hour_of_day string,days_since_prior_order string


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
row format delimited fields terminated by ',' 
lines terminated by '\n';

-- 导入数据
load local data inpath '/home/badou/Documents/data/order_data/orders.csv' 
overwrite into table orders;

2）orders 每个用户有多少个订单  key:user_id,value:1 => sum value
select user_id,count(1) as order_cnt 
from orders 
group by user_id 
order by order_cnt desc 
limit 10;
3）每个用户平均每个订单平均是多少商品 
我今天购买了2个order，一个是10个商品，另一个是4个product
（10+4）/2 =7
  a.先用prior这个表算一个order有多少products 10，4
  
  select order_id,count(1) as prod_cnt 
  from priors 
  group by order_id
  limit 10;
  
  b. prior与order通过order_id关联 ,把订单中产品数量的信息带到每个用户里（订单中产品数量和user对应上）
  select user_id,prod_cnt
  from orders od
  join (
  select order_id,count(1) as prod_cnt 
  from priors 
  group by order_id
  limit 10000)pro
  on od.order_id=pro.order_id
  limit 10;
  
  c. 求和，一个总共购买多少产品
  select user_id,sum(prod_cnt)as sum_prods
  from orders od
  join (
  select order_id,count(1) as prod_cnt 
  from priors 
  group by order_id
  limit 10000)pro
  on od.order_id=pro.order_id
  group by user_id
  limit 10;
  
  d.求平均
  select user_id,
  sum(prod_cnt)/count(1) as sc_prod,
  avg(prod_cnt) as avg_prod 
  from (select * from orders where eval_set='prior')od --如果不是prior统计为0
  join (
  select order_id,count(1) as prod_cnt 
  from priors 
  group by order_id
  limit 10000)pro
  on od.order_id=pro.order_id
  group by user_id
  limit 10;
  
  4)每个用户在一周中的购买订单的分布(列转行)
  user_id,dow0,dow1,dow2,dow3,dow4...dow6
	1       0    0    1    2    2      0
  select 
  user_id,
  sum(case order_dow when '0' then 1 else 0 end) as dow0,
  sum(case order_dow when '1' then 1 else 0 end) as dow1,
  sum(case order_dow when '2' then 1 else 0 end) as dow2,
  sum(case order_dow when '3' then 1 else 0 end) as dow3,
  sum(case order_dow when '4' then 1 else 0 end) as dow4,
  sum(case order_dow when '5' then 1 else 0 end) as dow5,
  sum(case order_dow when '6' then 1 else 0 end) as dow6
  from orders
  group by user_id
  limit 10;

作业2：1、平均每个购买天中，购买的商品数
比如有一个user ，有两天是购买商品的 ：
day 1 ：两个订单，1订单：10个product，2订单：15个product ， 共25个
day 2：一个订单， 1订单：12个product 共12个
day 3： 没有购买 

这个user 平均每个购买天的商品数量：
(10+15+12)/2 ,这里是2天有购买行为，不是三天，也不是3个订单。

select ord.user_id,sum(pri.products_cnt)/ count(distinct ord.days_since_prior_order) as avg_prod  
--date: 2离第一个商品10天,3离第二个10天 
from 
(select order_id,
user_id, 
if(days_since_prior_order='','-1',days_since_prior_order) as days_since_prior_order 
from orders where eval_set='prior')ord 
join 
(select order_id,count(1) as products_cnt from priors group by order_id)pri 
on ord.order_id=pri.order_id
group by ord.user_id
limit 10; 

2.2、每个用户最喜爱购买的三个product是什么，最终表结构可以是三个列，也可以是一个字符串/数组
select user_id, 
collect_list(concat_ws('_',product_id,cast(row_num as string))) as pro_top3,
size(collect_list(product_id)) as top_size
from
(
select user_id,
product_id, 
row_number() over(partition by user_id order by top_cnt desc) as row_num
from
(
-- user_id，product_id,count(1)这个用户其中一个商品购买了几次
select 
ord.user_id as user_id,
pri.product_id as product_id,
count(1) over(partition by user_id,product_id) as top_cnt
from 
(select * from orders where eval_set='prior')ord
join 
(select * from priors limit 10000)pri 
on ord.order_id=pri.order_id
-- group by ord.user_id,pri.product_id
)t 
)t1  where row_num <=3 group by user_id limit 10; 

user1 product1 5   1
user1 product2 2   2
user1 product3 1   3
user2 product12 10  1
user2 product2   8  2

100142  32784   1
100142  25919   2
100142  31624   3

100142  [32784,25919,31624] 

100142  36070   4
100142  45066   5
100142  9551    6

100208  7860    1
100208  22128   2
100208  2408    3

100208  27360   4
100208  44337   5
100208  5385    6


  
3.hive内外表，分区表，业务场景
create table  if not exists inner_test (
aisle_id string,                                      
aisle_name string     
)
row format delimited fields terminated by ',' lines terminated by '\n'  
stored as textfile  
location '/data/inner';

未被external修饰的是内部表（managed table），被external修饰的为外部表（external table）(必须是文件)； 
区别： 
内部表数据由Hive自身管理，外部表数据由HDFS管理； 
内部表数据存储的位置是hive.metastore.warehouse.dir（默认：/user/hive/warehouse），外部表数据的存储位置由自己制定； 
删除内部表会直接删除元数据（metadata）及存储数据；删除外部表仅仅会删除元数据，HDFS上的文件并不会被删除； 
对内部表的修改会将修改直接同步给元数据，而对外部表的表结构和分区进行修改，则需要修复（MSCK REPAIR TABLE table_name;）

分区表：
create table partition_test(
order_id string,                                      
user_id string,                                      
eval_set string,                                      
order_number string,  
order_hour_of_day string,                                      
days_since_prior_order string
)partitioned by(order_dow string)
row format delimited fields terminated by '\t';

set hive.exec.dynamic.partition=true;
set hive.ex
ec.dynamic.partition.mode=nonstrict;

insert overwrite table partition_test partition (order_dow='1')
select order_id,user_id,eval_set,order_number,order_hour_of_day,days_since_prior_order from orders where order_dow='1' limit 10;

实时来的数据：spark streaming
dt=20180421  dt=20180422
select * from orders where dt=20180422

4.hive优化
1)跑sql的时候会出现的参数：

In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number> 
  如果大于<number>，就会多生成一个reduce
  <number> =1024    <1k 一个reduce
  1m 10个reduce
  
  set hive.exec.reducers.bytes.per.reducer=20000;
  select user_id,count(1) as order_cnt 
  from orders group by user_id limit 10;
--结果number of mappers: 1; number of reducers: 1009  
  
  
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
  set hive.exec.reducers.max=10;
 -- number of mappers: 1; number of reducers: 10 
 
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
  set mapreduce.job.reduces=5;
  --number of mappers: 1; number of reducers: 5
  set mapreduce.job.reduces=15;
  --number of mappers: 1; number of reducers: 15
  对你当前窗口，或者执行任务（脚本）过程中生效

  2)where条件使得group by冗余(影响性能)
  map 和 reduce执行过程是一个同步的过程
  同步：打电话
  异步：发短信 
  1：map执行完 reduce在执行       1+2=》3：reduce
  2：map reduce
  
  map 60%  reduce=3%
  
  3）只有一个reduce(影响性能)
  a.没有group by
  set mapreduce.job.reduces=5;
  select count(1) from orders where order_dow='0';
  --number of mappers: 1; number of reducers: 1
  b.order by
  set mapreduce.job.reduces=5;
  select user_id,order_dow 
  from orders where order_dow='0'
  order by user_id
  limit 10;
  -- number of mappers: 1; number of reducers: 1
  c.笛卡尔积(影响性能) cross product
  tmp_d
1
2
3
4
5
select * from tmp_d 
join (select * from tmp_d)t 
where tmp_d.user_id=t.user_id; --相当于on

join没有on的字段关联(性能慢)
1   1
2	1
3	1
1	2
2	2
3	2
1	3
2	3
3	3
user product(库中所有商品中调小部分觉得这个用户喜欢 召回(match) 候选集1000)  top10 
users 母婴类 products
要同时考虑users和products信息来给它们做一个筛选（粗粒度）

5）map join(必须是小表)(提升性能)
select /*+ MAPJOIN(aisles) */ a.aisle as aisle,p.product_id as product_id 
from aisles a join products p 
on a.aisle_id=p.aisle_id limit 10;


dict  hashMap  {aisle_id : aisle}
for line in products:
	ss = line.split('\t')
	aisle_id = ss[0]
	product_id = ss[1]
	aisle = dict[aisle_id]
	print '%s\t%s'%(aisle,product_id)
	
6)union all / distinct   == union( )  (union all 性能更快，直接关联，无需去重，后续再distinct)
--运行时间：74.712 seconds 2job
select count(distinct *) 
from (
select order_id,user_id,order_dow from orders where order_dow='0' union all
select order_id,user_id,order_dow from orders where order_dow='0' union all 
select order_id,user_id,order_dow from orders where order_dow='1'
)t;

--运行时间122.996 seconds 3 job
select count(*) 
from(
select order_id,user_id,order_dow from orders where order_dow='0' union 
select order_id,user_id,order_dow from orders where order_dow='0' union 
select order_id,user_id,order_dow from orders where order_dow='1')t;

7) 
set hive.groupby.skewindata=true;
将一个map reduce拆分成两个map reduce
‘-’（‘’，-1,0,null）1亿条 到一个reduce上面，

1个reduce处理6000w ‘-’ 1%     200w求和 =》1条
29 reduce处理剩余的4000w 99%

1.随机分发到不同的reduce节点，进行聚合（count）
2. 最终的一个reduce做最终结果的聚合（200w求和 =》1条）
	
select add_to_cart_order,count(1) as cnt 
from priors 
group by add_to_cart_order
limit 10; 
	
-- 没指定set hive.groupby.skewindata=true;
--Launching Job 1 out of 1
-- 1m 41s

--指定了set hive.groupby.skewindata=true;
--Launching Job 1 out of 2
-- 2m 50s

如果在不导致reduce一直失败起不来的时候，就不用这个变量
如果确实出现了其中一个reduce的处理数据量太多，导致任务一直出问题，运行时间长。这种情况需要设置这个变量。

凌晨定时任务，近一周报表，跑了3个小时。
洗出来的基础表，3点出来，7点出来，后面接了70任务 
  
  8）MR的数量
 --Launching Job 1 out of 1
 select 
 ord.order_id order_id,
 tra.product_id product_id,
 pri.reordered reordered
from orders ord 
join trains tra on ord.order_id=tra.order_id
join priors pri on ord.order_id=pri.order_id
limit 10;

--两个MR任务
 select 
 ord.order_id,
 tra.product_id,
 pro.aisle_id
from orders ord
join trains tra on ord.order_id=tra.order_id
join products pro on tra.product_id=pro.product_id
limit 10;

9）/*+ STREAMTABLE(a) */ a是大表
类似map join 放到select中的，区别：它是指定大表
select /*+STREAMTABLE(pr)*/ ord.order_id,pr.product_id,pro.aisle_id
from orders ord
join priors pr on ord.order_id=pr.order_id
join products pro on pr.product_id=pro.product_id
limit 10;

10)LEFT OUTER JOIN
select od.user_id,
od.order_id,
tr.product_id
from
(select user_id,order_id,order_dow from orders limit 100)od
left outer join
(select order_id,product_id,reordered from trains)tr 
on (od.order_id=tr.order_id and od.order_dow='0' and tr.reordered=1)
limit 30;

--join默认是inner

11)set hive.exec.parallel=true
1：map执行完 reduce在执行       1+2=》3：reduce
2：map reduce


12)
1. '-' ,where age<>'-' 直接丢掉这个数据
select age,count(1) group by age where age<>'-'

1_-  2_- 3_-

怎么定位具体哪几个key发生倾斜？
sample 

长尾数据
 


  
  
  
  
  