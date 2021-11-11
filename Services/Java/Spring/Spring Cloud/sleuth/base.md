## 定义
随着微服务拆分粒度越来越细化，微服务之间的调用关系也随之错综复杂，通常一个客户端发起请求会进过多个不同的微服务调用来协同产生最后的请求结果，这时候我们就需要一个全链路调用的跟踪系统帮助我们快速发现错误根源以及监控分析每条请求链路上的性能瓶颈。
## 基础使用篇
### 客户端
1. 依赖sleuth架包
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-sleuth</artifactId>
</dependency>
```
2. 与zipkin集成
 
3. 采样收集方式
    1. Sampler接口: 通过实现isSampled方法产生跟踪信息的时候调用来为跟踪信息生成是否要被收集的标志，返回false仅代表该追踪信息不被输出到后续对接的远程分析系统。
    2. PercentageBaseSampler(默认情况)实现的抽样策略，以请求百分比的方式配置和收集跟踪信息。通过配置spring.sleuth.sampler.percentage=0.1收集10%的请求跟踪信息。

## 核心知识
### 追踪原理
1. 请求进入分布式系统端点是，会为请求创建一个唯一的跟踪标识 TraceId
2. 请求到达各个服务组件是，或者处理逻辑到达某个状态时，会用表示SpanId表示过程及结束。

### 跟踪请求Header中的重要信息
- X-B3-TraceId: 一个请求链路(Trace)的唯一标识
- X-B3-SpanId: 一个工作单元(Span)的唯一标识
- X-B3-ParentSpanId: 标识当前工作丹玉所属的上一个单元
- X-B3-Sampled: 是否被抽样输出的标志
- X-Span-Name: 工作单元名称
