# Arthas 

## 安装
1. 下载jar包，命令启动
```shell script
wget https://alibaba.github.io/arthas/arthas-boot.jar
```
2. 通过Shell脚本安装
```shell script
curl -L https://alibaba.github.io/arthas/install.sh | sh
./as.sh
```
## 作用
1. 某类从哪个 jar 包加载的？为什么会报各种类相关的 Exception？
2. 代码为什么没有执行到？
3. 线上 debug
4. 全局视角来查看系统的运行状况？
5. 监控到JVM的实时运行状态？

## 使用
1. 启动
```shell script
java -jar arthas-boot.jar
```
2. 选择需诊断的进程

3. 查看慢方法
```shell
trace com.microfoolish.xxxx.Controller method
```
4. 查看方法耗时
```shell
tt -t com.microfoolish.xxxx.Controller method
```
5. 查看线程状态
    1. 查看所有线程状态
    ```shell
    thread
    ```
    2. 查看某个线程的状态
    ```shell
    thread [trhead_id]
    ```
    3. 查看阻塞线程
    ```shell
    thread -b
    ```
    4. 查看占用CPU最高的[number]个线程
    ```shell
    thread -n [number]
    ```
7. 关闭
```shell script
shutdown
```

## IDEA 远程诊断
1. 安装插件 Alibaba Cloud Toolki
