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