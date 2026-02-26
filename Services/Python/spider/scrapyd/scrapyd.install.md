### Install Scrapyd
1. Install Scrapyd
```shell
pip3 install scrapyd
```
2. Config Scrapyd
    1. Create Config Dir/File
    ```shell
    sudo mkdir /etc/scrapyd   
    sudo vi /etc/scrapyd/scrapyd.conf 
    ```
    2. Config Scrapyd
    ```
    [scrapyd]   
    eggs_dir    = eggs   
    logs_dir    = logs   
    items_dir   =   
    jobs_to_keep = 5   
    dbs_dir     = dbs   
    max_proc    = 0   
    max_proc_per_cpu = 10   
    finished_to_keep = 100   
    poll_interval = 5.0   
    bind_address = 0.0.0.0   
    http_port   = 6800   
    debug       = off   
    runner      = scrapyd.runner   
    application = scrapyd.app.application   
    launcher    = scrapyd.launcher.Launcher   
    webroot     = scrapyd.website.Root   
    
    [services]   
    schedule.json     = scrapyd.webservice.Schedule   
    cancel.json       = scrapyd.webservice.Cancel   
    addversion.json   = scrapyd.webservice.AddVersion   
    listprojects.json = scrapyd.webservice.ListProjects   
    listversions.json = scrapyd.webservice.ListVersions   
    listspiders.json  = scrapyd.webservice.ListSpiders   
    delproject.json   = scrapyd.webservice.DeleteProject   
    delversion.json   = scrapyd.webservice.DeleteVersion   
    listjobs.json     = scrapyd.webservice.ListJobs   
    daemonstatus.json = scrapyd.webservice.DaemonStatus
    ```
    3. 配置参考
       - https://scrapyd.readthedocs.io/en/stable/config.html#example-configuration-file

3. 启动
```shell
scrapyd > ~/workspace/logs/scrapyd.log &
```
- 参考博客: https://blog.csdn.net/weixin_38819889/article/details/108685372