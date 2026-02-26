# [Babel](https://babeljs.io/docs/usage)
[Babel](https://www.babeljs.cn/docs/) 是一个工具链，主要用于将采用 ECMAScript 2015+ 语法编写的代码转换为向后兼容的 JavaScript 语法，以便能够运行在当前和旧版本的浏览器或其他环境中。

## Core Library
| 组件                                                                                                    | 名称       | 作用                  | 版本     | 兼容性                 |
|-------------------------------------------------------------------------------------------------------|----------|---------------------|--------|---------------------|
| babel-cli                                                                                             | Cli      | 命令行工具               | 6.26.0 |                     |
| @babel/cli                                                                                            | Cli      | 命令行工具               |        | Babel 7             |
| babel-core                                                                                            | Core     | 核心库                 | 6.26.3 |                     |
| @babel/core                                                                                           | Core     | 核心库                 |        | Babel 7             |
| babel-eslint                                                                                          | Eslint   | Eslint              | 8      |                     |
| [@babel/eslint-parser](https://github.com/babel/babel/blob/main/eslint/babel-eslint-parser/README.md) | Eslint   |                     |        | @babel/core@>=7.2.0 |
| [babel-loader](https://github.com/babel/babel-loader)                                                 | Loader   | Webpack 的 Babel 加载器 |        |                     |
| @babel/polyfill                                                                                       | Polyfill |                     |        | Babel <= 7.4.0      |


## [Preset](https://babeljs.io/docs/presets)
| 组件                         | 名称             | 作用                                     | 版本 | 兼容性       | 博客                                         |
|----------------------------|----------------|----------------------------------------|----|-----------|--------------------------------------------|
| babel-preset-env           | Preset-env 预处理 |                                        |    |           |                                            |
| @babel/preset-env          | Preset-env 预处理 |                                        |    |           | https://juejin.cn/post/7451824088924209167 |
| babel-preset-es2015-rollup | Es2015         | 需搭配rollup-plugin-babel 一起使用            |    |           |                                            |
| babel-preset-stage-2       | Stage          |                                        |    | Babel < 7 | 目前被  @babel/preset-env  替代                 |
| @babel/preset-react	       | react转码插件      | 将 React 的特定语法（如 JSX）转换为普通的 JavaScript。 |    |
| @babel/preset-typescript   | typescript转码插件 | 用于编译 TypeScript 代码                     |    |

## [CSS插件]
| 插件                      | 名称 | 作用         | 版本 | 兼容性 |
|-------------------------|----|------------|----|-----|
| mini-css-extract-plugin |    | css文件提取插件  |    |     |
| postcss                 |    | css浏览器兼容处理 |    |


- Github: https://github.com/babel/babel/tree/master/packages