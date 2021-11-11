# Redux
1. Redux是什么?
    - Redux 会将数据存储在公用存储数据处(Store)进行数据存储统一管理
    - Redux = Reducer + Flux
2. Redux 的工作流程
    - Actions Creators(借书)
    - React Components(借书的人)
    - Store(图书馆)
    - Reducers(记录本)

3. Store的原理
    
## Redux 基础使用
1. 引入并创建store
```
import { createStore } from 'redux';
import reducer from './reducer';
// 创建一个store
const store = createStore(reducer);
export store;
```
2. 创建reducer
```
import defaultState = {
    inputValue:'test',
    list:[]
}
export default (state = defaultState,action) => {
    if (action.type === 'change_input_value') {
        const newState = state;
        newState.inputValue = action.value;
        return newState;
    }
    return state;
}
```
3. 创建动作类型管理器
    - 创建actionTypes.js文件
    ```
        export const CHANGE_INPUT_VALUE = 'change_input_value'
    ```
4. 创建动作创建器
    - 创建actionCreators.js文件
    ```
        import {CHANGE_INPUT_TYPE} from './actionType'
        export const getInputChangeAction = (value) => ({
            type : CHANGE_INPUT_TYPE,
            value
        })
    ```  
5. 使用处引入调用store
```
import store from './store/index.html'

class TodoList extends Component {
    constructor(props) {
        super(props);
        this.state = store.getState();
        this.handleStoreChange = this.handleStoreChange.bind(this);
        this.handInputState = this.handInputState.bind(this);
        store.subscribe(this.handleStoreChange);
    } 

    // 修改state
    handInputState(e) {
        const action = {
            type: 'change_input_value',
            value: e.target.value
        }
        store.dispath(action);
    }
    
    // 感知Store发生变化
    handleStoreChange() {
        this.setState(store.getState());
    }
}

5. 

```

## Redux 高阶使用

## Redux 原理
https://zhuanlan.zhihu.com/p/50247513