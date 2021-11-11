## Java Clone

### Cloneable接口
参考Blog: https://www.cnblogs.com/ldq2016/p/5231832.html
1. 深复制与浅复制的区别:
   深复制: 将一个对象复制后，不论是基本数据类型还有引用类型，都是重新创建的。简单来说，就是深复制进行了完全彻底的复制，
   浅复制: 浅复制复制内存地址，复制不彻底。
2. 深复制:
   > 要实现深复制，需要采用流的形式读入当前对象的二进制输入，再写出二进制数据对应的对象。
    ```
    public Object deepClone() throws IOException, ClassNotFoundException {
        /* 写入当前对象的二进制流 */
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        ObjectOutputStream oos = new ObjectOutputStream(bos);
        oos.writeObject(this);

        /* 读出二进制流产生的新对象 */
        ByteArrayInputStream bis = new ByteArrayInputStream(bos.toByteArray());
        ObjectInputStream ois = new ObjectInputStream(bis);
        return ois.readObject();
    }
    ```
3. 浅复制
    ```
    public Object clone() throws CloneNotSupportedException {
        Prototype proto = (Prototype) super.clone();
        return proto;
    }
   ```

