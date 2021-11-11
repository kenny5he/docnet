## Spring MVC 的工作原理
1. 路径映射: 用户请求 ->  前端控制器 DispatcherServlet 中央处理器 -> HandlerMapping 处理映射器 获取Handler (获取配置或注解，路径映射获取Handler)(HandlerExecutionChain)
2. 请求执行: 获取HandlerAdapter请求执行Handler -> HandlerAdapter根据Handler规则执行不同类型的请求 -> 执行完毕，返回ModelAndView
3. 视图解析: 返回View -> ViewResolver 视图解析器，将逻辑视图解析成真正的视图国际化处理(Freemarker 中存在 if...) -> 返回View
4. 页面渲染: 渲染视图将Model视图转为Response相应



### 实战扩展案例
1. 通用返回结果: ResponseBodyAdvice接口
2. 通用异常处理: