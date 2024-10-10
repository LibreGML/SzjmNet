#### My project is to make all software free(自由)  --Richard Stallman
# 苏州经贸校园网双系统(win+linux)自动登录解决方案
## 文末附有安卓端方案

前言:  
1. 本脚本仅适用于所有使用linux的同学，或有编程/系统知识的同学。
2. 由于双系统切换会被识别为两台不同的设备，在某系统关机时未退出，在另一系统上会进入以下界面，需手动下线设备，再刷新登录，因此写了退出校园网的脚本，需让其在关机前执行。
![图片](https://github.com/user-attachments/assets/82c983df-1160-4646-8d82-ed50f1e59a03)
3. （重要）Linux上用sh脚本，windows7以上用ps1脚本，都在scripts目录下，lg为登陆脚本,out为退出脚本。  其他文件都不需要，学习用的，如 js和py是脚本的其他语言的实现，需要node和python环境。
4. （无需关心） 仅用于学习的，winpkg目录下为windows的exe程序，linuxpkg目录下为linux的deb包与Arch包。exe必须和config.ini同目录，linux安装后需在有config.ini的目录下执行`sjmlogin`命令。config.ini填写个人信息。



## Linux平台
> 用NetworkManager而非systemd-networkd。
> 建议用.sh脚本，写了nmcli monitor监控了网络情况，确保一定分配到ip后执行，避免过早执行。
> .js脚本纯粹是为了做第二个校园网认证界面，但由于服务端禁止跨域，无法伪造cors而告终。
### 信息配置
修改lg.sh, 找到如下，改成自己的信息。其他语言的脚本一样。python需要写在config.ini里。
```
# 构建请求体
request_body='{
  "domain": "telecom", # 运营商 default | cmcc | telecom | unicom，分别是校园网、移动、电信、联通，填入自己办理的运营商。
  "username": "xxxxxx0222", # 苏州经贸学号
  "password": "Sjmxxxxxx"   # # 密码，Sjm+身份证后六位
}'
```
运行测试一下，`bash lg.sh`或`zsh lg.sh` 。如果用js则`node lg.js`。

### 开机自启
**开机自启(创建service并启用)：**
1. 把lg.sh放到某个位置，比如`/home/tzgml/Mycode/szjm/network/scripts/lg.sh`, 进入到此目录再`chmod +x lg.sh`赋予执行权限。
2. 创建service文件 `sudo vim /etc/systemd/system/bootexec.service`
3. 写入如下内容：
```
[Unit]
Description=auto login network after boot
Wants=multi-user.target

[Service]
ExecStart=/home/tzgml/Mycode/szjm/network/scripts/lg.sh      # 一定要确保路径是自己脚本存放的位置，并且脚本一定要赋予执行权限
Type = always

[Install]
WantedBy=multi-user.target
```
4. 键入:wq保存退出，然后`sudo systemctl enable --now bootexec.service`即可。

**直接写在shell里（不推荐）**
1. 在.bashrc或.zshrc里写上`bash ./lg.sh`或'zsh ./lg.sh此类，让shell启动的时候也执行这个脚本'
2. 设置终端开机自启。
3. 不推荐，因为终端打开一次就会执行一次

### Linux关机自动退出认证
1. 把lg.sh放到某个位置，比如`/home/tzgml/Mycode/szjm/network/scripts/out.sh`, 进入到此目录再`chmod +x out.sh`赋予执行权限。
2. 创建service文件 `sudo vim /etc/systemd/system/poweroffexec.service `
3. 写入如下内容：
```
[Unit]
Description=Run command before shutdown
DefaultDependencies=no
Before=shutdown.target reboot.target halt.target

[Service]
Type=oneshot
ExecStart=/home/tzgml/Mycode/szjm/network/scripts/out.sh  # 一定要确保路径写对了，并且脚本一定要赋予执行权限

[Install]
WantedBy=shutdown.target reboot.target halt.target
```
4. 键入:wq保存退出，然后`sudo systemctl enable --now poweroffexec.service`即可。

### 软件包作用
> Linux下的软件包主要用于待机/睡眠后断网，测试， 自启动损坏时使用
> deb包用`dpkg -i`, Arch包用`pacman -U `安装
1. linuxpkg下有打包好的deb包和Arch包，用pyinstaller打包，`sjmlogin`命令需要在有config.ini文件的目录下执行。否则会出现如下报错：
```
Traceback (most recent call last):
  File "sjmlogin.py", line 5, in <module>
  File "configparser.py", line 759, in get
  File "configparser.py", line 1132, in _unify_values
configparser.NoSectionError: No section: 'login'
[PYI-14260:ERROR] Failed to execute script 'sjmlogin' due to unhandled exception!
```
2. 执行`sjmlogin`登陆， 执行`sjmout`退出，实际上这俩命令都在/usr/bin下。
3. config.ini配置如下， 必须cd到有这个config.ini的目录下才能正确执行`sjmlogin`命令， 建议直接放在$HOME（~/）下。
```
[login]
domain = telecom    # 运营商 default | cmcc | telecom | unicom，分别是校园网、移动、电信、联通，填入自己办理的运营商。
username= xxxxxx0222  # 苏州经贸学号
password= Sjmxxxxxx  # 密码，Sjm+身份证后六位
```


## Windows平台
**直接用lg.ps1和out.ps1脚本**实现登陆退出
### 信息配置
在lg.ps1下更改如下信息
```
# 运营商 default | cmcc | telecom | unicom，分别是校园网、移动、电信、联通，填入自己办理的运营商。
Body "{`"domain`":`"telecom`",`"username`":`"你的学号`",`"password`":`"你的密码`"}"
```
### 开机自启动与关机自动退出认证
1. win+R打开运行，输入`gpedit.msc`回车打开组策略编辑器。
2. 计算机配置＞windows设置＞脚本（启动/关机），双击启动和关机进行编辑。
![屏幕截图(2)_021634](https://github.com/user-attachments/assets/e2d6749b-93d6-414e-906e-5ed5d4e71815)
3. 选择windows powershell脚本， 点击添加
![屏幕截图(5)](https://github.com/user-attachments/assets/da910daf-29f3-4ad8-bde6-194470b41148)
4. 点击浏览，找到lg.ps1的路径打开即可。点击确定，再点击应用，确定即可。
5. 关机同理，找到out.ps1的路径。

### 软件包作用
**仅用于学习**，最好用上面的**ps1脚本**。
winpkg下的软件包主要用于**不方便使用脚本**的懒同学，去release下载打包好的win.zip,解压到本地目录， config.ini配置如下
```
[login]
domain = telecom    # 运营商 default | cmcc | telecom | unicom，分别是校园网、移动、电信、联通，填入自己办理的运营商。
username= xxxxxx0222  # 苏州经贸学号
password= Sjmxxxxxx  # 密码，Sjm+身份证后六位
```
再按照上面那个方法添加autologin.bat和autoout.bat这两个脚本，实现自启动。不用切换到powershell脚本，直接就选脚本。
不想要config.ini的改py脚本，直接把信息写在请求体，再用pyinstaller打包成exe即可。



## 脚本相关
**其他相关**
1. Linux直接用sh，win上用ps1 。win7以下可以安装curl, 使用curl命令，方法见本文最后。
2. 直接运行sh，js，py文件都要先找到请求体改成自己的信息。用exe要先在config.ini写自己的信息并且同目录。
3. 直接运行js需要node环境，`node lg.js`，py需要python环境，Linux可能已经作为依赖被安装了。
4. 这个脚本实际就只是发送一个post请求而已，任何语言都能轻松实现。
5. 实际上只需要用到.ps1和.sh就行了，其他都是写着玩的，不用管。

**自己实现**
- 按f12或ctrl+shift+i打开浏览器开发者工具，点击网络，进入登陆界面，捕获一次请求
![图片](https://github.com/user-attachments/assets/79aaa906-77e4-4156-ad32-d68c3260891e)
- 第一看请求方法是POST, 第二看过滤消息头中协议是http,服务端程序所在主机为10.255.254.13,文件名是/api/portal/v1/login,这是服务端写的API,前端请求都是发给他的。也就是http://10.255.254.13/api/portal/v1/login'。
- 第三看消息头部分中的请求头，第四看请求部分查看请求体，类似{"domain":"telecom","username":"xxxxxx0222","password":"Sjmxxxxxx"}	""
- 这是登陆时的POST过程，退出同理,后端API文件在http://10.255.254.13/api/portal/v1/logout。 据此即可用自己喜欢的语言写一个POST请求。
- 可以直接右键请求条目复制为Powershell/curl/fetch命令。保存为对应文件，让他开机自启。




## 安卓
新建一个lg.sh文件，粘贴如下：
```
#!/bin/bash
# 定义URL和请求头
url='http://10.255.254.13/api/portal/v1/login'
headers=(
  "Accept: application/json, text/javascript, */*; q=0.01"
  "Accept-Encoding: gzip, deflate"
  "Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2"
  "Connection: keep-alive"
  "Content-Type: application/json; charset=UTF-8"  # 修改Content-Type为application/json
  "DNT: 1"
  "Host: 10.255.254.13"
  "Origin: http://10.255.254.13"
  "Priority: u=0"
  "Referer: http://10.255.254.13/portal/index.html?v=202102142343"
  "Sec-GPC: 1"
  "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:131.0) Gecko/20100101 Firefox/131.0"
  "X-Requested-With: XMLHttpRequest"
)

# 构建请求体
request_body='{
  "domain": "telecom",
  "username": "240xxxxxx",
  "password": "Sjmxxxxxx"
}'

# 发送POST请求并解析响应
response=$(curl -s -H "${headers[@]}" -d "$request_body" "$url")
```

此脚本可直接运行在安卓端，使用shizuku+autoTask自动在特定条件下执行.sh脚本，即可实现自动化，具体教程请在B站搜索shizuku或自动任务，需要手机支持无线调试，华为请附加一个黑阈来激活shizuku，或有线adb方式。测试此脚本可使用MT管理器直接执行，或Termux运行。
