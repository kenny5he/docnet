blog: https://www.cnblogs.com/ducklyl/p/9969919.html
blog: https://my.oschina.net/u/3136594/blog/3071868    (linux安装修改glibc)
blog: https://my.oschina.net/u/3136594/blog/3071216    (java native调用c)

http://mirror.hust.edu.cn/gnu/glibc/
首先检查自己的linux有没有java环境
通过java、和javac两个命令看看可以用不

如果没有则检查一下yum当中有哪些JDK可以提供安装
yum search java | grep -i --color jdk

然后选择一个你的版本安装，以jdk8为例

yum install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64

安装gcc?用来编译C程序    yum -y install gcc


tar -zxvf glibc-2.19.tar.gz

修改glibc的源码?
修改pthread_mutex_lock()？ where-->your dir/glibc-2.19/nptl/pthread_mutex_lock.c---pthread_mutex_lock()

p

result：未来任何线程调用pthread_mutex_lock()都会打印msg tid=123456677（tid）



compiler----------------------
cd glibc-2.19
mkdir out
cd out
../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
make
注意看录屏当中的系统时间  15:31   上面的命令已经执行完了
注意看录屏第42分钟上述命令已经执行完了，接下来执行第二条命令
 make install


javac 编译
javah 编译生成头文件

根据c文件生成 library 对应的so文件
gcc -fPIC -I /usr/local/src/jdk1.6.0_45/include -I /usr/local/src/jdk1.6.0_45/include/linux -shared -o libJucThreadNative.so getId.c

将 so 路径加入 LIBRARY库目录
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/apaye/Downloads/concurrent

执行java文件


javah 头文件(按当前编译类的地址计算)

真的在做事情 --------不能停止  api

真正阻塞      -------解阻塞   继续

无限循环   --改变循环条件 继续执行











https://blog.csdn.net/yunlianglinfeng/article/details/53171191