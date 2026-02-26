# Mock
## Mock JS
1. NPM Install
```shell
npm install mockjs
```
2. 模拟数据
```
Mock.mock({
  chartData: [
    {
      title: 'userInfo.week.1',
      value: 1
    }
  ],
  tableData: [
    {
      id: '1',
      bid: 'A',
      pid: 'D',
      name: 'GFD Company',
      time: '2021-12-18',
      type: 'userInfo.type.optionA',
      status: 'userInfo.status.optionD',
    }
  ]
})
```
3. 模拟请求
```
// 拦截 GET 请求
Mock.mock('/api/users', 'get', {
  'code': 200,
  'message': 'success',
  'data|10': [{
    'id|+1': 1,
    'name': '@cname',
    'age|18-60': 1
  }]
})
```
4. 高级设置
```
// 设置响应延时
Mock.setup({
  timeout: '200-600'  // 响应时间在200-600ms之间
})
```

## Axios Mock Adapter