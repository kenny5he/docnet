/**
 * 菜单表：列举 下厨房等 饮食类网站所有数据，爬虫抓取数据，图片水印处理
 * 
 * 中国菜 
 * 	八大菜系: 川菜、湘菜、粤菜、豫菜、鲁菜、苏菜、闽菜、浙菜
 * 	口味: 辣(超辣、中辣、微辣)
 * 	种类: 小吃、夜宵、粉面饺、汤、粥类、面点、甜品/饮品
 *  节日食宿: 
 *  传统美食: 
 *  场景: 
 *  适宜人群: 
 * 	//档次: 快餐、家常菜、特色菜、上等菜品、特级菜品
 *  时间冲突: 适合时间吃
 *	营养冲突: 
 * 	营养价值：
 *  烹饪方式: 
 *  烹饪难度: 
 *  所需时间: 
 *  
 * 国外: 
 *  按地区分类：西式菜点、印度菜、泰国菜、韩国菜、日本菜、越南菜
 * 	按时间:
 *
 * 技巧表:
 *   背景: 烹饪每道菜品过程，处理食材过程都需要一定的方式方法，可能根据食品材料不同而不同，可能因为菜品不同而不同，但烹饪过程肯定是带技巧性的，
 *   故根据菜品材料、菜品不同 而对处理技巧进行分类
 *
 *
 * 	
 */
/** Cook Web: http://home.meishichina.com/recipe-type.html*/
/** 微愚烹饪 **/
CREATE DATABASE cook;
/**
 * 基础表: 主料表
 */
create table tbl_mainmaterial(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '主料名称',
	obtain_difficult numeric(5,2) comment '材料获取难度',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='主料表';

/**
 * 基础表:
 * 	主料分类表: 素菜、肉类、海鲜、清真、珍贵食材(鲍鱼、鱼翅、燕窝)
 */
create table tbl_mainmaterial_type(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '主料类型',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='主料分类表';

/**
 * 基础表:
 * 	主料分类关系表
 */
create table tbl_mainmaterial_type_relationship(
	mainmaterialid int(20) NOT NULL comment '主料表主键id',
	typeid int(20) NOT NULL comment '主料分类表主键id',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='主料分类关系表';

/**
 * 基础表: 辅料表
 */
create table tbl_auxiliarymaterial(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '辅料名称',
	obtain_difficult numeric(5,2) comment '材料获取难度',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='辅料表';

/**
 * 基础表: 调料表
 */
create table tbl_sauce(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '调料名称',
	obtain_difficult numeric(5,2) comment '材料获取难度',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='调料表';

/**
 *  基础表：菜品口味
 */
create table tbl_taste(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '口味名称',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='口味表';

/**
 * 基础表：
 * 烹饪工艺：烧、炒、爆、焖、炖、蒸、煮、拌、烤、炸、烩、溜、氽、腌、卤、炝、煎、酥、扒、熏、煨、酱、煲、烘、焙、火锅、砂锅、拔丝、烙、榨、冷冻
 */
create table tbl_technics(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '烹饪方式',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='烹饪工艺表';

/**
 * 类别
 * 主要分四类：
 *  菜品: 
 * 		原材料种类：海鲜、素菜 (通过原材料判断)
 * 		常规划分:汤羹类、火锅、腌菜、泡菜、酱菜、凉菜
 * 	主食: 炒粉、炒饭、粉、面、饺子、馄饨、包子、馒头、花卷、油条、饼、五谷杂粮
 *  地方小吃: 北京小吃、陕西小吃、广东小吃、四川小吃、重庆小吃、天津小吃、上海小吃、福建小吃、湖南小吃、湖北小吃、江西小吃、山东小吃、山西小吃、
 * 			河南小吃、台湾小吃、江浙小吃、云贵小吃、东北小吃、西北小吃
 * 	甜品: 甜品(大类)、冰品、果汁、糖水、布丁、果酱、果冻、酸奶、鸡尾、酒、咖啡、豆浆、奶昔、冰淇淋
 */
/**
 * 主食
 */
create table tbl_staplefood(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '主食名称',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment="类别：主食";

/**
 * 小吃
 */
create table tbl_snack(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '小吃名称',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment="类别：小吃";

/**
 * 甜品
 */
create table tbl_dessert(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '主食名称',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment="类别：甜品";

/*地区美食*/
/**
 *  中国:
 * 		川菜
 * 		湘菜
 * 		粤菜
 *		...
 *	泰国
 *	印度
 *	美国 
 */
create table tbl_regionfood(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键', 
	name VARCHAR(30) NOT NULL comment '国家、地区名称',
	parent int(20) NULL comment '父级码',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='地区美食';

/**
 * 基础表：适宜人群
 */
create table tbl_suitcrowds(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '人群种类',
	minage int(3) NULL comment '人群最小年龄',
	maxage int(3) NULL comment '人群最大年龄',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='适宜人群表';

/** 由程序计算所得，根据 步骤、制作工艺(蒸、煮、煎、炸)、制作时间来判定 **/
/*烹饪难度*/
create table tbl_level(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '烹饪难度',
	createdate datetime NULL comment '创建日期',
	createby  VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='烹饪难度';

/** 具体烹饪详情 **/
create table tbl_cookdetail(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	name VARCHAR(30) NOT NULL comment '菜品名,菜品标题',
	nikename VARCHAR(30) NULL comment '菜品别名',
	list_img_id int(20) NULL comment '列表页图',
	detail_img_id int(20) NOT NULL comment '详情页图',
	keyword VARCHAR(500) NOT NULL comment '搜索关键词',
	description VARCHAR(3000) NULL comment '描述信息',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='烹饪';

/***
 * 
 */
create table tbl_cook_rawmaterial(



)type=InnoDB,comment='烹饪材料、厨具表';

/** 烹饪步骤 **/
create table tbl_cookstage(
	id int(20) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT comment 'ID，无符号、非空、递增——唯一性，主键',
	cookdetailid int(20) NOT NULL comment '烹饪详情主键id',
	sort_number int(5) NOT NULL comment '步骤编号',
	content VARCHAR(500) NOT NULL comment '步骤内容，不能超过500字节，大约200个中文汉字左右',
	img_id int(20) NULL comment '步骤图',
	createdate datetime NULL comment '创建日期',
	createby   VARCHAR(20) NULL comment '创建人',
	lastupdatedate datetime NULL comment '最后更改日期',
	lastupdateby VARCHAR(20) NULL comment '最后更改人'
)type=InnoDB,comment='烹饪步骤';

/*
 * 养生 
 * 
 */

/**
 * 场景
 * 
 */
