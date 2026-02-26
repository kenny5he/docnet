# Restful (Representational State Transfer)

## 资源（Resources）
1. 资源即网络上的一个实体，或者说是网络上的一个具体信息
2: 例:
   1. product  产品
   2. customer 客户
   3. order    订单

## 表现层（Representation）
1. 表现层即将"资源"具体呈现出来的形式。
2. 例: -> javax.ws.rs.core.MediaType
   1. xml
   2. json
   3. html
## 状态转化（State Transfer）
1. 客户端操作服务器，须通过某种手段，让服务器端发生"状态转化"。
2. 操作: 
   1. GET: 获取资源
   2. POST: 新建资源(也可用于更新资源)
   3. PUT: 更新资源
   4. DELETE: 删除资源
3. 例: 

|编号|请求方式| 地址                               |释义|
|---|---|----------------------------------|---| 
|1.| GET| /product                         |获取全部产品资源|
|2.| GET| /product/{id}                    |获取某个产品|
|3.| GET| /product/page/{pageSize}/{curPage} |获取产品分页|
|4.| POST| /product                         |新建产品|
|5.| PUT| /product/{id}                    |更新某个产品|
|6.| DELETE| /product/{id}                    |删除某个产品/失效产品(软删除/硬删除)|
|7.| GET| /order/{id}/product              |某个订单的所有产品|
|8.| POST | /order/batch                     |批量操作|
|9.| GET| /order/export/excel              |导出数据至excel|
|10.| POST| /order/import/excel              |从Excel导入数据|

- 注: 检查数据是否存在: /product/check/{id} , 检查动作内层深意为查询某条数据是否存在，故只需查询数据，判断其条数即可。