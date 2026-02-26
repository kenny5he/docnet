##### 开源Mybaits插件
- [分页插件PageHelper](https://github.com/pagehelper/Mybatis-PageHelper)

##### 自定义实现插件的方式:
1. 选定拦截类对象(Executor?StatementHandler?其它?)，实现Interceptor接口
    - 实现Interceptor接口中的三个方法
        - interceptor拦截逻辑
        - plugin 返回动态代理对象
        - setProperties 配置文件的自定义配置对象
    - PageHelper拦截的对象为Executor对象
    - 选定拦截对象的方法，将方法中的参数类型按顺序放入args注解中
        ```
      @Intercepts(
            {
                @Signature(type = Executor.class, method = "query", args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class}),
                @Signature(type = Executor.class, method = "query", args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class, CacheKey.class, BoundSql.class}),
            }
        )
      ```
2. 实现过程 
    - 在intercept方法中通过invocation.getArgs();获取对象参数
    - 通过invocation.getTarget()获取拦截被的对象信息
    - 
3. PageHelper是怎么实现区分不同的数据库执行不同SQL语句的？
    - 通过PageAutoDialect类getDialect方法，根据传入参数MappedStatement获取数据库连接串信息，根据连接串信息判断数据库类型
4. PageHelper是怎么实现判断是否应该执行Count分页的？
    - 
5. PageHelper是怎么生成Count语句的?
    - 

##### Mybaits源码调用插件过程分析
1. 调用过程
    Excutor(SimpleExecutor/ReuseExecutor/BatchExecutor/CachingExecutor).doUpdate/doQuery/doQueryCursor -—> Configuration.newParameterHandler/Configuration.newStatementHandler/Configuration.newResultSetHandler --> interceptorChain.pluginAll
2. ParameterHandler/StatementHandler/ResultSetHandler/PreparedStatementHandler分析
    - StatementHandler 是真正执行数据库时的对象
    - ParameterHandler 可以通过statementHandler.getParameterHandler();获取的参数对象
    - ResultSetHandler 是结果集处理对象
3. RowBounds/MappedStatement/BoundSql作用分析
    - 通过statementHandler.getBoundSql()获取执行的SQL
    
##### Mybatis自定义封装反射封装类(MetaObject)
- 通过Mybaits封装的反射类MetaObject从对象statementHandler中获取属性中的值
```
MetaObject metaObject = MetaObject.forObject(
        statementHandler, SystemMetaObject.DEFAULT_OBJECT_FACTORY,SystemMetaObject.DEFAULT_OBJECT_WRAPPER_FACTORY,new DefaultReflectorFactory());
String sqlId = (String)metaObject.getValue("delegate.mappedStatement.id");
```
- 通过Mybatis封装的反射类MetaObject为对象statementHandler的赋值
```
MetaObject metaObject = MetaObject.forObject(
                statementHandler, SystemMetaObject.DEFAULT_OBJECT_FACTORY,SystemMetaObject.DEFAULT_OBJECT_WRAPPER_FACTORY,new DefaultReflectorFactory());
metaObject.setValue("delegate.boundSql.sql",pageSql);
```
    