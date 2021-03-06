## 并发编程
1. 并发编程三要素
   1. 原子性: 即一个操作或者多个操作 要么全部执行并且执行的过程不会被任何因素打断，要么就都不执行。
   2. 可见性: 可见性是指当多个线程访问同一个变量时，一个线程修改了这个变量的值，其他线程能够立即看得到修改的值。
   3. 有序性: 即程序执行的顺序按照代码的先后顺序执行。
2. volatile关键字
    1. volatile关键字是Java用来保证可见性的，当一个共享变量被volatile修饰时，它会保证修改的值会立即被更新到主存，当有其他线程需要读取时，它会去内存中读取新值。
    2. volatile关键字禁止进行指令重排序,故volatile能在一定程度上保证有序性。
    3. volatile关键字禁止指令重排序有两层意思：
        1. 当程序执行到volatile变量的读操作或者写操作时，在其前面的操作的更改肯定全部已经进行，且结果已经对后面的操作可见；在其后面的操作肯定还没有进行；
        2. 在进行指令优化时，不能将在对volatile变量访问的语句放在其后面执行，也不能把volatile变量后面的语句放到其前面执行。
3. 指令重排: 在Java内存模型中，允许编译器和处理器对指令进行重排序，但是重排序过程不会影响到单线程程序的执行，却会影响到多线程并发执行的正确性。
4. happens-before原则:
   - 程序次序规则：一个线程内，按照代码顺序，书写在前面的操作先行发生于书写在后面的操作
   - 锁定规则：一个unLock操作先行发生于后面对同一个锁lock操作
   - volatile变量规则：对一个变量的写操作先行发生于后面对这个变量的读操作
   - 传递规则：如果操作A先行发生于操作B，而操作B又先行发生于操作C，则可以得出操作A先行发生于操作C
   - 线程启动规则：Thread对象的start()方法先行发生于此线程的每个一个动作
   - 线程中断规则：对线程interrupt()方法的调用先行发生于被中断线程的代码检测到中断事件的发生
   - 线程终结规则：线程中所有的操作都先行发生于线程的终止检测，我们可以通过Thread.join()方法结束、Thread.isAlive()的返回值手段检测到线程已经终止执行
   - 对象终结规则：一个对象的初始化完成先行发生于他的finalize()方法的开始
