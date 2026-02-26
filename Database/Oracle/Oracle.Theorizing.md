1. 表设计：3NF （三大范式）
	- 第一范式：（原子性）字段不可再分解
	- 第二范式：确保表中的每列都和主键相关 (完全依赖)(解决数据冗余问题)
	- 第三范式：确保每列都和主键列直接相关,而不是间接相关(消除传递依赖)

2. 启动关闭Oracle实例
	1. STARTUP [nomount|mount|open|force|] [resetrict] [pfile=filename]
		- nomount: 启动实例不加载数据库(创建Oracle实例的各种内存结构和服务进程，不加载数据库，不打开数据库文件)
		- mount: 启动实例加载数据库并保持数据库的关闭状态(启动实例，加载数据库并保持数据库关闭状态)(数据库维护时使用，例：执行数据库完全恢复，更新数据库的归档模式)
		- open: 启动实例加载并打开数据库，默认选项
		- force: 终止实例并重新启动数据库
		- resetrict: 指定以受限制的会话方式启动数据库
		- pfile: 指定启动实例时所使用的文本参数文件 
	2. STUTDOWN [normal|transactional|immediate|abort] 
		- normal 以正常方式关闭数据库
		- transactional 在当前所有的活动事务被提交完毕后，关闭数据库
		- immediate 在尽可能短的时间内立即关闭数据库
		- abort 以终止方式关闭数据库
