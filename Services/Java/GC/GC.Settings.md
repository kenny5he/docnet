tomcat jvm设置:
    blog:https://www.cnblogs.com/lytwajue/p/7120031.html
jvm内存组成分配:
    blog: http://www.cnblogs.com/redcreen/archive/2011/05/04/2036387.html
jvm内存申请、对象衰老:
    blog: http://www.cnblogs.com/redcreen/archive/2011/05/04/2037056.html
jvm参数设置、分析:
    blog: https://www.cnblogs.com/redcreen/archive/2011/05/04/2037057.html
gc种类:
    blog: http://www.cnblogs.com/redcreen/archive/2011/05/04/2037029.html


堆:
    堆是运行时数据区域，所有类实例和数组的内存均从此处分配。堆是在 Java 虚拟机启动时创建的。
    ”“在JVM中堆之外的内存称为非堆内存(Non-heap memory)”。
    主要管理两种类型的内存：堆和非堆。
        堆就是Java代码可及的内存，是留给开发人员使用的；
        非堆就是JVM留给 自己用的，方法区、JVM内部处理或优化所需的内存(如JIT编译后的代码缓存)、
        每个类结构(如运行时常数池、字段和方法数据)以及方法和构造方法 的代码都在非堆内存中。

方法栈&本地方法栈:
    线程创建时产生,方法执行时生成栈帧
方法区(方法区属于堆中永久区(PremGen)的一部分)(永久区 几乎不会被GC垃圾回收)(JDK8无永久区，存在Meta Space元空间，直接使用物理内存)
    存储类的元数据信息 常量等
堆
    java代码中所有的new操作
native Memory(C heap)
    Direct Bytebuffer JNI Compile GC;


-Xms指定JVM初始分配的内存,默认是物理内存的1/64
-Xmx指定JVM最大分配的内存,默认是物理内存的1/4
-XX:PermSize设置JVM非堆内存初始值，默认是物理内存的1/64；(JDK1.8 无效,Metaspacesize)
-XX:MaxPermSize设置最大非堆内存的大小，默认是物理内存的1/4。(JDK1.8 无效,MaxMetaspacesize)
-XX:NewSize	设置年轻代大小(for 1.3/1.4)
-XX:MaxNewSize	年轻代最大值(for 1.3/1.4)
-Xss	每个线程的堆栈大小
-XX:ThreadStackSize	Thread Stack Size

