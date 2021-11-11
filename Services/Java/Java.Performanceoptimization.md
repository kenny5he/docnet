# Java性能优化
1. 应用程序运行缓慢
    - 解决方案：需要调整JVM参数。采取措施平衡黑白暂停和GC频率。
2. 消耗过多内存
    - 应用程序的内存占用量与任何给定时间点JVM中活动对象的数量和大小有关。这可能是由于需要保留在内存中的有效对象，
    - 或者是因为程序员忘记删除对不需要的对象的引用（在Java用语中通常称为“内存泄漏”。并且当内存占用达到阈值时，
    - JVM抛出java.lang.OutOfMemoryError。
3. Java.lang.OutOfMemoryError发生的原因:
    1. JavaHeap空间低以创建新对象。增加-Xmx（java.lang.OutOfMemoryError：Java堆空间）。java.lang.OutOfMemoryError：Java堆空间
    2. 永久生成低。增加XX：MaxPermSize = 256m（java.lang.OutOfMemoryError：PermGen space）java.lang.OutOfMemoryError：PermGen space
    3. java.lang.OutOfMemoryError：  ....超出交换空间......
        -即使JavaHeap和PermGen具有内存，JNI Heap的内存也很低。如果您正在进行大量繁重的JNI调用，通常会发生这种情况，
        - 但JavaHeap对象占用的空间很小。在那种情况下，GC可能不会感觉到清理JavaHeap的冲动，而JNI Heap一直在增加，直到内存不足为止。

4. 问题诊断方式:
   1. GC输出
        java -verbose：gc
   2. hprof输出文件
        java -Xrunhprof：heap = sites，cpu = samples，depth = 10，thread = y，doe = y
            heap = sites告诉探测器写入有关堆上内存利用率的信息，指出它的分配位置。
            cpu = samples告诉探查器进行统计采样以确定CPU使用情况。
            depth = 10表示线程的跟踪深度。
            thread = y告诉探查器识别堆栈跟踪中的线程。
   3. -XX：+ HeapDumpOnOutOfMemoryError -XX：HeapDumpPath = C：\ OOM.txt
        将堆转储到OOM上，然后使用jhat工具（与JDK捆绑在一起）分析OOM.txt（二进制文件）
        以下命令将启动http server @port 7777。使用URL“http：// localhost：7777”打开浏览器以查看结果。
        jhat -port 7777 c：\ OOM.txt
   4. 分析应用程序

5. JVM参数调整
    1. 内存大小：   总大小，单个区域大小
        1. -ms，-Xms
            - 设置初始堆大小（仅限年轻和终身生成，非永久）
            如果应用程序以大内存占用开始，则应将初始堆设置为一个较大的值，以便JVM不会消耗周期来继续扩展堆。
        2. -mx，-Xmx
            - 设置最大堆大小（仅限年轻和终身，不是Perm）（默认值：64mb）
            最常调整的参数，以满足应用程序的最大内存要求。较低的值会使GC过度使用，以便为创建新对象释放空间，
            并可能导致OOM。非常高的价值可以使其他应用程序挨饿并引发交换。因此，配置内存要求以选择正确的值。
        3. -XX：PermSize = 256 -XX：MaxPermSize = 256m
            - MaxPermSize默认值（-client为32mb，-server为64mb）
            - 调整此值以增加永久性生成最大值。
    2. GC参数：
        1. -X minf [0-1]， - XX：MinHeapFreeRatio [0-100]
            设置最小可用堆空间的百分比 - 控制堆扩展速率
        2. -X maxf [0-1]， - XX：MaxHeapFreeRatio [0- 100]
            设置最大可用堆空间的百分比 - 控制VM何时将未使用的堆内存返回到OS
        3. -XX：NewRatio
            设置堆中新旧代的比率。NewRatio为5将新旧比率设置为1：5，使新一代占据整体堆
            默认值的1/6 ：客户端8，服务器2
        4. -XX：SurvivorRatio
            设置新对象区域中幸存者空间与伊甸园的比率。SurvivorRatio为6将三个空间的比例设置为1：1：6，使每个幸存者空间成为新对象区域的1/8
6. 一些技巧
    - 除非您遇到暂停问题，否则请尽量为虚拟机授予尽可能多的内存
   - 将-Xms和-Xmx设置为相同的值...但请确保应用程序行为
   - 确保在增加处理器数量时增加内存，因为分配可以并行化
   - 别忘了调整Perm一代
   - 尽量减少同步的使用
   - 只有在有益的情况下才使用多线程。注意线程开销。例如，一个简单的任务，比如计数器从1增加到10亿......使用单线程。多个线程将破坏多达10个。我在具有8个线程的双CPU WinXP上测试了它。
   - 避免过早创建对象。创作应尽可能接近实际使用地点。我们倾向于忽略的非常基本的概念。
   - JSP通常比servlet慢。
   - 自定义CL太多，反射：增加Perm生成。不要与PermGen无关。
   - 内存泄漏的软参考。它们启用智能缓存，但不加载内存。如果JVM内存不足，GC将自动清除SoftReferences。
   - StringBuffer而不是String concat
   - 最小化代码中的JNI调用
   - XML API - 小心...... SAX或DOM-做出正确的选择。使用预编译的xpath可以更好地执行查询。

