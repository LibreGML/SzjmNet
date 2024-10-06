#### My project is to make all software free(自由)  --Richard Stallman
## 苏州经贸校园网双系统(win+linux)自动登录解决方案
前言:  
1. 本脚本仅适用于所有使用linux的同学，或有编程/系统知识的同学。
2. 由于双系统切换会被识别为两台不同的设备，在linux上关机时未退出，在win上会进入设备解绑界面，需注销设备，再刷新登录，因此写了退出校园网的脚本，需让其在关机前执行。
3. winpkg目录下为windows的exe程序，linuxpkg目录下为linux的deb包与Arch包。两者均为python脚本的打包，exe必须和config.ini同目录，linux安装后需在有config.ini的目录下执行`sjmlogin`或`sjmout`命令。scripts目录下为脚本源代码。
4. 脚本用js，shell，py分别写出三个版本，找到request_body这样的请求体，改成自己的信息，即可直接运行。py需要改一下，就可以不用config.ini。

### Linux上
开机自启：



### 
windows和linux的包都是python打包出来的，需要填写config.ini配置文件信息，没有则新建一个，写入以下内容，仅为例子，根据个人信息填写
```
[login]
domain = telecom       # 运营商 default | cmcc | telecom | unicom，分别是校园网、移动、电信、联通，填入自己办理的运营商。
username= 2103250226   # 苏州经贸学号
password= Sjm086634    # 密码，Sjm+身份证后六位
```
