# 枚举
枚举是一组命名整型常量，每个枚举都有一个底层整数类型，默认为int
1. Enum 案例
```c#
enum DayWeek {
    Monday = 0,
    Tuesday = 1,
    Wednesday = 2,
    Thursday = 3,
    Friday = 4,
    Saturday = 5,
    Sunday = 6,
}
```
2. 枚举转换
```c#
DayWeek week = (DayWeek)Enum.parse(typeof(DayWeek), 1) 
```