/**1.创建框架数据库**/
CREATE DATABASE framework;

/**2.用户表**/
CREATE TABLE tbl_user(
user_id int(20) UNSIGNED NOT NULL AUTO_INCREMENT comment '用户ID，无符号、非空、递增——唯一性，可做主键',
user_name VARCHAR(60) NOT NULL comment '用户名称，非空',
nike_name VARCHAR(60)  NOT NULL comment '昵称，非空',
mobile_phone VARCHAR(20) NULL comment '手机号码',
telephone VARCHAR(20) NULL comment '座机号码',
email VARCHAR(20) NULL comment 'email 邮箱',
user_type VARCHAR(5) NOT NULL comment '用户类型/是否为虚拟用户',
enabled int(2) NOT NULL comment '用户状态 锁定 0 启用 1',
start_date datetime NOT NULL comment '用户创建日期',
end_date datetime NULL comment '用户失效日期',
creation_date datetime NOT NULL comment '创建时间',
created_by VARCHAR(10) comment '记录创建人',
last_update_date datetime NULL comment '最后一次更改日期',
last_update_by datetime NOT NULL comment '最后一次更改人',
PRIMARY KEY(user_id)
)comment='用户表';

/**3.用户组表**/
CREATE TABLE tbl_group(
group_id int(10) UNSIGNED NOT NULL AUTO_INCREMENT comment '用户组ID,无符号、非空、递增、唯一，可作主键',
group_name VARCHAR(60) NOT NULL comment '用户组名称',
group_type VARCHAR(20) NOT NULL comment '用户组类型',
description VARCHAR(500) NULL comment '描述',
group_owner int(20) NULL comment '用户组owner,用户表用户ID',
creation_date datetime NOT NULL comment '创建时间',
created_by VARCHAR(10) comment '记录创建人',
last_update_date datetime NULL comment '最后一次更新时间',
last_update_by VARCHAR(10) comment '最后一次更新人',
role_status int NOT NULL comment '权限状态 锁定 0 启用 1',
PRIMARY KEY(group_id)
)comment='用户组表';

/**4.用户 用户组 关系表**/
CREATE TABLE tbl_user_group(
groupId int(10) UNSIGNED NOT NULL comment '用户组ID',
userId int(10) UNSIGNED NOT NULL comment '用户ID',
enabled int NOT NULL comment '是否启用，0 否 1 是',
creation_date datetime NOT NULL comment '创建日期',
created_by   VARCHAR(10) NULL comment '创建人',
last_update_date datetime NULL comment '最后一次更改日期',
last_update_by VARCHAR(10) NOT NULL comment '最后一次更改人',
PRIMARY KEY(groupId,userid)
)comment='用户用户组关系表';

/**5.职责表**/
CREATE TABLE tbl_role(
role_id int(10) UNSIGNED NOT NULL AUTO_INCREMENT comment '职责ID',
role_name VARCHAR(60) NOT NULL comment '职责名称',
description VARCHAR(500) NULL comment '标注', 
homepage VARCHAR(100) NULL comment '对应权限的首页',
creation_date datetime NOT NULL comment '创建时间',
created_by   VARCHAR(10) NULL comment '创建人',
last_update_date datetime NULL comment '最后一次更新时间',
last_update_by VARCHAR(10) comment '最后一次更新人',
enabled int NOT NULL comment '权限状态 锁定 0 启用 1',
PRIMARY KEY(role_id)
)comment='职责表';

/**6.用户 职责关系表**/
CREATE TABLE tbl_user_role(
ugrid int(10) UNSIGNED NOT NULL AUTO_INCREMENT comment '用户 职责关系Id',
role_id int(10) NOT NULL comment '职责表，职责Id',
user_id int(10) NULL comment '用户表，用户Id',
enabled int(2) NOT NULL comment '是否启用，0 否 1 是',
start_date int NOT NULL comment '开始生效时间',
end_date int NULL comment '到期时间',
last_update_by int(10) NOT NULL comment '更新人',
late_update_date datetime NOT NULL comment '更新时间',
PRIMARY KEY(ugrid)
)comment='用户职责关系表';

/**7.用户组 职责关系表**/
CREATE TABLE tbl_user_role(
ugrid int(10) UNSIGNED NOT NULL AUTO_INCREMENT comment '用户组 职责关系Id',
role_id int(10) NOT NULL comment '职责表，职责Id',
group_id int(10) NULL comment '用户组，用户组Id',
enabled int(2) NOT NULL comment '是否启用，0 否 1 是',
start_date int NOT NULL comment '开始生效时间',
end_date int NULL comment '到期时间',
last_update_by int(10) NOT NULL comment '更新人',
late_update_date datetime NOT NULL comment '更新时间',
PRIMARY KEY (ugrid)
)comment='用户组职责关系表';

