## Inject Metadata
### Bean 元数据
#### InjectionMetadata (元数据类)
1. 使用案例:
   
2. 作用: 
   
3. 核心子类
   1. InjectedElement
4. 源码: 
   ```
   
   ```
#### CommonAnnotationBeanPostProcessor
1. 作用:
    1. 处理 @Resource 节点: ResourceElement
    2. 处理 @WebServiceRef 节点: WebServiceRefElement
    3. 处理 @EJB 节点: EjbRefElement
2. 源码:
   ```
   
   ```
### Method 元数据
#### MethodIntrospector
1. 使用案例:
   ```
   Map<Method, T> methods = MethodIntrospector.selectMethods(clazz,
					(MethodIntrospector.MetadataLookup<T>) method -> {
						try {
							return getMappingForMethod(method, clazz);
						}
						catch (Throwable ex) {
							throw new IllegalStateException("Invalid mapping on handler class [" +
									clazz.getName() + "]: " + method, ex);
						}
					});
   ```
2. 源码:
