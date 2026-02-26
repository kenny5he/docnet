# Message Lose
## Producer Lose (生产端丢失)
1. 发送时报错
    - 解决方案：及时抛错给前端
2. 数据批量发送
    1. 批量策略
        1. Kafka: (消息缓冲区)
            1. 参考： https://zhuanlan.zhihu.com/p/15762360152
            2. RecordAccumulator: 记录累加器
            3. batch.size: 
                - 默认值: 
                - 控制批量的大小，数据批次字节大小
            4. linger.ms: 
                - 默认值
                - 延迟时间，在指定时间内，生产者收集到了足够多的消息（达到了batch.size的大小），则这些消息会被作为一个批次发送
            5. message.max.bytes: 
                - 默认值: 
                - 一个批次的消息大小, (值比 batch.size 大)
            6. max.request.size
                - 默认值:
                - 控制请求的最大大小
        2. RocketMQ:
            1. 
        3. RabbitMQ:
            1. 
    2. 解决方案: 每条数据独立发送
    
## Broker Lose (Broker 丢失)
1. Broker 宕机，集群数据不一致
    1. 丢失原因
        1. Producer 发送Message 给 Broker后，Broker 某台机器写入，此时数据未同步整个集群，Broker宕机，导致数据丢失
    2. 解决方案: 设置Ack接收
        1. Kafka:
            1. acks=0: 生产者不会等待确认，继续发送下一条消息
            2. acks=1: 生产者等待Leader确认，继续发送下一条消息
            3. acks=-1: 生产者等待ISR中所有副本确认，继续发送下一条消息
        2. RocketMQ
        3. RabbitMQ
## Consumer Lose (消费端丢失)
1. 数据不满足条件
   1. 解决方案: (根据业务情况决定)
       1. 脏数据丢弃
       2. 建草稿单，后续 显示给前端补充数据
2. 系统原因，重试多次，失败
    1. 通用解决方案：
        1. 记录消息id，记录消息内容及消息消费状态信息 至数据库，处理消息时及时更新数据状态。业务系统根据情况后续再进行处理操作
    2. Kafka:
    3. RocketMQ:
        1. ‌重试机制‌：当消费者没有发送ACK时，RocketMQ会自动进行重试，确保消息被多次尝试消费。
        2. 死信队列‌：如果消息经过多次重试仍然无法被成功消费，RocketMQ会将其放入死信队列（DLQ），以便后续分析和处理。
        3. 消费进度管理‌：RocketMQ通过消费进度（Offset）的管理来跟踪消费者的消费情况。即使消费者发生故障或重启，它也可以从上次的消费进度继续消费未处理的消息。
    4. RabbitMQ: