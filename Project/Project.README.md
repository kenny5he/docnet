## 计划/步骤
0. 可信性分析
    1. 市场前景
    2. 同行友军生存现状

1. 业务流程
    1. 整体流程
    2. 各应用流程

2. 根据业务划分应用 (应用划分维度、各应用职责)
    1. 参考: https://www.cnblogs.com/lovecindywang/p/10941007.html#4267699
    2. 公共集成/组件应用
        - 单点登录(SSO)
        - 网关路由(Gateway)
        - 应用认证(OAuth)
        - 统一权限申请(iAuth)
        - 文档文件存储(Edoc)
        - RASP/WAF(Security)
        - 消息平台(Logi Kafka)
        - 监控平台(Prometheus+Granfna/Skywalking)
        - 搜索平台(OpenSearch)
        - 站内信平台(WebSocket)
        - 工作流开发平台(Camunda BPM)
        - 配置平台(Nacos/Apollo)
        - 注册平台(Eureka/Zookeeper)
        - 日志平台(ELK)
        - 埋码平台(前端埋码、中台埋码)
        - 数据同步平台(FDI)
    3. DevOps:
        1. Jekins x(Building + Deploy)
        2. Sonarqube (CodeCheck)
        3. Gitlab (Version Control)
        4. Confluence Wiki (Wiki/Docs)
        5. Jfrog(Maven + Npm + Docker Images)
        6. Bug Manage
        7. 需求管理平台
        8. Api 测试平台
    4. 业务职责划分应用
    5. 客户群体划分应用
	
4. 应用流转关系(集成计划/方案)
5. 应用框架架构
    1. 整体架构
    2. 前台架构、中台架构、后台架构(数据存储分析架构)