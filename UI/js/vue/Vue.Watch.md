# Vue Watch
本质是监控（对象、函数）运行期间，读到某个响应式数据，瞬间建立关联关系
## Vue Watch Ref
```
<script setup>
import {watch, ref} from 'vue';

const n = ref(0);

watch(
    () => n,
    (newVal, oldVal) => {
        console.log('n changed: ', newVal, oldVal)
    }
)

setTimeout(()=> {
    n.value++;
}, 1000)
</script>
```
## Vue Watch Function
1. 案例一
    ```
    <script setup>
    import {watch, ref} from 'vue';
    
    const n = ref(0);
    function getN() {
        console.log('N');
        return n.value
    }
    watch(
        () => getN(),
        (newVal, oldVal) => {
            console.log('n changed: ', newVal, oldVal)
        }
    )
    
    setTimeout(()=> {
        n.value++;
    }, 1000)
    </script>
    ```

2. 案例二
    ```
    <script setup>
    import {watch, ref} from 'vue';
    
    const n = ref(0);
    function getN() {
        console.log('N');
        return n.value
    }
    
    const n2 = getN()
    watch(
        () => n2,
        (newVal, oldVal) => {
            console.log('n changed: ', newVal, oldVal)
        }
    )
    
    setTimeout(()=> {
        n.value++;
    }, 1000)
    
    // 运行结果: 只打印一次N，不打印 changed
    </script>
    ```

3. 案例三
    ```
    <script setup>
    import {watch, ref} from 'vue';
    
    const n = ref(0);
    const m = ref(1);
    function getN() {
        console.log('N+M');
        return n.value + m.value
    }
    
    watch(
        () => getN(),
        (newVal, oldVal) => {
            console.log('n changed: ', newVal, oldVal)
        }
    )
    
    setTimeout(()=> {
        n.value++;
        m.value--;
    }, 1000)
    
    // 运行结果: 打印多次N+M ，不打印 changed，因为n++与m--抵消，实际值未变，故不触发changed
    </script>
    ```