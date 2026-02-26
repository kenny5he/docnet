####GIT 使用文档
1. 配置本地ssh key
    ```
        ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
    1. 单ssh (Enter确定 输入密码  确认密码)(公钥默认位置在当前用户下.ssh文件夹下/id_rsa.pub文件)
    2. [多个ssh](https://blog.csdn.net/weixin_42257984/article/details/124788134)
        1. 配置多个ssh (注意第一次回车之后需要为生成的密钥自定义名字，输入一个 /Users/apaye/.ssh/id_rsa_github_qq，输入完之后一路回车)
            - /Users/apaye/.ssh/id_rsa_github_qq
            - /Users/apaye/.ssh/id_rsa_gitee_163
        2. 添加私钥
            ```shell
            ssh-add ~/.ssh/id_rsa_github_qq
            # or
            ssh-add ~/.ssh/id_rsa_gitee_163
            ```
        3. 添加配置文件
            1. 在.ssh/下创建config文件
               ```
               touch config
               ```
            2. 配置内容
                ```
                #gitlab
                Host gitlab.com
                HostName gitlab.com
                PreferredAuthentications publickey
                IdentityFile ~/.ssh/id_rsa
                #github
                Host github.com
                HostName github.com
                PreferredAuthentications publickey
                IdentityFile ~/.ssh/id_rsa_github
                ```
2. 配置帐号信息
    ``` 
    
   // 配置本地默认分支名(git)
   git config --global init.defaultBranch main
   
    git config --global user.name "kenny"
    git config --global user.email "yekun_he@163.com"
   
    git config --global user.name "kenny5he"
    git config --global user.email "923662064@qq.com"
   
    git config --global user.name "alphaerp"
    git config --global user.email "it3@alphafashion.cn"
   
    git config --list (检查设置)
    ```

3. 配置远程仓库信息
    ``` 
    git init
    git remote add origin git@github.com:heyekun54/webdemo.git 
    ```

4. 本地仓库与远程仓库关联
    ``` 
   // 重命名本地分支
   git branch -m main master
   
   git branch --set-upstream=origin/master master 
   ```

5. 拉取远程仓库代码
    ``` 
   git pull origin master 
    ```
    1. 切换分支: git checkout -b draft origin/draft

6. 修改远程仓库路径
    1. 添加远程仓库
    ```
        git remote add origin https://github.com/kenny5he/spring-framework.git
    ```
    2. 修改URL(直接修改会报错)
    ```
        git remote origin set-url --push spring-framework https://github.com/kenny5he/spring-framework.git
    ``` 
    3. 先删后加(亲测可用)
    ```
        git remote rm origin
        git remote add origin https://github.com/kenny5he/spring-framework.git
    ```
   4. 查看远程路径
    ```
        git remote -v
    ```
7. fork同源代码
    1. 添加同源地址
        ```shell script
            git remote add upstream https://github.com/spring-projects/spring-framework.git
        ```
    2. 核实远程分支列表
        ```shell script
            git remote -v
        ```
    3. fetch源分支的新版本到本地
        ```shell script
            git fetch upstream
        ```
    4. 合并两个版本的代码
        ```shell script
             git merge upstream/master
        ```
    5. 将两个版本的代码push到github自己的分支上
        ```shell script
             git push origin master
        ```
8. 切换分支
    ```
     -- (无)本地不存在新分支
     git checkout -b r180-comment origin/r180-comment
     -- (有)本地存在分支
     git checkout dev
    ```
9. 提交上传
    1. git add .
    2. git commit -m "[storyid/bugid] remark"(提交单个文件，例：git commit -m "remark" filename)
    3. git push (当含有多个分支时，须指定分支，例：git push origin master)

10. 解决冲突
    1. git stash (缓存已修改的文件)
        1. git pull (更新文件)
        2. git stash pop(弹出最近一次缓存好的文件)
        3. git stash save "local-prod" (将本地修改适配线上环境的配置暂存，方便下次调试)
        4. git stash list (查看暂存区列表)
        5. git stash apply stash@{0} (git stash apply 不会清除暂存记录，且参数 stash@{num} 需 git stash list 确认恢复的内容)
        6. git stash drop stash@{num} (清除指定暂存)
        7. git stash show stash@{num} (查看暂存与当前差异)
    2. git push -f (强制推送)
    3. git fetch   (先把git的东西fetch拉取数据到你本地然后merge合并再push)
       git merge
    4. git diff  (找到冲突的地方，然后解决冲突)(然后再上传)
  
11. 删除文件
     1. git rm xxxx.java (移除文件)
     2. git rm -cached xxxx.java (缓存区删除文件,保留文件在当前目录，不再跟踪)
12. 删除远端分支
    ```
        git push origin --delete 5.2.x-Comment
    ```
13. 查看日志
    1. git log  (按提交时间列出所有的更新)
    2. git log -p -2 (显示最近两次提交的内容差异)
    3. git log 的常用选项
    
    |选项	                      |说明|
    |---|:---|
    |-(n)             |仅显示最近的 n 条提交|  
    |--since, --after |仅显示指定时间之后的提交。|
    |--until, --before|仅显示指定时间之前的提交。|
    |--author         |仅显示指定作者相关的提交。|
    |--committer      |仅显示指定提交者相关的提交。|
    |--grep           |仅显示含指定关键字的提交|
    |-S               |仅显示添加或移除了某个关键字的提交|
    |-p               |按补丁格式显示每个更新之间的差异。|
    |--stat           |显示每次更新的文件修改统计信息。|
    |--shortstat      |只显示 --stat 中最后的行数修改添加移除统计。|
    |--name-only      |仅在提交信息后显示已修改的文件清单。|
    |--name-status    |显示新增、修改、删除的文件清单。|
    |--abbrev-commit  |仅显示 SHA-1 的前几个字符，而非所有的 40 个字符。|
    |--relative-date  |使用较短的相对时间显示（比如，“2 weeks ago”）。|
    |--graph          |显示 ASCII 图形表示的分支合并历史。|
    |--pretty         |使用其他格式显示历史提交信息。可用的选项包括 oneline，short，full，fuller 和 format（后跟指定格式）。|


14. idea解决冲突
    1. 参考博客[git在idea中的冲突解决](https://www.cnblogs.com/newAndHui/p/10851807.html)

15. github fork pull
    https://github.com/selfteaching/the-craft-of-selfteaching/issues/67

16. 密钥：
```
The key fingerprint is:
b3:73:ae:f6:c7:b0:a1:07:fe:85:cc:10:99:e5:cd:f2 923662064@qq.com
The key's randomart image is:
+--[ RSA 4096]----+
|          .      |
|         = o     |
|        + o o    |
|         . o     |
|        S   E    |
|        .*o.     |
|       .oo==.    |
|        ++o.o    |
|       ..=+.     |
+-----------------+
```