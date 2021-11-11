Socket 是实现TCP协议的一个接口实现，由操作系统实现，以供外部系统调用
Socket 是一个IP+端口的文件，也是一个进程
文件描述符
文件结构体
IO多路复用
    select模型(man 2 select 查看linux select方法的调用参数信息)
        [参考博客](https://blog.csdn.net/weixin_33901641/article/details/93640837)
        PCB(Process Control Block)
            最多包含1024个fd_set文件描述符的表(其中三个为标准输入流(键盘)、标准输出流(显示器)、标准错误)，当打开一个进程时，会占用一个，所以最多打开1021个。
    epoll模型
        
        
        
        
在Java中 Socket是一个实现了TCP的类
在Java中DatagramSocket 是实现了UDP的类
