blog: https://www.cnblogs.com/Alexr/p/9531211.html
1. 生成 JavaCore 与 Heapdump文件
    WEB应用:
        1): ps -ef | grep java 查询到java应用进程
        2): kill -3 pid > heapdump.phd (注意: 等文件生成后再做一次同样的操作，再产生一组文件)
        3): java -Xmx4g -jar /Users/apaye/workspace/git/microfoolish/worknote/java/javacore\&heapdump/ibmHeapanalyzer.jar(ha456.jar)
    SpringBoot 微服务应用(官方文档: https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
        1): Heapdump文件: curl 'http://localhost:8008/cas/actuator/heapdump' -O

2. JavaCore 日志文件( CPU )(jcaxxx.jar)
    文件生成方式:
        jstack -l -r -pid
        例(jdk1.8): jstack -l 18803 > javacore.txt
    运行分析:(ha456.jar)
        java -Xmx1g -jar /Users/apaye/workspace/git/microfoolish/worknote/java/javacore\&heapdump/jca457.jar
    作用:
        JavaCore文件主要保存的是Java应用各线程在某一时刻的运行的位置，即JVM执行到哪一个类、哪一个方法、哪一个行上。
        它是一个文本文件，打开后可以看到每一个线程的执行栈，以stack   trace的显示。通过对JavaCore文件的分析可以得到应用是否“卡”在某一点上，
        即在某一点运行的时间太长，例如数据库查询，长期得不到响应，最终导致系统崩溃等情况
    状态:
        死锁（Deadlock）【重点关注】：一般指多个线程调用间，进入相互资源占用，导致一直等待无法释放的情况。
        执行中（Runnable）【重点关注】：一般指该线程正在执行状态中，该线程占用了资源，正在处理某个请求，有可能在对某个文件操作，有可能进行数据类型等转换等。
        等待资源（Waiting on condition）【重点关注】：等待资源，如果堆栈信息明确是应用代码，则证明该线程正在等待资源，一般是大量读取某资源、且该资源采用了资源锁的情况下，线程进入等待状态。又或者，正在等待其他线程的执行等。
        等待监控器检查资源（Waiting on monitor）
        暂停（Suspended）
        对象等待中（Object.wait()）
        阻塞（Blocked）【重点关注】：指当前线程执行过程中，所需要的资源长时间等待却一直未能获取到，被容器的线程管理器标识为阻塞状态，可以理解为等待资源超时的线程。这种情况在应用的日志中，一般可以看到 CPU 饥渴，或者某线程已执行了较长时间的信息。
        停止（Parked）
    分析工具:
        IBM Thread and Monitor Dump Analyzer for Java (jca457.jar)


2.Heapdump 日志文件( 内存 )(haxxx.jar)
    文件生成方式:
         jmap -dump:file=path_to_file pid
         例(jdk1.8): jmap -dump:file=/Users/apaye/workspace/git/cas-server/logs/heapdump.phd 18803
    运行分析:(ha456.jar)
         java -Xmx4g -jar /Users/apaye/workspace/git/microfoolish/worknote/java/javacore\&heapdump/ibmHeapanalyzer.jar
    作用:
        HeapDump文件是指定时刻的Java堆栈的快照，是一种镜像文件。Heap Analyzer工具通过分析HeapDump文件，哪些对象占用了太多的堆栈空间，
        来发现导致内存泄露或者可能引起内存泄露的对象
    分析工具:
        IBM Heap Analyzer

3.日志文件
    javacore.***.txt: 关于cpu的，javacore文件是java进程的快照，主要保存的是Java应用各线程在某一时刻的运行的位置，即JVM执行到哪一个类、哪一个方法、哪一行上。也即threaddump文件。
    heapdump.***.phd: 关于memory的，heapdump文件是指定时刻java堆栈的快照，是一个二进制镜像文件，它保存了某一时刻JVM堆中对象的使用情况。
    core.***.dmp: core文件是java宕掉生成的操作系统级别的进程二进制镜像文件。又叫核心转储，当程序运行过程中发生异常，程序异常退出时，由操作系统把程序当前的内存状况存储在一个core文件中。
    Snap.***.trc: snap文件是快速追踪的保留在跟踪缓冲区里的追踪点数据，用来分析本地内存的OOM异常。

4.Garbage Collector (GCCollector.zip)(blog: https://www.ibm.com/developerworks/cn/java/j-lo-optimize-gc/index.html)