## Oracle体系结构
1. 实例：实例是一组Oracle后台进程以及服务器中分配的共享内存区域			
2. 数据库：数据库是由基于磁盘的数据文件／控制文件／日志文件／参数文件和归档文件等组成的物理文件集合
    1. 功能：存储数据，（存储数据的方式称为存储结构，存储结构分为逻辑存储结构和物理存储结构）
        1. 逻辑存储：为了便于管理Oracle数据而定义的具有逻辑层次关系的抽象概念，
            - 数据块是Oracle逻辑存储中最小的单位（可存放 表数据／索引数据／簇数据等）（结构：块头／表目录／行目录／空余空间／行数据）
                col name format a30
                col value format a20
                select name,value from v$paramter where name='db_block_size';(通过v$paramter数据字典查询Oracle标准数据块大小)
            - 数据区是由一组连续的Oracle数据块构成的Oracle存储结构，（数据区用来保存特定数据类型的数据）（一个或多个数据块组成一个数据区，一个或多个数据区组成一个段）
            段是为特定数据对象（表／索引／回滚）分配的一系列数据区
                - 数据段：数据段中保存的是表中的数据记录
                - 索引段：索引段中包含用于提高性能的索引
                - 回滚段：回滚段中保存了回滚条目，
                - 临时段：暂时性保存解析过程查询语句及排序过程时产生的临时数据（当执行创建索引／查询等操作，可能会使用临时存储空间）
            - 表空间
                - SYSTEM表空间：系统表空间，用于存放Oracle系统内部表和数据字典的数据（表名／列名／用户名等）（不建议把用户创建的表／索引等放进系统表中）
                    - 通过dict查询数据库数据字典信息
                        col table_name for a30
                        col comments for a30
                        select * from dict;
                    - 通过v$fixed_view_definition查看数据库中内部系统表信息
                        col view_name format a30
                        col view_definition format a30	
                        select * from v$fixed_view_definition
                - SYSAUX表空间：随数据库创建而创建，充当SYSTEM的辅助表空间
                - UODO表空间：撤销表空间，用于存储撤销信息的表空间
                - USERS表空间：用户表空间，建议用户使用的空间
        2. 物理存储结构：用来描述Oracle数据在磁盘上的物理组成情况，主要有数据文件／控制文件／重做日志文件／归档日志文件／参数文件／口令文件和警告日志文件等
            - 数据文件	用作保存用户应用程序数据和Oracle系统内部数据等文件（系统数据文件／撤销数据文件／用户数据文件）
                col file_name for a50;
                set linesize 100;
                select file_name,tablespace_name from dba_data_files;
            - 控制文件：是二进制文件，记录数据库物理结构
                Oracle系统对控制文件信息
                    col name format a60
                    slect name from v$controlfile;
            - 日志文件：记录对数据所作对修改，包括重做日志文件／归档日志文件
                - 重做日志文件：用来记录数据库所发生过更改信息及由Oracle内部行为（创建数据表／索引）而引起对数据库变化信息	
                    Oracle 系统对日志文件信息
                        col member for a50;
                        select member from v$logfile;	
                - 归档日志文件：归档日志文件会占用大量磁盘空间，会影响系统整体性能，系统默认不采用归档模式运行
                    col name format a30;
                    select dbid,name,log_mode from v$database;		
            - 服务器参数文件：二进制文件，记录Oracle数据库的基本参数信息（数据库名／控制文件所在路径／日志缓冲大小）
                - 查询视图v$parameter
                    col name for a30;
                    col value for a30;
                    select name,value,ismodified from v$parameter;
                - 显示服务器参数
                    show paramter;
                - 修改服务器参数(修改标准数据块大小为4096字节)
                    alter system set db_block_size=4096			
            - 密码文件／警告文件和跟踪文件
                - 密码文件是用于验证用户权限的二进制文件，默认存放位置在%dbhome_1%\database目录下，密码文件的命名格式为PWD<sid>,sid表示数据库实例名
                    - 创建密码文件
                        ORAPWD FILE=<filename> PASSWORD=<password> ENTRIES=<max_users>
                        filename:密码文件名称
                        password:设置internal/sys账户口令
                        max_users:表示密码文件中可以存放的最大用户数，对应允许以sysdba/sysoper权限登录数据库的最大用户数
                - 警告文件是一个存储在Oracle系统目录下的文本文件，用来记录Oracle系统运行信息和错误信息
                    - 查看警告文件
                        col name for a20;
                        col value for a50;
                        select name,value from v$parameter where name='background_dump_dest';
                跟踪文件包括后台进程跟踪文件和用户进程跟踪文件。用于记录后台进程的警告或错误消息。		
    2. 数据库服务器：数据库服务器是指管理数据库的各种软件工具（例：Sqlplus／OEM）／实例以及数据库
        1. 实例可以划分为系统全局区（SGA）和后台进程（PMON／SMON等）SGA使用操作系统内存资源，后台进程使用CPU和内存资源
        2. 系统全局区（System Global Area）：是所用用户进程共享的内存区域，它随实例的启动加载到内存中
            1. 高速数据缓存区（Database buffer cache）
                - 脏数据区：被修改过的数据，与数据块中数据信息不一致
                - 空闲区：无任何数据
                - 保留区：保留区包含正在被用户访问的数据块和明确保留以作为将来使用的数据块（缓存块）
            2. 重做日志缓存区（Red log buffer cache）：存储对数据库进行修改操作产生的日志信息，在写入日志文件前，首先写入日志缓冲区
            3. 共享池（Shared Pool）：SGA保留的内存区域，用于缓存SQL语句 PL/SQL语句 数据字典 资源锁 字符集以及其他控制结构等。共享池包含高速缓冲区和字典高速缓冲区
                - 设置共享池内存空间：
                    ```
                    alter system set shared_pool_size=30m;
                    ```
            4. 大型池（Large Pool）：实例使用大型池减轻共享池等访问压力，
                - 常用情况：
                    - 当使用恢复管理器进行备份和恢复操作时，大型池作为I/O缓冲区使用
                    - 使用I/O Slave 仿真异步I/O功能时，大型池将被当作I/O缓冲区使用
                    - 执行具有大量排序操作的SQL语句
                    - 当使用并行查询时，大型池作为并行查询进程彼此交换信息的地方
            5. Java池：提供内存空间给Java虚拟机使用，支持在数据库中运行Java程序包
            6. 流池：用于在数据库与数据库之间运行信息共享
        3. 程序全局区（Program Global Area）别称 用户进程全局区，内存区在进程私有区而不是共享区中，可以把代码／全局变量／数据结构存放在其中，每个Oracle服务器进程拥有自己的PGA资源，不被所有用户进程所共享	
            1. 私有SQL区：存储变量以及SQL语句运行时的内存结构信息
            2. 会话区：存放用户的会话信息，共享服务器连接模式，会话位于SGA区域
                - 显示当前用户进程的PGA信息
                  ```sql
                  show parameter pga;
                  ```
        4. 前台进程
            1. 用户进程：产生或执行SQL语句的应用程序，
                - 连接：用户进程与实例之间建立的通信渠道
                - 会话：用户进程与实例之间建立连接后形成的用户与实例之间的交互方式。
            2. 服务器进程：用于处理用户会话过程向数据库实例发出的SQL语句或SQL*Plus命令
        5. 后台进程
            1. 数据写入进程
            2. 检查点进程（CKPT）：
            3. 日志写入进程（LGWR）：用于将重做日志缓冲区中的数据写入重做日志文件
            4. 归档进程（ARCH）：数据库处于归档模式时，进程才起作用
            5. 系统监控进程（SMON）：数据库启动时执行恢复工作的强制性进程
            6. 进程监控进程（PMON）：用于监控其他进程的状态，当有进程启动失败时，PMON会清楚失败的用户进程
            7. 锁定进程（LCKN）：可选，并行服务器模式下出现多个锁定进程以利于数据库通信
            8. 恢复进程（RECO）：用于数据不一致时进行恢复工作
            9. 调度进程（DNNN）：可选，在共享服务器模式下使用
            10. 快照进程（SNPN）：处理数据库快照自动刷新
    3. 数据字典：Oracle存放关于数据库内部信息的地方，用途时用来描述数据库内部运行和管理情况。
        1. dba_:包含数据库实例的所有对象信息			
        2. v$_:当前实例的动态视图，包含系统管理和系统优化等所使用的视图
        3. user_:记录用户的对象信息
        4. gv_:分布式环境下所有实例的动态视图，包含系统管理和系统优化使用的视图
        5. all_:记录用户的对象信息机被授权访问的对象信息
        6. 基础数据字典
            - dba_tablespaces 表空间信息
            - dba_ts_quotas 所有用户表空间限额
            - dba_free_space 所有表空间中的自由分区
            - dba_segments 数据库中所有段的存储空间
            - dba_extends 数据库中所有分区信息
            - dba_tables 数据库中所有数据表的描述
            - dba_tab_columns 所有表／视图以及簇的列
            - dba_views 所有视图的信息
            - dba_synonyms 同义词的信息查询
            - dba_sequences 用户序列信息
            - dba_constraints 用户表的约束信息
            - dba_indexs 数据库中所有索引的描述
            - dba_ind_columns 所有表及簇上压缩索引的列
            - dba_triggers 所用用户的触发器信息
            - dba_source 所有用户的存储过程信息
            - dba_data_files 查询关于数据库文件的信息
            - dba_tab_grants/privs 查询关于对象授权的信息
            - dba_objects 数据库所有的对象
            - dba_users 管用数据库中所有用户的信息
        7. 常用动态性能视图
            - v$database 描述关于数据库的相关信息
            - v$datafile 数据库使用的数据文件信息
            - v$log 从控制文件中提取有关重做日志组的信息
            - v$logfile 有关实例重置日志组文件名及其位置的信息
            - v$archived_log 记录归档日志文件的基本信息
            - v$archived_dest 记录归档文件的路径信息
            - v$controlfile 控制文件相关信息
            - v$instance 实例基本信息
            - v$system_parameter 显示实例当前有效的参数信息
            - v$sga 显示实例的SGA区的大小
            - v$sgastat 统计SGA使用情况的信息
            - v$parameter 记录初始化参数文件中所有项的值
            - v$lock 通过访问数据库会话，设置对象锁的所有信息
            - v$session 有关会话的信息
            - v$sql 记录SQL语句的详细信息
            - v$sqltext 记录SQL语句的语句信息
            - v$bgprocess 显示后台进程信息
            - v$process 当前进程信息
		
