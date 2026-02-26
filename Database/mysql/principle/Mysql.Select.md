## Mysql 查询
1. Mysql 查询时，锁的影响？
   1. Mysql 查询时，会持有 MDL 元数据读锁，与元数据写锁，存在冲突。

#### Mysql Select Count(*)
1. 在不同的 MySQL 引擎中，count(*) 有不同的实现方式。
   - MyISAM 引擎把一个表的总行数存在了磁盘上，因此执行 count(*) 的时候会直接返回这个数，效率很高；
   - InnoDB 引擎执行 count(*) 的时候，需要把数据一行一行地从引擎里面读出来，然后累积计数。
2. InnoDB为什么不把Count(*)数字存起来呢?
    1. 多版本并发控制（MVCC
    ![MVCC 案例](workspace/git/worknotes/docnet/Database/mysql/imgs/Mysql.InnoDB.Select.Count..webp)
        - 三个会话 A、B、C 会同时查询表 t 的总行数,但结果却不同。
    2. InnoDB 可重复读是它默认的隔离级别，在代码上就是通过多版本并发控制，也就是 MVCC 来实现的。每一行记录都要判断自己是否对这个会话可见，因此对于 count(*) 请求来说，InnoDB 只好把数据一行一行地读出依次判断，可见的行才能够用于计算“基于这个查询”的表的总行数。
