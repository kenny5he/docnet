### Redis
[redis命令](http://doc.redisfans.com/)
install reids url:http://www.cnblogs.com/codersay/p/4301677.html

1. install redis
tar -xvf redis.tar.gz -C /software
cd /software/redis
make
make -PREFIX=/usr/local/redis

2.启动/关闭
    启动服务端
    2.1前端启动 ./usr/local/redis/bin/redis-server
    2.2后端启动 修改redis.conf文件 将daemonize值设置为yes ./usr/local/redis/bin/redis-server /usr/local/redis/redis.conf
    启动客户端
        命令: redis-cli -h host -p port -a password
        ./usr/local/redis/bin/redis-cli
    关闭服务端
        ./usr/local/redis/bin redis-cli shutdown
    
3. redis 数据类型
redis 使用的是键值对 保存数据(map)
    key String 类型(key名 不要过长 也不能太短 否则影响使用效率(理论上))
    value (五种数据类型) 
          String "小明"
          Hash   {uname:'小明'}   易转 JavaBean
          List   [1,2,3,4,5]      Java LinkedList（链表 添加 删除 效率极高）
          Set    ['a','b']        Java HashSet
          有序Set集合
字符串在redis中是二进制安全的    存入和获取数据相同 字符串类型Value最大能容纳512M

二进制安全与数据安全无关    Mysql 关系型数据库 二进制不安全（乱码）
String    
    赋值：
    set key value
    如果存在则进行覆盖 总是返回OK
    get key
    获取不存在的值 返回nil
    del key 删除指定 key
    getset key value 先get获取 然后set值  返回get的值
    incrkey 自增  相当于Java中的++i（如果key不存在，则先赋值为0，然后++）
    decr    自减  （如果key不存在，则先赋值为0，然后--）
    append  字符追加 （如果key不存在，则创建，如果key存在，则追加）
    incrby  数值追加 (例 incrby key 10)
    decrby  数值减(例 decrby key 10)

    String 使用环境 一般用于保存 json格式的字符串
Hash
    Hash 类型可以看成具有String key和 String Value的map容器
    Hash 特点:占用的磁盘空间比较少
    赋值:
        hset key field value:为指定key设置field字段 字段值
        hmset key field1 value1 field2 value2：一次为多个字段赋值
    取值：
        hget key field:取出指定key的值
        hmget key field1 field2 field3：获取多个特定字段的值
        hgetall key：获取key中所有字段的值
    删除：（如果hash中没有值，将不存在hash）
        hdel  key field 删除Hash key中的字段field
        del key 删除整个hash
    hicrby key field increment:Hash数值增加
    hexists key field：判断字段是否存在
    hlen key : 获取key所包含的field数量
    hkeys key: 获取所有的字段
    hvals key：获取所有值
    
List ==> Java LinkedList
    Array数组  通过索引取值（取值速度与数据量无关），增删改 （数据量越多，越慢）(增删改时，需要维护后续索引位置)
    Linked 链表 通过索引取值(先维护索引，再取值，数据量越多，取值越慢) 增删改 速度与数据量无关,(增删改时，维护单个节点链接关系)(大数据集合增删 任务队列)
    Array 与 Linked 相互互补，
    
    Redis 操作中 最多的操作是进行元素的增删
        
    取值
    lrange key start end //例：lrange list 0 -1 查询所有数据
    赋值  A  B  C   D
    lpush key value1 [value2...]  //从左至右添加   首 -->  尾     D C B A
    rpush key value1 [value2...]  //从右至左添加   尾 -->  首     A B C D
    删除
    lpop key  //从左至右删除 
    rpop key  //从右至左删除
    lrem key startindex cell //从左端 下表索引位置 删除元素cell（效率极底）
    lset key index value //通过索引 替换 值（效率极底）
    linsert key before|after pivot value  //在pivot之前或之后插入value值
    rpoplpush list1 list2 //将list1中最后一位移出 插入至 list2
    rpoplpush list1 list1 //循环队列
    
    
Jedis（Java 操作 Redis数据库）
    commons-pool2-2.3.jar
    jedis-2.7.0.jar（官方推荐）
    
    //单实例连接数据库 所有Redis命令 Jedis都有
    Jedis jedis = new Jedis("ip","port");//获取Redis连接
    
    //Jedis 连接池
        JedisPoolConfig config = new JedisPoolConfig();//1.设置连接池的配置对象
        config.setMaxTotal(100);//设置连接池中最大的连接数量[可选]
        config.setMaxIdle(10);//设置连接池值中空闲 最大连接数[可选]
        JdeisPool pool = new JedisPool(config,ip,port);//[必选]
        Jedis jedis = pool.getResource();//从池中获取连接对象[必选]   
        jedis.close();//将连接归还池中
            
    
    
开放 8080 端口：
    /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
保存配置
    /etc/rc.d/init.d/iptables save