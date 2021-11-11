const path = require('path');
const config = {
    // 入口
    entry: "./helloworld.js",
    // 出口
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: "bundle.js"
    },
    module: {
        // loader 让 webpack 能够去处理那些非 JavaScript 文件,loader 可以将所有类型的文件转换为 webpack 能够处理的有效模块
        loaders: [
            {
                // test 属性，用于标识出应该被对应的 loader 进行转换的某个或某些文件。
                // use 属性，表示进行转换时，应该使用哪个 loader。
                test: /\.css$/,
                loader: "style-loader!css-loader"
            }
        ]
    }
};
module.exports = config;