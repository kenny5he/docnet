[Mybatis面试题](http://svip.iocoder.cn/MyBatis/Interview/)
##### Mybatis编程步骤:
1. 创建 SqlSessionFactory 对象。
2. 通过 SqlSessionFactory 获取 SqlSession 对象。
3. 通过 SqlSession 获得 Mapper 代理对象。
4. 通过 Mapper 代理对象，执行数据库操作。
5. 执行成功，则使用 SqlSession 提交事务。
6. 执行失败，则使用 SqlSession 回滚事务。
7. 最终，关闭会话。

##### Mybatis 3 的基础使用方式：
1. resultMap的使用方式
    [官方docs](http://www.mybatis.org/mybatis-3/zh/sqlmap-xml.html#Result_Maps)
    1. resultMap返回内部类的使用
        - 注意：内部类Scope必须是静态类 static
        ```xml
        <resultMap id = "scope" type="com.microfoolish.it.vo.TemplateVO$Scope">
            <result property="scope" column="scope"/>
            <result property="scopeName" column="scope_name"/>
        </resultMap>
       ```
    2. 声明类型时使用时，typeAlias可不用输入类的全路径
        ```
       <typeAlias type="com.microfoolish.it.vo.User" alias="User"/>	
       <select id="QueryUsers" resultType="User">
          select id, username, hashedPassword
            from tbl_users
            where id = #{id}
       </select>
       ```
2. myBatis调用存储过程
    - statementType 默认值为PREPARED
        - STATEMENT == Statement
        - PREPARED  == PreparedStatement
        - CALLABLE  == CallableStatement
    ```xml
   <update id="xxxx" statementType="CALLABLE">
        {call 存储过程(入参...,出参... )}
    </update>
    ```
3. 动态SQL 
    - if语句
        ```xml
        <select id="findActiveBlogLike" resultType="Blog">
          SELECT * FROM BLOG WHERE state = ‘ACTIVE’ 
          <if test="title != null">
            AND title like #{title}
          </if>
          <if test="author != null and author.name != null">
            AND author_name like #{author.name}
          </if>
        </select>
        ```
    - choose when语句
        ```
        <select id="findActiveBlog" resultType="Blog">
          SELECT * FROM BLOG WHERE state = ‘ACTIVE’
          <choose>
            <when test="title != null">
              AND title like #{title}
            </when>
            <when test="author != null and author.name != null">
              AND author_name like #{author.name}
            </when>
            <otherwise>
              AND featured = 1
            </otherwise>
          </choose>
        </select>
        ```
    - bind 绑定替代属性
        ```
            <!-- sql代码块中 -->
            <bind name="key" value=""/>
            <!-- sql 代码块，使用处-->
            ${key}
        ``` 
    - include 引用sql代码块
        ```
            <include id="sqlId">
                <property name="key" value="value"/>
            </include>
        ```
4. Mybatis 可以映射枚举类，对应的实现类为 EnumTypeHandler 或 EnumOrdinalTypeHandler
    [参考博客](https://segmentfault.com/a/1190000010755321)

5. Mybatis 都有哪些 Executor 执行器？它们之间的区别是什么？
    <br/>Mybatis 有四种 Executor 执行器，分别是 SimpleExecutor、ReuseExecutor、BatchExecutor、CachingExecutor 。
    - SimpleExecutor ：每执行一次 update 或 select 操作，就创建一个 Statement 对象，用完立刻关闭 Statement 对象。
    - ReuseExecutor ：执行 update 或 select 操作，以 SQL 作为key 查找缓存的 Statement 对象，存在就使用，不存在就创建；用完后，不关闭 Statement 对象，而是放置于缓存 Map<String, Statement> 内，供下一次使用。简言之，就是重复使用 Statement 对象。
    - BatchExecutor ：执行 update 操作（没有 select 操作，因为 JDBC 批处理不支持 select 操作），将所有 SQL 都添加到批处理中（通过 addBatch 方法），等待统一执行（使用 executeBatch 方法）。它缓存了多个 Statement 对象，每个 Statement 对象都是调用 addBatch 方法完毕后，等待一次执行 executeBatch 批处理。实际上，整个过程与 JDBC 批处理是相同。
    - CachingExecutor ：在上述的三个执行器之上，增加二级缓存的功能。

6. 介绍 MyBatis 的一级缓存和二级缓存的概念和实现原理？
    [参考博客](https://tech.meituan.com/2018/01/19/mybatis-cache.html)
    1. 一级缓存
        1. 一级缓存介绍
           -  在应用运行过程中，我们有可能在一次数据库会话中，执行多次查询条件完全相同的SQL，MyBatis提供了一级缓存的方案优化这部分场景，如果是相同的SQL语句，会优先命中一级缓存，避免直接对数据库进行查询，提高性能。
            每个SqlSession中持有了Executor，每个Executor中有一个LocalCache。当用户发起查询时，MyBatis根据当前执行的语句生成MappedStatement，在Local Cache进行查询，如果缓存命中的话，直接返回结果给用户，如果缓存没有命中的话，查询数据库，结果写入Local Cache，最后返回结果给用户。
        2. 一级缓存配置
            - 在MyBatis的配置文件中，添加如下语句，就可以使用一级缓存。共有两个选项，SESSION或者STATEMENT，默认是SESSION级别，
                SESSION级别在一个MyBatis会话中执行的所有语句，都会共享这一个缓存。
                一种是STATEMENT级别，可以理解为缓存只对当前执行的这一个Statement有效。
            ```
                <setting name="localCacheScope" value="SESSION"/>
            ```
    2. 二级缓存
        1. 二级缓存介绍
            如果多个SqlSession之间需要共享缓存，则需要使用到二级缓存。开启二级缓存后，会使用CachingExecutor装饰Executor，进入一级缓存的查询流程前，先在CachingExecutor进行二级缓存的查询
        2. 二级缓存配置
            1. 在MyBatis的配置文件中开启二级缓存(全局的二级缓存默认开启，各个mapper之间默认关闭)。
            ```xml
               <setting name="cacheEnabled" value="true"/>
            ```
           2. 在MyBatis的映射XML中配置cache或者 cache-ref
                ```xml
                   <cache/>
                ```
                - type：cache使用的类型，默认是PerpetualCache，可配置为自己实现的缓存底层实现类。
                - eviction： 定义回收的策略，常见的有FIFO，LRU。
                - flushInterval： 配置一定时间自动刷新缓存，单位是毫秒。
                - size： 最多缓存对象的个数。
                - readOnly： 是否只读，若配置可读写，则需要对应的实体类能够序列化。
                - blocking： 若缓存中找不到对应的key，是否会一直blocking，直到有对应的数据进入缓存
                <br/>cache-ref代表引用别的命名空间的Cache配置，两个命名空间的操作使用的是同一个Cache。
                   ```xml
                        <cache-ref namespace="mapper.StudentMapper"/>
                   ```
           3. 二级缓存应用场景
                - 单体应用: 权限等基本不修改数据时
                - 分布式应用: ehCache实现
    3. 一级缓存与二级缓存的区别 
        1. 作用范围不同
            - 一级缓存中，其最大的共享范围就是一个SqlSession内部
            - 二级缓存中，SqlSession之间共享，Mapper
    4. 实现分布式Mybaits二级缓存
        [参考博客](https://www.cnblogs.com/NeverCtrl-C/p/9658406.html)
    5. 缓存装饰
        - Mybatis源码CacheBuilder#setStandardDecorators方法定义缓存装饰顺序
        - 默认装饰者模式 SynchronizedCache -> LoggingCache -> SerializedCache -> LRUCache(默认，由type而定) -> PerpetualCache
    6. mybatis二级缓存脏读、幻读
        - 问题描述
        - 问题解决
            TransactionalCacheManager、TransactionalCache 
            标识
7. 如何配置修改Mapper.xml不重新启动，加载最新SQL
    - org.apache.ibatis.builder.xml.XMLMapperBuilder 类 parse方法中
        if (!configuration.isResourceLoaded(resource)) 判断Mapper资源是否已经被加载过
    ```
     XMLMapperBuilder xmlMapperBuilder = new XMLMapperBuilder(configLocation.getInputStream(),
            configuration, configLocation.toString(), configuration.getSqlFragments());
     xmlMapperBuilder.parse();
    ```
8. 如何加载自定义的MapperProxy，动态加载管理页面配置的SQL

9. 多参数是不使用@Param重命名，参数为arg0 arg1问题修复
    - 问题根因: JDK反射问题
    - jdk1.8方式: idea中 --parameters
    - springmvc 使用字节码编译技术实现，解决该问题
   