--创建badou  schema
create schema if not exists badou;
--删除 schema
--drop schema badou;
--使用 badou schema
use badou;

--创建用户表
--create table users
--(
--
--)
--row format delimited fields terminated by ',' 
--lines terminated by '\n';

--创建一级品类表( 部门/类别 比如厨房类 )
create table departments
(
department_id String,
department String
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

--通过hive 加载csv中的数据保存至hdsf中
load data local inpath '/home/apaye/data/departments.csv' overwrite into table departments;

--创建二级品类表( 货架表 )
	-- row format delimited fields terminated by ','   通过,号分割列数据   
	-- lines terminated by '\n   通过\n分割行数据
create table aisles
(
aisle_id String,
aisle String
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

--通过hive 加载csv中的数据保存至hdsf中
load data local inpath '/home/apaye/data/aisles.csv' overwrite into table aisles;

--创建产品表
	--scala 拼写表字段    str.split(",").map(_+" String").mkString(",") 
		--退出scala  :quit
create table products
(
product_id String,
product_name String,
aisle_id String,
department_id String
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

--通过hive 加载csv中的数据保存至hdsf中
load data local inpath '/home/apaye/data/products.csv' overwrite into table products;

--创建订单表
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

--  通过hive 加载csv中的数据保存至hdsf中
load data local inpath '/home/apaye/data/orders.csv' overwrite into table orders;

--创建 订单记录表
create table order_products_train(
order_id String,
product_id String,
add_to_cart_order String,
reordered String
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

--  通过hive 加载csv中的数据保存至hdsf中
load data local inpath '/home/apaye/data/order_products__train.csv' overwrite into table order_products__train;

--创建 订单记录表(历史记录)
create table order_products_prior(
order_id String,
product_id String,
add_to_cart_order String,
reordered String
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

--  通过hive 加载csv中的数据保存至hdsf中
load data local inpath '/home/apaye/data/order_products__prior.csv' overwrite into table order_products__prior;

--order by 必须在同一个reduce 上 sort by 可以在不同reduce上

--作业:
-- 1. 计算orders 每个用户有多少个订单
select o.user_id,count(0) as cnt from orders o group by o.user_id order by cnt  limit 10;
-- 2.每个用户平均每个订单平均是多少商品
-- 2.1 先算每个订单有多少商品
select order_id,count(1) as prod_cnt 
from order_products__prior 
group by order_id
limit 10;
-- 2.2 prior与order通过order_id关联 ,把订单中产品数量的信息带到每个用户里
select user_id,prod_cnt
from orders od
join (
select order_id,count(1) as prod_cnt 
from order_products__prior 
group by order_id
limit 10000)pro
on od.order_id=pro.order_id
limit 10;
-- 2.3  求和，一个总共购买多少产品
select user_id,sum(prod_cnt)as sum_prods
from orders od
join (
select order_id,count(1) as prod_cnt 
from order_products__prior 
group by order_id
limit 10000)pro
on od.order_id=pro.order_id
group by user_id
limit 10;
--2.4 每个用户平均每个订单平均是多少商品
select user_id,sum(prod_cnt)/count(1) as sc_prod,avg(prod_count) as avg_prod
from orders od
join (
select order_id,count(1) as prod_cnt 
from order_products__prior 
group by order_id
limit 10000)pro
on od.order_id=pro.order_id
group by user_id
limit 10;
--3 每个用户在一周中的购买订单的分布(列转行)
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

-- 4、平均每个购买天中，购买的商品数
select ord.user_id,sum(pri.products_cnt)/ count(distinct ord.days_since_prior_order) as avg_prod  
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

-- 5、每个用户最喜爱购买的三个product是什么，最终表结构可以是三个列，也可以是一个字符串/数组
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
select 
ord.user_id as user_id,
pri.product_id as product_id,
count(1) over(partition by user_id,product_id) as top_cnt
from 
(select * from orders where eval_set='prior')ord
join 
(select * from order_products__prior limit 10000)pri 
on ord.order_id=pri.order_id
)t 
)t1  where row_num <=3 group by user_id limit 10; 




