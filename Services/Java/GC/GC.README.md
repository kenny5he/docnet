### GC
JVM里的GC(Garbage Collection)的算法有很多种，如标记清除收集器，压缩收集器，分代收集器(常用)等等,
    分代收集(generational collection): 将不同生命周期的对象放在不同区域
       过程:
            young generation(生命周期短)(绝大部分object分配位置)
                满  -> 引发minor collection(YGC) -> 在minor collection后存活的object会被移动到tenured generation
            tenured generation(生命周期比较长)
                满  -> 触发major collection,major collection（Full gc）会触发整个heap的回收
            permanet generation
       我们要尽量减少 Full gc 的次数(tenured generation 一般比较大,收集的时间较长,频繁的Full gc会导致应用的性能收到严重的影响)
       组成:
            young generation有eden、2个survivor 区域组成。
            其中一个survivor区域一直是空的，是eden区域和另一个survivor区域在下一次copy collection后活着的objecy的目的地。
            object在survivo区域被复制直到转移到tenured区。
堆内存GC
       JVM(采用分代回收的策略)，用较高的频率对年轻的对象(young generation)进行YGC，而对老对象(tenured generation)
       较少(tenured generation 满了后才进行)进行Full GC。这样就不需要每次GC都将内存中所有对象都检查一遍。
非堆内存不GC
      GC不会在主程序运行期对PermGen Space进行清理，所以如果你的应用中有很多CLASS
      (特别是动态生成类，当然permgen space存放的内容不仅限于类)的话,就很可能出现PermGen Space错误

一、内存申请过程
    JVM会试图为相关Java对象在Eden中初始化一块内存区域；
    当Eden空间足够时，内存申请结束。否则到下一步；
    JVM试图释放在Eden中所有不活跃的对象（minor collection），释放后若Eden空间仍然不足以放入新对象，则试图将部分Eden中活跃对象放入Survivor区；
    Survivor区被用来作为Eden及old的中间交换区域，当OLD区空间足够时，Survivor区的对象会被移到Old区，否则会被保留在Survivor区；
    当old区空间不够时，JVM会在old区进行major collection；
    完全垃圾收集后，若Survivor及old区仍然无法存放从Eden复制过来的部分对象，导致JVM无法在Eden区为新对象创建内存区域，则出现"Out of memory错误"；
二、对象衰老过程
    新创建的对象的内存都分配自eden。Minor collection的过程就是将eden和在用survivor space中的活对象copy到空闲survivor space中。
    对象在young generation里经历了一定次数(可以通过参数配置)的minor collection后，就会被移到old generation中，称为tenuring。