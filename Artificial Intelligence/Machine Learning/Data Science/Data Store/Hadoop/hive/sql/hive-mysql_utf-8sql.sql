
/** 修改字段注释字符集 **/
alter table COLUMNS_V2 modify column COMMENT varchar(256) character set utf8;
/** 修改表注释字符集 **/
alter table TABLE_PARAMS modify column PARAM_VALUE varchar(4000) character set utf8;
/**  修改分区注释字符集 **/
alter table PARTITION_KEYS modify column PKEY_COMMENT varchar(4000) character set utf8;

show variables like '%char%';