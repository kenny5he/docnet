## 分区技术
1. 创建表分区
	1. 范围分区
	   - 例：
		```
			create table ware_retail_part(	  --创建一个描述商品零售的数据表
				id integer primary key,			  --销售id
				retail_date date,				  --销售日期
				ware_name varchar2(50)             --商品名称
			)
			partition by range(retail_date)
			(
				--第一个季度 分区
				partition par_01 values less than(to_date('2014-04-01','yyyy-mm-dd')) tablespace TBSP_1,
				--第二个季度 分区
				partition par_02 values less than(to_date('2014-04-01','yyyy-mm-dd')) tablespace TBSP_2,
				--第三个季度 分区
				partition par_03 values less than(to_date('2014-04-01','yyyy-mm-dd')) tablespace TBSP_3,
				--第四个季度 分区
				partition par_04 values less than(to_date('2014-04-01','yyyy-mm-dd')) tablespace TBSP_4
			);
  		
  			--插入数据时，自动根据数据情况插入进相应分区
			--查询第二个分区中的数据
			select * from ware_retail_part partition(par_02);
   		```
	2. 散列分区
		- 例：
		```
			create table ware_part3
			(
				id integer primary key,
				retail_date date,
				ware_name varchar2(50)
			)
			partition by hash(id)
			(
				partition par_01 tablespace TBSP_1,
				partition par_02 tablespace TBSP_2
			);
  		```
	3. 列表分区
	   - 例:
			```
			create table clients
			(
				id integer primary key,
				name varchar2(50),
				province varchar2(20)
			)
			partition by list(province)			--以province列为分区键创建列表分区
			(
				partition shandong values('山东省'),
				partition hunan values('湖南省'),
				partition guangdong values('广东省')
			);
   			```
	4. 组合分区(首先用第一个数据分布方法对表格进行分区，然后用第二个数据分区方法进行二次分区)
		1. Oracle11g支持组合分区方案
			1. 组合范围--范围分区
			2. 组合列表--范围分区
			3. 组合范围--散列分区
			4. 组合范围--列表分区
			5. 组合列表--列表
			6. 组合列表--散列分区
		2. 例：
		```
			create table person2
			(
				id number primary key,
				name varchar2(20),
				sex varchar2(2)
			)
			partition by range(id)						--以id作为分区键 创建范围分区
			subpartition by hash(name)					--以name列作为分区键创建hash子分区
			subpartitions 2 store in(tbsp_1,tbsp_2)		--hash子分区共有两个，分别存储在两个不同的命脉空间中
			(
				partition par1 values less than(5000),	--范围分区 id小于5000
				partition par2 values less than(10000),
				partition par3 values less than(maxvalue)--范围分区  id不小于10000
			)
  		```
2. Interval(范围分区自动化)
   ```
		create table saleRecord(
			id number primary key,
			goodsname varchar2(50),
			saledate date,
			quantity number
		)
		partition by range(saledate)
		interval (numtoyminterval(1,'year'))			--interval分区实现按年份进行自动区分
		(	
			--设置分区键值日期小于 2012-01-01
			partition par_fist values less than (to_date('2012-01-01','yyyy-mm-dd'))
		)
   ```
