# 元素重叠度
```javascript
// 创建重叠度观察器
const ob = new IntersectionObsrver(
    (entries)=>{
       console.log('重叠度变化了');
       for (const entry of entries) {
          // 进入时
          if (entry.isIntersecting) {
          
          }
       }
    },
    // root: null // 视口
    threshold: 0, //重叠阈值
})
// 选择要观察的元素
const dom = document.querySelector('.loading');
ob.observe(dom);
```

