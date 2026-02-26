## java.lang.reflect.Type 类型
1. 
```

```

### java.lang.TypeVariable


### java.lang.reflect.GenericDeclaration  
1. 声明（定义）范型变量”的实体（如Class，Constructor，Method）的公共接口
2. 获取 Generic
```

```

### java.lang.reflect.ParameterizedType 参数化类型( 泛型参数处理 )
1. 获取类的参数化类型
```

```
2. 获取参数化类型
```

public static ParameterizedType findGenericDeclaration(GenericDeclaration declaration, Type scope) {
    if (scope instanceof ParameterizedType) {
        ParameterizedType type = (ParameterizedType) scope;
        if (type.getRawType() == declaration) {
            return type;
        }
        scope = type.getRawType();
    }
    if (scope instanceof Class) {
        Class<?> classScope = (Class<?>)scope;
        ParameterizedType result = findGenericDeclaration(declaration, classScope.getGenericSuperclass());
        if (result == null) {
            for (Type type : classScope.getGenericInterfaces()) {
                result = findGenericDeclaration(declaration, type);
                if (result != null) {
                    break;
                }
            }
        }
        return result;
    }
    return null;
}
```


- 参考: CXF: InjectionUtils
- 参考: Spring Core: ResolvableType