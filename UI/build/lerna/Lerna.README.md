## Lerna 
### 介绍
lerna 是一种多包管理工具， 可以让你在主项目下管理多个子项目，从而解决了多个包互相依赖，且发布时需要手动维护多个包的问题，每个 package 都有自己的依赖项
能够作为独立的 npm package 发布，只是源码放在一起维护，公共包可以放在根目录中的 package.json 中维护。
1. 安装 lerna
```
npm install --global lerna
```

2. 特性: 
   1. 根据 Git 提交信息，自动生成 changelog
   2. 提交代码，代码检查 hook
   3. 遵循 semver 版本规范

3. 目录结构: 
```
├── lerna.json
├── package.json
└── packages
    ├── package1
    │   └── package.json
    ├── package2
        └── package.json
```

4. 配置文件(Demo 释义)
```
{
  "private": true,
  "packages": [
    "packages/*",
  ],
  "command": {
    "publish": {
        // 忽略修改文件
      "ignoreChanges": [
        "ignored-file",
        "*.md"
      ],
      "message": "chore(release): publish"
    },
    "bootstrap": {
      "ignore": "component-*"
    }
  },
  "version": "1.0.3"
}
```

5. 常用命令
    1. 创建一个包
    ```
    // 创建一个包，name包名，loc 位置可选
    lerna create <name> [loc]
    ```
    2. 查看包
    ```
    lerna list
    ```
6. 安装依赖 bootstrap
- 包之间可以建立链接，当修改 A 包的源代码时，B 的 node_modules 中引用的 A 包也会相应修改 
    1. 安装某个包
    ```
    lerna bootstrap --scope=package
    ```
     2. 给A添加依赖B
     ```
     lerna add A --scope=B
     ```
     3. 提升公共包到根目录
     ```
     lerna bootstrap --hoist axios
     ```
     4. 删除所有依赖
     ```
     lerna clean
     ```
     5. 删除某个包的依赖
     ```
     lerna clean --scope=package
     ```