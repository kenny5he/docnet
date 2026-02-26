## JQuery事件扩展:
1. 例1:
    ```javascript
    $.extend({
      "fn1": function () {
      }
    });
    $dom.fn1();
    ```
2. 例2:
    ```javascript
    $.fn.extend({
      "fn2": function () {
         console.log("英语八级就是好！");
      }
    })
    $dom.fn2();
    ```
