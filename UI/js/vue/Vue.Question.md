## Vue Question
1. Vue2 与 Vue3有哪些差异？
    1. [组件式API](https://cn.vuejs.org/guide/extras/composition-api-faq.html)
        1. 选项式
            ```
            export default {
               data() {
                  return {
                     open: false
                  }
               }
            }
            ``` 
        2. 组件式
        ```
        const open = ref(false)
        ```
    2. [Script setup](https://cn.vuejs.org/api/sfc-script-setup.html)
    3. [Teleport 组件](https://cn.vuejs.org/guide/built-ins/teleport.html)
        1. 作用：将一个组件内部的一部分模板“传送”到该组件的 DOM 结构外层的位置去。
        2. 通俗解释：弹窗
    4. [Fragments 片段](https://v3-migration.vuejs.org/zh/new/fragments.html)
        1. 通俗解释：组件可以包含多个根节点，不再需要div标签包裹
    5. [Emits 组件选项](https://cn.vuejs.org/api/options-state.html#emits)
        1. 用于声明由组件触发的自定义事件
    6. [自定义渲染器 createRenderer](https://cn.vuejs.org/api/custom-renderer.html)
2. Vue 父子组件传递？

3. Vue3中如何实现动态组件？
    - Vue3中使用 <component> 元素和 v-bind:is 属性来实现动态组件
    - 参考: https://blog.csdn.net/qq_44879989/article/details/128876650
    ```
    <template>
      <div class="container">
        <!-- 指定 First 组件不需要被缓存 -->
        <keep-alive  exclude="First">
          <!-- 使用属性绑定指令将指定的数据绑定到属性中 -->
          <component v-bind:is="show"></component>
        </keep-alive>
        <button @click="transfer()">Transfer</button>
      </div>
    </template>

    <script>
    // 导入组件
    import First from '@/components/First.vue';
    import Last from '@/components/Last.vue';
    
    export default {
      // 定义数据
      data() {
        return {
          show: 'First'
        }
      },
      // 注册组件
      components: {
        First, 
        Last
      },
      // 定义事件处理函数
      methods: {
        transfer() {
          if(this.show === 'First'){
            this.show = 'Last';
          }else{
            this.show = 'First';
          }
        }
      }
    }
    </script>
    ```
4. Vue 如何实现异步组件加载？
    1. 参考: https://cn.vuejs.org/guide/components/async.html
    2. Promise 方式加载
    ```
    import { defineAsyncComponent } from 'vue'
   
    const AsyncComp = defineAsyncComponent(() =>
        import('./components/MyComponent.vue')
    )
    
    ```
    3. app.component() 全局注册
    ```
    app.component('MyComponent', defineAsyncComponent(() =>
        import('./components/MyComponent.vue')
    ))
    ```
5. Vue 如何实现自定义指令？
6. Vue 如何实现全局状态管理？
7. Vue 如何如何属性扩展?