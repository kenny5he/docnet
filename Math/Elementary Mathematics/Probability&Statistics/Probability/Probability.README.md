# 概率学 Probability
## 概率
### 概率
### 随机事件
1. 定义：在一定条件下，可能发生也可能不发生的事件，叫随机事件

### 条件概率
1. 定义：在已知某个事件 B 已经发生的前提下，另一个事件 A 发生的概率，记作 P(A | B)，读作在B发生的条件下，A发生的概率
2. 例：
    > 假设袋子里有10个球：
    > - 5个红球（其中2个大球，3个小球）
    > - 5个篮球 (其中3个大球，2个小球)
    > 1. 随便摸一个球，是红色的概率是多少？
    >    - P(红) = 5/10 = 0.5
    > 2. 如果你已经知道摸到的是大号球，那么它是红色的概率是多少？
    >     - 既然已知是大号，那袋子中小号球全部扔掉不看
    >     - 现在剩下的样本空间只有大号球，2个红大号+3个蓝大号 = 5个大号球
    >     - P(红|大号) = 2/5 = 0.4
  
### 贝叶斯
1. 定义：根据新证据来更新我们对某个假设成立的概率估计
    1. 先验概率(Prior): 在没有任何线索前，你觉得某人犯罪的可能性
    2. 新证据(Likelihood): 你发现现场留下的指纹
    3. 后验概率(Posterior): 结合指纹新证据，更新后的判断
2. 例：
    > 假设有一种罕见病，发病率只有1%，
    > 假设有一种检测手段
    >    1. 如果真的患病，检测阳性概率是99%
    >    2. 如果没患病，检测阳性概率是5%
    > 问题：如果检测是阳性，你真的患病概率是多少？
    > 思考过程：
    >    1) 假设有10000人做检测
    >    2) 患病者：10000 * 1% = 100人，这100人中，检测出阳性的有 100 * 99% = 99人
    >    3) 健康者: 10000 - 100 = 9900人，这9900人中，检测出阳性（误报）的有 9900 * 5% = 495 假阳性
    >    4) 总阳性人数：99(真病) + 495(误报) = 594
    >    5) 计算后概率： P(患病|阳性) = 99/594≈16.7%
3. 朴素贝叶斯
    1. "朴素"(Naive): 假设特征之间相互独立(假设现实中往往不成立),
    2. 公式: $ P(垃圾邮件∣含"中奖") = \dfrac{P(含"中奖"∣垃圾邮件)×P(垃圾邮件)}{P(含"中奖")} $
### 随机变量
1. 定义： 随机变量(Random Variable) 是一个函数，它将随机实验的每一个可能结果，映射为一个实数
2. 随机变量分类

| 类型 | 比喻 | 特点 | 例子 |
| --- | --- | ---| --- |
|离散型|楼梯|取值是一个个孤立的点，可以数得清。|摇色子 1,2,3,4,5,6|
|连续型|斜坡|取值是一段连续的区间，有无穷多个值，数不清| 人的身高: 170.1cm,170.11cm,170.2... 、室温等 |
## 概率分布
1. 伯努利分布(Bernoulli Distribution)
    1. 场景：抛一次硬币
    2. 结果：要么正面(记1)，要么反面(记0)
    3. 比喻：如果正面概率是p, 伯努利分布就是描述这个开关处于"开"状态的可能性
    4. 特点：最简单、最基础的分布，只有两个值
2. 二项分布(Binomial Distribution)
    1. 场景：抛硬币n次，正面出现k次的概率
    2. 结果：
    3. 比喻：
    4. 特点：离散型分布，结果是整数，当n很大时，它的形状会变得像一座小山（正态分布）
3. 均匀分布(Uniform Distribution)

4. 正态分布(Normal Distribution)

5. 随机分布

