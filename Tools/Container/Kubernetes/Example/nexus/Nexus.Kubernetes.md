## Nexus
1. 安装 Nexus 前提条件
   1. CPU 至少4 核 (/proc/cpuinfo)
   2. 内存 2G 以上
2. Backup (备份)
    1. Database Metadata Backup
    > 1.登录管理账号 -> 2. 创建Task (Admin - Export databases for backup) -> 3. 存放路径(/nexus-data/metadatabackup) -> 4. 设置备份频率
    2. Nexus Blobs Stores Backup: Repository Backup
        1. Nexus3 目录位置: /nexus-data/.../blobs/default
        2. 压缩成 tar.gz 后，解压替换同目录下文件
- 参考: https://www.cnblogs.com/ssgeek/p/12270079.html