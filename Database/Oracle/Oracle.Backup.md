# 数据备份
### RMAN
RMAN是执行备份和恢复操作的客户端应用程序，最简单的RMAN只包括两个组件：RMAN命令执行器和目标数据库。

1. RMAN命令执行器
    - WINDOWS运行窗口输入 RMAN TARGET SYSTEM/NOCATALOG
    - SHOW ALL(查看当前所有的默认配置)

    
        目标数据库
        RMAN恢复目录
        介质管理子系统
        备份数据库
        恢复目录数据库
	
2. 手动分配通道
```
    run{
        allocate channel ch_1 device type disk
        format = 'd:\oracledf\%u_%c.bak';
        backup tablespace system,users.tbsp_1,ts_1 channel ch_1;
    }
```
3. 自动分配通道
    ```
        backup tablespace users;
        run{restore tablespace examples;}
    ```
	1. 自动分配通道命令
			CONFIGURE DEVICE TYPE SBT/DISK PARALLELISM N：用于定义RMAN使用的通道数量
			CONFIGURE DEFAULT DEVICE TYPE TO DISK/SBT：用于指定自动通道的默认设备
			CONFIGURE CHANNEL DEVICE TYPE：用于设置自动通道的参数
			清除自动分配通道的设置，将通道清除设置为默认状态
				CONFIGURE TYPE DISK CLEAR
				CONFIGURE DEFAULT DEVICE TYPE CLEAR
				CONFIGURE CHANNER DEVICE TYPE DISK/SBT CLEAR
	2. RMAN命令
		1.  连接到目标数据库
			- 如果RMAN未使用恢复目录，则可以使用如下命令形式之一连接到目标数据库
				$rman nocatalog
				$rman target sys/nocatalog
				$rman target /
				connect target sys/password@网络连接串（如果目标数据库与RMAN不在同一个数据库服务器时必须使用"@网络连接串"的方法）
			- 如果目标数据库服务器与RMAN不在同一个服务器上，则需要添加网络连接
				$rman target /catalog rman/rman@man
				$ramn target sys/change_on_install catalog rman/rman
				connect catalog sys/password@网络连接串
		2. 建立备份表空间(SQL*Plus环境使用SYSTEM模式登录)
			create tablespace rman_tbsp datafile 'D:\OracleFiles\Recover\rman_tbsp.dbf' size 2;
			创建RMAN用户并授权
				create user rman_user identified by mrsoft default tablespace rman_tbsp tem porary tablespace temp;
				grant connect,recovery_catalog_owner,resource to rman_user;
			打开恢复管理器
				rman catalog rman_user/mrsoft target orcl; 或 rman target system/1qaz2wsx catalog rman_user/mrsoft;
			在RMAN模式下，使用REGISTER命令注册数据库
				register database;
			启动关闭数据库
				shutdown immediate;
				startup;	
				startup mount;
				startup pfile = 'F:\app\oracle\product\initora11g.ora';
				alter database open;
	3. 备份数据库
		命令行中输入: rman target 用户/密码 catalog rman_user/_rman_password;
		RMAN命令行输入: backup database format 'D:\OracleFiles\Backup\oradb_%Y_%M_%D_%U.bak'
					  maxsetsize 2G;
		非一致性备份 RMAN命令行输入: sql 'alter system archive log current';
		查看建立的备份集与备份片段信息: RMAN命令行输入: list backup of database;
	4. 备份表空间
		- 连接到目标数据库：rman target 用户名/密码 nocatalog;
		- 在RMAN中执行BACKUP TABLESPACE命令，使用受到分配的通道ch_1对两个表空间进行备份
            ```
            run{
                allocate channel ch_1 type disk;
                backup tablespace tbsp_1,ts_1
                format 'D:OracleFiles\Backup%d_%p_%t_%c.dbf'
            }
            ```
		- 执行LIST BACKUP OF TABLESPACE命令查看建立的表空间备份信息
            ```
            list backup of tablespace tbsp_1,ts_1;
            ```
	5. 备份数据文件及数据文件的复制
		- 在RMAN中执行BACKUP DATAFILE命令备份指定的数据文件
            ```
			backup datafile 1,2,3 filesperset 3;
            ```
		- 使用LIST BACKUP OF DATAFILE查看备份结果
            ```
			list backup of datafile 1,2,3;
            ```
	6. 备份控制文件
       ```
		backup current controlfile; 或 backup tablespace tbsp_1 include current controlfile;
		```
        - 查看包含控制文件的备份集与备份段信息: list backup of controlfile;
7. 增量备份(数据库在归档模式下时，既可以在数据库关闭状态下运行增量备份，也可以在数据库打开状态下运行增量备份。非归档模式下时，只能在关闭数据库后进行增量备份)
    1.  0级差异增量备份(system,sysaux和users表空间)
        - RMAN中执行
            ```
            run{
                allocate channel ch_1 type disk;
                backup incremental level=0
                format 'D:\OracleFiles\Backup\oar11g_%m_%d_%c.bak'
                tablespace system,sysaux,users;
            }
            ```
    2. 1级差异增量备份(system表空间)
        - RMAN中执行
            ```
            backup incremental level = 1
            format 'D:\OracleFiles\Backup\oar11g_%m_%d_%c.bak'
            tablespace system;
            ```
    3. 2级差异增量备份
        - RMAN中执行
            ```
            backup incremental level=2 cumulative tablespace example
            format 'D:\OracleFiles\Backup\oar11g_%m_%d_%c.bak';
            ```