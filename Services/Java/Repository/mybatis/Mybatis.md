源码结构:
    https://my.oschina.net/wenjinglian/blog/1625437

Mybatis中重要的几个对象释义:
    - MappedStatement: 对应为Mapper文件中的标签，映射的语句，每个增删改查标签都对应一个 MappedStatement，SelectKey也都对应一个MappedStatement，
    - MapperMethod:  Mapper 方法，里面包含方法签名、SQL命令,其中包含MappedStatement,并通过MappedStatement获取ResultType、ResultMap等,在 Mapper 接口中，每个定义的方法，对应一个 MapperMethod 对象，
    - SqlCommand: 存在类型字段 CommandType( INSERT/UPDATE/SELECT/DELETE/FLUSH/UNKNOWN)和 name字段(方法id)，主要为辅助作用
    - RowBounds: 分页作用
    - BoundSql: $符在getBoundSQL时就已经进行参数替换的SQL，#号
    - ResultHandler: 结果集处理
    - ParameterHandler: 参数处理
        - BaseStatementHandler
            - CallableStatementHandler
                存储过程处理类
            - PreparedStatementHandler
                通过实现父类BaseStatementHandler中instantiateStatement方法，调用Configuration中获取连接，通过连接获得JDBC中的ParamerStatement，并设置超时时长，
                真正调用JDBC Execute方法是在此类中，用来处理 #号符，防止SQL注入，
    - SqlSession:
        - 获取Mapper
        - Mapper代理执行
            最终方法执行都是通过SqlSession 调用Executor执行器执行的，在SqlSession中 增删改都调用update方法，查询调用Select方法
            有缓存调用 CachingExecutor执行，无缓存调用 BaseExecutor执行，最终调用SimpleExecutor执行查询、      
    - InterceptorChain 拦截器链(pluginAll)
        - 总共有四处调用
            - ParameterHandler: 在new ParameterHander时会执行
            - ResultSetHandler: 在new ResultSetHandler时会执行
            - StatementHandler: 在new StatementHandler时会执行
            - Executor: 在new Executor时执行        
    - SqlSessionFactoryBean
        获取mybatis-config.xml中的配置，将配置塞入对象Configuration中，并构造SqlSessionFactory，通过SqlSessionFactory获取得到SqlSession