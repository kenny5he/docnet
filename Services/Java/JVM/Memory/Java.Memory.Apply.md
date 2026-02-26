## Java Memory Apply (Java 内存申请的过程)
JVM会试图为相关Java对象在Eden中初始化一块内存区域；
当Eden空间足够时，内存申请结束。否则到下一步；
JVM试图释放在Eden中所有不活跃的对象（minor collection），释放后若Eden空间仍然不足以放入新对象，则试图将部分Eden中活跃对象放入Survivor区；
Survivor区被用来作为Eden及old的中间交换区域，当OLD区空间足够时，Survivor区的对象会被移到Old区，否则会被保留在Survivor区；
当old区空间不够时，JVM会在old区进行major collection；
完全垃圾收集后，若Survivor及old区仍然无法存放从Eden复制过来的部分对象，导致JVM无法在Eden区为新对象创建内存区域，则出现"Out of memory错误"；
    