### Remote Debug
##### Before Jdk 1.5
- 调试参数:
    1. -Xdebug和-Xrunjdwp
        - -Xdebug告诉JVM以调试模式运行应用程序，
        - -Xrunjdwp用于提供调试参数（它也可以在JVM 1.5或1.6中使用）
- 案例:
    ```
    -Xdebug -Xrunjdwp：transport = dt_socket，address = 8000，server = y，suspend = n
    ```
##### After Jdk1.5
- 调试参数:
    -agentlib参数与调试参数一起传递。用于调试的本机库名称是jdwp，因此需要提供-agentlib：jdwp以及调试参数。
- 案例:
    ```
    -agenlib：jdwp = transport = dt_socket，address = 8000，server = y，suspend = n
    ```
##### 参数信息:
- transport(必填): 用于调试器和应用程序之间通信的传输协议实现。Sun JVM提供了两种实现，即套接字传输和共享内存传输。套接字传输的值是“dt_socket”，而共享内存传输的值是“dt_shmem”。
- server(非必填)(y/n): 告知JVM是用作服务器还是作为客户端参考JVM-Debugger通信。如果JVM将充当服务器，那么调试器将自己附加到此JVM，否则如果JVM将充当客户端，则它将自身附加到调试器。
- address(非必填): 指定套接字地址。
- timeout(非必填): JVM的等待时间
- suspend(非必填)(y/n): 告诉JVM暂停调用应用程序，直到调试器和JVM连接在一起。

##### IDE:
- Eclipse:
  >  选择程序-> Debug Configuration —> Remote Java Application -> 配置远程服务器地址 端口信息
