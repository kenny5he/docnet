# GameObject
GameObject 是Unity中所有实体的基类
通过Hierarchy面板下的Create菜单可以手动创建一个GameObject，它可以是一个相机，一个灯光，或者一个简单的模型
当我们在程序里动态的创建一个空物体时，可以new 一个GameObject,创建球体或者立方体，可通过GameObject内提供的CreatePrimitive创建

## GameObject API
1. Find 查找游戏对象
```c#
// 从Scene下开始查找，根据GameObject的名字进行查找，允许使用"/"穿越层次查找
GameObject.Find("Unity");

// 根据Tag查找一个GameObject
GameObject.FindWithTag("Player");

// 根据Tag批量查找GameObject
GameObject.FindGameObjectWithTag("Player");

// 查找带有Camera组件的物体(只查一个)
GameObject.FindObjectOfType<Camera>();
```
2. 添加/获取组件
```c#
// 获取并设置GameObject是否为静态
gameObject.isStatic = true;

// 设置物体是否启动
gameObejct.SetActive(true);

// 给物体添加一个组件
gameObject.AddComponent<Camera>();

// 给物体设置一个Tag标签
gameObject.tag = "Player";

// 寻找子物体的Camera组件
gameObject.getComponentInChildren<Camera>();

// 寻找父物体的Camera组件
gameObject.getComponentInParent<Camera>();

// 寻找物体的所有 Camera组件
gameObject.getComponents<Camera>();

// 寻找这个物体的Camera组件
gameObject.getComponent<Camera>();
```
3. 销毁游戏对象
```c#
GameObject.Destroy(obj);
```