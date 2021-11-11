ResourceManager(RM)
	ResourceManager负责集群资源的统一管理和调度，承担了 JobTracker 的角色，整个集群只有“一个”，总的来说，
	RM的作用：　
		1.处理客户端请求
		2.启动或监控ApplicationMaster
		3.监控NodeManager
		4.资源的分配与调度

NodeManager(NM)
	NodeManager管理YARN集群中的每个节点。NodeManager 提供针对集群中每个节点的服务，从监督对一个容器的终生管理到监视资源和跟踪节点健康。
	MRv1 通过slot管理 Map 和 Reduce 任务的执行，而 NodeManager 管理抽象容器，这些容器代表着可供一个特定应用程序使用的针对每个节点的资源。
	NM的下作用。
		1.管理单个节点上的资源
		2.处理来自ResourceManager的命令
		3.处理来自ApplicationMaster的命令
		
ApplicationMaster(AM)
	每个应用有一个，负责应用程序的管理 。ApplicationMaster 负责协调来自 ResourceManager 的资源，并通过 NodeManager 监视容器的执行和资源使用（CPU、内存等的资源分配）。
	请注意，尽管目前的资源更加传统（CPU 核心、内存），但未来会支持新资源类型（比如图形处理单元或专用处理设备）。
	AM的作用：
		1.负责数据的切分
		2.为应用程序申请资源并分配给内部的任务
		3.任务的监控与容错
		
Container
	Container 是 YARN 中的资源抽象，它封装了某个节点上的多维度资源，如内存、CPU、磁盘、网络等，当AM向RM申请资源时，RM为AM返回的资源便是用Container表示的。
	YARN会为每个任务分配一个Container，且该任务只能使用该Container中描述的资源。
	Container的作用：
		对任务运行环境进行抽象，封装CPU、内存等多维度的资源以及环境变量、启动命令等任务运行相关的信息