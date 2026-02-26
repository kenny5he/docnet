### ElasticSearch
1. [鲁班学院文档](https://www.yuque.com/books/share/9f4576fb-9aa9-4965-abf3-b3a36433faa6#) ggmc
- elasticsearch相关概念、及关系:
    -特点:
        1. 不支持事务和复杂关系
        2. 不注重存储，注重搜索
- 适用场景: 日志搜索定位(sky)、大数据搜索
- 逻辑划分
    - 索引: 类似于关系型数据库中的数据库
    - 类型: 是文档的逻辑容器，(可以看做为关系型数据库的表，7.x版本后只有一个类型(_doc)，7.x之前可设置多个类型)
    - 文档: 是用于索引和搜索的基本单位，(可认为是关系型数据库中的一行，文档以类型为分组，类型包含若干文档)
        - 文档的属性: 自我包含(同时包含字段及其值)、层次型(文档中可包含新文档)、灵活结构(不依赖预先定义，即用即开字段)
    - 映射: 是将文档进行逻辑划分，(映射用于解决对文档类型的猜测)，索引是映射类型的容器，索引存储了所有映射类型的字段及部分设置
    - 索引名+类型名+文档id=唯一确定的文档
- 物理划分:
    - 节点: 一个节点是一个es实例，多节点组成集群
    - 分片: es将索引划分为分片，每份分片在集群中的不同服务器间迁移，每份分片都是一个"Lucene的索引"(一个包含倒排索引的文件目录)，
        - 索引有一个或多个主分片和零个或多个副本分片构成，过少分片影响扩展性，过多的分片影响性能
        - 主分片:
        - 副本分片: 可在运行的时候添加和移除(主分片不可以)
    - 索引文档过程:
        - 根据文档id的散列值选择一个主分片，并将文档发送给主分片，然后文档被发送到主分片所有的副本分片进行索引，使副本分片与主分片直接保持数据同步，
        - 使副本分片可以服务于搜索请求，当主分片故障后，副本分片可以自动升级为主分片。
- 分组(group)和活动(event):(活动属于分组)


- elasticsearch关键词搜索算法:


- elasticsearch的使用(9200 http通信，9300 集群通信方式)
    0. 准备
        1. 创建测试索引库(当文档不存在时，es自动创建文档索引、类型)
            ```
            curl -XPUT -H "Content-Type:application/json" 'localhost:9210/index-test/group/1?pretty' -d '{"name": "Elasticsearch test","org": "Apaya"}'
            ```
            - 注:
                1. index-test为索引名称
                2. group为类型名称
                3. 1代表文档的id
                4. pretty使文档可读性更好,默认情况下es返回一行json字符串
    1. 基础搜索
        1. eslasticsearch 字符拼接 按关键词搜索单字段
            - 搜索请求
                ```
                curl 'localhost:9210/index-test/group/_search?q=elasticsearch&pretty&timeout=3s'
                ```  
              - 注:
                    - q为搜索关键词
                    - timeout代表超时时间
            - 返回结果:
                - result:
                ```
                    {
                      "took" : 13,
                      "timed_out" : false,
                      "_shards" : {
                        "total" : 5,
                        "successful" : 5,
                        "skipped" : 0,
                        "failed" : 0
                      },
                      "hits" : {
                        "total" : 1,
                        "max_score" : 0.25316024,
                        "hits" : [
                          {
                            "_index" : "index-test",
                            "_type" : "group",
                            "_id" : "1",
                            "_score" : 0.25316024,
                            "_source" : {
                              "name" : "Elasticsearch test",
                              "Org" : "Apaya"
                            }
                          }
                        ]
                      }
                    }
                ```
                - 注:
                    - took: 耗时时间
                    - time_out: 是否超时
                    - _shards: 查询的分片信息，(total 总分片信息，successful 成功的分片信息)
                    - hits: 所有匹配文档的统计数据
        1. eslasticsearch json 按关键词搜索单字段(querystring)
            ```
            curl 'localhost:9210/index-test/group/_search?pretty' -d '{
                "query": {
                    "query_string":{
                        "query": ["elasticsearch","test"],
                        "default_field": "name",
                        "default_operator": "AND"
                    }
                }
            }'
           ```
            - 注:
                - query为查询字符串(搜索关键词均为小写匹配,故区分的大小写)
                - default_field为默认查询字段名
                - default_operator为默认使用的关联词，不指定默认为OR
        2. eslasticsearch json 按关键词搜索单字段(term)
             ```
             curl 'localhost:9210/index-test/group/_search?pretty' -d '{
                "query": {
                    "term":{
                        "name": "elasticsearch"
                    }
                }
             }'
             ```
        3. eslasticsearch 过滤器查询
            - 特点:
                1) 无得分数据
                2) 相比于其它查询，速度更快
                3) 只关心一条结果是否匹配搜索条件
            curl 'localhost:9210/index-test/group/_search?pretty' -d '{
                "query": {
                    "filtered":{
                        "filter": {
                            "term"{
                                "name": "Elasticsearch"
                            }
                        }
                    }
                }
            }'

    2. 倒排索引

    3. 分词器
        - ik分词器
            - ik_max_word和 ik_smart的区别
                [link](https://blog.csdn.net/weixin_44062339/article/details/85006948)
    4. 打分系统
