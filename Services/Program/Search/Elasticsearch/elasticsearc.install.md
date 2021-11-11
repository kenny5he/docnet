#### 安装说明文档
[参考blog] https://www.jianshu.com/p/e60985802096
1. 下载文件
    ```
        wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.4.tar.gz
        wget https://artifacts.elastic.co/downloads/kibana/kibana-6.5.4-linux-x86_64.tar.gz
    ```
2. 解压
    ```
        tar -xvf /software/search/elasticsearch-6.5.4.tar.gz -C /opt/search
    ```
3. 配置
    1. 配置jvm 内存
        1. vi /opt/search/elasticsearch-6.5.4/bin/elasticsearch
        ```
        ES_JAVA_OPTS='-Xms512m -Xmx512m'
        ```
        2. /opt/search/elasticsearch-6.5.4/config/jvm.options
        ```
        -Xms512m
        -Xmx512m
        ```
    2. 配置远程访问
        ```
        vi /opt/search/elasticsearch-6.5.4/config/elasticsearch.yml
        network.host: 120.77.206.247
        network.host: 172.18.229.70
       ```
    3. error info
        1) max file descirptions [4096] for elasticsearch process is too low,increase to least[65536]
            - resolve(append)
                - vi /etc/security/limits.conf
                esuser soft nofile 65536
                esuser hard nofile 65536
                esuser soft nproc 4096
                esuser hard nproc 4096
        2) max number of threads [3790] for user [xxx] is too low, increase to at least [4096]
            - resolve(modify '*          soft    nproc     4096')
                vi /etc/security/limits.d/20-nproc.conf
                esuser          soft    nproc     4096
        3) max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
            - resolve(append)
                - vi /etc/sysctl.conf
                vm.max_map_count=655360
                sysctl -p (excute command and let it effective)

4. 创建用户组、用户
    ```
    groupadd esgroup
    # useradd -s /sbin/nologin -g esgroup -M esuser
    useradd esuser -g esgroup -p esMicrof0olish.Adm
    cd /opt/search/
    chown -R esuser:esgroup elasticsearch-6.5.4
    ```
5. 启动
    1) 正常启动
        ```
        sh /opt/search/elasticsearch-6.5.4/bin/elasticsearch
        ```
    2) 允许root 用户启动
        ```     
        sh /opt/search/elasticsearch-6.5.4/bin/elasticsearch -Des.insecure.allow.root=true
        ```
    3) 后台启动
        ```
        sh /opt/search/elasticsearch-6.5.4/bin/elasticsearch -d
        sh /opt/search/elasticsearch/bin/elasticsearch -d
        ```
6. 测试启动情况
    ```
    curl 127.0.0.1:9200
    ```
7. 安装插件
    1. head
        1. 简介: head是elasticearch的集群管理工具，可以用于数据的浏览和查询,它托管于github上，elasticsearch5.0后 不做插件放在plugin目录下
        2. 安装
            1. git 下载源码
                ```
                git clone git://github.com/mobz/elasticsearch-head.git
                ```
            2. 安装依赖
                ```
                cd elasticsearch-head
                npm install -g grunt-cli
                npm install
                ```
            3. 修改配置文件,使所有ip可访问
                ```
                vi Gruntfile.js(在connect --> server --> options 下添加)
                    hostname: '*',
                cd _site
                vi app.js
                将this.base_url = this.config.base_uri || this.prefs.get("app-base_uri") || "http://localhost:9200"中的localhost改为你es所在的ip地址
                    this.base_url = this.config.base_uri || this.prefs.get("app-base_uri") || "http://172.18.229.70:9200"
                ```
            4. 配置允许跨域访问
                - 打开elasticsearch(注意: 不是head插件)配置文件elasticsearch.yml在文件末尾追加
                ```
                vi /opt/search/elasticsearch-6.5.4/config/elasticsearch.yml
                    http.cors.enabled: true
                    http.cors.allow-origin: "*"
                ```

            5.1.2.5 启动前端项目
                ```
                npm run start
                open http://localhost:9100/
                ```
    5.2 kibana
        1. 简介: Kibana 是Elasticsearch的开源分析可视化平台，使用Kibana可以查询、查看并与存储在ES索引的数据进行交互操作，使用Kibana能执行高级的数据分析，并能以图标、表格和地图的格式查看数据
        2. 安装
            1. 解压缩
                tar -xvf /software/search/kibana-6.5.4-linux-x86_64.tar.gz -C /opt/search/
            2. 编辑配置文件
                1. vi /opt/search/kibana-6.5.4-linux-x86_64/config/kibana.yml
                2. 在#server.host: "localhost"下添加对应Ip的信息
                    - server.host: "172.18.229.70"
                3. 在#elasticsearch.url: "http://localhost:9200"下添加对应es的信息
                    - elasticsearch.url: "http://172.18.229.70:9200"
            3. 开启5601端口
            4. 启动
                ```
                sh /opt/search/kibana-6.5.4-linux-x86_64/bin/kibana
                ```