3. 识别大表
	1. ANALYZE TABLE语句进行分析(参考Blog:http://blog.csdn.net/bbliutao/article/details/46532001)
		- 完全计算法： analyze table table_name compute statistics;
		- 抽样估算法(抽样20%)： analyze table table_name estimate statistics sample 20 percent;
	2. 查询表的大小
		```
		SELECT segment_name AS TABLENAME,round(BYTES/1024/1024,2)||'M'  FROM user_segments WHERE segment_name='表名'
		```
4. 添加表分区
	```
	alter table clients
	add partition hebei values('河北省')
	storage(initial 10K next 20K) tablespace tbsp_1
	nologging;
	```
5. 合并分区
	1. 合并散列分区
		1. 合并person分区表中的一个HASH分区
		```
		alter table person coalesce partition;
		```
		2. 合并复合分区
			- 例：将person2分区表中的par3分区合并到其它保留的子分区
		```
		alter table person2 modify par3 coalesce subpartition;
		```
	2. 并入分区（将两个以上的分区合并到一个已存在的分区中，合并后一般索引需要重建）
		```
			create table saleRecord(
				id number primary key,
				goodsname varchar2(50),
				saledate date
			)
			partition by range(saledate)		--按日期分区
			(	
				--第一季度
				partition par_sea1 values less than (to_date('2012-01-01','yyyy-mm-dd')) tablespace tbsp_1,
				--第二季度
				partition par_sea2 values less than (to_date('2012-01-01','yyyy-mm-dd')) tablespace tbsp_2,
				--第三季度
				partition par_sea3 values less than (to_date('2012-01-01','yyyy-mm-dd')) tablespace tbsp_1,
				--第四季度
				partition par_sea4 values less than (to_date('2012-01-01','yyyy-mm-dd')) tablespace tbsp_2
			)
   		```
    3. 创建局部索引
	```
	create index index_3_4 on sales(saledate)
	local(
		partition part_sea1 tablespace tbsp_1,
		partition part_sea2 tablespace tbsp_2,
		partition part_sea1 tablespace tbsp_1,
		partition part_sea2 tablespace tbsp_2
	);
 	```
    4. 将第三分区并入到第四分区中	
	   	```
         alter table sales merge partitions part_sea4 3,part_sea4 into partition part_sea4;
	   ```
	5. 重建局部索引
	```
	alter table sales modify partition part_sea4 rebuild unusable local indexes;
	```
	6. 删除分区（删除分区时，该分区的数据也会被删除，如果不希望被删除数据，则必须采用合并分区的方法）
	```
      	alter tatble ware_retail_part drop partition par_04;
	```
 2. 索引分区
     1. 本地索引分区(局部索引)
         - 查询本地索引
         ```
        	select partition_name,tablespace_name from dba_ind_partitions where index_name ='GRADE_INDEX';
        ```
     2. 全局索引分区
		```
         create index index_saleprice on Books(saleprice)
         global partition by range(saleprice)
         (
             partition p1 values less than (30),
             partition p1 values less than (50),
             partition p1 values less than (maxvalue)
         );
		```
3. 用户管理与权限分配
	- 用户是用来连接数据库对象。而模式(schema)用是用创建管理对象的。(模式跟用户在oracle 是一对一的关系)(创建schema必须通过创建用户而创建。)
	1. 用户管理
		1. 创建用户
		   ```
			create user user_name identified by password
			[or identified exeternally]									--要求用户必须与操作系统中所定义的用户名相同
			[or identified globally as 'CN=user']						--用户名有Oracle安全域中心服务验证，CN名字表示用户的外部名
			[or identified tablespace tablepace_default]					--用户在创建数据对象时使用的默认表空间
			[temporary tablespace tablespace_temp]						--用户所使用的临时表空间
			[quato [integer k[m]] [unlimited]] on tablespace_secify1		
			[,quato [integer k[m]] [unlimited]] on tablespace_secify2		--用户在指定表空间中允许占用的最大空间
			[,...]...on tablespace_specifyn								--
			[profiles profile_name]										--资源文件名称
			[account lock or account unlock]								--用户是否被加锁
			```
		2. 修改用户
			```
			alter user east identified by password;	--修改用户密码
			alter user SH account unlock;			--解锁被锁住的用户
	   		```
		3. 删除用户
			```
				drop user user_name[ cascade]
			```
	2. 权限管理
		1. 角色授权
		   ```
			grant sys_privi | role to user | role | public [with admin option]
				sys_privi 表示Oracle系统权限
				with admin option 表示被授权用户可以将权限授予另外的用户
				public 代表系统所有用户
		   ```	
		2. 回收系统权限
		   ```
			revoke sys_privi | role from user | user | public	
     		```	
		3. 对象授权
		   	```
			grant obj_privi | all column on schema.object to user | role | public [with grant option] | [with hierarchy option]	
				obj_privi 对象授权，(ALTER EXECUTE SELECT UPDATE INSERT等)
				with admin option:授权者可以在将系统权限授予其它用户
				with hierarchy option:在对象的子对象上授权给用户
		   ```
		4. 回收对象权限
		   ```
			revoke obj_privi | all on schema.object from user | user | role | public	cascade constraints
				cascade constraints:有关联关系的权限也被回收
     		```
     	5. 权限类别

		|权限名|权限描述|
		|--- |--- |
		|DBA_USERS		|数据库用户基本信息表|
		|DBA_SYS_PRIVS	|已授予用户或角色的系统权限|
		|DBA_TAB_PRIVS	|数据库对象上的所有权限|
		|USER_SYS_PRIVS	|登录用户可以查看自己的系统权限|
		|ROLE_SYS_PRIVS	|登录用户查看自己的角色|
		|ALL_TABLES		|用户可以查看基表信息|
		|USER_TAB_PRIVS	|用户自己将哪些基表权限授予哪些用户|
		|ALL_TAB_PRIVS	|哪些用户给自己授权|
	   
	3. 角色管理
		1. 系统预定义角色
		   
			|角色	|				权限|
		    | --- | --- |
		    |CONNECT|				ALTER SESSION、CREATE CLUSTER、CREATE DATABASE LINK、CREATE SEQUENCE、CREATE SESSION、CREATE SYNONYM、CREATE TABLE、CREATE VIEW|
		    |RESOURCE|				CREATE CLUSTER、CREATE INDEXTYPE、CREATE OPERATOR、CREATE PROCEDURE、CREATE SEQUENCE、CREATE TABLE、CREATE TRIGGER、CREATE TYPE|
		    |DBA|					所有权限 不受限制|
		    |EXP_FULL_DATABASE|	SELECT ANY TABLE、BACKUP ANY TABLE、EXECUTE ANY PROCEDURE、EXECUTE ANY TYPE、ADMINISTER RESOURCE MANAGER|
		    |IMP_FULL_DATABASE|	EXECUTE——CATALOG_ROLE、SELECT_CATALOG_ROLE|
		   
		2. 创建角色与授权
		   	```
			create role role_name [not identified | identified by [password] | [exeternally] | [glabally]]	
				identified by password:角色口令
				identified by exeternally:角色名在操作系统下验证
				identified by globally:用户是Oracle 安全域中心服务器来验证，此角色有全局用户来使用
	   		```
		3. 管理角色
        	- 查看角色所包含的权限
				```
				select * from role_sys_privs where role = 'DESIGNER'
				```
		   	- 修改角色密码
				```
				alter role designer not identified;			--取消角色密码
				alter role designer identified by mrsoft;	--为角色设置新密码
				```
	4. 资源配置PROFLIE
		1. PROFILE 作为用户配置文件，是密码限制、资源限制的命名集合。
			1. 注意：
				- 建立用户时，不指定PROFLIE选项，默认将DEFAULT分配给相应数据库用户
				- 建立PROFILE时，如果设置部分密码和资源选项，其他选项会使用默认值，即使DEFAULT文件中有相应的选项值
				- 使用PROFILE管理密码时，密码管理选项总是处于被激活状态，但是如果使用PROFILE管理资源，必须激活资源限制
				- 一个用户只能分配一个PROFILE文件，如果要同时管理用户的密码和资源，那么建立PROFILE时应该同时指定密码和资源选项。
			2. 账户锁定
				```
				create profile lock_account limit
				failed_login_attempts 5					--连续失败五次
				password_time 7;							--锁定时间 7天
				alter user dongfang profile lock_account;--将文件分配给用户dongfang
				```
			3. 密码过期
				```
				create profile password_lift_time limit
				password_life_time 30					--设置密码有效时间			30天
				password_grace_time 3;					--设置口令失效的宽限时间		3天
				alter user dongfang profile password_lift_time;
				```
			4. 密码历史
				```
				password_reuse_time:参数指定密码可重用的时间，单位/天
				password_reuse_mas:设置口令在被重新使用之前，必须改变的次数，
      			```
			5. 密码复杂度
				```
				password_verify_function 对用户密码和格式验证
      			```
		2. 使用PROFILE管理资源
			1. 激活资源限制
				```
				/** 查看参数值 **/
				show parameter resource_limit;
				/** 设置参数值为true  **/
				alter system set reource_limit=true;	
				```
   			2. 对各种资源的限制
				- SESSION_PERUSER：用户可以同时连接的会话数量，如果用户的连接数达到该限制，则试图登录时参数错误信息
				- CPU_PER_SESSION:限制用户再一次进行数据库会话期间可以使用的CPU时间，(单位百分之一秒)当达到该时间后，系统终止该会话
				- CPU_PER_CALL：该参数用户限制每条SQL语句所能使用CPU时间，(单位百分之一秒)
				- LOGICAL_READS_PER_SESSION：限制每个会话所能读取的数据块数量，包括从内存中读取的数据块和从磁盘中读取的数据块。
				- CONNECT_TIME：限制每个用户连接到数据库的最长时间，单位为分钟
				- IDLE_TIME:限制每个用户会话连接到数据库的最长时间，超过该空闲时间的会话，系统将终止会话
		3. 修改PROFILE文件
			```
			alter profile password_lift_time limit
			cpu_per_session 2000
			sessions_per_user 10
			cpu_per_call 500
			password_life_time 180
			failed_login_attempts 10;
			```
		4. 删除PROFILE文件
			```
			drop profile password_lift_time cascade;
			```
		5. 显示PROFILE信息
			```
			select profile from dba_users where username='DONGFANG';
			```
		6. 显示指定PROFILE文件的资源配置信息
			```
			column limit for a20
			select resource_name,resource_type,limit from dba_profiles where profile='LOCK_ACCOUNT';
			```

## DBA必备技术
1. 查看视图原表：
	```
	SELECT view_definition FROM v$fixed_view_definition WHERE view_name='GV$SQL';
	SELECT view_definition FROM v$fixed_view_definition WHERE view_name='GV$SQLAREA';
	SELECT view_definition FROM v$fixed_view_definition WHERE view_name='GV$SQLTEXT';
	```
2. v$session 和gv$session 只在RAC中区别明显，gv$开头视图是rac全局的，v$开头是本节点的，gv$session比v$session多一个字段而已： INST_ID
	1. v$session(用于寻找用户SID或SADDR)(blog: http://blog.csdn.net/cunxiyuan108/article/details/5999220)
		1. 查找你的session信息
			```
			SELECT SID, OSUSER, USERNAME, MACHINE, PROCESS  FROM V$SESSIONWHEREaudsid = userenv('SESSIONID');  
			```
		2. 当machine已知的情况下查找session
			```
			SELECT SID, OSUSER, USERNAME, MACHINE, TERMINAL FROM V$SESSION WHEREterminal ='pts/tl'ANDmachine ='rgmdbs1';  
			```
		3. 查找当前被某个指定session正在运行的sql语句。假设sessionID为100
			```
			select b.sql_text from v$session a,v$sqlarea b where a.sql_hash_value=b.hash_value and a.sid=100  
			```
		- 寻找被指定session执行的SQL语句是一个公共需求，如果session是瓶颈的主要原因，那根据其当前在执行的语句可以查看session在做些什么。
			- 视图应用：
			- v$session 表中比较常用的几个字段说明:
				1. sid,serial#
					1.  通过sid我们可以查询与这个session相关的各种统计信息,处理信息.
						```
						SELECT * from v$sesstat where sid = :sid;   
						```
					2. 查询用户相关的各种统计信息.
						```
						SELECT a.sid, a.statistic#, b.name, a.value FROM v$sesstat a, v$statname b  WHERE a.statistic# = b.statistic#  AND a.sid = :sid;
        				```
					3. 查询用户相关的各种io统计信息
				   		```
						SELECT * from v$sess_io where sid = :sid;
				   		```
					4. 查询用户想在正在打开着的游标变量.
						```
                    	SELECT * from v$open_cursor where sid = :sid;  
						```
					5. 查询用户当前的等待信息. 以查看当前的语句为什么这么慢/在等待什么资源.
					   	```
					   SELECT * from v$session_wait where sid = :sid ; 
					   	```
					6. 查询用户在一段时间内所等待的各种事件的信息. 以了解这个session所遇到的瓶颈
					    ```
                 		SELECT * from v$session_event where sid = :sid;  
						```
					7. 还有, 就是当我们想kill当前session的时候可以通过sid,serial#来处理.
					   	```
                       	alter system kill session ':sid,:serail#';  
					   	```
						- 例：查询锁死的SQL，将它kill
						  	```
							select * from v$session t1,v$locked_object t2 where t1.sid = t2.SESSION_ID;
                           	alter system kill session ':sid,:serail';
						  	```
				2. paddr.字段, process addr, 通过这个字段我们可以查看当前进程的相关信息, 系统进程id,操作系统用户信息等等.
				   	```
                   	SELECT a.pid, a.spid, b.name, b.description, a.latchwait, a.latchspin, a.pga_used_mem, a.pga_alloc_mem, a.pga_freeable_mem, a.pga_max_mem FROM v$process a, v$bgprocess b WHERE a.addr = b.paddr(+)  AND a.addr = :paddr;
					```
				3. command 字段, 表明当前session正在执行的语句的类型.请参考reference.
				4. taddr 当前事务的地址,可以通过这个字段查看当前session正在执行的事务信息, 使用的回滚段信息等
				   	```
                   	SELECT b.name rollname, a.* FROM v$transaction a, v$rollname b WHERE a.xidusn = b.usn AND a.addr = '585EC18C';  
				   	```
				5. lockwait字段, 可以通过这个字段查询出当前正在等待的锁的相关信息.
				   	```
                   	SELECT * FROM v$lock WHERE (id1, id2) = (SELECT id1, id2 FROM v$lock WHERE kaddr = '57C68C48')  
				   	```
				6. (sql_address,sql_hash_value) (prev_sql_addr,prev_hash_value) 根据这两组字段, 我们可以查询到当前session正在执行的sql语句的详细信息.
				   	```
                   	SELECT * FROM v$sqltext WHERE address = :sql_address AND hash_value = :sql_hash_value;  
				   	```
				7.ROW_WAIT_OBJ#,ROW_WAIT_FILE#,ROW_WAIT_BLOCK#,ROW_WAIT_ROW#可以通过这几个字段查询现在正在被锁的表的相关信息.^_^
					1. 首先得到被锁的的信息
					   	```
                       	SELECT * FROM dba_objects WHERE object_id = :row_wait_obj#; 
					   	```
					b. 根据row_wait_file#可以找出对应的文件的信息.
					   	```
                       	SELECT * FROM v$datafile WHERE file# = :row_wait_file#. 
					   	```
					c. 在根据以上四个字段构造出被锁的字段的rowid信息.
					   	```
                      	SELECT dbms_rowid.ROWID_CREATE(1, :row_wait_obj#, :row_wait_file#, :row_wait_block#, :row_wait_row#)  FROM dual; 
					   	```
				8. logon_time 当前session的登录时间.
				9. last_call_et 该session idle的时间, 每3秒中更新一次.
				
	2. v$sqlarea中的信息列($sql与v$sqlarea基本相同，记录共享sql区（share pool）中sql统计信息)
		- HASH_VALUE：SQL语句的Hash值。 
		- ADDRESS：SQL语句在SGA中的地址。 
		- PARSING_USER_ID：为语句解析第一条CURSOR的用户 
		- VERSION_COUNT：语句cursor的数量 
		- KEPT_VERSIONS： 
		- SHARABLE_MEMORY：cursor使用的共享内存总数 
		- PERSISTENT_MEMORY：cursor使用的常驻内存总数 
		- RUNTIME_MEMORY：cursor使用的运行时内存总数。 
		- SQL_TEXT：SQL语句的文本（最大只能保存该语句的前1000个字符）。 
		- MODULE,ACTION：使用了DBMS_APPLICATION_INFO时session解析第一条cursor时的信息 
		- SORTS: 语句的排序数 
		- CPU_TIME: 语句被解析和执行的CPU时间 
		- ELAPSED_TIME: 语句被解析和执行的共用时间 
		- PARSE_CALLS: 语句的解析调用(软、硬)次数 
		- EXECUTIONS: 语句的执行次数 
		- INVALIDATIONS: 语句的cursor失效次数 
		- LOADS: 语句载入(载出)数量 
		- ROWS_PROCESSED: 语句返回的列总数
		- 例:
		  	1. 查找前10条性能差的sql语句
			```
			SELECT * FROM (select PARSING_USER_ID,EXECUTIONS,SORTS,COMMAND_TYPE,DISK_READS,sql_text FROM v$sqlarea  
			order BY disk_reads DESC )where ROWNUM<10 ;
			```
			2. 查看执行次数多的sql
			```
   			Select sql_text,executions,parsing_schema_name From v$sqlarea Order by executions desc;
			```
3. v$sqlstats 该视图中保存着sql游标性能的统计信息。v$sqlstats中的列定义和$sql与v$sqlarea中的基本一致，但保存的信息时间更长)
	