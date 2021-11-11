## Thread Pool(线程池)
1. 线程池是什么？有什么作用？

2. 线程池的种类？

3. 线程间通信
   
4. 线程间传递上下文
    1. 通过 TaskDecorator 方式 (推荐方式)
    2. 
### 多种姿势使用线程池
1. Executors.newFixedThreadPool: 底层为无界队列 ThreadPoolExecutor
2. ExecutorService
    1. Example 
    ```
        1. TaskHandlerExecutorPool 类实现 Executor 接口
        2. TaskHandlerExecutorPool 类中 创建线程池
        /**
         * @param corePoolSize 核心线程数量
         * @param maximumPoolSize 线程创建最大数量
         * @param keepAliveTime 当创建到了线程池最大数量时  多长时间线程没有处理任务，则线程销毁
         * @param unit keepAliveTime 时间单位
         * @param workQueue 此线程池使用什么队列 
         *               LinkedBlockingDeque 无界缓存等待队列，当前执行的线程数量达到corePoolSize的数量时，剩余的元素会在阻塞队列里等待。
         *               ArrayBlockingQueue 有界缓存等待队列，当正在执行的线程数等于corePoolSize时，多余的元素缓存在ArrayBlockingQueue队列中等待有空闲的线程时继续执行，
         *                                  当ArrayBlockingQueue已满时，加入ArrayBlockingQueue失败，会开启新的线程去执行，当线程数已经达到最大的maximumPoolSizes时，再有新的元素尝试加入ArrayBlockingQueue时会执行拒绝策略。
         *               SynchronousQueue 无缓冲等待队列，是一个不存储元素的阻塞队列，会直接将任务交给消费者，必须等队列中的添加元素被消费后才能继续添加新的元素。
         */
        // Runtime.getRuntime().availableProcessors() 通过Hotspot 获取当前虚拟机可调度的最大处理器数量，值不小于1
        ExecutorService executorService = new ThreadPoolExecutor(Runtime.getRuntime().availableProcessors(),
                maxPoolSize, 120L, TimeUnit.SECONDS, new ArrayBlockingQueue<>(queueSize));
        3. 调用处实例化 Executor 接口的类
        TaskHandlerExecutorPool taskHandlerExecutor = new TaskHandlerExecutorPool(50, 1000);
        4. 执行executer方法(注意TaskHandler 必须实现 Runable 接口)
        taskHandlerExecutor.execute(new TaskHandler(task));
   ```
    2. 注意事项
        1. 当线程最大数为0，线程池队列为有界队列时，抛错: 参数校验 corePoolSize不能小于0、maximumPoolSize不能小于等于0
        2. 当线程最大数为0，线程池队列为无界队列时，一直运行，并且CPU 100%(结论: 使用无界队列时，可能会造成CPU 100%)，队列中无线程，一直往队列中传任务
    
3. 通过第三方jar包类创建线程池
    1. CustomizableThreadFactory(Spring)
        ```
            ThreadFactory springThreadFactory = new CustomizableThreadFactory("springThread-pool-");
            ExecutorService executorService = new ThreadPoolExecutor(4, 10, 0L, TimeUnit.MILLISECONDS,
                new LinkedBlockingQueue<Runnable>(10),springThreadFactory);
            // 注意TaskHandler 必须实现 Runable 接口
            executorService.submit(TaskHandler);
        ```
    2. ThreadFactoryBuilder(Guava)
        ```
            ThreadFactory guavaThreadFactory = new ThreadFactoryBuilder().setNameFormat("retryClient-pool-").build();
            ExecutorService exec = new ThreadPoolExecutor(4, 10, 0L, TimeUnit.MILLISECONDS,
                new LinkedBlockingQueue<Runnable>(10),guavaThreadFactory );
            exec.submit(TaskHandler);
        ```
    3. BasicThreadFactory
        ```
            ThreadFactory basicThreadFactory = new BasicThreadFactory.Builder()
		        .namingPattern("BasicThreadFactory-").build();
            ExecutorService executor = new ThreadPoolExecutor(4, 10, 0L, TimeUnit.MILLISECONDS,
                new LinkedBlockingQueue<Runnable>(10),basicThreadFactory );
            executor.submit(TaskHandler);
        ```