## 分类
### 贝叶斯分类
1. 垃圾邮件分类
    1. 手写原理版
    ```jupyter
    # -*- coding: utf-8 -*-
    import math
    import re
    import os
    from collections import defaultdict
    import jieba
    from sklearn.feature_extraction.text import ENGLISH_STOP_WORDS  # ② 英文表（318词，零下载）
    jieba.setLogLevel(20)
    
    # ========== ① 加载中文停用词表：哈工大系（本地包兜底 + GitHub 双路径） ==========
    def load_zh_stopwords():
    # 路径A：从 goto456/stopwords 下载后放本地（推荐，最标准）
    if os.path.exists("hit_stopwords.txt"):
    with open("hit_stopwords.txt", encoding="utf-8") as f:
    return {w.strip() for w in f if w.strip()}
    # 路径B：synonyms 包内置的同源表（pip install synonyms 即有，1667词）
    try:
    import synonyms
    p = os.path.join(os.path.dirname(synonyms.__file__), "data", "stopwords.txt")
    with open(p, encoding="utf-8") as f:
    return {w.strip() for w in f if w.strip()}
    except Exception:
    pass
    return set()  # 都没有则返回空（退化为不过滤）
    
    ZH_STOPWORDS = load_zh_stopwords()
    STOPWORDS = ZH_STOPWORDS | set(ENGLISH_STOP_WORDS)   # 中英合并去重
    print(f"已加载停用词: 中文 {len(ZH_STOPWORDS)} + 英文 {len(ENGLISH_STOP_WORDS)} = {len(STOPWORDS)} 个")
    
    # ========== ② 分词 ==========
    def tokenize(text):
    words = jieba.lcut(text.lower())
    return [w for w in words
    if re.search(r'[a-z\u4e00-\u9fa5]', w) and w not in STOPWORDS]
    
    # ========== ③ 训练数据 + 分类器（与上一版完全一致） ==========
    train_emails = [
    ("恭喜您中奖了！点击链接领取百万现金大奖！", "spam"),
    ("免费领取优惠券，限时抢购，先到先得！", "spam"),
    ("恭喜中奖！点击领取您的免费iPhone大奖", "spam"),
    ("速来领取百万奖金，机会难得，立即点击！", "spam"),
    ("免费办理低息贷款，无需抵押，当天放款！", "spam"),
    ("在家兼职，轻松日结，月入过万，速来！", "spam"),
    ("Congratulations! You are the lucky winner! Click to claim your free prize now!", "spam"),
    ("Free viagra! Lowest price, buy now, free shipping!", "spam"),
    ("Win a free iPhone! Click here to claim your prize!", "spam"),
    ("You won the lottery! Claim your money now, urgent!", "spam"),
    ("会议纪要：明天上午十点开产品评审会，请准时参加", "ham"),
    ("请查收本周的工作周报，有问题随时沟通", "ham"),
    ("周五晚上部门聚餐，地点还是老地方", "ham"),
    ("项目进度报告已更新，详见附件，请查收", "ham"),
    ("您的快递已发出，预计明天送达，请注意查收", "ham"),
    ("The project meeting is scheduled for Monday morning, please attend on time.", "ham"),
    ("Please find attached the weekly report for your review.", "ham"),
    ("Hi team, the code review will be at 3pm tomorrow.", "ham"),
    ("Let's have lunch together this Friday, same place as usual.", "ham"),
    ("Your package has been shipped and will arrive tomorrow.", "ham"),
    ]
    
    class NaiveBayesSpamClassifier:
    def __init__(self):
    self.spam_word_count = defaultdict(int)
    self.ham_word_count  = defaultdict(int)
    self.spam_total = 0
    self.ham_total  = 0
    self.vocab = set()
    self.p_spam, self.p_ham = 0, 0
    
        def fit(self, emails):
            n_spam = sum(1 for _, label in emails if label == "spam")
            self.p_spam, self.p_ham = n_spam / len(emails), 1 - n_spam / len(emails)
            for text, label in emails:
                for word in tokenize(text):
                    self.vocab.add(word)
                    if label == "spam":
                        self.spam_word_count[word] += 1; self.spam_total += 1
                    else:
                        self.ham_word_count[word] += 1;  self.ham_total += 1
    
        def _word_prob(self, word, wc, total):
            return (wc[word] + 1) / (total + len(self.vocab))  # 拉普拉斯平滑
    
        def predict(self, text):
            log_p_spam = math.log(self.p_spam)
            log_p_ham  = math.log(self.p_ham)
            for word in tokenize(text):
                log_p_spam += math.log(self._word_prob(word, self.spam_word_count, self.spam_total))
                log_p_ham  += math.log(self._word_prob(word, self.ham_word_count,  self.ham_total))
            p_spam = 1 / (1 + math.exp(log_p_ham - log_p_spam))
            return ("spam" if log_p_spam > log_p_ham else "ham"), p_spam
    
    # ========== ④ 训练 + 预测 ==========
    clf = NaiveBayesSpamClassifier()
    clf.fit(train_emails)
    for text in ["恭喜您获得免费大奖，点击链接立即领取！",
    "明天下午三点开项目评审会，请准时参加",
    "You won a free prize! Click here to claim it now!"]:
    label, p = clf.predict(text)
    print(("🚨垃圾邮件" if label == "spam" else "✅正常邮件"), f"{p:6.1%}", "|", text)

    ```
    2. sklearn API版
        ```
        from sklearn.feature_extraction.text import CountVectorizer
        from sklearn.naive_bayes import MultinomialNB
        from sklearn.pipeline import make_pipeline
    
        # 一个 pipeline 串起 "分词 → 向量化 → 朴素贝叶斯"
        model = make_pipeline(
        CountVectorizer(analyzer="char", ngram_range=(1, 2)),  # 字符 1~2 元组当特征
        MultinomialNB(alpha=1.0),                              # alpha=1 即拉普拉斯平滑
        )
        model.fit(texts, labels)      # texts/labels 来自上面的数据
    
        model.predict(["恭喜您获得免费大奖，点击链接立即领取！"])  # → ['spam']
        ```
        1. 拉普拉斯平滑(+1): 新邮件里如果出现一个训练时没见过的词，不做平滑的话概率为 0，会把整个连乘"一票否决"。加 1 就像说"没见过 ≠ 不可能"。
        2. 取对数: 几十个 0.01 相乘 ≈ 10⁻¹⁸，计算机直接下溢成 0。取对数把乘法变加法，稳定又快。