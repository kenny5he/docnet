# 数据同步方案
## 数据库层
###CDC（change data capture，数据变更抓取）
通过数据源的事务日志抓取数据源变更，这能解决一致性问题(只要下游能保证变更应用到新库上)。它的问题在于各种数据源的变更抓取没有统一的协议。如:
- [Canal](https://github.com/alibaba/canal/wiki): 阿里开源的基于数据库增量日志解析，提供增量数据订阅&消费
- Debezium: Redhat 开源的数据变更抓取组件,支持 MySQL、MongoDB、PostgreSQL 三种数据源的变更抓取。Snapshot Mode 可以将表中的现有数据全部导入 Kafka，并且全量数据与增量数据形式一致，可以统一处理，很适合数据库迁移。
- [Yugong](https://github.com/alibaba/yugong/releases): 阿里开源的基于标准jdbc协议开发的数据库迁移方案，使用Oracle的物化视图日志函数，类似于内部触发器。原始表的数据库需要具有创建和删除物化视图日志的权限，以进行用户授权。
### Mysql
1. Binlog

### Oracle
1. 物化视图

### SQLServer
1. 
### PostgreSQL
1. Logical decoding 机制

### MongoDB
1. oplog

## 应用服务层
1. 消息同步
    1. 优点: 
        1. 业务代码解耦，并且能够做到准实时。目前tk的ES同步用的就是这中方式吧
    2. 缺点:
        1. 需在业务代码中加入发送消息到MQ的代码，数据调用接口耦合。
2. 接口同步
    1. 优点: 
        1. 实施起来比较简单，简单服务里面常用的方式。
    2. 缺点:
        1. 代码耦合度高。
        2. 和业务逻辑同步执行，效率变低。
        3. 服务限流影响
    