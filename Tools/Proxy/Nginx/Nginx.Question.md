## Nginx 常见问题解决
1. 请求 414
```
location / {
    # 配置Nginx主体长度 (默认值1M, 为0时不限制大小)
    # 默认 1M，表示客户端请求服务器最大允许大小，在“Content-Length”请求头中指定。如果请求的正文数据大于client_max_body_size，HTTP协议会报错 413 Request Entity Too Large。就是说如果请求的正文大于client_max_body_size，一定是失败的。如果需要上传大文件，一定要修改该值。
    client_max_body_size 4M;
    
    # 默认 8k/16k,设置请求主体的缓冲区大小，如果请求的数据小于client_body_buffer_size直接将数据先在内存中存储。
    # 通过命令 查看 nginx -T | grep client_body_buffer_size 配置大小
    client_body_buffer_size 64k
    
    # 请求头 buffer 大小 (默认1k)
    client_header_buffer_size 8k;
    
    # 请求头的总大小 最大值 (默认值 4 8k)
    # 格式: large_client_header_buffers number size
    large_client_header_buffers 16 32k
}
```
2. 请求302



- 参考: https://blog.csdn.net/yexudengzhidao/article/details/128069617