# 粘贴板
## 原生方式获取粘贴板内容 (navigator.clipboard)
1. 可获取条件
    1. localhost
    2. https协议
2. 写
    ```javascript
    document.addEventListener('copy', (e) => {
        e.preventDefault();
        navigator.clipboard.writeText('禁止复制，请先关注公众号 Kenny ')
    })
   ```
3. 读
    ```javascript
    navigator.clipboard.readText().then((text) => {
      
    })
   ```
## Vue 复制/粘贴 功能插件
1. 安装 v-clipboard 插件
```js
npm install --save v-clipboard
```

2. 使用处引入声明
```js
import Clipboard from 'v-clipboard'
```

3. 复制功能
```js
<template>
    <button v-clipboard="待copy的对象"
        v-clipboard:success="copySuccessHandler"
        v-clipboard:error="copyErrorHandler">
        Copy
    </button>
</template>
<!-- 注: copySuccessHandler 为copy成功后的回调方法，copyErrorHandler为copy失败后的回调方法 -->
```
4. 自动获取粘贴板内容
    1. 监听 ctrl + v 键盘事件
    ```js
    // 监听 ctrl + v 键盘事件
    document.addEventListener("paste",(event) =>  {
        let text = (event.clipboardData || window.clipboardData).getData("text");
        // 再按业务处理粘贴板的数据
    });
    ```
    2. @paste
       
5. 阻止 paste 粘贴功能
    1. 阻止 element 组件中的 <el-inpute/>的粘贴功能
    ```js
    <el-input v-model="input"
      placeholder="提示内容"
      @pasete.native.capture.prevent="handlePaste"
    </el-input> 
    <!--说明:  -->
    <!-- 1. native: 表明 dom的原生事件，如果不加native，vue会认为paste是一个自定义事件，必须在组件内手动触发，那么在粘贴的时候自然就不会触发了  -->
    <!-- 2. capture: 表明这个方法在捕获阶段执行，默认为冒泡执行，参考 addEventListener方法中的useCapture参数 -->
    <!-- 3. 相当于event.preventDefault 阻止默认行为，同时也会阻止事件的向下传递和向上冒泡 -->
    ```
