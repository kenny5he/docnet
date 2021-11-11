# Spring Spel
## Spring 表达式
1. 创建SPEL 上下文
```
// 创建一个ExpressionParser对象，用于解析表达式
ExpressionParser parser = new SpelExpressionParser();

// 使用直接量表达式
Expression exp = parser.parseExpression();

// 创建一个EvaluationContext对象，作为SpEL解析变量的上下文
EvaluationContext ctx = new StandardEvaluationContext();

// 为上下文设置变量
ctx.setVariable("list" , list);

// 执行表达式获取值
parser.parseExpression("#list[0]").getValue(ctx)
```
### 集合
1. 获取数组中所有的name元素
```
#list.![name]
```
2. 判断数组元素length是否大于7
```
#mylist.?[length()>7
```


## Spel表达扩展与应用
1. Spring Cache
   1. CacheEvaluationContext
   2. CacheOperationExpressionEvaluator