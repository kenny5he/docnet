type Method = 'GET' | 'POST';

function request(url: string, method: Method) {
  if (method === 'GET') {
    // get 逻辑处理
  } else if (method === 'POST') {
    // post 逻辑处理
  } else {
    // 永远不会执行的情况，例外情况：编译报错，未修改到位情况下，主动抛错。
    const n: never = method;
  }
}