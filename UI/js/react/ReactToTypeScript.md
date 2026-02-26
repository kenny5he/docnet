## TypeScript


### 将已有React 项目引入 TypeScript
1. 全局安装typescript
```
npm install typescript -g 
// 或者
yarn global add typescript
```
2. 项目引入 typescript
```
npm install typescript
// 或者
yarn add typescript
```
3. 初始化生成typescript 配置文件(tsconfig.json)
```
npx tsc --init
```
4. 安装ts-loader 处理ts和tsx文件
```
npm install ts-loader
// 或者
yarn add ts-loader
```
5. 安装@type模块
```
npm install @types/react
npm install @types/react-dom
npm install @types/react-redux

// 或者
yarn add @types/react
```
6. 配置支持jsx语法
```
{
   "compilerOptions":{
        "jsx": "react"
   }
}
```
-- 参考: https://segmentfault.com/a/1190000019075274