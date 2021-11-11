### MyCat 安装
1. 安装包
```
tar -xvf Mycat-server-1.6.5-release.tar.gz -C /opt/apache/
```
2. 配置环境变量MYCAT_HOME
```
$MYCAT_HOME/bin/startup_nowrap.sh
JAVA_OPTS="-server -Xms1G -Xmx2G -XX:MaxPermSize=64M -XX:+AggressiveOpts -XX:MaxDirectMemorySize=2G"
```
3. 启动MyCat
```
```