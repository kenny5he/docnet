## Mysql实战笔记
### 连接篇 
1. 一个用户成功建立连接后，即使你用管理员账号对这个用户的权限做了修改，也不会影响已经存在连接的权限。修改完成后，只有再新建的连接才会使用新的权限设置。
2. MySQL 在执行过程中临时使用的内存是管理在连接对象里面的。这些资源会在连接断开的时候才释放。所以一个Mysql长连接使用很长时间或者大查询可能会导致OOM
    - 解决方案:
      1. 定期断开长连接。使用一段时间，或者程序里面判断执行过一个占用内存的大查询后，断开连接，之后要查询再重连。
      2. MySQL 5.7 或更新版本，可以在每次执行一个比较大的操作后，通过执行 mysql_reset_connection 来重新初始化连接资源。这个过程不需要重连和重新做权限验证，但是会将连接恢复到刚刚创建完时的状态。

### 查询缓存
1. 查询缓存流程
    1. 之前执行过的语句及其结果可能会以 key-value 对的形式，被直接缓存在内存中。
    2. 语句不在查询缓存中，就会继续后面的执行阶段。执行完成后，执行结果会被存入查询缓存中。
2. 查询缓存的优劣势
    - 优势:
        1. 
    - 劣势:
        1. 查询缓存的失效非常频繁，只要有对一个表的更新，这个表上所有的查询缓存都会被清空。
3. 查询缓存设定:
    1. 按需使用: 参数 query_cache_type 设置成 DEMAND
    2. 确定要使用查询缓存的语句，可以用 SQL_CACHE 显式指定
        ```
            select SQL_CACHE * from tbl_user where user_id = 1001；
        ```

### 分析器
1. 

### 优化器
1. 
### 执行器
1. 判断查询的权限
2. 