	/* 基本数据类型 */
		/* 数值类型 NUMBER、PLS_INTEGER、BINARY_INTEGER 三种基本类型，NUMBER类型可以存储整数和浮点数*/
			/* NUMBER烈性多重命名 DEC、DECIMAL、DOUBLE、INTEGER、INT、NUMERIC、SMALLINT、BINARY_INTEGER、PLS_INTEGER */
		/* 字符类型 VARCHAR2、CHAR、LONG、NCHAR、NVARCHAR2 */
			/* VARCHAR2 用于存储可变长度的字符串 */
			/* CHAR 表示指定长度的字符串 */
			/* LONG 表示一个可变的字符串*/	
		/* 日期类型 DATE*/
			/* 存储空间为7个字节，分别使用一个字节存储 世纪、年、月、日、时、分、秒 */ 
		/* 布尔类型 */
			/* BOOLEAN 用于程序流程控制和业务逻辑判断， TRUE FALSE NULL */
		/* BLOB (binary large object)，二进制大对象，是一个可以存储二进制文件的容器。 *//* CLOB使用CHAR来保存数据。 */
			/*MySQL的四种BLOB类型(TinyBlob 最大 255、Blob 最大 64K、MediumBlob 最大16M、LongBlob 最大 4G)*/
		/* 特殊类型 */
			/* %TYPE 声明一个与指定列名称相同的数据类型 */
				/* 例：*/
				declare
					var_ename emp.ename%type;										 --声明与ename列类型相同的变量
					var_job emp.job%type;			
				begin
					select ename,job into var_ename,var_job from emp where empno=7369;--查询数据并保存到变量中
					dbms_output.put_line(var_ename||'的职务是'||var_job);				--输出
				end;
				/																	--结束符/
			/* RECORD 使用该类型变量可以存储由多个列值组成的一行数据 */
				/* 例 */
				declare
					type emp_type is record                                          	--声明record类型emp_type
					(
						var_name varchar2(20),										--定义字段/成员变量
						var_job varchar2(20),
						var_sal number
					);
					empinfo emp_type;												--定义变量
				begin
					select ename,job,sal
					into empinfo														--查询数据至record变量中
					from emp
					where empno=7369;
					dbms_output.put_line(empinfo.var_ename||'的职务是'||empinfo.var_job||'工资是'||empinfo.var_sal);		--输出
				end;
				/																	--结束符/
			/* %ROWTYPE 可以根据数据表中行的结构定义一种特殊的数据类型，能够存储表中一行数据的特殊类型 */
				/* 例 */
				declare
					rowVar_emp emp%rowtype;											--定义变量
				begin
					select ename,job,sal
					into rowVar_emp													--查询数据至record变量中
					from emp
					where empno=7369;
					dbms_output.put_line(rowVar_emp.var_ename||'的职务是'||rowVar_emp.var_job||'工资是'||rowVar_emp.var_sal);	--输出
				end;
				/																	--结束符/
	/* 定义变量、常量 */
			/* 定义变量： <变量名> <数据类型> [(长度):=<初始值>]; */
			/* 定义常量： <变量名> constant <数据类型> [(长度):=<初始值>];  constant 相当于java中的final*/
	/* 块结构 */
		[DECLARE]
			--声明部分
		BEGIN
			--执行部分
		[EXCEPTION]	
			--异常处理部分
		END 
	/* 流程控制语句 */
		/* if then elseif */
			if <condition_expression1> then
			elseif <condition_expression2> then
			else
			end if;
		/* case语句 */
			case <selector>
				when <expression1> then plsql_sentence1;
				when <expression2> then plsql_sentence2;
				[else plsql_sentence;]
			end case;
	/* 循环语句 */		
		/* loop语句 */
			loop
				plsql_sentence;
				exit when end_condition_exp
			end loop;
		/* while语句 */
			while condition_expression loop
				plsql_sentence;
			end loop;
		/* for语句 */
			for variable_counter_name in [reverse] lower_limit..upper_limit loop
				plsql_sentence;
			end loop;
			/* variable_counter_name:变量 lower_limit:下限值 upper_limit:上限值*/
	/* 游标 */	
		/* 显式游标 : 由用户声明操作的一种游标，通常用于操作查询结果集*/
			/* 游标属性 %found、%notfound、%isopen、%rowcount */
			/* 步骤 : 声明游标、打开游标、读取游标、关闭游标 */
				/* 例 */
				set serveroutput on
				declare
					cursor cur_emp(var_job in varchar2:='SALESMAN')					--声明游标
					is select empno,ename,sal
						from emp
						where job=var_job;
					type record_emp is record										--声明一个记录类型(record)
					(
						var_empno emp.empno%type,
						var_ename emp.ename%type,
						var_sal emp.sal%type
					);
					emp_row record_emp;												--声明一个record_emp类型的变量
				begin
					open cur_emp('MANAGER');											--打开游标
					fetch cur_emp into emp_row;										--让指针指向结果集的第一行，并将值保存到emp_row中
					while cur_emp%found loop
						dbms_output.put_line(emp_row.var_ename||'的编号是'||emp_row.var_empno);
						fetch cur_emp into emp_row;									--让指针指向结果集的下一行，并将值保存到emp_row中
					end loop;
					close cur_emp;													--关闭游标
				end;
				/																	--结束符
		/* 隐式游标 : 主要是处理数据操纵语句*/
			/* 例 */
				set serveroutput on
				begin
					update emp
					set sal = sal*(1+0.2)
					where job='SALESMAN';
					if sql%notfound then
						dbms_output.put_line('没有雇员需要上调工资');
					else
						dbms_output.put_line('有'||sql%rowcount||'个雇员工资上调20%');
					end if;
				end 
				/
		/*  循环 遍历 游标 */
			/* 例 */
			set serveroutput on
			begin
				for emp_record in (select empno,ename,sal from emp where job='SALESMAN')--遍历隐式游标中的记录
				loop
					dbms_output.put('雇员编号：'||emp_record.empno);
				end loop;
			end; 
			/
	/* 异常处理 */		
		/* 系统预定义异常 */
			/* ZERO_DIVIDE					除数为零引发的异常 */
			/* ACCESS_INTO_NULL				企图为某个未初始化对象的属性赋值 */
			/* COLLECTION_IS_NULL			企图使用为初始化的集合元素 */
			/* CURSOR_ALREADY_OPEN			企图再次打开一个已经打开过的游标，但在重新打开之前，游标未关闭 */
			/* INVALID_CURSOR				执行一个非法的游标操作，例如：关闭一个未打开的游标 */
			/* INVALID_NUMBER				企图讲一个字符串转换成一个无效的数字而失败 */
			/* LOGIN_DENIED					企图使用无效的用户名或密码连接数据库 */
			/* NO_DATA_FOUND					SELECT INTO 语句没有返回数据 */
			/* ROWTYPE_MISMATCH				主游标变量与PL/SQL游标变量的返回类型不兼容 */
			/* SELF_IS_NULL					使用对象类型时，使用空对象调用其方法 */
			/* SUBSCRIPT_BEYOND_COUNT		元素下标超过嵌套表或VARRAY的最大值 */
			/* SUBSCRIPT_OUTSIDE_LIMIT		企图使用非法索引号引用嵌套表或VARRAY中的元素 */
			/* SYS_INVALID_ROWID			字符串向ROWID转换时的错误，因为该字符串不是一个有效的ROWID值 */
			/* TIMEOUT_ON_RESOURCE			Oracle在等待资源时超时 */
			/* TOO_MANY_ROWS				执行SELECT INTO语句时，结果集超过一行引发异常 */
		/* 自定义异常 */	
			/* 错误编号异常 指在Oracle系统发生错误时，系统会显示错误编号和相关描述信息的异常*/
				set serveroutput on
				declare
					primary_iterant exception									--定义一个异常变量
					pragma exception_init(primary_iterant,-00001);				--关联错误号和异常变量名
				begin
					insert into dept value(10,'软件开发部','深圳');
				exception
					when primary_iterant then									--捕捉异常
						dbms_output.put_line('主键不允许重复');
				end;
				/
			/* 业务逻辑异常 */
				set serveroutput on
				declare
					null_exception exception;									--声明一个exception类型的异常变量
					dept_row dept%rowtype;										--声明rowtype类型的变量 dept_row
				begin
					dept_row.deptno:=66;											--给变量赋值
					dept_row.dname:='公共部';										
					insert into dept
					values(dept_row.deptno,dept_row.dname,dept_row.loc);			--插入一条数据至表
					if dept_row.loc is null then
						raise null_exception;									--引发异常，程序转入exception部分
					end if;
				exception
					when null_exception then										--捕捉空异常
					dbms_output.put_line('loc字段的值不允许为Null');				
					rollback;													--回滚事物
				end; 
				/
	/* 存储过程 ：命名的PL/SQL语句块，已编译好的代码(执行效率高)*/
		/* 创建存储过程 */
			create [or replace] procedure procedure_name [(parameter1[,parameter2]...)] is|as
			begin
				plsql_sentences;
			[exception]
				[dowith_sentences;]
			end [procedure_name]; 
		/* 例 */	
			create or replace procedure in pro_square(
			num in out number,													--计算平方或平方根  in out 参数
			flag in boolean default true)is										--计算平方或平方根的标识 in 参数  默认值为true
			i int :=2;															
			begin
				if flag then
					num:= power(num,i);
				else
					num:=sqrt(num);
				end if;
			exception
				when no_data_found then
				  dbms_output.put_line('该部门编号不存在');
			end 
		/*调用存储过程*/
			/* 指定名称传递 */
			begin
				pro_square(num=>16,flag=>false);
			end; 
			/* 按位置传递 */
			begin
				pro_square(16,false);
			end; 
	/* 视图 */
		create [or replace] view <view_name> [alias[,alias]...)] 		--创建 或 修改视图 并取别名
		as <subquery>												--用于指定视图对应的子查询语句
		[with check option] [constraint constraint_name]				--用于指定在视图上定义的CHECK约束
		[with read only]												--用于定义只读视图
			
		/*重新编译视图*/
			alter view view_name compile;
		/* 查看视图定义 */
			desc user_views;
			select text from user_views where view_name = upper(view_name)；
		/* 删除视图 */	
			drop view view_name;
	/* 函数 */			
		/* 用于计算和返回一个值，一般将经常使用的计算或功能封装成函数 */
			create [or replace] function fun_name(parameter1[,parameter2]...) return data_type is [inner_variable]
			begin
				plsql_sentence;
			[exception]	
				[dowith_sentences]
			end [fun_name]; 
			
	/* 触发器 */		
			/* 语法 */
			create [or replace] trigger tri_name
				[before | after | instead of] tri_event						--before 操作前触发 after 操作后触发 instead of 表示触发器为替代触发器 
				on table_name | view_name | user_name | db_name				--某些操作引起触发器运行
				[fore each row] [when tri_condition]							--for each row 指定触发器为行级触发器  tri_condition 触发条件表达式
				begin
					plsql_sentences											--触发器功能实现主体
				end tri_name;
			/* 语句级触发器 针对一条DML语句而引起的触发执行 */	
				create or replace trigger tri_dept
					before insert or update or delete
					on dept
				declare
					var_tag varchar2(10);
				begin
					if inserting then										--触发事件是 INSERT时，也可针对列  if updating(cloumn) then dosometing end if;
						var_tag:='插入';
					elsif updating then										--触发事件是 UPDATE时
						var_tag:='修改';
					elsif deleting then										--触发事件是 DELETE时
						var_tag:='删除';										
					end if;
					insert into dept_log values(var_tag,sysdate);			--向日志表中插入对dept表的操作信息
				end tri_dept;
			/* 行级触发器 针对DML所影响的每一行数据都执行一次触发器*/
				create or replace trigger tri_insert_good
					before insert
					on goods
					for each row												--创建行级触发器
				begin
					select seq_id,nextval
					into :new.id
					from dual;												--从序列中生成一个新数值，赋值给当前插入行的id列
				end; 
			/* 替换触发器 替换触发器定义在视图，不是定义在表上*/	
				create or replace trigger tri_insert_view
					instead of insert
					on view_emp_dept
					for each row
				declare
					row_dept dept%rowtype;
				begin
					select * from row_dept from dept where deptno =: new.deptno;
					if sql%notfound then										--未查询到该部门编号的记录
						insert into dept(deptno,dname)						--向dept 表中插入数据、
						values(:new.deptno,:new.dname);
					end if;
					insert into emp(empno,ename,deptno,job,hiredate)
					values(:new.empno,:new.ename,:new.deptno,:new.job,:new.hiredte);
				end tri_insert_view;
			/* 用户事件触发器 */	
				create or replace trigger tri_ddl_oper
					before create or alter or drop
					on scott.schema											--在scott模式下 创建 修改 删除数据对象之前将引发该触发器的运行
				begin
					insert into ddl_oper_log values(
					ora_dict_obj_name,										--操作数据对象名称
					ora_dict_boj_type,										--操作数据对象类型
					ora_sysevent,											--操作事件名称
					ora_login_user,											--登录用户
					sysdate);
				end 
				
	/* 程序包 */	
			/* 程序包一定要在 包主体之前被创建*/	
			create [or replace] package pack_name is 
				[declare_variable];											--规范内声明变量
				[declare_type];												--声明类型
				[declare_cursor];											--声明游标
				[declare_function];											--声明函数，仅定义参数和返回类型，不包括函数主体
				[declare_procedure];											--声明存储过程，仅定义参数，不包括 存储过程主体
			end [pack_name];
			/* 例： */
			create or replace package pack_emp is
				function fun_avg_sal(num_deptno number) return number;		--声明函数
				procedure pro_regulate_sal(var_job varchar2,num_proportion number);		--声明存储过程
			end pack_emp;	
			/																--结束符
			/* 包主体 */
				create [or replace] package body pack_name is
				[inner_variable]
				[cursor_body]
				[function_title]
				{begin
					fun_plsql;
				[exception]
					[dowith_sentences;]
				end [fun_name]}
				[procedure_title]
				{begin
					pro_plsql;
				[exception]
					[dowith_sentences;]
				end [pro_name]}
			/* 例： */
				create or replace package body pack_emp is
					function fun_avg_sal(num_deptno number) return number is		--引入"规范"中的函数
						num_avg_sal number;
					beign
						select avg(sal)
						into num_avg_sal
						from emp
						where deptno=num_deptno;
						return(num_avg_sal);										--返回平均工资
					exception
						when no_data_found when
							dbms_output.put_line('不存在该雇员');
						return 0;
					end fun_avg_sal;
					procedure pro_regualte_sal(var_job varchar2,num_proportion number) is	--引入规范中的函数
					begin
						update emp
						set sal=sal*(1+num_proportion)
						where job = var_job;
					end pro_regulate_sal;
				end pack_emp;
				/