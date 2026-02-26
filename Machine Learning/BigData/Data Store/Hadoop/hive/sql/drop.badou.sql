--使用八斗 schema
use badou;

--清除wordcount表
drop table if exists article;

--清除一级品类表
drop table if exists departments;

--清除二级品类表
drop table if exists aisles;

--清除产品表
drop table if exists products;

--清除订单表
drop table if exists orders;

--清除订单记录表
drop table if exists order_products_train;

--清除订单历史记录表
drop table if exists order_products_prior;