/**8.职责权限关系表**/
CREATE TABLE tbl_permission(
permission_id int(10) UNSIGNED NOT NULL AUTO_INCREMENT comment '权限Id',
role_id int(10) NOT NULL comment '外键 职责表 职责ID',
creation_date datetime NOT NULL comment '创建时间',
created_by int(10) NOT NULL comment '创建人',
last_update_by int(10) NOT NULL comment '更新人',
late_update_date datetime NOT NULL comment '更新时间'
)comment='职责权限关系表';

/**9.用户登陆当前系统记录表**/
CREATE TABLE tbl_userlogin(
user_id int(10) NOT NULL comment '用户id，外键关联用户表用户id',
role_id int(10) NOT NULL comment '职责id，外键关联职责表职责id',
servername VARCHAR(20) NOT NULL comment '登录的服务器名称',
ip VARCHAR(20) NOT NULL comment '用户登录系统的IP',
equipment VARCHAR(20) NOT NULL comment '用户登录设备',
login_entrance VARCHAR(20) NOT NULL comment '登录入口(微信公众号/网页端/App端)',
login_way VARCHAR(20) NOT NULL comment '登录方式（微信授权/QQ授权/MS短信登录/帐号登录（邮件/用户名））',
login_in_time datetime NOT NULL comment '用户登录系统具体时间 yyyy-mm-dd hh:24mi:ss',
login_out_time datetime NOT NULL comment '用户退出系统具体时间(非正常退出则记录session失效时间) yyyy-mm-dd hh:24mi:ss'
)comment='用户登陆记录表';

/**10.数据范围表**/
CREATE TABLE tbl_programe(
programe_id int(10) NOT NULL AUTO_INCREMENT comment '维度id',
programe_name VARCHAR(20) NOT NULL comment '维度名称',
enabled int(2) NOT NULL comment '维度状态 0 否 1 是',
description VARCHAR(500) NULL comment '描述信息',
owner int(20) NULL comment 'Owner',
creation_date  datetime NULL comment '创建时间',
created_by int(10) NOT NULL comment '创建人',
last_update_by int(10) NOT NULL comment '更新人',
late_update_date datetime NULL comment '更新时间'
)comment='数据维度表';

/**10.国际化表**/
CREATE TABLE tbl_i18n(
i18nid int(10) NOT NULL AUTO_INCREMENT comment '国际化id',
i18n_key VARCHAR(100) NOT NULL comment '国际化key,唯一键',
i18n_value VARCHAR(200) NOT NULL comment '国际化内容',
language VARCHAR(10) NOT NULL comment '国际化语言(English,Chinese)',
description VARCHAR(500) NULL comment '描述',
enabled int NULL comment '是否启用(0/1)',
creation_date  datetime NULL comment '创建时间',
created_by int(10) NOT NULL comment '创建人',
last_update_by int(10) NOT NULL comment '更新人',
late_update_date datetime NULL comment '最后更新时间',
PRIMARY KEY(i18nId)
)comment='国际化表';

/**11.数据字典表**/
CREATE TABLE tbl_registry(
registry_id int(10) NOT NULL AUTO_INCREMENT comment '数据字典id',
registry_name VARCHAR(50) NOT NULL comment '数据字典名称',
display_name VARCHAR(50) NOT NULL comment '数据字典别名',
enabled int(2) NOT NULL comment '数据字典状态 0失效 1启用',
value  VARCHAR(100) NOT NULL comment '数据字典value',
parent_id int(10) NOT NULL comment '数据字典父层id',
index_id int(10) NOT NULL comment '下表索引',
path VARCHAR(100) NOT NULL comment '数据字典路径',
description VARCHAR(100) NOT NULL comment '数据字典描述',
creation_date datetime NOT NULL comment '创建时间',
created_by int(10) NOT NULL comment '创建人',
last_update_by int(10) NOT NULL comment '更新人',
late_update_date datetime NOT NULL comment '更新时间',
PRIMARY KEY (registry_id)
)comment='数据字典表';

/**12.lookupClassify**/
CREATE TABLE tbl_lookupclassify(
classify_id int(20) NOT NULL AUTO_INCREMENT comment '主lookupId',
classify_type_id VARCHAR(20) NOT NULL comment '分类类型Id',
classify_type VARCHAR(20) NOT NULL comment '分类类型',
classify_parent_type_id int(20) NULL comment '父级类型Id',
enabled int NOT NULL comment '是否启用(0/1)',
description VARCHAR(100) NOT NULL comment '描述信息',
creation_date datetime NOT NULL comment '创建时间',
created_by int(10) NOT NULL comment '创建人',
last_update_by int(10) NOT NULL comment '更新人',
late_update_date datetime NOT NULL comment '更新时间',
PRIMARY KEY (classify_id)
)comment='lookupClassifier';

