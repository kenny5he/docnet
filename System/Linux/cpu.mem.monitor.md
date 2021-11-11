## Linux 内存、CPU 分析
1. linux下获取占用CPU资源最多的10个进程，可以使用如下命令组合：
```shell
ps aux|head -1;ps aux|grep -v PID|sort -rn -k +3|head
```
2. linux下获取占用内存资源最多的10个进程，可以使用如下命令组合：
```shell
ps aux|head -1;ps aux|grep -v PID|sort -rn -k +4|head
```
3. 