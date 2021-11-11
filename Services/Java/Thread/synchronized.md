blog: http://www.iocoder.cn/JUC/sike/synchronized/?vip
https://juejin.im/post/5abc9e14f265da23953111d6(掘金)
https://juejin.im/post/5abc9de851882555770c8c72(掘金)

synchronized 实现同步的基础：
    普通同步方法，锁是当前实例对象
    静态同步方法，锁是当前类的class对象
    同步方法块，锁是括号里面的对象

synchronized实现方式:
    1) 同步代码块是使用 monitorenter 和 monitorexit 指令实现的；
    2）同步方法（在这看不出来需要看JVM底层实现）依靠的是方法修饰符上的ACC_SYNCHRONIZED 实现


