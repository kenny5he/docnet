### 线程并发
1. 并发与并行的区别:
	- 并发：不同代码块交替执行的性能
	- 并行：不同代码块同时执行的性能

### Multi Thread(多线程)
1. 实现多线程的方式:
    1. 继承Thread类
    2. 实现Runnable接口，重写run方法
        - 注意:实现Runnable只是创建线程任务，并非创建一个新的线程
    3. 实现Callable接口，重写call方法，创建一个Future的FutureTask实例，构造方法传参将Callable的实例对象传入，线程target为ft
       - 注意:该方式也是创建线程任务，并非真正的创建线程
2. 线程方法:
    1. 常用方法:
        - currentThread: 返回代码段正在被哪个线程调用
        - isAlive: 判断线程是否处于活动状态,线程已启动且尚未终止，
        - getState: 获取线程状态
        - sleep: 让当前正在执行的线程 休眠，暂停执行
        - getId: 取得线程唯一标识
    2. 停止线程方法:
        - 退出标记: 线程正常退出，run方法运行完成后线程终止
        - stop: 方法不安全，不建议使用，
        - interrupt: 调用interrupt()方法仅仅是在当前线程打了一个停止标记，不是真的停止线程
    3. 判断线程是否停止状态:
        - interrupted: 测试当前线程是否已经中断，(测试当前线程是否已经是中断状态，执行后具有将状态标志置为false的功能)
        - isInterrupted: 测试线程是否已经中断，(测试线程Thread对象是否已经是中断状态，但不清除状态标志)
    4. 线程优先级
        - getPriority: 获取线程优先级
        - setPriority: 设置线程优先级, 默认值为 5, 最大值为10
3. 线程状态:
   ![Java 线程状态](/Users/apaye/workspace/git/worknotes/docnet/Services/Java/Thread/imgs/Java.Thread.State.png)
	1. 线程状态 (Thread.State 枚举类)
        1. NEW (新建)
        2. RUNNABLE (RUNNABLE: 运行、RUNNING: 运行中 、READY: 就绪)
        3. BLOCKED (阻塞)
        4. WAITING (无限等待)
        5. TIMED WAITING (计时等待)
        6. TERMINATED (终止)
    
### 线程安全处理	

### 线程问题定位


- 知乎: https://zhuanlan.zhihu.com/p/429951570