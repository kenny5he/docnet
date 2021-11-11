# Mysql Index (数据库索引)
1. 索引类型: 主键索引、非主键索引
   - 主键索引的叶子节点存的是整行的数据(聚簇索引)
   - 非主键索引的叶子节点内容是主键的值(二级索引)
   1. 主键索引和普通索引的区别?
      - 主键索引只要搜索ID这个B+Tree即可拿到数据。普通索引先搜索索引拿到主键值，再到主键索引树搜索一次(回表)
   2. 主键索引和普通索引的存储位置
      - 主键索引的叶子节点存的是整行数据，主键索引也被称为聚簇索引（clustered index）。
      - 非主键索引的叶子节点内容是主键的值。在 InnoDB 里，非主键索引也被称为二级索引（secondary index）。
   3. 主键长度越小，普通索引的叶子节点就越小，普通索引占用的空间也就越小。
   4. 建立/移除 主键/非主键索引
      ```sql
         /* 主键索引 */
         alter table T drop primary key;
         alter table T add primary key(id);
         /* 非主键索引 */
         alter table T drop index k;
         alter table T add index(k);
         /* 前缀索引 */
         alter table tbl_user add index email_index(email(8));
         /* 全文索引 */
         alter table t add FULLTEXT(field_name);
   ```
   5. 强制某个sql使用某个索引
      ```sql
         select * from tbl_user force index(user_id) where user_id = 1831246;
   ```
   6 通过慢查询日志，分析索引
       ```sql
      /** 查看是否开启了慢查询日志, OFF 关 、ON 开 **/
      show variables like 'slow_query_log';
   
      /** 设置当前数据库开启慢查询 **/
      set global slow_query_log=1;
   
      /** 将慢查询日志的阈值设置为 0，表示这个线程接下来的语句都会被记录入慢查询日志中；long_query_time的默认值为10，意思是记录运行10秒以上的语句。 **/
      set long_query_time=0;
      
      /** 执行要分析的语句 **/
      select * from tbl_user where user_id = 1831246;
   
      /** 查看要分析的慢查询日志位置 **/
      show variables like 'log-slow-queries'; /* Mysql 5.6以下版本慢查询日志存储路径 */
      show variables like 'slow-query-log-file'; /* Mysql 5.6版本后慢查询日志存储路径，不设置该参数，系统默认host_name-slow.log */
   ```
   7. 查看索引区分度，索引基数
       ```sql
    show index from tbl_user;
   ```
   8. 修正索引信息
       ```sql
    analyze table tbl_user
   ```
2. 覆盖索引
   1. 覆盖索引说明: 
      ```
      select ID from T where k between 3 and 5
      ```
      - ID 的值已经在 k 索引树上了，因此可以直接提供查询结果，不需要回表
   2. 覆盖索引的作用: 覆盖索引可以减少树的搜索次数，显著提升查询性能，所以使用覆盖索引是一个常用的性能优化手段
   3. 最左前缀原则
      1. 背景:
         - 索引字段的维护总是有代价的,如果为每一种查询都设计一个索引，又感觉有点浪费。
      2. 原则: 第一原则是，如果通过调整顺序，可以少维护一个索引，那么这个顺序往往就是需要优先考虑采用的。
         例: 当已经有了 (a,b) 这个联合索引后，一般就不需要单独在 a 上建立索引了
3. 索引下推(MySQL 5.6引入)(index condition pushdown)
   1. 在索引遍历过程中，对索引中包含的字段先做判断，直接过滤掉不满足条件的记录，减少回表次数,，提升整体性能。
   
4. 唯一索引
   1. 由于索引定义了唯一性，查找到第一个满足条件的记录后，就会停止继续检索
5. 前缀索引
   1. 使用前缀索引，定义好长度，就可以做到既节省空间，又不用额外增加太多的查询成本。
   2. 即使使用了前缀索引， InnoDB 还是要回到 id 索引再查一下，使用前缀索引就用不上覆盖索引对查询性能的优化
   
### 数据结构
1. 哈希表
   - 键 - 值（key-value）存储数据的结构，我们只要输入待查找的键即 key，就可以找到其对应的值即 Value。哈希的思路很简单，把值放在数组里，用一个哈希函数把 key 换算成一个确定的位置，然后把 value 放在数组的这个位置。.
2. 有序数组(有序数组索引只适用于静态存储引擎)
3. 搜索树
4. 跳表(Redis)
5. LSM 树

