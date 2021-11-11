## React 基础使用
1. 定义数据
    ```
    import React, {Component} from 'react';
    
    class TodoList extends Componet {
        // 构造函数
        constructor (props) {
            // 调用父类
            super(props);
            
            this.state = {
                inputValue: '',
                list: ['React','Vue'] 
            }
        }
        
        render(){
            return (
                <Fragment>
                    <div>
                        {
                            /* 
                             * 原生事件为 onchange
                             * React 事件为 onChange
                             * 
                             * 默认调用 React方法中 this指向为 undefined
                             * 需通过 bind 方法绑定this指向
                             * 在构造方法中绑定事件的this指向 性能优于在 jsx 事件中绑定this指向
                             *
                             * 样式类需使用 className = 'red' 而非 class = 'red'
                             * html 中label标签中 for 需使用 htmlFor
                             */
                        }
                        <input value = {this.state.inputValue}
                        onChange = {this.handleInputChange.bind(this)}/>
                        <button onClick = {this.handleClick.bind(this)}>Submit</button>
                    </div>
                    <ul>
                        {
                            this.state.list.map((item,index) => {
                                {// 循环中必须拥有一个key值，否则会有Warring提示}
                                return 
                                    <li 
                                        key={index}
                                        onClick={this.handleItemDelete.bind(this,index)}>
                                        {item}
                                    </li>
                            })
                        }
                    </ul>
                </Fragment>
            )
        }
        
        handleInputChange (e) {
            // 异步赋值, 性能优化
            const value = e.target.value;
            this.setSate(() => ({
                "inputValue": value
            }))
           
            // this.setState({
            //    "inputValue": e.target.value
            // });
        }
        
        handleClick () {
            // 展开运算符，会将原有的 this.state.list 展开为一个新的list,然后再将 this.state.inputValue初始化添加至数组中 
            // preState 上一个状态        
            this.setState((preState) => ({
                list: [...preState.list, preState.inputValue],
                inputValue： ''
            }))    
        }
    
        handleItemDelete (index){
            // 代码优化
            this.setState((preState) => {
                const list = [...preState.list]
                list.splice(index,1);
                return {list}
            })
            
            // React中 immutable概念，state 不允许做任何改变
            const list = [...this.state.list]
            list.splice(index,1);
            this.setState({list: list});
        }
    }
    ```
