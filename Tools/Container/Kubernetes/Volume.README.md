# Volume(存储卷)
Volume是Pod中能够被多个容器访问的共享目录，Pod里多个容器挂载到一个文件目录下,Kubernetes 中的Volume与Pod的生命周期相同
1. Volume的种类: 
   1. awsElasticBlockStore: 亚马逊公司提供，实现将亚马逊云平台提供的EBS volume挂接到pod上。
   2. azureDisk: 
   3. azureFile:
   4. emptyDir: 在Pod分配到Node时创建，在pod被删除时其上数据会被清空
      1. 特点: 
         1. 临时空间，用于某些应用程序运行时所需的临时目录，且无需永久保留
         2. 长时间任务的中间过程CheckPoint 的临时保存目录
         3. 一个容器需要从另一个容器中获取数据的目录(多容器共享目录)
   5. cephfs
      
   6. configMap
   7. csi
   8. downwardAPI
   9. fc (fibre channel)
   10. flocker: 使用Flocker管理存储卷
   11. gcePersistentDisk: 使用Google 公有云提供的永久磁盘(Persistent Disk)存放Volume数据，Pod被删除是，PD被卸载，不会删除
       1. 使用条件
          1. Node 需要是 GCE 虚拟机
          2. 虚拟机与PD存在相同的 GCE项目和 Zone中
       2. 创建PD
          ```shell
            gcloud compute disks create -size=500G --zone=us-centrall-a app-disk
          ```
       3. 配置使用:
          ```
            volumes: 
            - name: app-volume
              gcePersistentDisk:
                pdName: app-disk
                fsType: ext4
          ```
   12. glusterfs: 使用 Google开源 GlusterFS网络文件系统的目录挂载到Pod中
   13. hostPath: 在Pod上挂载宿主机上的文件或目录
       1. 特点: 
          1. 容器应用程序生成的日志文件需要永久保存时，可使用宿主机的高速文件系统进行存储
          2. 需要访问宿主机上 Docker 引擎内部数据结构的容器应用时，通过定义hostPath为宿主机 /var/lib/docker目录，使容器内部应用可直接访问 Docker 文件系统
       2. 注意点:
          1. 在不同的Node上具有相同配置的Pod可能会因宿主机上的目录和文件不同而导致对Volume上目录和文件的访问结果不一致
          2. 如果使用资源配额管理，则Kubernetes无法将hostPath在宿主机上使用的资源纳入管理。
   14. iscsi: 使用iSCSI 存储设备上的目录挂载到Pod中
   15. local
   16. nfs: 使用NFS网络文件系统提供共享目录存储数据时。
       1. 配置使用:
         ```
         volumes:
           - name: nfs
             nfs: 
               server: nfs-server.alphafashion.cn
               path: "/"
         ```
   17. persistentVolumeClaim
   18. projected
   19. portworxVolume
   20. quobyte
   21. rbd
   22. scaleIO
   23. secret
   24. storageos
   25. vsphereVolume