# Angular
## Angular 安装
1. 全局安装angular-cli
```
npm install -g @angular/cli
```
2. 创建angular应用
```
ng new angular-demo
```
3. 启动angular应用（使用 --open或 -o参数可以自动打开浏览器并访问）
```
ng serve --open
```
## Angular 目录
1. e2e: 端到端测试目录
2. src: 应用文件目录
    1. app: 应用组件模块
        1. app.component.ts: 应用组件
        2. app.module.ts: 应用模块
    2. assets: 静态文件目录
    3. enviroments: 环境配置文件目录
    4. index.html:
    5. main.ts: angular 应用入口点
    6. polyfills.ts: 导入应用库，使angular兼容老浏览器
    7. styles.css: 应用全局样式
    8. tsconfig.json: typescript编辑器配置
3. angular-cli.json: angular命令行工具配置文件
4. karma.conf.js: 单元测试执行
5. package.json: npm工具配置文件，第三方依赖包
6. protractor.conf.js: 自动化测试文件
7. tslint.json: typescript代码规范检查

## angular组件(Component)(例:app.component.t)
1. 必备元素:
    1. @component:装饰器
        1. 作用: 告知angular框架如何处理typescript类
        2. 组成: 元数据(angular根据元数据的值渲染组件并执行逻辑)
    2. Template: 模板
        1. 作用: 定义组件的外观,以html的形式存在，渲染组件，可以使用数据绑定
    3. Controller:控制器(普通的typescript类)
       1. 作用:大部分逻辑在控制器中，处理模板发生的事件
2. 注入对象(可选):
    1. @Inputs() 输入属性
    2. providers 提供器
    3. Lifecycle Hooks: 生命周期钩子
3. 输出对象(可选):
    1. @Outputs: 可选输出对象
    2. styles: 样式表
    3. Animations: 动画
    4. Lifecycle Hooks: 生命周期钩子
## angular模块(Model)(例: app.module.ts):




## Angular 构建
1. angular命令行生成组件:(项目路径下)
```
ng n coponent search
```