### sql语句的执行步骤：
1. 语法分析，分析语句的语法是否符合规范，衡量语句中各表达式的意义。
2. 语义分析，检查语句中涉及的所有数据库对象是否存在，且用户有相应的权限。
3. 视图转换，将涉及视图的查询语句转换为相应的对基表查询语句。
4. 表达式转换， 将复杂的 SQL 表达式转换为较简单的等效连接表达式。
5. 选择优化器，不同的优化器一般产生不同的“执行计划”
6. 选择连接方式， ORACLE 有三种连接方式，对多表连接 ORACLE 可选择适当的连接方式。
7. 选择连接顺序， 对多表连接 ORACLE 选择哪一对表先连接，选择这两表中哪个表做为源数据表。
8. 选择数据的搜索路径，根据以上条件选择合适的数据搜索路径，如是选用全表搜索还是利用索引或是其他的方式。
9. 运行“执行计划”

### SQL优化
1. 使用exists替代in 子查询 
    - 问题原因分析: 使用EXIST，Oracle系统会首先检查主查询，然后运行子查询直到它找到第一个匹配项，
          这就节省了时间Oracle系统在执行IN子查询时，首先执行子查询，并将获得的结果列表存放在在一个加了索引的临时表中。
2. 避免使用having子句
    - 问题原因分析: HAVING 只会在检索出所有记录之后才对结果集进行过滤。

### SQL Select语句完整的执行顺序：   
1. from子句组装来自不同数据源的数据；
2. where子句基于指定的条件对记录行进行筛选；
3. group by子句将数据划分为多个分组；
4. 使用聚集函数进行计算；
5. 使用having子句筛选分组；
6. 计算所有的表达式；
7. select 的字段；
8. 使用order by对结果集进行排序。

### 执行计划
1. 什么是执行计划
 - SQL是一种傻瓜式语言，每一个条件就是一个需求，访问的顺序不同就形成了不同的执行计划。Oracle必须做出选择，一次只能有一种访问路径。执行计划是一条查询语句在Oracle中的执行过程或访问路径的描述。
2. 执行计划的选择
 - 通常一条SQL有多个执行计划，那我们如何选择？那种执行开销更低，就意味着性能更好，速度更快，我们就选哪一种，这个过程叫做Oracle的解析过程，然后Oracle会把更好的执行计划放到SGA的Shared Pool里，后续再执行同样的SQL只需在Shared Pool里获取就行了，不需要再去分析。
3. 执行计划选定依据
 - 根据统计信息来选择执行计划。

4. 执行计划的种类
    1. 如果sql执行很长时间才出结果或返回不了结果，用方法1：explain plan for
    2. 跟踪某条sql最简单的方法是方法1：explain plan for，其次是方法2：set autotrace on
    3. 如果相关察某个sql多个执行计划的情况，只能用方法4：dbms_xplan.display_cursor或方法6：awrsqrpt.sql
    4. 如果sql中含有函数，函数中有含有sql，即存在多层调用，想准确分析只能用方法5：10046追踪
    5. 想法看到真实的执行计划，不能用方法1：explain plan for和方法2：set autotrace on
    6. 想要获取表被访问的次数，只能用方法3：statistics_level = all

|获取方法|优点|缺点|
| --- | --- | --- |
|[explain plan for] plsql按F5<br/>explain plan for select * from dual;</br>select * from table(dbms_xplan.display());|无需真正执行，快捷方便|	1.没有输出相关统计信息，例如产生了多少逻辑读，多少次物理读，多少次递归调用的情况；<br/>2.无法判断处理了多少行；<br/>3.无法判断表执行了多少次|
|[set autotrace on]-sql*plus<br/>set autotrace on<br/>select * from dual;|1.可以输出运行时的相关统计信息（产生多少逻辑读、多少次递归调用、多少次物理读等）；<br/>2.虽然要等语句执行完才能输出执行计划，但是可以有traceonly开关来控制返回结果不打屏输出；|1.必须要等SQL语句执行完，才出结果；<br/>2.无法看到表被访问了多少次；|
|[statistics_level=all]<br/>alter session set statistics_level=all;<br/>select * from dual;<br/>select * from table(dbms_xplan.display_cursor(‘sql_id/hash_value’,null,'allstats last'));|1.可以清晰的从starts得出表被访问多少次；<br/>2.可以从E-Rows和A-Rows得到预测的行数和真实的行数，从而可以准确判断Oracle评估是否准确；<br/>3.虽然没有准确的输出运行时的相关统计信息，但是执行计划中的Buffers就是真实的逻辑读的数值；|1.必须要等执行完后才能输出结果；<br/>2.无法控制结果打屏输出，不像autotrace可以设置traceonly保证不输出结果；<br/>3.看不出递归调用，看不出物理读的数值|
|[dbms_xplan.display_cursor]<br/>select * from table( dbms_xplan.display_cursor('&sql_id') );|1.知道sql_id即可得到执行计划，与explain plan for一样无需执行；<br/>2.可得到真实的执行计划|1.没有输出运行的统计相关信息；<br/>2.无法判断处理了多少行；<br/>3.无法判断表被访问了多少次；|
|步骤1：alter session set events '10046 trace name context forever,level 12'; --开启追踪<br/>步骤2：执行sql语句；<br/>步骤3：alter session set events '10046 trace name context off'; --关闭追踪<br/>步骤4：找到跟踪后产生的文件（开启10046前先用‘ls -lrt’看一下文件，执行结束后再看哪个是多出来的文件即可）<br/>步骤5：tkprof trc文件 目标文件 sys=no sort=prsela,exeela,fchela --格式化命令|1.可以看出sql语句对应的等待事件；<br/>2.如果函数中有sql调用，函数中有包含sql，将会被列出，无处遁形；<br/>3.可以方便的看处理的行数，产生的逻辑物理读；<br/>4.可以方便的看解析时间和执行时间；<br/>5.可以跟踪整个程序包|1.步骤繁琐；<br/>2.无法判断表被访问了多少次；3.执行计划中的谓词部分不能清晰的展现出来|
