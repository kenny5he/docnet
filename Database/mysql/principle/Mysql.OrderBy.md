# Mysql Order by
1. 全字段排序
```sql
explain select city,name,age from t where city='杭州' order by name limit 1000  ;
```
- 注: Extra中的“Using filesort”表示的就是需要排序,MySQL 会给每个线程分配一块内存用于排序，称为 sort_buffer。
  ![Order By 索引示意图](/Users/apaye/workspace/git/worknotes/docnet/Database/mysql/imgs/Mysql.Select.OrderBy.Example.webp)
- 语句执行流程
    1. 初始化 sort_buffer，确定放入 name、city、age 这三个字段；
    2. 从索引 city 找到第一个满足 city='杭州’条件的主键 id，也就是图中的 ID_X；
    3. 到主键 id 索引取出整行，取 name、city、age 三个字段的值，存入 sort_buffer 中；
    4. 从索引 city 取下一个记录的主键 id；
    5. 重复步骤 3、4 直到 city 的值不满足查询条件为止，对应的主键 id 也就是图中的 ID_Y；
    6. 对 sort_buffer 中的数据按照字段 name 做快速排序；按 name 排序”这个动作，可能在内存中完成，也可能需要使用外部排序，这取决于排序所需的内存和参数 sort_buffer_size。
    7. 按照排序结果取前 1000 行返回给客户端。
- 判断排序语句是否使用了临时文件: 通过查看 OPTIMIZER_TRACE的结果，从 number_of_tmp_files 中确认是否使用了临时文件
  ```sql
    /* 打开optimizer_trace，只对本线程有效 */
    SET optimizer_trace='enabled=on';

    /* @a保存Innodb_rows_read的初始值 */
    select VARIABLE_VALUE into @a from  performance_schema.session_status where variable_name = 'Innodb_rows_read';

    /* 执行语句 */
    select city, name,age from t where city='杭州' order by name limit 1000;

    /* 查看 OPTIMIZER_TRACE 输出 */
    SELECT * FROM `information_schema`.`OPTIMIZER_TRACE`\G

    /* @b保存Innodb_rows_read的当前值 */
    select VARIABLE_VALUE into @b from performance_schema.session_status where variable_name = 'Innodb_rows_read';

    /* 计算Innodb_rows_read差值 */
    select @b-@a;
  ```
    - 注: number_of_tmp_files 表示的是，排序过程中使用的临时文件数,外部排序一般使用归并排序算法。
    - 假设number_of_tmp_files的数字12表示，MySQL 将需要排序的数据分成 12 份，每一份单独排序后存在这些临时文件中。然后把这 12 个有序文件再合并成一个有序的大文件。
    - sort_mode 中的 packed_additional_fields的意思为排序过程对字符串做了“紧凑”处理,按字段实际长度分配空间
    - 查询语句 select @b-@a，表示实际扫描的行数
2. rowid 排序
    - max_length_for_sort_data，是 MySQL 中专门控制用于排序的行数据的长度的一个参数。表示如果单行的长度超过这个值，MySQL 就认为单行太大，要换一个算法。
    ```sql
    SET max_length_for_sort_data = 16;
    ```
    - 执行流程
        1. 初始化 sort_buffer，确定放入两个字段，即 name 和 id
        2. 从索引 city 找到第一个满足 city='杭州’条件的主键 id，也就是图中的 ID_X；
        3. 到主键 id 索引取出整行，取 name、id 这两个字段，存入 sort_buffer 中
        4. 从索引 city 取下一个记录的主键 id；
        5. 重复步骤 3、4 直到不满足 city='杭州’条件为止，也就是图中的 ID_Y
        6. 对 sort_buffer 中的数据按照字段 name 进行排序；
        7. 遍历排序结果，取前 1000 行，并按照 id 的值回到原表中取出 city、name 和 age 三个字段返回给客户端。
3. 按自定义规则排序
    ```sql
    select * from order o order by field (o.state,1,0,2,-1,3)
    ```