2. React 事件
    1. [处理React事件](https://reactjs.org/docs/handling-events.html)
    2. [React合成事件](https://reactjs.org/docs/events.html)

3. React的State和Props
    - 当组件的 State 和 Props发生改变时，render会重新执行
    - 当父组件的 render函数运行时，其所有子组件的render均会被执行

4. React中 ref的使用
    - 注意: 不推荐使用ref,尽量以数据驱动方式
    1. 案例
       ```
        <input onChange={this.handleChange}
            ref={(input) => {this.input = input}}/>
       
       // JS
       handleChange (e){
          e.target.value
          this.input.value;
       }
       ```
5. React 中定义使用(react-transaction-group)动画   
   1. 安装依赖
    ```
        npm install react-transition-group --save
    ```
   2. 使用CSS Transition
       ```
            import { CSSTransition } from 'react-transition-group'
            
            construct(){
                this.state = {
                    show: true
                }
            }      
      
            render() {
                return (
                    <div>
                        // 当this.state.show 发生改变时，触发动画，时间为1000毫秒
                        // className 代表样式前缀命名
                        <CSSTransition in = { this.state.show }
                            timeout = { 1000 }
                            classNames = 'fade' 
                            onEntered = {(el) => {this.transitionEntered.bind(this)}}
                            appear = {true}>
                            <div>Hello Word</div>
                        </CSSTransition>
                    </div>
                )
      
                // 通过钩子函数，实现样式动画
                transitionEntered () {
                    
                }
            }
       ```
   2. 使用CSS Transition
          ```
            import { CSSTransition ,TransitionGroup } from 'react-transition-group'
            
            render() {
                return (
                    <div>
                        <TransitionGroup>
                            {
                                this.state.list.map(item,index) => {
                                    return (
                                        /* 多组使用CSS 样式 */
                                        <CSSTransition>
                                        </CSSTransition>
                                    )
                                }
                            }
                        </TransitionGroup>
                    </div>
                )
            }
         ```
## React中的虚拟DOM
1. 虚拟DOM发展对比
    - 方式一:
        - 步骤
            1. state数据
            2. JSX 模板
            3. 数据 + 模板结合，生成真实的DOM显示
            4. state发生改变
            5. 数据+模板结合，生成真实DOM，替换DOM
        - 缺陷:
            1. 生成完整DOM 替换原有DOM 损耗性能
    - 方式二:        
        - 步骤:
            1. state 数据
            2. JSX模板
            3. 数据+模板结合，生成真实DOM
            4. state发生改变
            5. 数据+模板结合，生成新DOM(DocumentFragment)
            6. 新的DOM和原有DOM对比
            7. 对比差异处替换原有DOM
        - 缺陷: 
            1. 性能提升不明显
    - 方式三:        
        - 步骤:
            1. state 数据
            2. JSX模板
            3. 生成虚拟DOM,(虚拟DOM为一个JS对象，用来描述真实DOM)
            4. 数据+模板结合，生成真实DOM
            5. state发生改变
            6. 生成新的虚拟DOM
            7. 对比原生虚拟DOM和新虚拟DOM差异处
            8. 操作DOM提升性能
2. React 虚拟DOM
    - React JS 创建虚拟DOM
        ```
        render(){
            return React.createElement('div',{},React.createElement('span',{},'item'))
        }
        等价于
        render(){
            return <div><span>item</span></div>
        }
      ```
      1. 参数1: 创建dom
      2. 参数2: dom结点的元素
      3. 参数3: 挂载内容(可以为子节点信息)
    - React 虚拟DOM数据存储
        ```
        <div id='abc'><span>hello world</span></div>
        ['div',{id:'abc'},['span',{},'hello world']]
        ```
3. React中的Diff算法
    1. setState 异步方式对比，如果同时三次操作setState，会合并为一次进行对比。
    2. 同层对比，同层虚拟dom不同，则同层及子节点将删除，重新渲染，以此提升对比性能
    3. 对比命名 a -> a ,b -> b ,故不能用index作为 key值 （使用稳定的值作为key值）


## React 参数传递
0. [官方文档-PropTypes](https://zh-hans.reactjs.org/docs/typechecking-with-proptypes.html)
1. 参数校验、参数默认值
    - 参数校验
        ```
            // 引入参数类型校验
            import PropTypes from 'prop-types'
            class ChildrenItem extends Component{
                render(){
                    return (
                        // do someting
                    )
                }
            }
            // 设置属性必填，及属性类型
            ChildrenItem.propType = {
                // 通过设置isRequired 来设置组件必填
                aaa: PropTypes.string.isRequired,
                xxx: PropTypes.string,
                xxMethod: PropTypes.func
            }
            // 设置属性默认值
            ChildrenItem.defaultProps = {
                aaa: 'hello world!'
            }
        ```
    - 参数默认值
2. 父组件传递数据至子组件
    - 通过 props 属性传递
        ```
        // 父组件
        return (
            <Children xxxx = { data }>
        )
        
        // 子组件
        this.props.xxxx
        ```

3. 子组件传递数据至父组件
    - 通过子组件调用父组件方法实现
        ```
        // 父组件
        return (
            <Children xxmethod = { this.xxhandleMethod.bind(this) }>
        )
        
        // 子组件
        clickDelete () {
            this.props.xxmethod();
        }
        ```
## React 按需引入/异步化加载
1. 异步化加载
    - 通过react-loadable实现异步化加载
        1. 安装
            ```
                yarn add react-loadable
            ```
        2. 为子模块创建loadable.js文件
            ```
               import Loadable from 'react-loadable';
               import Loading from './my-loading-component';
               
               const LoadableComponent = Loadable({
                 loader: () => import('./my-component'),
                 loading: Loading,
               });
               
               export default () => <LoadableComponent/>;
            ```
        3. 在父模块中引入 loadable.js文件
        
        4. loadable方式路由传参处理
        ```
            import withRouter from 'react-router-dom'
      
            const mapState = (state) => ({
                title: state.getIn(['detail','title']),
                content: state.getIn(['detail','content'])
            });
      
            const mapDispatch = (dispath) => ({
                getDetail(id) {
                    dispatch(actionCreators.getDetail(id));
                }
            });
            // 通过withRouter 方法将 参数 传递给Detail组件
            export default connect(mapSate,mapDispatch)(withRouter(Detail));
        ```
## React 生命周期
- 生命周期函数指在某一时刻组件自动调用执行的函数
- Mounting
    1. componentWillMount函数: 在组件即将挂载到页面的时候被执行
    2. render 函数: 在state或props数据发生变化时触发的函数
    3. componentDidMount函数: 在组件挂载到页面后被执行;(一般Ajax请求放到componentDidMount)
- Updation
    1. componentWillReceiveProps: 在接收到父组件传递的函数，只要父组件的render函数被重新执行了(第一次存在于父组件时不被执行)，子组件的生命周期函数就会被执行。
    2. shouldComponentUpdate: 组件被更新之前自动执行，要求返回Boolean类型结果
    3. componentWillUpdate: 在组件被更新前执行，但在shouldComponentUpdate后执行，如果shouldComponentUpdate返回false则不执行
    4. componentDidUpdate: 在组件被更新完成后被执行
- Unmounting
    1. componentWillUnmount: 当组件即将被页面剔除时被执行

## React特性
1. React 与 Jquery 对比
    - React 是声明式编程，JQuery是页面式编程
2. React 与 VUE 对比
    - 
3. React 的特性
    - 声明式开发
    - 可以与其它组件并存
    - 组件化
    - 单向数据流
    - 视图层框架
    - 函数式编程