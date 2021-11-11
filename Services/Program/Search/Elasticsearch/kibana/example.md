### 索引库
#### 创建索引库
- 创建空索引库，设置索引库
```
PUT /example 
{
	"settings": {
		"number_of_shards": "2",
		"number_of_replicas": "0",
		"write.wait_for_active_shards": 1
	}
}
```
- 创建明确类型的索引库信息
```
PUT /customer_contact
{
  "settings": {
    "number_of_replicas": 0,
    "number_of_shards": 1
  },
  "mappings": {
    "properties": {
      "id": {
        "type": "long"
      },
      "name": {
        "type": "text",
        "analyzer": "ik_max_word"
      },
      "customer_org": {
        "type": "text",
        "analyzer": "ik_max_word"
      },
      "address": {
        "type": "text",
        "analyzer": "ik_max_word"
      },
      "phone_number": {
        "type": "text",
        "analyzer": "ik_max_word"
      },
      "email": {
        "type": "text",
        "analyzer": "ik_smart"
      },
      "status": {
        "type": "integer"
      },
      "create_time": {
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss"
      },
      "update_time": {
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss"
      }
    }
  }
}
```
- number_of_shards: 分片数
- number_of_replicas: 副本数
#### 修改索引库
- 修改索引库分片信息
```

```
- 给索引库添加类型
```

```
- 给索引库添加新字段
```

```
- 修改索引库字段信息
```
POST /example/_mapping?pretty
{
  "properties": {
    "customer_org": {
      "type": "text"
    }
  }
}
```
- 修改索引库字段分词器
```
```
#### 查看索引库字段信息
- 查看索引库某一字段分词结构
```
GET /example/_doc/10001/_termvectors?fields=name
```
- 查看索引库mapping
```
GET /example/_mapping?pretty
```
- 查看索引库settings设置
```
GET /example/_settings
```
- 查看索引库分词器
```
GET /example/_analyze
```
#### 插入数据
- 指定Id插入
```
POST /example/_doc/10001
{
  "id":10001,
  "name":"张三",
  "age":20,
  "sex":"男",
  "customer_org":"中国移动通信集团",
  "phone":"13100338762",
  "email":"zhangsan@10086.cn"
}
```
- 不指定id,es帮我们自动生成
```
POST /example/_doc
{
  "id":10002,
  "name":"李四",
  "age":20,
  "sex":"男",
  "customer_org":"中国联合通信集团",
  "phone":"13800338762",
  "email":"lisi@10010.cn"
}
```

#### 搜索
- took          Elasticsearch运行查询需要多长时间(以毫秒为单位)
- timed_out  	搜索请求是否超时
- _shards       搜索了多少碎片，并对多少碎片成功、失败或跳过进行了细分。
- max_score     找到最相关的文档的得分
- hits.total.value  找到了多少匹配的文档
- hits.sort     文档的排序位置(当不根据相关性得分排序时)
- hits._score   文档的相关性评分(在使用match_all时不适用)
##### 搜索全部数据
```
POST /example/_search
{
  "query": { "match_all": {} },
  "sort": [
    {
      "id": {
        "order": "asc"
      }
    }
  ]
}
```

##### 高亮显示
```

```
##### 测试中文分词
```
GET /example/_analyze
{
  "analyzer": "ik_max_word", 
  "text": "中国联合通信有限公司"
}
```