4. 并不是所有的 order by 语句，都需要排序操作的。从上面分析的执行过程，我们可以看到，MySQL 之所以需要生成临时表，并且在临时表上做排序操作，其原因是原来的数据都是无序的。
5. 随机显示
    - 例: 英语学习 App 首页有一个随机显示单词的功能，也就是根据每个用户的级别有一个单词表，然后这个用户每次访问首页的时候，都会随机滚动显示三个单词。
    1. 方案1：order by rand()
        - order by rand() 这种写法都会让计算过程非常复杂，需要大量的扫描行数，因此排序过程的资源消耗也会很大。
        1. 内存临时表
        ```sql
        explain select word from words order by rand() limit 3;
        ```
        - Extra 字段显示 Using temporary，表示的是需要使用临时表；Using filesort，表示的是需要执行排序操作。
        - 执行流程:
            1. 创建一个临时表。这个临时表使用的是 memory 引擎，表里有两个字段，第一个字段是 double 类型，为了后面描述方便，记为字段 R，第二个字段是 varchar(64) 类型，记为字段 W。并且，这个表没有建索引。
            2. 从 words 表中，按主键顺序取出所有的 word 值。对于每一个 word 值，调用 rand() 函数生成一个大于 0 小于 1 的随机小数，并把这个随机小数和 word 分别存入临时表的 R 和 W 字段中，到此，扫描行数是 10000。
            3. 现在临时表有 10000 行数据了，接下来你要在这个没有索引的内存临时表上，按照字段 R 排序。
            4. 初始化 sort_buffer。sort_buffer 中有两个字段，一个是 double 类型，另一个是整型。
            5. 从内存临时表中一行一行地取出 R 值和位置信息（我后面会和你解释这里为什么是“位置信息”），分别存入 sort_buffer 中的两个字段里。这个过程要对内存临时表做全表扫描，此时扫描行数增加 10000，变成了 20000。
            6. 在 sort_buffer 中根据 R 的值进行排序。注意，这个过程没有涉及到表操作，所以不会增加扫描行数。
            7. 排序完成后，取出前三个结果的位置信息，依次到内存临时表中取出 word 值，返回给客户端。这个过程中，访问了表的三行数据，总扫描行数变成了 20003。
               ![随机排序完整流程图](workspace/git/worknotes/docnet/Database/mysql/imgs/Mysql.Select.OrderBy.Round.webp)
            - 注: pos是位置信息,
            - 每个引擎用来唯一标识数据行的信息。
            - 对于有主键的 InnoDB 表来说，这个 rowid 就是主键 ID；
            - 对于没有主键的 InnoDB 表来说，这个 rowid 就是由系统生成的；
            - MEMORY 引擎不是索引组织表。可以视他为数组，其rowid为数组的下标
        2. 磁盘临时表
            - 条件: tmp_table_size 这个配置限制了内存临时表的大小，默认值是 16M。如果临时表大小超过了 tmp_table_size，那么内存临时表就会转成磁盘临时表。
            - 磁盘临时表使用的引擎默认是 InnoDB，是由参数 internal_tmp_disk_storage_engine 控制的。
            - 当使用磁盘临时表的时候，对应的就是一个没有显式索引的 InnoDB 表的排序过程。
            ```sql
              /** 创造磁盘临时表的条件 **/
              set tmp_table_size=1024;
              set sort_buffer_size=32768;
              set max_length_for_sort_data=16;
      
              /* 打开 optimizer_trace，只对本线程有效 */
              SET optimizer_trace='enabled=on';

              /* 执行语句 */
              select word from words order by rand() limit 3;

              /* 查看 OPTIMIZER_TRACE 输出 */
              SELECT * FROM `information_schema`.`OPTIMIZER_TRACE`\G
            ```
            - 将 max_length_for_sort_data 设置成 16，小于 word 字段的长度定义，sort_mode 里面显示的是 rowid 排序，参与排序的是随机值 R 字段和 rowid 字段组成的行。
            - R 字段存放的随机值就 8 个字节，rowid 是 6 个字节，数据总行数是 10000，共有 140000 字节，，超过了 sort_buffer_size 定义的 32768 字节，
            - number_of_tmp_files 的值为 0，未使用临时文件，MySQL 5.6 版本引入的一个新的排序算法，即：优先队列排序算法。
            1. 优先队列算法，就可以精确地只得到三个最小值
                1. 对于这 10000 个准备排序的 (R,rowid)，先取前三行，构造成一个堆；（对数据结构印象模糊的同学，可以先设想成这是一个由三个元素组成的数组）
                2. 取下一个行 (R’,rowid’)，跟当前堆里面最大的 R 比较，如果 R’小于 R，把这个 (R,rowid) 从堆中去掉，换成 (R’,rowid’);
                3. 重复第 2 步，直到第 10000 个 (R’,rowid’) 完成比较。
                   ![优先队列排序算法示例](/Users/apaye/workspace/git/worknotes/docnet/Database/mysql/imgs/Mysql.Select.Prioritize.Example.webp)
    2. 方案2:
        1. 取得这个表的主键 id 的最大值 M 和最小值 N;
        2. 用随机函数生成一个最大值到最小值之间的数 X = (M-N)*rand() + N;
        3. 取不小于 X 的第一个 ID 的行。
        ```sql
        select max(id),min(id) into @M,@N from t ;
        set @X= floor((@M-@N+1)*rand() + @N);
        select * from t where id >= @X limit 1;
        ```
        - 效率很高，因为取 max(id) 和 min(id) 都是不需要扫描索引的,select 也可以用索引快速定位,但不同行的概率不一样，
    3. 方案3:
        1. 取得整个表的行数，并记为 C。
        2. 取得 Y = floor(C * rand())。 floor 函数在这里的作用，就是取整数部分
        3. 再用 limit Y,1 取得一行。
        ```sql
        select count(*) into @C from t;
        set @Y = floor(@C * rand());
        set @sql = concat("select * from t limit ", @Y, ",1");
        prepare stmt from @sql;
        execute stmt;
        DEALLOCATE prepare stmt;
        ```
    4. 方案4
        1. 取得整个表的行数，记为 C；
        2. 根据相同的随机方法得到 Y1、Y2、Y3；
        3. 再执行三个 limit Y, 1 语句得到三行数据。
        ```sql
        select count(*) into @C from t;
        set @Y1 = floor(@C * rand());
        set @Y2 = floor(@C * rand());
        set @Y3 = floor(@C * rand());
        // 在应用代码里面取Y1、Y2、Y3值，拼出SQL后执行
        select * from t limit @Y1，1;
        select * from t limit @Y2，1;
        select * from t limit @Y3，1;
        ```
