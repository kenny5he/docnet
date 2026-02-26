# Vue

## Vue 基础
1. Vue 基础语法
   - v-text: 元素的innerText 只能在双标签中使用
   - v-html: 元素的innerHTML 不能包含 {{xxx}}
   - v-if: 元素是否移除
   - v-show: 元素是否显示
   - v-model: 双向数据绑定，修改内存值
   - v-bind: 单向数据绑定
2. Vue 父子组件通信
    1. inject/provide
    ```typescript
    // 提供方
    import { provide, ref } from 'vue';
    const handle = (value: any) => {
        display.value = value;
    };
    provide('handle', handle);
   
    // 注入方
    import { inject, ref, reactive, computed } from 'vue';
    const handle: any = inject('handle');
    const typeChange = () => {
        handle(true);
    };
    ```
    2. 父传子
        1. 通过 props
            1. 方式1 
            ```typescript
            export interface Props {
                title?: string
            }
            const props = defineProps<Props>({
                title: '标题'
            })
            ```
            2. 方式2
            ```typescript
            const props = defineProps({
                // 对象类型的默认值
                param: {
                   type: Object,
                   // 工厂函数写法
                   default(rawProps) {
                       return { message: 'hello' }
                   }
               },
           })
           ```
   3. 子传父
       1. emit 
       ```typescript
       import { defineEmits } from 'vue';
       const emit = defineEmits(['update:status']);
       
       const changeStatus = (event,value) => {
           emit('update:status',value)
       }
       ```
       2. expose 暴露
       ```vue
       <!--子组件-->
       <script lang="ts" setup>
       import { expose } from 'vue'
       const validator = () => {
          
       }
       // 暴露方法
       expose({ validator })
       </script>
       
       <!-- 父组件 -->
       <template>
           <Child ref="child"></Child>
       <template>
       <script lang="ts" setup>
       import { ref } from 'vue'
       const child = ref()
       const submit = () => {
			child.value.validator()
		}
       </script>
       ```
3. 插槽
    ```vue
    <!-- 父组件 -->
    <template>
        <div>
            <!-- 默认插槽，default -->
            <slot></slot>
            <!-- 具名传参插槽 -->
            <slot v-bind:user="user" name="header"></slot>
        </div>
    </template>
   
    <!-- 子组件 -->
    <children>
        <!-- 默认插槽 -->
        <template></template>
        <!-- 使用header插槽 -->
        <template v-slot:header="{user: person}">{{ person }}</template>
    </children>
    ```


## 高阶
1. ref 与 reactive
    1. 区别
        1. reactive 重新分配新的对象，会失去响应式。
        2. ref必须使用.value进行操作
    2. 使用场景
        - 一个简单的基本类型,使用ref
        - 一个简单的对象类型,使用reactive或者ref
        - 一个深层次的响应式对象,最好用reactive