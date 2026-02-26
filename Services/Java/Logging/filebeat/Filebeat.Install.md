## Install Filebeat
1. 安装地址: https://www.elastic.co/cn/downloads/past-releases#filebeat
2. 下载 Logstash tar.gz:
```shell
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.1.2-linux-x86_64.tar.gz
```
3. 启动filebat
```
./filebeat -e -c /opt/apps/manager/root.log
```


- 参考博客: https://blog.csdn.net/zyxwvuuvwxyz/article/details/108831962