-- 建内部表
create table article(sentence string)
row format delimited fields terminated by '\n'

--从本地导入数据
load data local inpath '/home/badou/Documents/code/mr/mr_wc/The_Man_of_Property.txt' insert into table article;

实时的数据：200亿条用户的行为数据
10000亿 查询200亿 
select * from badou.news where dt='20180414'
where dt in('20180414','20180413')

20天，用脚本写，copy
创建一个表，join

dt=20180414
dt=20180413


user age gender  pc/m/app 

join表 
196     242     3       881250949
186     302     3       891717742
22      377     1       878887116
244     51      2       880606923
user_id







196%3=1
186%3 = 0
22%3 = 1
23%3=2

--相当于设定了4个reduce，就会有四个文件生成
set hive.enforce.bucketing = true;
create table bucket_user (id int)clustered by (id) into 4 buckets;
insert overwrite table bucket_user select cast(user_id as int) from badou.udata;

select * from badou.bucket_user tablesample(bucket 1 out of 16 on id) limit 10;

orders:
order_id,user_id
trains:
order_id,product_id
--用这两个表中的数据，查看每个user购买了什么商品
select user_id,product_id
from
(select order_id,user_id from orders)ord
join
(select order_id,product_id from trains)tra
on ord.order_id=tra.order_id 
limit 10;

select user_id,product_id
from orders join trains 
on orders.order_id=trains.order_id
limit 10;


reduce 有多少个就有多少个文件，
一个reduce会生成一个文件
4 buckets 4 reduce => 将这一个文件分成4个文件

1/16 只需要取第一个数据里面的4*(1/16)

在数据倾斜里面用到采样

1 reduce
所有的map数据都会落到一个reduce，增加这个reduce节点的负担
3 reduce
会把所有map数据分发给3个reduce，提升了reduce阶段的执行效率。

4个buckets
16：采样的每一份需要4*(1/16)=1/4 => 只需要每个文件里面的1/4
2：采样的每一份需要4*（1/2）=2buckets
 
buckets=64，y=32 
采样的y中的每一份=64*（1/32）=2buckets

timestamp
881250949  1997/12/4 23:55:49
每个用户 产生行为的时候，用timestamp来区分下单先后关系。
user product timestamp什么时候看过什么商品

推荐数据里面，想知道，距离现在最近的时间是什么时候
最远的时间是什么时候
select max(`timestamp`) as max_t,min(`timestamp`) from badou.udata;
893286638   874724710
最近的这个点作为时间参考点

能查看用户的行为时间点，可以用这个数据做一个数据清洗的规则
select user_id,collect_list(cast(days as int)) as day_list
from
(
select user_id,exp(-(cast(893286638 as bigint)-cast(`timestamp` as bigint))/(60*60*24)/2)*rating as days from badou.udata) t
group by user_id
limit 10;

一个用户有多条行为，做行为分析的时候，最近的行为越有效果（越好）。
时间分布：[1,3,5,6]days 需要一个函数exp(-t/2)
sum([exp(-t/2)*score for score in score_list for t in days])

sum=0
for (t,score) in (days,score_list):
	sum +=exp(-t/2)*score
	
select user_id,sum(exp(-(cast(893286638 as bigint)-cast(`timestamp` as bigint))/(60*60*24)/2)*rating) as days from badou.udata
group by user_id
limit 10;

作业：
1.将orders，trains建表，将数据导入到hive中
2.每个用户有多少个订单
orderid userid set    number   dow      24小时  days
2539329 1       prior   1       2       08
2398795 1       prior   2       3       07      15.0
473747  1       prior   3       3       12      21.0
2254736 1       prior   4       4       07      29.0
3.每个用户一个订单平均是多少商品
trains：
order_id,product_id

4.dow => day of week
每个用户在一周中的购买订单的分布(列转行)
user_id dow_0 dow_1 ....dow_6
1			0   2			1






















