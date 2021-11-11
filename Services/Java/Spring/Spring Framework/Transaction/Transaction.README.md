#### 事物的特性:
- 原子性: 事物是最小的执行单位，不允许分割，事物的原子性确保动作要么全部完成，要么完全不起作用
- 一致性: 执行事物前后，数据保持一致
- 隔离性: 并发访问数据库时，一个用户的事物不被其他事物所干扰，各并发事物之间数据库是独立的
- 持久性: 一个事物被提交后，它对数据库中的数据的改变是持久的，即使数据库发生故障也不应该对其有任何影响

##### Spring 事物接口:
1. PlatformTransactionManager: (平台)事物管理	
    - 作用: 按照给定的事物规则来执行提交、或者回滚动作
    - Spring并不直接管理事物，而是提供多种事物管理器，他们将事物管理的职责委托给Hibernate 或者JTA等持久化机制的相关平台框架管理
    - Spring事物管理接口: org.springframework.transaction.PlatformTransactionManager
        - Method: 
            - TransactionStatus getTransaction(TransactionDefiniton definition);
            - void commit(TransactionStatus status);
            - void rollback(TransactionStatus status);
    - Spring持久层框架实现:
        - org.springframework.datasource.DataSourceTransactionManager  使用SpringJDBC或者IBatis进行持久化数据
        - org.springframework.orm.hibernate3.HibernateTransactionManager 使用Hibernate3.0进行持久化数据
        - org.springframework.orm.jpa.JpaTransactionManager 使用JPA进行持久化数据
        - org.springframework.transaction.jta.JtaTransactionManger 使用一个JTA实现管理事物，在事务跨越多个资源时使用
2. TransactionDefinition: 事物定义信息(事物隔离级别、传播行为、超时、只读、回滚规则)
    - 作用: 事物基本配置，描述事物策略应用到方法上，事物属性包含隔离级别、传播行为、回滚规则、是否只读、事物超时
    - Method:
        - int getPropagationBehavior();//返回事物的传播行为
        - int getIsolationLevel();//返回事物的隔离级别、事物管理器根据它来控制另一个事物
        - String getName(); //返回事物的名字
        - int getTimeOut(); //返回事物必须在多少秒之内完成
        - boolean isReadOnly();//返回是否优化为只读事物
    - 事物并发运行问题(多个用户对同一数据进行操作):
        - 脏读(DirtyRead): 
            当一个事物正在访问数据并对数据进行修改，而这个修改还没有提交到数据库中，这时另一个事物也访问到这个数据，使用了这个数据，
            因为这个数据还没哟提交，那么另外一个事物读取到的数据是脏数据
        - 丢失修改(Lost to modify): 
            在一个事物读取数据时，另一个事物也访问了该数据，那么第一个事物中修改这个数据后，第二个事物也修改了这个数据，这样第一个事物内的修改结果被丢失
        - 不可重复读(Unrepeatableread): 在一个事物内多次读取同一个数据，在这个事物还没有结束时，另一个事物也访问该数据，
            在第一个事物中的两次读取数据之间由于第二个事物的修改导致第一个事物两次读取的数据可能不太一样，这样就发生了一个事务两次读到的数据不一样的情况
        - 幻读(Phantom read): 
            幻读与不可重复读取相似，它发生在一个事务(T1)读取了几行数据，接着另一个并发事务(T2)插入一些数据时，在随后的查询中，
            第一个事物(T1)就会发现多了一些原本不存在的记录，就好像发生幻觉一样
        - 不可重复读与幻读的区别: 不可重复读的重点在修改，幻读的重点在新增或者删除
    - 事物隔离级别(五个常量):
        - TransactionDefinition.ISOLATION_DEFAULT: 使用后端数据库的默认隔离级别，MySql默认采用REPEATABLE_READ隔离级别，
        - Oracle默认采用READ_COMMITTED隔离级别
        - TransactionDefinition.ISOLATION_READ_UNCOMMITTED: 最低的隔离级别，允许读取尚未提交的数据变更
        - TransactionDefinition.ISOLATION_READ_COMMITTED: 允许读取并发事务已经提交的数据
        - TransactionDefinition.ISOLATION_REPEATABLE_READ: 对同一字段多次读取结果一致的，除非数据时被本身事务自己所修改
        - TransactionDefinition.ISOLATION_SERIALIZABLE: 最高的隔离级别，完全服从ACID的隔离级别，所有事务依次逐个执行，这样事务之间就不会产生干扰(可以防止脏读、不可重复读、幻读)，但严重影响程序性能，一般情况下不会使用该级别
    - 事务的传播行为(为解决业务层方法之间相互调用的事务问题):
        - 支持当前事务的情况:
            - TransactionDefinition.PROPAGATION_REQUIRED: 如果当前存在事务，则加入该事物，如果当前没有事务，则创建一个新的事务
            - TransactionDefinition.PROPAGATION_SUPPORTS: 如果当前存在事务，则加入该事物，如果当前没有事务，则以非事务方式运行
            - TransactionDefinition.PROPAGATION_MANDATORY: 如果当前存在事务，则加入该事物，如果当前没有事物，则抛出异常	
        - 不支持当前事务的情况:
            - TransactionDefinition.PROPAGATION_REQUIRES_NEW: 创建一个新的事务，如果当前存在事务，则把当前事务挂起
            - TransactionDefinition.PROPAGATION_NOT_SUPPORTED: 以非事务方式运行，如果当前存在事务，则把当前事务挂起
            - TransactionDefinition.PROPAGATION_NOT_SUPPORTED: 以非事务方式运行，如果当前存在事务，则抛出异常
        - 其他情况:
            - TransactionDefinition.PROPAGATION_NESTED: 如果当前存在事务，则创建一个事务作为当前事务的嵌套事务来运行，如果当前没有事物，
            - 则该取值等价于TransactionDefinition.PROPAGATION_REQUIRED
    - 事物超时属性(一个事务允许执行的最长时间)
        所谓事务超时，就是指一个事务所允许执行的最长时间，如果超过该时间限制但事务还没有完成，则自动回滚事务，在TransactionDefinition中以int的值来表示超时时间，其单位为秒
    - 事务只读属性(对事物资源是否执行只读操作)
        事务的只读属性是指对事务性资源进行只读操作或者读写操作，所谓事务性资源就是指那些被事务管理的资源，比如数据源、JMS资源，
        以及自定义的事务性资源进行只读操作，那么我们可以将事务标志为只读的，以提高事务处理的性能，在TransactionDefinition中boolean类型来表示该事务
    - 回滚规则(定义事务回滚规则)
        这些规则定义了哪些异常会导致事务回滚而哪些不会，默认情况下，事务只有遇到运行期异常时才会回滚，而在遇到检查型异常时不会回滚(这一行为与EJB的回滚行为一致)，
        但是你可以声明事务在遇到特定的检查型异常时像遇到运行期异常那样回滚，同样，你还可以声明事务遇到特定的异常不回滚，即使这些异常是运行期异常
3. TransationStatus: 事物运行状态
    - boolean isNewRransaction();//是否是新的事物
    - boolean hasSavepoint();//是否有恢复点
    - void setRollbackOnly();//设置为只回滚
    - boolean isRollbackOnly();//是否为只回滚
    - boolean isCompleted();//是否已完成
4. Spring 事物配置使用:	
```
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManger">
        <property name="dataSource" java.lang.ref="dataSource"/>
    </bean>
```
