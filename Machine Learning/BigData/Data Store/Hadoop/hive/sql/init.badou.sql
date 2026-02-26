select "创建badou  schema";
create schema if not exists badou;

select "使用 badou schema";
use badou;

/** WordCount **/
select "创建 article表  用于wordcount";
create table article(sentence String) row format delimited fields terminated by '\n';
select "通过hive 加载csv中的数据保存至hdsf中";
load data local inpath '/home/apaye/data/The_man_of_property.txt' overwrite into table article;

/** jieba分词 Start **/
/** 分词完成后的数据表 **/
select "jieba表";
create table if not exists news_jieba(
content String comment '原始内容',
label String comment '',
seg Array<String> comment '分词后的字符数组'
)
row format delimited fields terminated by ','
lines terminated by '\n';

/** jieba分词 End **/

/**  LR 商品推荐  Start  **/
select "创建一级品类表( 部门/类别 比如厨房类 )";
create table if not exists departments
(
department_id String comment '一级品类id',
department String comment '一级品类名称'
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

select "通过hive 加载csv中的数据保存至hdsf中";
load data local inpath '/home/apaye/data/departments.csv' overwrite into table departments;

select "创建二级品类表( 货架表 )";
create table if not exists aisles
(
aisle_id String comment '二级品类id',
aisle String comment '二级品类名称'
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

select "通过hive 加载csv中的数据保存至hdsf中";
load data local inpath '/home/apaye/data/aisles.csv' overwrite into table aisles;

select "创建产品表";
create table if not exists products
(
product_id String comment '产品id',
product_name String comment '产品名称',
aisle_id String comment '一级品类id',
department_id String comment '二级品类id'
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

select "通过hive 加载csv中的数据保存至hdsf中";
load data local inpath '/home/apaye/data/products.csv' overwrite into table products;

select "创建订单表";
create table if not exists orders
(
order_id string comment '订单id',
user_id string comment '用户id',
eval_set string comment 'prior历史行为',
order_number string comment '订单号码',
order_dow string comment '订单购买日期(星期)',  
order_hour_of_day string comment '订单购买具体时间',
days_since_prior_order string comment '上个订单间隔时间'
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

select "通过hive 加载csv中的数据保存至hdsf中";
load data local inpath '/home/apaye/data/orders.csv' overwrite into table orders;

select "创建 订单记录表";
create table if not exists order_products_train(
order_id String comment '订单id',
product_id String comment '产品id',
add_to_cart_order String comment '加购物车的位置',
reordered String comment '订单是否被再次购买（是否）'
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

select " 通过hive 加载csv中的数据保存至hdsf中";
load data local inpath '/home/apaye/data/order_products__train.csv' overwrite into table order_products_train;

select "创建 订单记录表(历史记录)";
create table if not exists order_products_prior(
order_id String comment '订单id',
product_id String comment '产品id',
add_to_cart_order String comment '加购物车的位置',
reordered String comment '订单是否被再次购买（是否）'
)
row format delimited fields terminated by ',' 
lines terminated by '\n';

select "通过hive 加载csv中的数据保存至hdsf中";
load data local inpath '/home/apaye/data/order_products__prior.csv' overwrite into table order_products_prior;

/**  LR 商品推荐  End  **/
