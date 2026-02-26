	/** 表空间 **/
		/*创建表空间*/
			CREATE [SMALLFILE/BIGFILE] TABLESPACE tablespace_name						/* SMALLFILE/BIGFILE 创建的是小文件表空间还是大文件表空间 */
			DATAFILE '/path/filename' SIZE num[k/m] REUSE							/* REUSE 若该文件存在，则清除该文件再重新创建*/
			[,'/path/filename' SIZE num[k/m] REUSE]
			[,...]
			[AUTOEXTEND [ON|OFF] NEXT num[k/m]										/* 数据文件是否自动扩展 */
			[MAXSIZE num[k/m]|UNLIMITED]												/* 数据文件自动扩展时，允许文件扩展最大长度字节数，如果指定UNLIMITED则不需要指定字节长度 */
			[MININUM EXTENT num[k/m]]												/* 指定最小长度，有系统和数据库块决定 */
			[DEFAULT STORAGE storage]												/* 指定以后要创建的表、索引及簇的存储参数值 */
			[ONLINE|OFFLINE]															/* 表空间 在线 或离线 */
			[LOGGING|NOLONGGING]														/* 指定表空间内的表在加载数据时是否产生日志 */
			[PERMANENT|TEMPORARY]													/* 指定创建表空间时永久还是临时表空间，默认为永久性表空间 */
			[EXTENT MANAGEMENT DICTIONARY|LOCAL [AUTOALLOCATE|UNIFORM SIZE num[k/m]]]
				/*EXTENT MANAGEMENT 指定表空间的扩展方式是使用数据字典管理还是本地化管理，默认为本地化管理，
				AUTOALLOCATE|UNIFORM SIZE：如果采用本地化管理表空间，在表扩展时，指定每次磁盘扩展大小室友系统自动指定还是按照等同大小进行 */
			/* 通过段空间管理方式创建表空间 注：段空间管理方式建立在本地化空间管理方式基础上*/
				/*手动段管理方式*//* 使用自由块列表和PCT_FREE 与 _USED参数标识插入操作数据块 */
					/* INSERT或UPDATE操作后，比较该数据中剩余自由空间与改短的_FREE设置，如果数据块少于PCT_FREE自由空间(剩余空间已经进入系统下限设置)，数据库会从自由列表上将其取下，不再进行插入操作 */
					/* UPDATE或DELETE操作 数据库比较该数据块中已用空间与PCT_USED设置，已用空间少于PCT_USED已用空间，数据块加入自由列表中 */
					create tablespace tablespace_name datafile 'filepath\filename'
					size 20m
					extent management local autoallocate
					segment space management manual;
				/*自动段空间管理方式*//*该方式不能创建临时表空间和系统空间，Oracle本身推荐使用自动段空间管理方式管理永久表空间，但是默认情况下却是MANUAL手动方式*/
					create tablespace tablespace_name datafile 'path\filename'
					size 20m
					extent management local autoallocate
					segment space management auto;
		/* 维护表空间与数据文件 */
			/* 设置默认表空间 */
				/* 设置默认临时表空间 */
				alter database default temprory tablespace temp_1
				/*设置默认永久表空间*/
				alter database default tablespace tbs_example
			/* 更改表空间状态 */
				/* 更改表为可读可写状态 */
				alter tablespace tbs_test3 read write;
				/* 更改表表空间为只读状态 */
				alter tablespace tbs_test3 read only;
			/* 重命名表空间 */	/* 不能对SYSTEM和SYSAUX表空间进行重命名  */
				alter tablespace tbs_test3 rename to tbs_test3_new;
			/* 删除表空间 *//* INCLUDING CONTENTS删除表空间的同时删除表空间中的数据 CASCADE CONSTRAINTS当删除当前表空间时也删除相关的完整性限制 */
				DROP TABLESPACE tbs_name[INCLUDING CONTENTS] [CASCADE CONSTRAINTS]
			/* 维护表空间中的数据文件 */		
				/* 向表中添加数据文件 */
				alter tablespace users add datafile 'filepath/filename' size 10m autoextend on next 5m maxsize unlimited;
				/* 从表空间中删除数据文件 */
				alter tablespace users drop datafile 'filepath/filename';
				/* 对数据文件的自动扩展设置 */
				col file_name for a50;
				select file_name ,autoextensible from dba_data_files where tablespace_name = 'TBS_TEST2';
				alter database datafile 'filepath/filename' autoextend on next 10m maxsize unlimited;
			/* 管理撤销表空间 UNDO  撤销表空间的作用：使读写一致  可以回滚事物 事物恢复 闪回操作*/
				/* 创建UNDO表空间 */
				create undo tablespace undo_tbs1
				datafile 'filepath/filename'
				size 1024m;
				/* 修改UNDO表空间 */
				alter tablespace undo_tbs1
				datafile 'filepath/filename'
				size 2g;
				/* 删除UNDO表空间 */
				alter system set undo_tablespace=undotbs1;
				drop tablespace undo_tbs1;
				/* 查询UNDO表空间信息 */
					/* 查询当前使用的UNDO信息 */
					show parameter undo_tablespace;
					/* 实例的所有UNDO表空间 */
					select tablespace_name from dba_tablespaces where contents = 'UNDO';
					/* UNDO表空间的统计信息 */
					select to_char(beigin_time,'hh24:mi:ss') as '开始时间',
						   to_char(end_time,'hh24:mi:ss') as '结束时间',
						   undoblks as '回退块数'
						   from v$undostat
						   order by begin_time;
					/* 显示UNDO段统计信息 */
					select rn.name,rs.xacts,rs.writes,rs.extends
						from v$rollname rn,v$rollstat rs
						where rn.usn = rs.usn;
					/* 显示活动事物信息 */
					select name,status from v$transaction;
					/* 显示UNDO区信息 */
					select segment_name,extent_id,bytes,status from dba_undo_extents
					where segment_name='_SYSSMU3_991555123$';
	/** 数据库表 **/
		/* 创建数据库表 */
		create table table_name(
			column1 number(10) not null,
			column2 varchar2(8)
		)tablespace tablespace_name						/* 表空间 */
		storage(inital 256k)						/* 指定为该表分配第一个盘区的大小 */
		pctfree 20								/* 数据块管理参数 */
		pctused 40								/* 数据块管理参数 */
		initrans 10;								/* 数据块管理参数，10个事物条目 */
		
		/* 维护数据表 */
			/* 增加和删除字段 */
			alter table table_name add(column3 varchar2(10));/* 新增字段 */
			alter table table_name drop column column3;/* 删除字段 */
			/* 修改字段 */
			alter table table_name modify column_name column_property;
			/* 重命名表 */
			alter table table_old_name rename to table_new_name;
			/* 修改表空间 */
			alter table table_name move tablespace tablespace_name1;
			/* 修改存储参数 */
			alter table table_name pctfree 25 pctused 45;
			/* 删除表 */
			drop table table_name [cascade constraints];
			/* 修改表的状态 */
			alter table table_name read only;/* 设置只读 */
		/* 数据完整性和约束性 */	
			/* 非空约束 */
			alter table table_name modify clo1 not null;
			/* 主键约束 */
			alter table table_name add constraint PK_name primary key (column1);
			/* 唯一约束 */
			alter table table_name add constraint UK_name unique(column1);
			/* 外键约束 */
			alter table table_name add constraint FK_name foreign key(column1) references foreign_table(foreign_column);
			/* 禁用、启用约束 */
			alter table table_name disable|enable constraint PK_name|UK_name|FK_name;
			/* 删除约束 */
			alter table table_name drop constraint PK_name|UK_name|FK_name;
	/* 索引 */
			
		/* 存储方式区分：B树索引、位图索引、反向键索引、基于函数的索引 */
		/* 索引列的唯一性区分：唯一索引、非唯一索引 */
		/* 索引列的个数区分：单列索引和复合索引 */
		
		/* 使用索引注意点： */
			/* 1.索引应该建立在WHERE子句频繁引用表列上，如果在大表上频繁使用某列或某几列作为条件执行索引操作，并检索行数低于总行15%，就应该考虑在这些列上建立索引 */
			/* 2.如果经常需要基于某列或某几列执行排序操作，那么在这些列上建立索引可以加快数据排序操作 */
			/* 3.限制表的索引个数。索引主要用于加快查询速度，但会降低增删改操作的速度，索引越多DML操作速度越慢 */
			/* 4.指定索引块空间的使用参数，基于表建立索引时，Oracle会将相应列数据添加到索引块，为索引块添加数据时，Oracle会按照PCTFREE参数在索引块上预留部分空间 */
			/* 5.将表和索引部署到相同的表空间，可以简化表空间的管理；将表和索引部署到不同表空间，可以提高访问性能 */
			/* 6.当在大表上建立索引时，使用NOLOGGING选项可以最小化重做记录，使用NOLOGGING选项可以节省重做日志空间、降低索引建立时间、提高索引并行建立的性能。 */
			/* 7.不要在小表上建立索引 */
			/* 8.为提交多表连接的性能，应该在连接列上建立索引 */
		/* 同义词对象 */
			/*同义词：避免直接引用表、视图或其它数据库对象的名称，分类：公有同义词、私有同义词*/
			/* 创建同义词（默认创建私有同义词）*//* 若创建公有同义词，用户必须拥有CREATE PUBLIC SYSNONYM系统权限*/
				create [public] synonym synonym_name from table|view...
			/* 删除同义词 */	
				drop [public] synonym synonym_name;
		/* 序列 */
			/* 创建序列 */
				create sequence <seq_name>					--创建序列
				[start with n]								--序列开始位置
				[increment by n]								--序列 每次增量(可为负数)
				[minvalue n | nomainvalue]					--序列最小值
				[maxvalue n | nomaxvalue]					--序列最大值
				[cache n | nocycle]							--是否产生序列号预分配，并存储在内存中
				[cycle | nocycle]							--当序列达到最大值或最小值 是否复位并继续下去
				[order | noorder];							--保证序列值按顺序产生（noorder 只保证唯一）
			/* 使用序列 */
				select seq_name.nextval from dual;	--返回序列生成下一个序列号
				select seq_name.currval from dual;	--返回当前序列号
		/*建立索引*/
			/* B树索引 （默认使用的索引、最常用的索引）（默认情况下以升序方式排列）*//*通过索引中保存排序的索引列的值以及记录物理地址ROWID来实现快速查找*/
				create index index_name on table_name(column_name) pctfree 25 tablespace tablespace_name;
			/* 位图索引 *//* 通过给定的索引列值，快速查找对应的记录 */
				create bitmap index index_name on table_name(column_name) tablespace tablespace_name;
				/*修改位图索引 分配位图区大小，默认为8MB*/
				alter system set create_bitmap_area_size = 8388608 scope = spfile;
			/* 反向键索引 *//*存储结构与B树索引相同，如果用户使用序列在表中记录，则反向键索引首先只想每个列键值的字节，然后在反向后的新数据上进行索引*/
				create index index_name on table_name(column_name) reverse tablespace tablespace_name;
				/*重建索引*/
				alter index index_name rebuild reverse;
			/* 基于函数的索引 */
				create index index_name on table_name(function_name(column_name));
				/*例：函数大写  create index column_lowwer_funtion_index on table_name(lower(column_name));*/
			/* 删除索引 */	
				drop index index_name;
			/* 显示索引信息 */
				/* 显示表的所有索引 *//*查询所有者是HR的全部索引对象*/
				select index_name,index_type from dba_indexes where owner = 'HR';
				/* 显示索引列 */
				column column_name for a30;
				select column_name,column_length from user_ind_columns where index_name = 'EMP_DEPTNO_INDEX';
				/* 显示索引段位置及其大小 */
				select tablespace_name,segment_type,bytes from user_segments where segment_name='EMP_DEPTNO_INDEX';
				/* 显示函数索引 */
				select column_expression from user_ind_expressions where index_name='EMP_JOB_FUN';
	/** 检索数据 **/
		select {[distinct | all] columns | *}  /*需要显示的字段、值*/
			/* distinct：去除重复数据 */ 
			/* 可使用函数 count(统计数量) sum(求和) avg(求平均数) min(最小值) max(最大值) 等(暂时只举简单几个例子) 例：select count(0) from tbl_student*/
			/* 字段别名：使用英文空格 或 AS为字段取别名 例：select name '姓名',age AS '年龄' from tbl_student*/
		[into table]                           /*into 将原表的结构和数据插入新表中*/
		from {tables | views | other select}   /*数据来源自表 或 视图 或 其它查询SQL中 */
			/* 自然连接：数据来源可以为多个表，多个表使用,号分隔 例：select * from student,class */
			/* 表别名：使用英文空格取别名 例：select * from tbl_student s where s.name = 'xxx' and s.age = 18 */
		[[INNER JOIN table on conditions] | [LEFT [OUTER] JOIN table on conditions] | [RIGHT [OUTER] JOIN table on conditions] |[FULL [OUTER] JOIN table on conditions]]	
			/* INNER JOIN table : 内连接：内连接消除了与另一个表中任何行不匹配的行 */
			/* LEFT [OUTER] JOIN table ：左连接 以左侧表为主表查询*/
			/* RIGHT [OUTER] JOIN table ：右连接 以右侧表为主表查询*/
			/* FULL [OUTER] JOIN table  ：全连接 可查询所有连接表中所有字段*/
			/* cross join :交叉连接 */
		[where conditions]                     /*按 条件 筛选 数据*/ 
			/* 使用 and (并且关系) 或 or (或者关系) 连接多个条件*/
			/* 模糊匹配:(column like '%some%') 注意：双%不走索引、
			 * 比较符：等于(=) 、不等于(!或<>)、大于(>)、小于(<)、大于等于(>=)、小于等于(<=) 
			 * IN关键字：匹配一组目标值 例： colum in ('java','python')
			 * NOT IN：指定值不在查询目标值中 例：colum not in ('sql','php')
			 * BETWEEN关键字：在xxx之间 注意：between and 为一个整体 例：colum between 2000 and 3000 
			 * IS NULL：空值 匹配空列字段，查询不为空则使用 IS NOT NULL
			 */
		[group by columns]                     /*按字段分组查询 指定某一列的值将数据集合划分为多个分组，同一组内所有记录在分组属性具有相同的值 */
		[having conditions]					  /*分组查询过滤*/
		[order by columns]					  /*按照字段排序 asc 正序 desc 倒序*/
	/** 常用函数 **/	
		/* 字符类型 */		
			/* ASCII(c):用于返回一个字符的ASCII码，c代表一个字符(char) */
			/* CHR(i):用于返回给出ASCII码值对应的字符 */
			/* CONCAT(s1,s2):将s2连接到s1后面 */
			/* INITCAP(s):使s的每个单词的第一个字母大写，其它字母小写，单词之间使用空格、控制字符、标点符号区分。例：Oh My God! */
			/* INSTR(s1,s2[,i][,j]):用于返回字符s2在字符串s1中第j次出现时的位置，i为负数则从右至左查询 */
			/* LENGTH(s)：s字符的长度 */
			/* LOWER(s): 转小写字符 */
			/* UPPER(s): 转大写字符*/
			/* TRIM(s1,s2)：删除字符串s1左右两端的字符串s2 */
			/* LTRIM(s1,s2) 删除字符串s1左边的字符串s2 */
			/* RTRIM(s1,s2) 删除字符串s1右边的字符串s2 */
			/* REPLACE(sourceStr,s1[,s2]): 将sourceStr中的 s1 字符使用 s2 字符替换*/
			/* SUBSTR(s,i,[j]) 从字符串s的第i个位置开始截取长度为j的子字符串，如果省略参数j，则直接截取到尾部*/
		/* 字符类型 */
			/* ABS(n) 返回n的绝对值 */
			/* CEILn 返回大于或等于数值n的最小整数 */
			/* COS(n) 返回n的余弦值，n为弧度 */
			/* EXP(n) 返回e的n次幂，e=2.71828183 */
			/* FLORR(n) 返回小于或等于n的最大整数 */
			/* LOG(n1,n2) 返回以n1为底n2的对数 */
			/* MOD(n1,n2) 返回n1除以n2的余数 */
			/* POWER(n1,n2) 返回n1的n2次方 */
			/* ROUND(n1,n2) 返回舍入小数点右边n2位的n1的值(n2默认值为0，n2必须为整数，如果n2为负数，则舍入到小数点左边相应的位上) */
			/* SIGN(n) 若n为负数，则返回-1，若n为整数，则返回 1 若n=0，则返回0 */
			/* SIN(n) 返回n的正弦值*/
			/* SQRT(n) 返回n的平方根，n为弧度 */
			/* TRUNC(n1,n2) 返回结尾到n2位小数的n1的值，n2默认设置为0，当n2为默认设置时，会将n1截尾为整数，如果n2为负值，就截尾在小数点左边相应位上 */
		/* 时间、日期类 函数 */
			/* ADD_MONTHS(d,i) 返回日期d加上i个月之后的结果，i为任意整数 */
			/* LAST_DAY(d) 返回包含日期d月份的最后一天 */
			/* MONTHS_BETWEEN(d1,d2) 返回d1和d2之间的数目 */
			/* NEW_TIME(d1,t1,t2)  d1为日期数据类型 t1、t2为时区 当时区t1中的日期和时间都是d1时，返回时区t2中的日期和时间 */
			/* SYSDATE() 返回当前日期 */
		/* 转换类 函数 */
			/* CHARTORWIDA(s) 将字符串s转换为RWID数据类型 */
			/* CONVERT(s,aset[,bset]) 将字符串s由bset字符集转换为aset类型 */
			/* ROWIDTOCHAR() 将ROWID数据类型转换为CHAR类型 */
			/* TO_CHAR(x,[,format]) 将表达式转换为字符串，format代表字符串格式 */
			/* TO_DATE(s[,format[lan]]) 将字符串s转换为date类型 */
			/* TO_NUMBER(s[,format[lan]]) 将返回字符串s代表的数字，返回值按照format格式显示 */
		/* 聚合类函数 */
			/* AVG(x[DISTINCT|ALL]) 计算选择列表项的平均值，项目可以是一列或多列的表达式 */
			/* COUNT(x[DISTINCT|ALL]) 返回查询结果中的记录数 */
			/* MAX(x[DISTINCT|ALL]) 返回选择列表项中的最大数 */
			/* MIN(x[DISTINCT|ALL]) 返回选择列表项中的最小数 */
			/* SUM(x[DISTINCT|ALL]) 返回选择列表项中的数值总和 */
			/* VARIANCE(x[DISTINCT|ALL]) 返回选择列表项中的统计方差 */
			/* STDDEV(x[DISTINCT|ALL]) 返回选择列表项中的标准偏差 */
		
		
/** keep over 分析函数 **/
    /** keep 指明后面的括号里是按照指定规则排名的top 1或bottom 1 **/
    select
       deptno,
       empno,
       ename,
       sal,
       /**  **/
       max(ename) keep(dense_rank FIRST order by sal) over (partition by deptno) as min_sal_man,
        /** 此条sql 含义为 按deptno 分区 获取 最小的 sal  **/
       max(sal) keep(dense_rank FIRST order by sal) over (partition by deptno) as min_sal,
       /**  **/
       max(ename) keep(dense_rank LAST order by sal) over (partition by deptno) as max_sal_man,
        /** 此条sql 含义为 按deptno 分区 获取 最大的 sal  **/
       max(sal) keep(dense_rank LAST order by sal) over (partition by deptno) as max_sal
    from emp
    where deptno=10

/** Start with **/
    /** 查询客户行业信息，通过行业 IND200000994 查询行业层级 **/
    /** 问题点: 当前层级若不满足，则不存在结果集中，但不影响下一层级展示 **/
    select
        listagg(mci.industry_en_name,'/') within group(order by level desc) industry_en_name
    from mdm.mdm_cdh_industry_info_t mci where mci.public_flag = 'Y' and mci.status = 'Active'
    start with mci.industry_id = 'IND200000994' connect by mci.industry_id = PRIOR mci.parent_id
    group by connect_by_root(mci.industry_en_name)