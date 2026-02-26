### Kubernetes 报错解决
1. 错误：ERROR FileContent--proc-sys-net-bridge-bridge-nf-call-iptables 设置错误导致kubeadm安装k8s失败
    1. 错误原因: 少执行步骤
    ```
    modprobe br_netfilter
    echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
    echo 1 > /proc/sys/net/ipv4/ip_forward
    ```
    2. 问题解决: 执行步骤
2. 错误: Get http://localhost:10248/healthz: dial tcp 127.0.0.1:10248: connect: connection refused.
    1. 错误原因: 缺失文件/文件配置错误: /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
    2. 解决: (参考博客: https://blog.csdn.net/qq_34988341/article/details/117635805)
    ```
    # Note: This dropin only works with kubeadm and kubelet v1.11+
    [Service]
    Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
    Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
    # This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
    EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
    # This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
    # the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
    EnvironmentFile=-/etc/default/kubelet
    ExecStart=
    ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
    
    # 添加配置
    Environment="KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true --fail-swap-on=false"
    ```
    3. 重启生效
    ```shell
    systemctl daemon reload
    # systemctl daemon reload 不生效则可尝试以下命令
    systemctl daemon-reload
    systemctl restart kubelet.service
    
    # 查看 k8s service 服务状态
    systemctl status kubelet.service
    ```
3. 错误: failed to run Kubelet: running with swap on is not supported, please disable swap! or set --fail-swap-on flag to false. /proc/swaps contained
    1. 查看日志
    ```
    1. 查看 kubelet.service
    systemctl status kubelet.service -l
    
    # 日志信息
    kubelet.service - kubelet: The Kubernetes Node Agent
    Loaded: loaded (/usr/lib/systemd/system/kubelet.service; enabled; vendor preset: disabled)
    Drop-In: /usr/lib/systemd/system/kubelet.service.d
    └─10-kubeadm.conf
    Active: active (running) since Sat 2021-12-25 05:09:37 CST; 716ms ago
    Docs: https://kubernetes.io/docs/
    Main PID: 8992 (kubelet)
    Tasks: 9
    Memory: 17.7M
    CGroup: /system.slice/kubelet.service
    └─8992 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime=remote --container-runtime-endpoint=/run/containerd/containerd.sock --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.6
   
    Dec 25 05:09:37 it105.alphafashion.cn systemd[1]: Started kubelet: The Kubernetes Node Agent.
    Dec 25 05:09:37 it105.alphafashion.cn kubelet[8992]: I1225 05:09:37.578802    8992 server.go:198] "Warning: For remote container runtime, --pod-infra-container-image is ignored in kubelet, which should be set in that remote runtime instead"
    Dec 25 05:09:37 it105.alphafashion.cn kubelet[8992]: I1225 05:09:37.588156    8992 server.go:446] "Kubelet version" kubeletVersion="v1.23.1"
    Dec 25 05:09:37 it105.alphafashion.cn kubelet[8992]: I1225 05:09:37.588322    8992 server.go:874] "Client rotation is on, will bootstrap in background"
    Dec 25 05:09:37 it105.alphafashion.cn kubelet[8992]: I1225 05:09:37.589558    8992 certificate_store.go:130] Loading cert/key pair from "/var/lib/kubelet/pki/kubelet-client-current.pem".
    Dec 25 05:09:37 it105.alphafashion.cn kubelet[8992]: I1225 05:09:37.590175    8992 dynamic_cafile_content.go:156] "Starting controller" name="client-ca-bundle::/etc/kubernetes/pki/ca.crt"
    
    2. 查看 kubelet 状态
    systemctl status kubelet
    ● kubelet.service - kubelet: The Kubernetes Node Agent
    Loaded: loaded (/usr/lib/systemd/system/kubelet.service; enabled; vendor preset: disabled)
    Drop-In: /usr/lib/systemd/system/kubelet.service.d
    └─10-kubeadm.conf
    Active: activating (auto-restart) (Result: exit-code) since Sat 2021-12-25 05:07:10 CST; 3s ago
    Docs: https://kubernetes.io/docs/
    Process: 8864 ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS (code=exited, status=1/FAILURE)
    Main PID: 8864 (code=exited, status=1/FAILURE)
   
    Dec 25 05:07:10 it105.alphafashion.cn systemd[1]: Unit kubelet.service entere...
    Dec 25 05:07:10 it105.alphafashion.cn systemd[1]: kubelet.service failed.
    Hint: Some lines were ellipsized, use -l to show in full.
    3. 查看systemd 日志信息 
    journalctl -xefu kubelet
    Jan 13 03:15:40 it105.alphafashion.cn systemd[1]: kubelet.service holdoff time over, scheduling restart.
    Jan 13 03:15:40 it105.alphafashion.cn systemd[1]: Stopped kubelet: The Kubernetes Node Agent.
    -- Subject: Unit kubelet.service has finished shutting down
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    --
    -- Unit kubelet.service has finished shutting down.
    Jan 13 03:15:40 it105.alphafashion.cn systemd[1]: Started kubelet: The Kubernetes Node Agent.
    -- Subject: Unit kubelet.service has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    --
    -- Unit kubelet.service has finished starting up.
    --
    -- The start-up result is done.
    Jan 13 03:15:40 it105.alphafashion.cn kubelet[3163]: I0113 03:15:40.243604    3163 server.go:198] "Warning: For remote container runtime, --pod-infra-container-image is ignored in kubelet, which should be set in that remote runtime instead"
    Jan 13 03:15:40 it105.alphafashion.cn kubelet[3163]: I0113 03:15:40.249618    3163 server.go:446] "Kubelet version" kubeletVersion="v1.23.1"
    Jan 13 03:15:40 it105.alphafashion.cn kubelet[3163]: I0113 03:15:40.249811    3163 server.go:874] "Client rotation is on, will bootstrap in background"
    Jan 13 03:15:40 it105.alphafashion.cn kubelet[3163]: I0113 03:15:40.251281    3163 certificate_store.go:130] Loading cert/key pair from "/var/lib/kubelet/pki/kubelet-client-current.pem".
    Jan 13 03:15:40 it105.alphafashion.cn kubelet[3163]: I0113 03:15:40.251981    3163 container_manager_linux.go:980] "CPUAccounting not enabled for process" pid=3163
    Jan 13 03:15:40 it105.alphafashion.cn kubelet[3163]: I0113 03:15:40.251993    3163 container_manager_linux.go:983] "MemoryAccounting not enabled for process" pid=3163
    Jan 13 03:15:40 it105.alphafashion.cn kubelet[3163]: I0113 03:15:40.252048    3163 dynamic_cafile_content.go:156] "Starting controller" name="client-ca-bundle::/etc/kubernetes/pki/ca.crt"
    Jan 13 03:15:45 it105.alphafashion.cn kubelet[3163]: I0113 03:15:45.264150    3163 server.go:693] "--cgroups-per-qos enabled, but --cgroup-root was not specified.  defaulting to /"
    Jan 13 03:15:45 it105.alphafashion.cn kubelet[3163]: E0113 03:15:45.264271    3163 server.go:302] "Failed to run kubelet" err="failed to run Kubelet: running with swap on is not supported, please disable swap! or set --fail-swap-on flag to false. /proc/swaps contained: [Filename\t\t\t\tType\t\tSize\tUsed\tPriority /dev/dm-1                               partition\t16449532\t0\t-2]"
    Jan 13 03:15:45 it105.alphafashion.cn systemd[1]: kubelet.service: main process exited, code=exited, status=1/FAILURE
    Jan 13 03:15:45 it105.alphafashion.cn systemd[1]: Unit kubelet.service entered failed state.
    Jan 13 03:15:45 it105.alphafashion.cn systemd[1]: kubelet.service failed.
    ```
    2. 问题原因
    ```
    Swap 交换区问题，关闭交换区
    1. 查看交换区是否关闭
    cat /proc/swaps
    2. 关闭交换区
    sudo swapoff -a
    3. 备份交换区配置
    cp -p /etc/fstab /etc/fstab.bak$(date '+%Y%m%d%H%M%S')
    4. 注释交换区配置
    sed -i "s/\/dev\/mapper\/centos-swap/\#\/dev\/mapper\/centos-swap/g" /etc/fstab
    5. 重新挂载
    mount -a
    6. 查看生效情况
    free -m
    cat /proc/swaps
    ```
    - 参考: https://blog.csdn.net/nklinsirui/article/details/80855415
4. addrConn.createTransport failed to connect to {/run/containerd/containerd.sock /run/containerd/containerd.sock
    1. 报错信息
    ```
    Jan 13 03:25:34 it105.alphafashion.cn systemd[1]: kubelet.service holdoff time over, scheduling restart.
    Jan 13 03:25:34 it105.alphafashion.cn systemd[1]: Stopped kubelet: The Kubernetes Node Agent.
    -- Subject: Unit kubelet.service has finished shutting down
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    --
    -- Unit kubelet.service has finished shutting down.
    Jan 13 03:25:34 it105.alphafashion.cn systemd[1]: Started kubelet: The Kubernetes Node Agent.
    -- Subject: Unit kubelet.service has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    --
    -- Unit kubelet.service has finished starting up.
    --
    -- The start-up result is done.
    Jan 13 03:25:34 it105.alphafashion.cn kubelet[3674]: I0113 03:25:34.989325    3674 server.go:198] "Warning: For remote container runtime, --pod-infra-container-image is ignored in kubelet, which should be set in that remote runtime instead"
    Jan 13 03:25:34 it105.alphafashion.cn kubelet[3674]: I0113 03:25:34.994012    3674 server.go:446] "Kubelet version" kubeletVersion="v1.23.1"
    Jan 13 03:25:34 it105.alphafashion.cn kubelet[3674]: I0113 03:25:34.994163    3674 server.go:874] "Client rotation is on, will bootstrap in background"
    Jan 13 03:25:34 it105.alphafashion.cn kubelet[3674]: I0113 03:25:34.995317    3674 certificate_store.go:130] Loading cert/key pair from "/var/lib/kubelet/pki/kubelet-client-current.pem".
    Jan 13 03:25:34 it105.alphafashion.cn kubelet[3674]: I0113 03:25:34.995901    3674 container_manager_linux.go:980] "CPUAccounting not enabled for process" pid=3674
    Jan 13 03:25:34 it105.alphafashion.cn kubelet[3674]: I0113 03:25:34.995910    3674 container_manager_linux.go:983] "MemoryAccounting not enabled for process" pid=3674
    Jan 13 03:25:34 it105.alphafashion.cn kubelet[3674]: I0113 03:25:34.995910    3674 dynamic_cafile_content.go:156] "Starting controller" name="client-ca-bundle::/etc/kubernetes/pki/ca.crt"
    Jan 13 03:25:40 it105.alphafashion.cn kubelet[3674]: I0113 03:25:40.007759    3674 server.go:693] "--cgroups-per-qos enabled, but --cgroup-root was not specified.  defaulting to /"
    Jan 13 03:25:40 it105.alphafashion.cn kubelet[3674]: I0113 03:25:40.007948    3674 container_manager_linux.go:281] "Container manager verified user specified cgroup-root exists" cgroupRoot=[]
    Jan 13 03:25:40 it105.alphafashion.cn kubelet[3674]: I0113 03:25:40.008017    3674 container_manager_linux.go:286] "Creating Container Manager object based on Node Config" nodeConfig={RuntimeCgroupsName: SystemCgroupsName: KubeletCgroupsName: ContainerRuntime:remote CgroupsPerQOS:true CgroupRoot:/ CgroupDriver:systemd KubeletRootDir:/var/lib/kubelet ProtectKernelDefaults:false NodeAllocatableConfig:{KubeReservedCgroupName: SystemReservedCgroupName: ReservedSystemCPUs: EnforceNodeAllocatable:map[pods:{}] KubeReserved:map[] SystemReserved:map[] HardEvictionThresholds:[{Signal:memory.available Operator:LessThan Value:{Quantity:100Mi Percentage:0} GracePeriod:0s MinReclaim:<nil>} {Signal:nodefs.available Operator:LessThan Value:{Quantity:<nil> Percentage:0.1} GracePeriod:0s MinReclaim:<nil>} {Signal:nodefs.inodesFree Operator:LessThan Value:{Quantity:<nil> Percentage:0.05} GracePeriod:0s MinReclaim:<nil>} {Signal:imagefs.available Operator:LessThan Value:{Quantity:<nil> Percentage:0.15} GracePeriod:0s MinReclaim:<nil>}]} QOSReserved:map[] ExperimentalCPUManagerPolicy:none ExperimentalCPUManagerPolicyOptions:map[] ExperimentalTopologyManagerScope:container ExperimentalCPUManagerReconcilePeriod:10s ExperimentalMemoryManagerPolicy:None ExperimentalMemoryManagerReservedMemory:[] ExperimentalPodPidsLimit:-1 EnforceCPULimits:true CPUCFSQuotaPeriod:100ms ExperimentalTopologyManagerPolicy:none}
    Jan 13 03:25:40 it105.alphafashion.cn kubelet[3674]: I0113 03:25:40.008048    3674 topology_manager.go:133] "Creating topology manager with policy per scope" topologyPolicyName="none" topologyScopeName="container"
    Jan 13 03:25:40 it105.alphafashion.cn kubelet[3674]: I0113 03:25:40.008056    3674 container_manager_linux.go:321] "Creating device plugin manager" devicePluginEnabled=true
    Jan 13 03:25:40 it105.alphafashion.cn kubelet[3674]: I0113 03:25:40.008091    3674 state_mem.go:36] "Initialized new in-memory state store"
    Jan 13 03:25:40 it105.alphafashion.cn kubelet[3674]: I0113 03:25:40.008141    3674 util_unix.go:104] "Using this format as endpoint is deprecated, please consider using full url format." deprecatedFormat="/run/containerd/containerd.sock" fullURLFormat="unix:///run/containerd/containerd.sock"
    Jan 13 03:25:40 it105.alphafashion.cn kubelet[3674]: W0113 03:25:40.008362    3674 clientconn.go:1331] [core] grpc: addrConn.createTransport failed to connect to {/run/containerd/containerd.sock /run/containerd/containerd.sock <nil> 0 <nil>}. Err: connection error: desc = "transport: Error while dialing dial unix /run/containerd/containerd.sock: connect: no such file or directory". Reconnecting...
    Jan 13 03:25:40 it105.alphafashion.cn kubelet[3674]: E0113 03:25:40.008430    3674 server.go:302] "Failed to run kubelet" err="failed to run Kubelet: unable to determine runtime API version: rpc error: code = Unavailable desc = connection error: desc = \"transport: Error while dialing dial unix /run/containerd/containerd.sock: connect: no such file or directory\""
    Jan 13 03:25:40 it105.alphafashion.cn systemd[1]: kubelet.service: main process exited, code=exited, status=1/FAILURE
    Jan 13 03:25:40 it105.alphafashion.cn systemd[1]: Unit kubelet.service entered failed state.
    Jan 13 03:25:40 it105.alphafashion.cn systemd[1]: kubelet.service failed.
    ```
    2. 错误原因: 未启动基础容器 containerd
    ```
    systemctl daemon-reload
    systemctl status containerd
    systemctl restart containerd
    ```
5. cni plugin not initialized
    1. 错误信息
    ```
    Jan 13 03:34:05 it105.alphafashion.cn kubelet[4046]: E0113 03:34:05.608994    4046 dns.go:157] "Nameserver limits exceeded" err="Nameserver limits were exceeded, some nameservers have been omitted, the applied nameserver line is: 192.168.1.84 183.2.185.197 8.8.4.4"
    Jan 13 03:34:05 it105.alphafashion.cn kubelet[4046]: E0113 03:34:05.797017    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:34:10 it105.alphafashion.cn kubelet[4046]: E0113 03:34:10.799058    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:34:15 it105.alphafashion.cn kubelet[4046]: E0113 03:34:15.800390    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:34:20 it105.alphafashion.cn kubelet[4046]: E0113 03:34:20.802326    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:34:25 it105.alphafashion.cn kubelet[4046]: E0113 03:34:25.803438    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:34:30 it105.alphafashion.cn kubelet[4046]: E0113 03:34:30.804406    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:34:35 it105.alphafashion.cn kubelet[4046]: E0113 03:34:35.805883    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:34:40 it105.alphafashion.cn kubelet[4046]: E0113 03:34:40.807811    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:34:45 it105.alphafashion.cn kubelet[4046]: E0113 03:34:45.808529    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:34:50 it105.alphafashion.cn kubelet[4046]: E0113 03:34:50.609538    4046 dns.go:157] "Nameserver limits exceeded" err="Nameserver limits were exceeded, some nameservers have been omitted, the applied nameserver line is: 192.168.1.84 183.2.185.197 8.8.4.4"
    Jan 13 03:34:50 it105.alphafashion.cn kubelet[4046]: E0113 03:34:50.809772    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:34:55 it105.alphafashion.cn kubelet[4046]: E0113 03:34:55.811332    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:00 it105.alphafashion.cn kubelet[4046]: E0113 03:35:00.813122    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:01 it105.alphafashion.cn kubelet[4046]: E0113 03:35:01.609723    4046 dns.go:157] "Nameserver limits exceeded" err="Nameserver limits were exceeded, some nameservers have been omitted, the applied nameserver line is: 192.168.1.84 183.2.185.197 8.8.4.4"
    Jan 13 03:35:05 it105.alphafashion.cn kubelet[4046]: E0113 03:35:05.814571    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:10 it105.alphafashion.cn kubelet[4046]: E0113 03:35:10.816210    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:13 it105.alphafashion.cn kubelet[4046]: E0113 03:35:13.609381    4046 dns.go:157] "Nameserver limits exceeded" err="Nameserver limits were exceeded, some nameservers have been omitted, the applied nameserver line is: 192.168.1.84 183.2.185.197 8.8.4.4"
    Jan 13 03:35:15 it105.alphafashion.cn kubelet[4046]: E0113 03:35:15.817663    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:17 it105.alphafashion.cn kubelet[4046]: E0113 03:35:17.608671    4046 dns.go:157] "Nameserver limits exceeded" err="Nameserver limits were exceeded, some nameservers have been omitted, the applied nameserver line is: 192.168.1.84 183.2.185.197 8.8.4.4"
    Jan 13 03:35:20 it105.alphafashion.cn kubelet[4046]: E0113 03:35:20.819241    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:25 it105.alphafashion.cn kubelet[4046]: E0113 03:35:25.820959    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:30 it105.alphafashion.cn kubelet[4046]: E0113 03:35:30.821915    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:35 it105.alphafashion.cn kubelet[4046]: E0113 03:35:35.823771    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:40 it105.alphafashion.cn kubelet[4046]: E0113 03:35:40.825700    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:45 it105.alphafashion.cn kubelet[4046]: E0113 03:35:45.826385    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    Jan 13 03:35:50 it105.alphafashion.cn kubelet[4046]: E0113 03:35:50.827969    4046 kubelet.go:2347] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized"
    ```
    2. 解决原因: 
    ```
    1. it105.alphafashion.cn 为 hostname，设置it105的dns 
    127.0.0.1    it105.alphafashion.cn
    
    2. 网络插件: flannel
      1. 下载好flannel的组件镜像
      crictl pull quay.io/coreos/flannel:v0.14.0
      2. 获取 flannl 组件 k8s配置
      curl -O https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
      3. 部署flannl插件
      kubectl apply -f kube-flannel.yml
    3. 网络插件: 
    ```
    - 参考: https://blog.csdn.net/weixin_43847124/article/details/121502695
6. 访问https://192.168.1.5:6443/，报错: forbidden: User \"system:anonymous\" cannot get path \"/\""
    1. 报错信息:
    ```
    {
        "kind": "Status",
        "apiVersion": "v1",
        "metadata": {},
        "status": "Failure",
        "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
        "reason": "Forbidden",
        "details": {},
        "code": 403
    }
    ```
    2. 问题原因: K8s安全策略
    ```
    1. 允许匿名访问
    kubectl create clusterrolebinding test:anonymous --clusterrole=cluster-admin --user=system:anonymous
    2. 创建用户，授权访问
    
    ```
   -参考: https://blog.csdn.net/happyzwh/article/details/86325087
7. DNS Unknow host
    1. 报错信息:
    ```
    1. 查看日志: 
    kubectl cluster-info dump
    [ERROR] plugin/errors: 2 6759933941041887570.8387443695236110557. HINFO: read udp 192.168.0.2:41149->8.8.8.8:53: i/o timeout
    [ERROR] plugin/errors: 2 6759933941041887570.8387443695236110557. HINFO: read udp 192.168.0.2:51091->8.8.8.8:53: i/o timeout
    [ERROR] plugin/errors: 2 6759933941041887570.8387443695236110557. HINFO: read udp 192.168.0.2:37450->114.114.114.114:53: i/o timeout
    [ERROR] plugin/errors: 2 6759933941041887570.8387443695236110557. HINFO: read udp 192.168.0.2:58228->114.114.114.114:53: i/o timeout
    [ERROR] plugin/errors: 2 6759933941041887570.8387443695236110557. HINFO: read udp 192.168.0.2:39803->8.8.8.8:53: i/o timeout
    [ERROR] plugin/errors: 2 6759933941041887570.8387443695236110557. HINFO: read udp 192.168.0.2:35718->114.114.114.114:53: i/o timeout
    [ERROR] plugin/errors: 2 6759933941041887570.8387443695236110557. HINFO: read udp 192.168.0.2:56899->114.114.114.114:53: i/o timeout
    [ERROR] plugin/errors: 2 6759933941041887570.8387443695236110557. HINFO: read udp 192.168.0.2:58247->114.114.114.114:53: i/o timeout
    [ERROR] plugin/errors: 2 6759933941041887570.8387443695236110557. HINFO: read udp 192.168.0.2:60365->8.8.8.8:53: i/o timeout
    ```
    2. 问题原因: Vagrant 多网卡环境下 flannel 网络插件导致 DNS 无法解析
    ```
    1. 修改 kube-flannel.yml文件，- --kube-subnet-mgr 后面加一行参数：- --iface=eth1
    ```
    -  参考: https://blog.csdn.net/qianghaohao/article/details/98875005
8. User "system:kube-scheduler" cannot list resource "configmaps" in API group "" in the namespace "kube-system"
    1. 报错信息
    ```
    E0117 12:19:39.197904       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.PersistentVolumeClaim: failed to list *v1.PersistentVolumeClaim: persistentvolumeclaims is forbidden: User "system:kube-scheduler" cannot list resource "persistentvolumeclaims" in API group "" at the cluster scope
    W0117 12:19:39.197941       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.CSINode: csinodes.storage.k8s.io is forbidden: User "system:kube-scheduler" cannot list resource "csinodes" in API group "storage.k8s.io" at the cluster scope
    W0117 12:19:39.197959       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.Pod: pods is forbidden: User "system:kube-scheduler" cannot list resource "pods" in API group "" at the cluster scope
    E0117 12:19:39.197961       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.CSINode: failed to list *v1.CSINode: csinodes.storage.k8s.io is forbidden: User "system:kube-scheduler" cannot list resource "csinodes" in API group "storage.k8s.io" at the cluster scope
    E0117 12:19:39.197966       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.Pod: failed to list *v1.Pod: pods is forbidden: User "system:kube-scheduler" cannot list resource "pods" in API group "" at the cluster scope
    W0117 12:19:39.199247       1 reflector.go:324] k8s.io/apiserver/pkg/server/dynamiccertificates/configmap_cafile_content.go:205: failed to list *v1.ConfigMap: configmaps "extension-apiserver-authentication" is forbidden: User "system:kube-scheduler" cannot list resource "configmaps" in API group "" in the namespace "kube-system"
    E0117 12:19:39.199263       1 reflector.go:138] k8s.io/apiserver/pkg/server/dynamiccertificates/configmap_cafile_content.go:205: Failed to watch *v1.ConfigMap: failed to list *v1.ConfigMap: configmaps "extension-apiserver-authentication" is forbidden: User "system:kube-scheduler" cannot list resource "configmaps" in API group "" in the namespace "kube-system"
    W0117 12:19:39.199382       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.Service: services is forbidden: User "system:kube-scheduler" cannot list resource "services" in API group "" at the cluster scope
    E0117 12:19:39.199398       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.Service: failed to list *v1.Service: services is forbidden: User "system:kube-scheduler" cannot list resource "services" in API group "" at the cluster scope
    W0117 12:19:39.199431       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.PodDisruptionBudget: poddisruptionbudgets.policy is forbidden: User "system:kube-scheduler" cannot list resource "poddisruptionbudgets" in API group "policy" at the cluster scope
    E0117 12:19:39.199461       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.PodDisruptionBudget: failed to list *v1.PodDisruptionBudget: poddisruptionbudgets.policy is forbidden: User "system:kube-scheduler" cannot list resource "poddisruptionbudgets" in API group "policy" at the cluster scope
    W0117 12:19:39.199553       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.ReplicaSet: replicasets.apps is forbidden: User "system:kube-scheduler" cannot list resource "replicasets" in API group "apps" at the cluster scope
    E0117 12:19:39.199570       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.ReplicaSet: failed to list *v1.ReplicaSet: replicasets.apps is forbidden: User "system:kube-scheduler" cannot list resource "replicasets" in API group "apps" at the cluster scope
    W0117 12:19:39.199649       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.Node: nodes is forbidden: User "system:kube-scheduler" cannot list resource "nodes" in API group "" at the cluster scope
    E0117 12:19:39.199659       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.Node: failed to list *v1.Node: nodes is forbidden: User "system:kube-scheduler" cannot list resource "nodes" in API group "" at the cluster scope
    W0117 12:19:39.199679       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.ReplicationController: replicationcontrollers is forbidden: User "system:kube-scheduler" cannot list resource "replicationcontrollers" in API group "" at the cluster scope
    E0117 12:19:39.199689       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.ReplicationController: failed to list *v1.ReplicationController: replicationcontrollers is forbidden: User "system:kube-scheduler" cannot list resource "replicationcontrollers" in API group "" at the cluster scope
    W0117 12:19:39.199711       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.StatefulSet: statefulsets.apps is forbidden: User "system:kube-scheduler" cannot list resource "statefulsets" in API group "apps" at the cluster scope
    E0117 12:19:39.199717       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.StatefulSet: failed to list *v1.StatefulSet: statefulsets.apps is forbidden: User "system:kube-scheduler" cannot list resource "statefulsets" in API group "apps" at the cluster scope
    W0117 12:19:39.199740       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.Namespace: namespaces is forbidden: User "system:kube-scheduler" cannot list resource "namespaces" in API group "" at the cluster scope
    E0117 12:19:39.199749       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.Namespace: failed to list *v1.Namespace: namespaces is forbidden: User "system:kube-scheduler" cannot list resource "namespaces" in API group "" at the cluster scope
    W0117 12:19:39.199850       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.CSIDriver: csidrivers.storage.k8s.io is forbidden: User "system:kube-scheduler" cannot list resource "csidrivers" in API group "storage.k8s.io" at the cluster scope
    E0117 12:19:39.199861       1 reflector.go:138] k8s.io/client-go/informers/factory.go:134: Failed to watch *v1.CSIDriver: failed to list *v1.CSIDriver: csidrivers.storage.k8s.io is forbidden: User "system:kube-scheduler" cannot list resource "csidrivers" in API group "storage.k8s.io" at the cluster scope
    W0117 12:19:40.030697       1 reflector.go:324] k8s.io/client-go/informers/factory.go:134: failed to list *v1.ReplicaSet: replicasets.apps is forbidden: User "system:kube-scheduler" cannot list resource "replicasets" in API group "apps" at the cluster scope
    ```
    2. 问题原因: 
    ```
    ```
9. node节点运行 kubectl get nodes, 输出信息： The connection to the server localhost:8080 was refused - did you specify the right host or port?
    1. 报错信息：
    ```
    The connection to the server localhost:8080 was refused - did you specify the right host or port?
    ```
    2. 解决办法:
    ```
    # 1. 将 master 中/etc/kubernetes目录中的admin.conf文件 拷贝至 node中同目录
    # 2. 设置环境变量
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
    # 使环境变量生效
    source ~/.bash_profile 
    ```
- 参考: https://www.cnblogs.com/taoweizhong/p/11545953.html
- 官方: https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/
- 腾讯云: https://cloud.tencent.com/document/product/457/42946