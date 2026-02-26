# IDS 
## NIDS（Network Intrusion Detection System，网络入侵检测系统
NIDS 主要检测网络流量中的攻击行为。区别于部署在网络边界的防火墙，NIDS 一般部署在内网的网络节点（路由器或交换机）中，所有的网络请求都会流经这些网络节点，NIDS 基本可以获取到对应网络节点下全部的网络行为。
### 开源工具
1. [Snort](https://www.snort.org/#get-started)
2. [Suricata](https://suricata-ids.org/)

## HIDS（Host-based Intrusion Detection System，基于主机型入侵检测系统）。
HIDS 主要检测服务器系统中的攻击行为，监控各个用户在服务器系统上的行为来检测黑客的存在。
### 监控行为
1. 执行的系统命令
2. 发起和接受的网络请求
3. 运行的进程、监听的端口号
4. 系统关键文件的完整性
5. 其他黑客可能留下痕迹的地方
### 开源工具
1. 基于[Osquery](https://osquery.io/) 定制开发