3. 管理控制文件
    1. 控制文件是Oracle数据库最重要的物理文件之一，每一个Oracle数据库都必须至少有一个控制文件，在启动数据库实例时，Oracle会根据初始化参数查找控制文件，根据控制文件中的信息（
    2. 数据库名称、数据库文件、日志文件的名称及位置）在实例和数据库之间建立关联。
    3. 控制文件中对应数据库中的结构信息
        1. 数据库名称和SID标识
        2. 数据文件和日志文件列表（文件名称和对应路径信息）
        3. 数据库创建的时间戳
        4. 表空间信息
        5. 当前重做日志文件序列号
        6. 归档日志信息
        7. 检查点信息
        8. 回滚段的起始和结束
        9. 备份数据文件信息
    4. 控制文件的多路复用（避免产生由于某个磁盘故障而无法启动数据库的危险）	
        1.更改CONTROL_FILES参数
            alter system set control_files=
              '磁盘路径1',
              '磁盘路径2',
              '磁盘路径3'
            scope=spfile;
        2.赋值控制文件
            退出SQL*PLUS-->停止OracleServiceORCL和OracleDBConsoleORCL服务-->找到CONTROL_FILES参数指定控制文件，复制文件到新增目录下
            -->启动OracleServiceORCL和OracleDBConsoleORCL服务-->使用select name as 控制文件 from v$controlfile验证
    5. 创建控制文件(数据库所用控制文件全部丢失或损毁情况下使用)
        create controlfile
        reuse database db_name				--db_name 数据库名称通常是orcl
        logfile
        group 1 redofiles_list1				--重做日志组中的重做日志文件列表1
        group 2 redofiles_list2		
        group 3 redofiles_list3
        ...
        datafile
        datafile1							--数据文件路径
        datafile2
        datafile3
        ...
        maxlogfiles max_value1				--最大的重做日志文件数
        maxlogmembers max_value2				--最大的重做日志组成员数
        maxinstances max_value3				--最大实例数
        maxdatafiles max_value4				--最大数据文件数
        moresetlogs|resetlogs
        archivelog|noarchivelog
		
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		