3. InnoDB 是索引组织表，主键索引树的叶子节点是数据，而普通索引树的叶子节点是主键值。所以，普通索引树比主键索引树小很多。MySQL 优化器会找到最小的那棵树来遍历。在保证逻辑正确的前提下，尽量减少扫描的数据量，是数据库系统设计的通用法则之一。
4. show table status，输出结果的TABLE_ROWS 通过采样估算得来的，与Count(*)不同。
5. 不同的 count 用法的差别？
    1. count() 是一个聚合函数，对于返回的结果集，一行行地判断，如果 count 函数的参数不是 NULL，累计值就加 1，否则不加。最后返回累计值。
    2. count(*)、count(主键 id) 和 count(1) 都表示返回满足条件的结果集的总行数；而 count(字段），则表示返回满足条件的数据行里面，参数“字段”不为 NULL 的总个数。
    3. 对于 count(主键 id) 来说，InnoDB 引擎会遍历整张表，把每一行的 id 值都取出来，返回给 server 层。server 层拿到 id 后，判断是不可能为空的，就按行累加。
    4. 对于 count(1) 来说，InnoDB 引擎遍历整张表，但不取值。server 层对于返回的每一行，放一个数字“1”进去，判断是不可能为空的，按行累加。
    5. count(*) 是例外，并不会把全部字段取出来，而是专门做了优化，不取值。count(*) 肯定不是 null，按行累加。故Mysql的Count(*)与Count(0)差异不大。

### 相同查询逻辑，性能分析
1. 条件字段函数操作
    - 案例: 交易系统,交易记录表 tradelog 包含交易流水号（tradeid）、交易员 id（operator）、交易时间（t_modified）
    ```sql
    CREATE TABLE `tradelog` (
      `id` int(11) NOT NULL,
      `tradeid` varchar(32) DEFAULT NULL,
      `operator` int(11) DEFAULT NULL,
      `t_modified` datetime DEFAULT NULL,
      PRIMARY KEY (`id`),
      KEY `tradeid` (`tradeid`),
      KEY `t_modified` (`t_modified`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ```
    1. 统计发生在所有年份中 7 月份的交易记录总数
        ```sql
        select count(*) from tradelog where month(t_modified)=7;
        ```
        - t_modified字段上有索引，但是对字段做了函数计算，就用不上索引，
        - 对索引字段做函数操作，可能会破坏索引值的有序性，因此优化器就决定放弃走树搜索功能。

2. 隐式类型转换
    ```sql
    select * from tradelog where tradeid=110717;
    ```
    - 交易编号 tradeid 存在索引，但是 explain 的结果却显示全表扫描。
    - tradeid 的字段类型是 varchar(32)，而输入的参数却是整型，所以需要做类型转换。
    1. 转换规则
        - 如果规则是“将字符串转成数字”，那么就是做数字比较，结果应该是 1；
        - 如果规则是“将数字转成字符串”，那么就是做字符串比较，结果应该是 0。
    2. 实际执行的结果等同于 
    ```sql
    select * from tradelog where CAST(tradid AS signed int) = 110717;
     ```
3. 隐式字符编码转换
    - 案例: 表 trade_detail，用于记录交易的操作细节 
    ```sql
    CREATE TABLE `trade_detail` (
    `id` int(11) NOT NULL,
    `tradeid` varchar(32) DEFAULT NULL,
    `trade_step` int(11) DEFAULT NULL, /*操作步骤*/
    `step_info` varchar(32) DEFAULT NULL, /*步骤信息*/
    PRIMARY KEY (`id`),
    KEY `tradeid` (`tradeid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    insert into tradelog values(1, 'aaaaaaaa', 1000, now());
    insert into tradelog values(2, 'aaaaaaab', 1000, now());
    insert into tradelog values(3, 'aaaaaaac', 1000, now());

    insert into trade_detail values(1, 'aaaaaaaa', 1, 'add');
    insert into trade_detail values(2, 'aaaaaaaa', 2, 'update');
    insert into trade_detail values(3, 'aaaaaaaa', 3, 'commit');
    insert into trade_detail values(4, 'aaaaaaab', 1, 'add');
    insert into trade_detail values(5, 'aaaaaaab', 2, 'update');
    insert into trade_detail values(6, 'aaaaaaab', 3, 'update again');
    insert into trade_detail values(7, 'aaaaaaab', 4, 'commit');
    insert into trade_detail values(8, 'aaaaaaac', 1, 'add');
    insert into trade_detail values(9, 'aaaaaaac', 2, 'update');
    insert into trade_detail values(10, 'aaaaaaac', 3, 'update again');
    insert into trade_detail values(11, 'aaaaaaac', 4, 'commit');
    ```
    1. 查询 id=2 的交易的所有操作步骤信息
        ```sql
        select d.* from tradelog l, trade_detail d where d.tradeid=l.tradeid and l.id=2; /*语句Q1*/
        ```
        - 第一行显示优化器会先在交易记录表 tradelog 上查到 id=2 的行，这个步骤用上了主键索引，rows=1 表示只扫描一行；
        - 第二行 key=NULL，表示没有用上交易详情表 trade_detail 上的 tradeid 索引，进行了全表扫描。
        ![编码隐式转换](workspace/git/worknotes/docnet/Database/mysql/imgs/Mysql.Select.Execute.Encoding.Change.webp)
        - 原因: 这两个表的字符集不同，一个是 utf8，一个是 utf8mb4，所以做表连接查询的时候用不上关联字段的索引。
    2. 实际执行SQL
    ```sql
    select * from trade_detail where CONVERT(traideid USING utf8mb4)=$L2.tradeid.value;
    ```
    3. 修复方法
        1. 通过 MDL语句，修改字符集
        ```sql
        alter table trade_detail modify tradeid varchar(32) CHARACTER SET utf8mb4 default null;
        ```
        2. SQL语句优化，可及时优化
        ```sql
        select d.* from tradelog l , trade_detail d where d.tradeid=CONVERT(l.tradeid USING utf8) and l.id=2;
        ```

4. MDL 锁，导致查询慢
    1. 通过使用 show processlist 命令查看sql状态是否为 Waiting for table metadata lock
    2. 解决方案: 
        - 通过查询表 sys.schema_table_lock_waits，直接找出造成阻塞的 process id，将连接用 kill 命令断开

5. 等 flush
    1. 查询information_schema.processlist表，线程的状态是 Waiting for table flush
    ```sql
    select * from information_schema.processlist where id=1;
    ```
6. 等行锁
    1. 通过 sys.innodb_lock_waits 表,查看blocking_pid字段
    ```sql
    select * from sys.innodb_lock_waits where locked_table='`cas`.`tbl_user`'
    ```
7. 慢查询定位
   
