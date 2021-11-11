sqlplus连接：
	sqlplus username[/password][@connect_indentifier] [AS SYSOPER|SYSDBA]
	@connect_indentifier 数据库全库名
sqlplus命令：
	set命令：设置SQL*Plus运行环境（通过SET命令设置环境变量是临时的，不永久，退出SQL*Plus环境后，用户设置环境参数全部丢失）
		格式：SET system_variable value
			变量名				可选值					说明
			ARRAY[SIZE]			20(默认)|1~5000			从数据库获取的行数
			AUTO[COMMIT]			OFF(默认)|ON|IMMEDIATE	控制Oracle对数据库的修改自动提交，IMMEDIATE同ON
			BLO[CKTERMINATOR]	.(默认)|C				设置非字母数字字符，用于结束PL/SQL块，要执行块时，必须发出RUN命令或/命令
			CMDS[EP]				;|C|OFF(默认)|ON			设置非字母数字字符，用于分割在一行中输入的多个SQL*Plus命令
			ECHO					OFF|ON					控制START命令是否列出命令文件中的每一命令，ON 列出命令  OFF 制止列清单
			FLU[SH]				OFF|ON(默认)				控制输出送至用户的显示设备， OFF 运行操作系统做缓冲区输出 ON 不允许缓冲 
			HEA[DING]			OFF|ON(默认)				控制报表列标题的打印，ON 在报表中打印列标题  OFF 禁止打印列标题
			LIN[ESIZE]			80(默认)|n				设置SQL*Plus在一行中显示的最多字符总数
			NEWP[AGE]			1(默认)|n				设置一页中空行的数量
			NULL					text						设置表示控制的文本，如果没有文本，则显示空格
			NUMF[ORMAT]			格式						设置显示数值的默认格式
			PAGES[IZE]			14(默认)|n				设置从顶部标题至页结束之间的行数
			PAS[SE]				OFF(默认)|ON|TEXT			设置SQL*Plus输出结果是否滚动显示，ON 暑促结果每一页都暂停 按ENTER后继续显示
			RECSEP				WR[APPED](默认)|EA[CH]|OFF指定显示或打印记录分行符条件，一个记录分行符有RECSEPHAR指定都字符组成的单行
			SERVEROUT[PUT]		OFF|ON [SIZE n]			控制在SQL*Plus中存储过程是否显示输出，OFF 禁止 ON 显示输出 2000<n<100万
			SHOW[MODE]			OFF(默认)|ON				控制SQL*Plus在执行SET命令时是否列出其新老值old或new的设置，ON表示列出新老值
			SPA[CE]				1(默认)|n				设置输出列之间的空格数目，最大值为10
			SQLCO[NTINUE]		>;(默认)|文本				设置字符序列进行提示
			SQLN[UMBER]			OFF|ON(默认)				为SQL命令和PL/SQL块的第二行和后继行设置提示， ON 提示行号 OFF 提示设置为 SQLPROMPT
			TI[ME]				OFF(默认)|ON				控制当前日期的显示， ON 显示每一条命令提示前显示当前时间
			TIMI[NG]				OFF(默认)|ON				控制当前时间统计的显示 ON 显示每一个运行的SQL命令或PL/SQL块的时间统计
			UND[ERLINE]			-(默认)|C|OFF|ON			设置用在SQL*Plus报表中下划线列标题的字符，ON 或 OFF 将下划线设置 开或关状态
			VER[IFY]				OFF|ON(默认)				控制SQL*Plus用值替换前／后是否列出命令的文本 ON 显示文本 OFF 禁止列清单
			WRA[P]				OFF|ON(默认)				控制SQL*Plus是否截断数据项的显示，OFF 截断数据项 ON 允许数据项缠绕到下一行
	desc[ribe] object_name;查询指定对象的结构，查询表和视图的结构
	SPO[OL] [file_name[.ext] [CRE[ATE] | REP[LACE] | APP[END]] | OFF | OUT]		把查询结果输出到指定文件中
		CRE[ATE]:创建一个新到脱机文件
		REP[LACE]：替代已存在到脱机文件
		APP[END]：脱机内容附加到一个已存在到脱机文件中
		OFF|OUT：关闭SPOOL输出
	DEF[INE] [variable] | [variable=text] 定义一个用户变量并且可以分配给它一个CHAR值
	SHO[W] option 显示系统选项，常用选项ALL/PARAMETERS [parameter_name]/SGA/SPOOL/USER等	
	ED[IT] [file_name[.ext]] 编辑或运行最近输入的SQL语句 file_name 代表SQL缓冲区中最近一条SQL语句或PL/SQL块
	SAVE file 实现将SQL缓冲区中最近一条SQL语句或PL/SQL块保存到一个文件中
	GET [FILE] file_name[.ext] [LIST|NOLIST] 把一个SQL脚本文件内容放进SQL缓冲区
	COLUMN 命令
		COL[UMN] [column_name |alias | option]
			column_name 指定设置列的名称 alias 指定列的别名 option 指定某个列的显示格式
			option 选项值				说明
			CLEAR					清除指定列设置的属性，恢复默认显示属性			
			FORMAT					格式化指定的列
			HEADING					定义列标题
			JUSTIFY					调整列标题对齐方式，默认 右对齐
			NULL						指定一个字符串，如果列值唯恐，则由该值代替
			PRINT/NOPRINT			显示列标题或隐藏列标题，默认为PRINT
			OF|OFF					控制定义的显示属性状态
			WRAPPED					当字符串超过显示宽度，将字符串的超出部分折叠到下一行显示
			WORD_WRAPPED				表示一个完整的字符串折叠
			TRUNCATED				表示截断字符串尾部
			