# 类
1. 特性：封装、继承、多态
2. 关键字 virtual、 override
## 类继承
```c#
public class Animal {
  public string name;
  
  public Animal(string name) {
    this.name = name;
  }
  
  public virtual void Speek() {
    Debug.log("动物在讲话")
  }
}

public class Dog:Animal {
  
  public Dog(string name):base(name) {
  }
  
  public override void Speak() {
    Debug.log("动物在讲话")
  }
  
  
}
```
