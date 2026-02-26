# OpenTiny 原理
## OpenTiny 项目结构说明
### @opentiny/vue-common (vue 指令适配)
1. @opentiny/vue-common 中存在 adpater 目录，其中包含 vue2.6、vue2.7、vue3 指令适配
    1. opentiny版本
        1. @opentiny/vue@2
        2. @opentiny/vue@3
    2. virtual:common 
        1. vue2: packages/vue-common/src/adapter/vue2/index.ts
        2. vue2.7: packages/vue-common/src/adapter/vue2.7/index.ts
        2. vue3: packages/vue-common/src/adapter/vue3/index.ts
    
2. $setup
    1. (resolveMode) 处理设置的mode，默认值为 pc
    2. 判断模板有没有，是否正常，并加载模板 
    3. renderComponent 通过 adpater 适配出的 h 函数，根据模板渲染出组件
3. setup (桥接组件的方法、状态、模板)

4. directive(指令)

### @opentiny/vue (组件模板、组件定义、组件注册)
1. @opentiny/vue 为 组件vue的封装集

2. @opentiny/vue 内包含 @opentiny/vue-button等具体组件
3. @opentiny/vue-button 项目中 index.ts 主要用于组件注册
4. @opentiny/vue-button 项目中 src/index.ts
    1. defineComponent 定义组件，包含 name (组件名)、 props (组件支持的属性、属性类型)、setup(组件模板 template、组件上下文 context、组件属性)
    2. setup
        1. 源码:
        ```
        setup(props, context) {
            // props 为使用组件时 属性值信息
            return $setup({ props, context, template })
        }
        ```
       2. 可视为
       ```
       () => {
         // <button></button> 即为 pc.vue 或 mobile.vue
         return <button>xxx</button>
       }
       ```
    3. template 
        1. 编译前:
        ```
        import template from 'virtual-template?pc|mobile|mobile-first'
        ```
        2. 编译后(约等同于): 
        ```
        import PcTemplate from './pc.vue'
        import MobileTemplate from './mobile.vue'
       
        var template = function templateFun(mode) {
          return (process.env.TINY_MODE || mode) === 'mobile' ? MobileTemplate : PcTemplate
        }
        ```
        3. 原理:
            1. 通过 shims-app.d.ts 定义
            ```typescript
            declare module 'virtual-template?*' {
                // 引入 vue 组件定义
                import type { DefineComponent } from '@vue/runtime-core'
                // 根据 mode 参数值，引入组件
                const src: (mode: string) => DefineComponent<{}, {}, any>
                // 导出组件
                export default src
            }
            ```
            2. unplugin-virtual-template 插件
                - 通过插件在vite编译期，编译对应代码
            3. 通过tsconfig.vue?.json文件引入，从而在 typescript 编译阶段起作用
            4. react 组件实现，通过vite插件生成，tiny-vue源码 insternals目录 vite-plugin-template2jsx 插件
            
4. 自定义组件v-model的实现方式
   
### @opentiny/vue-renderless 组件状态、组件方法


- 参考: https://www.bilibili.com/video/BV1QP411y7cD/?vd_source=59e98684fc0b6a373fd64dc42518769e