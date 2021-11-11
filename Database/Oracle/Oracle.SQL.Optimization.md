### SQL优化
1. 常规优化
    1. 建立不用 * 来代替所有列名
       例1：select * from student;
       优化：select stu_name,stu_age,stu_sex... from student;
       例2: select count(*) from sutdent;
       优化: select count(0) from student;
    2. 用TRUNCATE代替DELETE
        - 使用DELETE删除表中的数据行时，Oracle会使用撤销表空间来存放恢复信息。
        - 使用TRUNCATE语句对表数据删除时，系统不会将删除数据写到回滚段。（故不能 ROLLBACK）
          ```
          truncate [table | cluster] schema.[table_name] [cluster_name] [drop | reuse storage]
          cluster_name：簇名
             ```
    3. 在确保完整性的情况下多使用COMMIT语句
       COMMIT所释放资源如下
       回滚段上用于恢复数据的信息，撤销表空间也只做短暂的保留
       被程序语句获得的锁
       redo log buffer中的空间
       Oracle为管理上述资源的内部花费
    4. 尽量减少表的查询次数(尽量少使用子查询)
        - 用[NOT] EXISTS 代替 [NOT] IN
2. 表连接优化
    1. 驱动表的选择
        - 表之间的连接关系必须两个表均建有索引，优化器才能紧随from关键字后面的驱动表的规则对待
    2. WHERE子句的连接顺序
        - Oracle采用自上而下的顺序解析WHERE子句，过滤最大数据记录的条件必须写在WHERE子句末尾，也就是表连接操作以前，过滤掉的记录数越多越好。
3. 合理使用索引
    1. 何时使用索引
        - 已查询关键字为基础目标中的行随机排序
        - 包含的列数相对较少的表
        - 表中的大多数查询都包含相对简单的WHERE从句
        - 对于经常以查询关键字为基础的表，并且该表中的行遵从均匀分布
        - 缓存命中率低，并不需要操作系统权限
    2. 索引列和表达式的选择
        - WHERE从句频繁使用的关键字
        - SQL语句中频繁由于进行表连接的关键字
        - 可选择性高的(重复性少的)关键字
        - 对于取值较少的关键字或表达式，不要采用标准的B树索引，可以考虑位图索引
        - 不要将频繁修改稿的列作为索引列
        - 不要使用包含操作符或函数的WHERE从句中的关键字作为索引列，如果需要的化可以考虑建立函数索引
        - 如果大量并发的INSERT、UPDATE、DELETE语句访问了父表或字表，则考虑使用完整性约束的外部键作为索引
        - 选择索引列时，还要考虑该索引所引起的INSERT、UPDATE、DELETE操作是否值得
4. 避免全表扫描大表(全表扫描是指不加任何条件或没有使用索引的查询语句)
    - 所查询的表没有索引
    - 需要返回所有行
    - 带like并使用%（有前%分号则不走索引）
    - 对索引主列有条件限制，但使用了函数
    - 带有is null,is not null或!=等字句导致全表扫描
5. 监视索引是否被使用
    - 语法：alter index schema.index_name monitoring usage;
    - 设置监视索引 grade_index
      ```
          alter index grade_index monitoring usage;
      ```
    - 检查索引使用情况
      ```
          select * from v$object_usage;
      ```
6. 优化器
   - 语法检查：检查SQL语句的拼写是否正确
   - 语义分析：核实所有数据字典不一致的表和列的名字
   - 概要存储检查：检查数据字典，以确定该SQL语句的概要是否已经存在
   - 生成执行计划：使用基于成本的优化规则和数据字典的统计表来决定最佳执行计划
   - 建立二进制代码：基于执行计划，Oracle生成二进制执行代码
    ``` sql
    explain plan [set statement_id [=] <string literal>]
    [into <table_name>]
    for <sql_statment>
    ```
		