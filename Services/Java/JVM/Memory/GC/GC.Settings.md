## GC 内存回收设置
### 设置堆内存

| 启动参数 | 说明 | 等价形式 |默认值| 示例|
|---|---|---|---|---|
|-Xmx|设置堆内存最大值| -XX:MaxHeapSize| 物理内存 1/64 | -Xmx4g|
|-Xms|设置堆内存初始值| -XX:InitalHeapSize|| -Xms512m|
|-XX:PermSize|设置持久代初始值||物理内存的1/64||
|-XX:MaxPermSize|设置持久代最大值||||
|-XX:NewSize|设置年轻代大小||||
|-XX:MaxNewSize|设置年轻代最大值||||
|-Xss|设置每个线程的栈大小|/|1m||
|-XX:PretenureSizeThreshold|对象超过多大是直接在旧生代分配|/|||

### 设置收集器
| JDK版本 | 启动参数 | 说明 |  其它 | 默认值 |示例|
|---|---|---|---|---|---|
| |-XX:+UseParallelGC|设置为并行收集(仅对年轻代有效)|可同时并行多个垃圾收集线程，但此时用户线程必须停止|||
| |-XX:+UseParNewGC|设置年轻代为并行收集(多线程收集)|可与CMS收集同时使用|||
| |-XX:+UseG1GC|使用G1垃圾收集器||||
| |-XX:MaxGCPauseMillis|设置GC最大的停顿毫秒数|/|GC的暂停时间主要取决于堆中实时数据的数量与实时数据量|-XX:MaxGCPauseMillis=50|
| |-XX:GCTimeRatio|GC花费不超过应用程序执行时间的1/(1+nnn),且 0<n<100,|/|/|-XX:GCTimeRatio=19, 则说明GC最大花费时间的比率=1/(1+19)=5%，程序每运行100分钟，允许GC停顿共5分钟|
| |-XX:ParallelGCThreads|设置GC并行阶段最大的线程数|/|/|-XX:ParallelGCThreads=4|
| |||||

#### 参考
- tomcat jvm设置: blog:https://www.cnblogs.com/lytwajue/p/7120031.html
- jvm内存组成分配: http://www.cnblogs.com/redcreen/archive/2011/05/04/2036387.html
- jvm内存申请、对象衰老: http://www.cnblogs.com/redcreen/archive/2011/05/04/2037056.html
- jvm参数设置、分析: https://www.cnblogs.com/redcreen/archive/2011/05/04/2037057.html
- gc种类: http://www.cnblogs.com/redcreen/archive/2011/05/04/2037029.html