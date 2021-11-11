[参考博客](https://www.jianshu.com/p/899fdb323eca)
#### 日志框架:
1. Java日志框架
     - SLF4j(日志API)
     - JCL(commons-logging)(日志API)
     - JUL(Java Util Log)(具体日志实现)
     - Log4j(具体日志实现)
     - Log4j2(具体日志实现)
     - Logback(具体日志实现)
2. 日志框架关系
    

#### 日志的级别；
- 由低到高: trace < debug < info < warn < error
    
#### 日志输出格式：
1. 释义
    - %d表示日期时间
    - %thread表示线程名，
    - %‐5level：级别从左显示5个字符宽度
    - %logger{50} 表示logger名字最长50个字符，否则按照句点分割。
    - %msg：日志消息，
    - %n是换行符

2. 常用配置:
   ```
   %d{yyyy‐MM‐dd HH:mm:ss.SSS} [%thread] %‐5level %logger{50} ‐ %msg%n
   ```

#### 高级使用
1. 自定义某用户日志基本为debug
2. 获取自定义某用户周期内的所有日志

#### 自定义日志输出参数
1. slf4j 通过 MDC 输出用户账号信息 [参考博客](https://www.jianshu.com/p/1dea7479eb07)
