blog: https://www.cnblogs.com/ducklyl/p/9969919.html
blog: https://my.oschina.net/u/3136594/blog/3071868    (linux��װ�޸�glibc)
blog: https://my.oschina.net/u/3136594/blog/3071216    (java native����c)

http://mirror.hust.edu.cn/gnu/glibc/
���ȼ���Լ���linux��û��java����
ͨ��java����javac��������������ò�

���û������һ��yum��������ЩJDK�����ṩ��װ
yum search java | grep -i --color jdk

Ȼ��ѡ��һ����İ汾��װ����jdk8Ϊ��

yum install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64

��װgcc?��������C����    yum -y install gcc


tar -zxvf glibc-2.19.tar.gz

�޸�glibc��Դ��?
�޸�pthread_mutex_lock()�� where-->your dir/glibc-2.19/nptl/pthread_mutex_lock.c---pthread_mutex_lock()

p

result��δ���κ��̵߳���pthread_mutex_lock()�����ӡmsg tid=123456677��tid��



compiler----------------------
cd glibc-2.19
mkdir out
cd out
../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
make
ע�⿴¼�����е�ϵͳʱ��  15:31   ����������Ѿ�ִ������
ע�⿴¼����42�������������Ѿ�ִ�����ˣ�������ִ�еڶ�������
 make install


javac ����
javah ��������ͷ�ļ�

����c�ļ����� library ��Ӧ��so�ļ�
gcc -fPIC -I /usr/local/src/jdk1.6.0_45/include -I /usr/local/src/jdk1.6.0_45/include/linux -shared -o libJucThreadNative.so getId.c

�� so ·������ LIBRARY��Ŀ¼
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/apaye/Downloads/concurrent

ִ��java�ļ�


javah ͷ�ļ�(����ǰ������ĵ�ַ����)

����������� --------����ֹͣ  api

��������      -------������   ����

����ѭ��   --�ı�ѭ������ ����ִ��











https://blog.csdn.net/yunlianglinfeng/article/details/53171191