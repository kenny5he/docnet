#Spring MVC 高阶用法
1. 指定某个处理器()处理某路径服务
```
@Bean
public HandlerMapping handlerMapping() {
    Map<String, Object> map = new HashMap<>();
    map.put("/path", new ExampleContoller());
    int order = -1; // before annotated controllers
    return new SimpleUrlHandlerMapping(map, order);
}
```