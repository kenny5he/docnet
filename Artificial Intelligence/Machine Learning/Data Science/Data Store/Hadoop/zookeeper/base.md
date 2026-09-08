强一致性:
数据库A  存在key a=1     更新 a =2
数据库B  存在key a=1     因为数据库A更新了值a,查询过程中阻塞，等同步后再返回a的值
弱一致性:
数据库A  存在key a=1     更新 a =2
数据库B  存在key a=1     返回a值为1
最终一致性:
数据库A  存在key a=1     更新 a =2
数据库B  存在key a=1     开始返回a值为1，后续更新后再返回a值为2


ZAB一致性协议:(保证最终一致性)
blog: https://www.jianshu.com/p/2bceacd60b8a
概念:
    Zookeeper Atomic Broadcast （Zookeeper原子广播）。
    Zookeeper是通过Zab协议来保证分布式事务的最终一致性
角色:
    Leader: 领导者
    follower: 跟随者，参与者(增加follower结点，增加读性能，影响写性能(ack步骤))
    observer: 观察者(无需参与领导选举、两阶段提交，无需ack,最终commit阶段发送信息就行)

过程:
     预提交       ->                   ack             ->          提交 (2PC 两阶段提交)
  占用资源，生成zxid                生成事务日志，后返回ack相应信息
  生成事务日志，DataTree(内存)         过半保存成功

操作:
    事务 create delete
    非事务 get exsist

选举:(配置有多个server,但只有一台启动，则无法启动)(配置只有一个server，启动则为standalone模式)
    开始的时候投票给自己，再相互交流，互相投票
    zxid 自增，先判断大小
    myid (data目录下的文件) 再判断leader
    选票箱(数组)

问题:
    1. 当选举完成后，新加入的zookeeper节点默认为follower
    2. 当值存在更新时,leader更新完成,follower1、follower2未更新完成，当leader突然挂掉后，重新选举leader，旧leader重新启动，更新操作回滚(未过半)
    3. 当follower挂掉后，leader存在过半未跟随自己，停止服务，重新选举。
    4. 当存在4台服务器时，最多可以挂掉1台，必须大于过半，等于也不行
    脑裂(存在多个leader):
       存在多个机房，机房1  5台机器，机房2 存在6台 机器，当机房直接网络存在问题时，则存在问题
       因为过半机制，zookeeper不存在脑裂问题

源码:
     QuorumPeerMain 启动类
     SendAckRequestProcesser  发送数据过程
     LeaderHandler.send       Leader发送数据给Follower时单个进行处理(poll)
     Leader

     QuorumMaj.containsQuarum  大小是否大于一半

     QuorumConfig.           如何判断过半
ZAB和PAXOS的区别:
