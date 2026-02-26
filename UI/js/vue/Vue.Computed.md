# Vue Computed
## Vue Computed Cached
1. 计算属性缓存(值未变化，不计算)
```javascript
import {computed} from 'vue'
export function useComputed(fn) {
    const map = new Map();
    return function(...args) {
      const key = JSON.stringify(args)
      if (map.has(key)) {
        return map.get(key);
      }
      const result = computed(() => fn(...args));
      map.set(key, result)
      return result;
    }
}

```