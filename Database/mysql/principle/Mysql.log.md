# Mysql Log
## redo log (重做日志)(redo log 是 InnoDB 引擎特有的日志)
WAL 技术(Write-Ahead Logging)(先写日志，再写磁盘,也就是先写粉板，等不忙的时候再写账本)
1. Redo Log 的作用: 
   - 当有一条记录需要更新的时候，InnoDB 引擎就会先把记录写到 redo log（粉板）里面，并更新内存
   - 数据库发生异常重启,提交的记录也不会丢失，这个能力称之为 crash-safe
2. Redo Log 的容量大小: 
    - redo log 是固定大小的
    - 通过配置一组N个文件，每个文件大小 M GB,从头开始写，写到末尾就又回到开头循环写
3. Redo 的运行机制
 ![Redo Log](/Users/apaye/workspace/git/worknotes/docnet/Database/mysql/imgs/Mysql.Redo.log.webp)
   - write pos 是当前记录的位置，一边写一边后移，写到第 3 号文件末尾后就回到 0 号文件开头。checkpoint 是当前要擦除的位置，也是往后推移并且循环的，擦除记录前要把记录更新到数据文件。
   - write pos 和 checkpoint 之间的是“粉板”上还空着的部分，可以用来记录新的操作。如果 write pos 追上 checkpoint，表示“粉板”满了，这时候不能再执行新的更新，得停下来先擦掉一些记录，把 checkpoint 推进一下。
4. 关于Redo Log 建议
    1. redo log 用于保证 crash-safe 能力。innodb_flush_log_at_trx_commit 这个参数设置成 1 的时候，表示每次事务的 redo log 都直接持久化到磁盘。这个参数我建议你设置成 1，这样可以保证 MySQL 异常重启之后数据不丢失
5. WAL flush操作
![Redo Log](/Users/apaye/workspace/git/worknotes/docnet/Database/mysql/imgs/Mysql.WAL.Example.webp)
    1. Flush操作触发的场景？
       1. Redo Log记满，系统停止更新操作，把 checkpoint 往前推进，redo log 留出空间可以继续写。(需尽量避免此种情况)(平时要多关注脏页比例，不要让它经常接近 75%)
       2. 业务量大，系统内存不足。当需要新的内存页，而内存不够用的时候，就要淘汰一些数据页，空出内存给别的数据页使用。
       3. MySQL 认为系统“空闲”时
       4. MySQL 正常关闭的情况，MySQL 会把内存的脏页都 flush 到磁盘上
       5. 扩展延伸:
          1. 计算脏页比例
             ```sql   
             select VARIABLE_VALUE into @a from global_status where VARIABLE_NAME = 'Innodb_buffer_pool_pages_dirty';
             select VARIABLE_VALUE into @b from global_status where VARIABLE_NAME = 'Innodb_buffer_pool_pages_total';
             select @a/@b;
             ```
    2. 脏页"连坐"(参数: innodb_flush_neighbors)
       - 一个查询请求需要在执行过程中先 flush 掉一个脏页时，这个查询就可能要比平时慢了。而 MySQL 中的一个机制，可能让你的查询会更慢：在准备刷一个脏页的时候，如果这个数据页旁边的数据页刚好是脏页，就会把这个“邻居”也带着一起刷掉；而且这个把“邻居”拖下水的逻辑还可以继续蔓延，也就是对于每个邻居数据页，如果跟它相邻的数据页也还是脏页的话，也会被放到一起刷。
       - 作用: 机械硬盘时代,减少随机 IO,SSD时代 IOPS不是瓶颈，更快地执行完必要的刷脏页操作，减少 SQL 语句响应时间。
    3. InnoDB 内存策略
       1. InnoDB 的策略是尽量使用内存，因此对于一个长时间运行的库来说，未被使用的页面很少。
       2. InnoDB 用缓冲池（buffer pool）管理内存，缓冲池中的内存页有三种状态：
          1. 还没有使用的；
          2. 使用了并且是干净页；
          3. 使用了并且是脏页。
       3. 过程: 当要读入的数据页没有在内存的时候，就必须到缓冲池中申请一个数据页。这时候只能把最久不使用的数据页从内存中淘汰掉：如果要淘汰的是一个干净页，就直接释放出来复用；但如果是脏页呢，就必须将脏页先刷到磁盘，变成干净页后才能复用。
    4. 刷数据页影响性能的情况？
       1. 一个查询要淘汰的脏页个数太多，会导致查询的响应时间明显变长；
       2. 日志写满，更新全部堵住，写性能跌为 0，这种情况对敏感业务来说，是不能接受的。
    5. 解决刷数据页性能方案
       1. 正确配置InnoDB 磁盘IO能力(设置innodb_io_capacity 参数)，建议你设置成磁盘的 IOPS(通过 fio 这个工具来测试)。
       ```
       fio -filename=$filename -direct=1 -iodepth 1 -thread -rw=randrw -ioengine=psync -bs=16k -size=500M -numjobs=10 -runtime=10 -group_reporting -name=mytest
       ```
       
## binlog (归档日志)(Server层日志)
1. Bin Log 的作用
2. Bin Log的模式:
    1. statement: 记sql语句
    2. row: 记录行的内容
3. Bin Log 的运行机制:
4. 关于Bin Log的建议
    1. sync_binlog 这个参数设置成 1 的时候，表示每次事务的 binlog 都持久化到磁盘。这个参数建议设置成 1，这样可以保证 MySQL 异常重启之后 binlog 不丢失。
## Bin Log 和 Redo Log的区别
1. redo log 是 InnoDB 引擎特有的；binlog 是 MySQL 的 Server 层实现的，所有引擎都可以使用
2. redo log 是物理日志，记录的是“在某个数据页上做了什么修改”；binlog 是逻辑日志，记录的是这个语句的原始逻辑，比如“给 ID=2 这一行的 c 字段加 1 ”。
3. redo log 是循环写的，空间固定会用完；binlog 是可以追加写入的。“追加写”是指 binlog 文件写到一定大小后会切换到下一个，并不会覆盖以前的日志。