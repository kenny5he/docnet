## Log4j2 Plugin
- PluginFactory
    1. @PluginFactory注解对应的必须使用一个静态的方法，传入的参数用@PluginAttribute修饰
    2. 参考案例: ThreadFilter.createFilter方法