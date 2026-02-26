## Vuex
### Vuex Store

```
import Vue from "vue";
import Vuex from "vuex";
 
Vue.use(Vuex);
 
export default new Vuex.Store({
    state: {
        leftFocus : '',
        hasBg : '',
        loadingNum : 0,
    },
    mutations: {
        chooseLeft: (state,thisActive) => state.leftFocus = thisActive,
        updateBg: (state,hasBg) => state.hasBg = hasBg,

        addLoading : (state) => state.loadingNum += 1,
        subLoading : (state) => state.loadingNum = state.loadingNum > 0?state.loadingNum-1:0,
    }
});
```
- state里面是存放数据的（类似于vue里面的data）
- mutations里面存放的是各种函数方法，用来改变state里面的数据的方法

1. state
    - 一般是挂在computed，挂在data上面，只会赋值一次，不会跟着vuex里面的变化而同步变化，当然也可以通过watch $store去解决这个问题
        ```
        computed: {
            hasBg(){
                return this.$store.state.hasBg
            }
        }
        // 监控数据
        watch : {
            '$store.state.hasBg' : {
                 handler(newVal,oldVal){
                     console.log(newVal)
                 }
            }
        }
        ```
2. mapState
    1. 方式一
    ```
    import { mapState } from 'vuex'
   ......
    computed : mapState({
    // vuex里的数据，两种写法：
    leftFocus : 'leftFocus',
    hasBg : (state) => state.hasBg,
    ......
    //这里是普通放在computed里面的函数
    fn1(){ return ......},
    })
    ```
    2. 方式二
    ```
    import { mapState } from 'vuex'
    ......
    computed : {
    ...mapState({
    leftFocus:'leftFocus',
    loadingNum:'loadingNum',
    hasBg:'hasBg'
    }),
    fn1(){ return ......},
    }
    ```
3. mapMutations
    ```
    import {mapMutations} from 'vuex'
    ......
    methods : {
    ...mapMutations([
    'updateBg'
    ]),
    }
    ```