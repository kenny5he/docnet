# Unity 生命周期
1. 基于继承类：MonoBehaviour
## [生命周期函数](https://docs.unity.cn/cn/2020.1/Manual/ExecutionOrder.html)
![生命周期](asset/monobehaviour_flowchart.svg)

### Reset()
1. 调用情况：只能在程序不运行时调用。
2. 调用时间：当脚本第一次挂载到对象身上，或使用Reset命令调用
3. 调用次数：只调用一次，
4. 作用：初始化脚本的各个属性

### Awake()
1. 调用情况：在调用场景时
    1. GameObject从未激活状态变为激活状态
    2. 在初始化使用Instantiate创建GameObject之后
2. 调用时间：在脚本的生存周期之内
3. 调用次数：仅调用一次
4. Awake代替构造函数来进行初始化

### OnEnable()
1. 调用情况：依附的GameObject的对象每次被激活时调用
2. 每次GameObject对象或脚本被激活调用一次，重复赋值，变为初始状态

### Start()
1. 调用情况：进行第一帧执行前才会执行，只有在GameObject 被激活后才会被调用
2. 在Awake之后，Update之前，方便控制逻辑先后调用顺序

### Fixed Update()
主要用于物理更新，每个固定时间间隔执行，
1. 时间设置在 Project Setting --> Time -> Fixed Timestamp 中设置
2. 时间设置在 File -> Build Settings -> Player Settings -> Time -> Fixed Timestep

### Update()
主要用于游戏核心逻辑更新
实时更新数据，接受输入数据，每帧调用，每秒60次左右。

### Late Update()
一般用于处理摄像机位置更新内容，Update与Late Update之间，Unity进行了一些处理，对动画相关的更新，影响渲染的结果，
如果在Update中更新相机，即摄像机位置变化后更新动画，可能会出现渲染错误，其运行帧率与Update相同

### OnDisable ()
当对象被禁用时调用，脚本被禁用时，游戏被销毁时调用
作用：对于一些状态的重置，资源回收与清理

### OnApplicationQuit ()
在程序退出之前所有游戏对象都会调用这个函数
在编辑器中用户终止播放模式调用
在网页视图关闭时
满足以上情况时调用一次，用于处理游戏退出后的一些逻辑

### OnDestroy ()
当物体被销毁时调用，对象存在的最后一帧更新完之后的所有Update函数执行完之后执行。
用于销毁一些游戏物体
Destroy(GameObject, time)