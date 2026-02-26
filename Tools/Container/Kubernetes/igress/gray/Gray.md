## Gray
1. 测试灰度
    1. 访问 `灰度` 应用
    ```shell
    curl -H "Host: gray.microfoolish.com"  http://<EXTERNAL_IP>
    ```
    2. 访问 `当前` 应用(通过 Header)
    ```shell
    curl -H "Host: www.example.com" -H "Region: bj" http://<EXTERNAL_IP>
    ```

- 参考: https://mp.weixin.qq.com/s/BZmuG6_NRHG-JiswqF07pA