/**13.lookupItem**/
CREATE TABLE tbl_lookup_item(
lookup_id int(20) NOT NULL AUTO_INCREMENT comment 'lookupId',
classify_id int(20) NOT NULL comment '主lookupId',
lookup_code_id VARCHAR(20) NOT NULL comment 'code唯一码Id（名称）',
lookup_code VARCHAR(20) NOT NULL comment 'code唯一码（值）',
description VARCHAR(500) NOT NULL comment '描述',
parentCode VARCHAR(20) NULL comment '父层级码',
enabled int(2) NOT NULL comment '是否启用 0 禁用 1启用',
language VARCHAR(20) NOT NULL comment '语言（中英文）',
sequence int(20) NULL comment '排序',
attribute1 VARCHAR(100) NULL comment '扩展字段1',
attribute2 VARCHAR(100) NULL comment '扩展字段2',
attribute3 VARCHAR(100) NULL comment '扩展字段3',
attribute4 VARCHAR(100) NULL comment '扩展字段4',
attribute5 VARCHAR(100) NULL comment '扩展字段5',
attribute6 VARCHAR(100) NULL comment '扩展字段6',
attribute7 VARCHAR(100) NULL comment '扩展字段7',
attribute8 VARCHAR(100) NULL comment '扩展字段8',
attribute9 VARCHAR(100) NULL comment '扩展字段9',
attribute10 VARCHAR(100) NULL comment '扩展字段10',
creation_date datetime NOT NULL comment '创建时间',
created_by int(10) NOT NULL comment '创建人',
last_update_by int(10) NOT NULL comment '更新人',
late_update_date datetime NOT NULL comment '更新时间',
PRIMARY KEY (lookup_id)
)comment='lookupItem';

/**14.HTMLAREA**/
CREATE TABLE tbl_htmlarea(
html_area_id int(100) NOT NULL AUTO_INCREMENT comment 'id',
category VARCHAR(20) NOT NULL comment '类别',
html_area_name VARCHAR(50) NOT NULL comment '名字',
title VARCHAR(50) NOT NULL comment '标题',
mapping_url VARCHAR(50) NOT NULL comment '映射地址',
description VARCHAR(500) NOT NULL comment '描述',
content longtext NOT NULL comment '网页内容',
enabled int(2) NOT NULL comment '是否启用(0/1)',
creation_date datetime NOT NULL comment '创建时间',
created_by int(10) NOT NULL comment '创建人',
last_update_by int(10) NOT NULL comment '更新人',
late_update_date datetime NOT NULL comment '更新时间',
PRIMARY KEY (html_area_id)
)comment='网页补丁';

/**14.Site Map 菜单栏**/
CREATE TABLE tbl_sitemap(
site_map_id int(100) NOT NULL AUTO_INCREMENT comment 'id',
site_map_name VARCHAR(200) NOT NULL comment '名字',
parent_node int(100) NOT NULL comment '父层级节点',
url VARCHAR(200) NULL comment '路径',
node_order int(100) NULL comment '节点排序',
publish int NOT NULL comment '是否开放',
menu_display int NOT NULL comment '可见类型 0 所有人可见 1 方法授权可见',
function int NULL comment '授权方法 外键权限表 permissionid',
link_type int NOT NULL comment '链接类型 菜单／新窗口／内嵌页面／外部网站',
description longtext NOT NULL comment '描述',
enabled int(5) NOT NULL comment '是否启用(0/1)',
creation_date datetime NOT NULL comment '创建时间',
created_by int(10) NOT NULL comment '创建人',
last_update_by int(10) NOT NULL comment '更新人',
late_update_date datetime NOT NULL comment '更新时间',
PRIMARY KEY (site_map_id)
)comment='菜单栏';

/**15.框架数据 - Excel导入表**/
# CREATE TABLE tbl_import_excel(

# );
/**16.框架数据 - Excel导出表**/
# CREATE TABLE tbl_import_excel(
#
#
# );

/**17.框架数据 - Excel导入监控表**/
# CREATE TABLE tbl_import_excel(

# );

/**18.框架数据 - Excel导出监控表**/
# CREATE TABLE tbl_import_excel(

# );

/**19. **/

/** task 任务表 **/
CREATE TABLE tbl_task(
  task_id int(100) NOT NULL AUTO_INCREMENT comment '任务id 主键',
  status int(5) NOT NULL comment 'task任务的状态'

)comment='处理任务表';

/** 消息表**/
CREATE TABLE tbl_push_message
(
    message_id int(100) NOT NULL AUTO_INCREMENT comment '消息id 主键',
    message_type VARCHAR(50) NULL comment '消息类型',
    message_type VARCHAR(100) NULL comment '消息类型',
    message_title VARCHAR(100) NULL comment '消息标题',
    message_template VARCHAR(100) NULL comment '消息模板',
    message_receiver VARCHAR(100) NULL comment '消息接收者',
    message_level VARCHAR(100) NULL comment '消息级别',
    message_flag VARCHAR(100) NULL comment '消息开关',
    message_overdo VARCHAR(100) NULL comment '是否消费完成',
    message_ico VARCHAR(100) NULL comment '消息',
    status int(5) NOT NULL comment '记录状态',
    creation_date datetime NOT NULL comment '创建时间',
    created_by int(10) NOT NULL comment '创建人',
    last_update_by int(10) NOT NULL comment '更新人',
    late_update_date datetime NOT NULL comment '更新时间',
    PRIMARY KEY (message_id)
)comment='消息发送表';