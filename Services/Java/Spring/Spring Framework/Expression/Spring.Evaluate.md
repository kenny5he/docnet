## Spel 表达式解析
1. 核心类:
    1. org.springframework.expression.spel.standard.Tokenizer#process 将字符串按特殊字符、数字、字母等区分，生成词的Token
    2. org.springframework.expression.spel.standard.InternalSpelExpressionParser
        1. doParseExpression: 解析表达式，逐层解析
        ```
        Tokenizer tokenizer = new Tokenizer(expressionString);
        this.tokenStream = tokenizer.process();
        this.tokenStreamLength = this.tokenStream.size();
        this.tokenStreamPointer = 0;
        this.constructedNodes.clear();
        ```
    3. SpelNodeImpl: 每一层节点记录
    4. org.springframework.expression.spel.standard.SpelExpression
       1. compileExpression 调用 SpelCompiler#getCompiler 方法解析公式
    5. SpelCompiler
       1. 


- 参考: https://cloud.tencent.com/developer/article/1497676
