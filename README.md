#### My project is to make all software free(自由)  --Richard Stallman
# 苏州经贸校园网双系统(win+linux)自动登录解决方案
前言:  
1. 本脚本仅适用于所有使用linux的同学，或有编程/系统知识的同学。
2. 由于双系统切换会被识别为两台不同的设备，在某系统关机时未退出，在另一系统上会进入以下界面，需手动下线设备，再刷新登录，因此写了退出校园网的脚本，需让其在关机前执行。
![图片](https://github.com/user-attachments/assets/82c983df-1160-4646-8d82-ed50f1e59a03)
3.  脚本用js，shell，py分别写出三个版本，在scripts目录下， lg为登陆脚本,out为退出脚本。 winpkg目录下为windows的exe程序，linuxpkg目录下为linux的deb包与Arch包。两者均为python脚本的打包，exe必须和config.ini同目录，linux安装后需在有config.ini的目录下执行`sjmlogin`命令。 Linux用户直接用shell(.sh)即可。运行js需要node,py需要python环境。不想要环境直接用构建的软件包并配合config.ini。 
4. 用软件包不想用config.ini, 在sjmlogin.py找到request_body这样的请求体，改成自己的信息，运行或者重新打包，就可以不用config.ini,直接运行。
5. 建议使用静态mac地址，然后去[自助服务](http://192.168.10.231:8080/Self/login/?302=LI)里找到左边的**无感知**打开，这样同一设备联网无需认证。账号是学号，密码Sjm+身份证后六位


## Linux平台
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
> 用exe搭配config.ini, 新建一个目录把exe和config.ini放在同一个目录。
> 不想用可执行文件的，自己写.bat或.ps1脚本。很抱歉我没有提供，但思路基本一模一样。（推荐）
### 信息配置
1. 把sjmlogin.exe和sjmout.exe和config.ini放到同一个目录下，我已经打包成zip放在release,直接下载并解压即可
2. 在config.ini下写入如下配置
```
[login]
domain = telecom    # 运营商 default | cmcc | telecom | unicom，分别是校园网、移动、电信、联通，填入自己办理的运营商。
username= xxxxxx0222  # 苏州经贸学号
password= Sjmxxxxxx  # 密码，Sjm+身份证后六位
```
3. 双击这两个exe分别测试是否正常运行。

### 开机自启动与关机自动退出认证



## 脚本相关
