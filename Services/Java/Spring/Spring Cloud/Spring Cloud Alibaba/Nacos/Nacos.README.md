1.docker-compose mysql
    docker-compose -f /Users/apaye/workspace/docker/mysql/nacos/default/docker-compose.yml up -d(首次)
    docker start nacosdefault
2.init sql
    https://github.com/alibaba/nacos/blob/master/config/src/main/resources/META-INF/nacos-db.sql
3.修改配置文件
spring.datasource.platform=mysql
db.num=1
db.url.0=jdbc:mysql://localhost:13316/nacos?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true
db.user=root
db.password=nac0s.admin
4.启动: sh /opt/nacos/bin/startup.sh -m standalone &
5.访问地址: http://127.0.0.1:8848/nacos/
6.nacos源码分析: https://www.jianshu.com/p/20ddf3bc6f8e

mysql连接版本问题分析: https://blog.csdn.net/waterflying2015/article/details/81047128