## Java序列化/反序列化:
### 序列化是什么？
对象序列化是一个用于将对象状态转换为字节流的过程，可以将其保存到磁盘文件中或通过网络发送到任何其他程序；从字节流创建对象的相反的过程称为反序列化。
### 序列化标识符
- SerialVersionUID:
   - SerialVersionUID是一个标识符，当它通常使用对象的哈希码序列化时会标记在对象上。我们可以通过Java中serialver工具找到该对象的serialVersionUID。
   - serialver classname
    SerialVersionUID用于对象的版本控制。当您添加或修改类中的任何字段时，已经序列化的类将无法恢复，因为serialVersionUID已为新类生成与旧的序列化对象将不同。
    Java序列化过程依赖于正确的serialVersionUID恢复序列化对象的状态，并在serialVersionUID不匹配时抛出java.io.InvalidClassException 异常。

### Java 序列化相关 关键字
1. transient
    - 作用: 满足安全约束,不序列化
    - 作用范围: 修饰符仅适用于变量，不适用于方法和类
2. static
   - 静态变量不是对象状态的一部分，因此它不参与序列化
3. final
    - final变量将直接通过值参与序列化，所以将final变量声明为transient变量不会产生任何影响

### 序列化的缺陷: 
1. Java序列化不支持跨平台

### [序列化漏洞](https://www.freebuf.com/vuls/170344.html)

### IDEA中设置类自动序列化
Settings -> Editor -> Inspections -> Java -> Serialization -> Serializable .class without 

### Java 序列化代码
1. Java序列化
    ```
    /**
     * 序列化
     * {@link #org.apache.ibatis.cache.decorators.SerializedCache.serialize()}
     */
    private byte[] serialize(Serializable value) {
        try (ByteArrayOutputStream bos = new ByteArrayOutputStream();
             ObjectOutputStream oos = new ObjectOutputStream(bos)) {
            oos.writeObject(value);
            oos.flush();
            return bos.toByteArray();
        } catch (Exception e) {
            throw new CacheException("Error serializing object.  Cause: " + e, e);
        }
    }
    ```
2. Java 反序列化
    ```
    /**
     * 反序列化
     * {@link #org.apache.ibatis.cache.decorators.SerializedCache.deserialize()}
     */
     private Serializable deserialize(byte[] value) {
         Serializable result;
         try (ByteArrayInputStream bis = new ByteArrayInputStream(value);
              ObjectInputStream ois = new CustomObjectInputStream(bis)) {
             result = (Serializable) ois.readObject();
         } catch (Exception e) {
             throw new CacheException("Error deserializing object.  Cause: " + e, e);
         }
         return result;
     }
    
    ```