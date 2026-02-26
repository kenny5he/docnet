/**
 * 执行器
 */
const executor = (resolve, callback) => {
    if (typeof callback === 'function') {
        callback(resolve, null)
    } else if  (callback instanceof Array && callback?.length > 0 && typeof callback[0] === 'function') {
        const exec = callback.shift()
        exec(resolve, callback)
    } else {
        resolve(true)
    }
}