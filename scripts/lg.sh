#!/bin/bash
nmcli networking connectivity | grep full >/dev/null 2>&1&&echo 已登录1|lolcat ||env LANG=C.utf8 nmcli monitor | while read -r nmline;do
if echo $nmline | grep portal >/dev/null 2>&1;then
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
  "username": "xxxxxx0222",
  "password": "Sjmxxxxxx"
}'

# 发送POST请求并解析响应
response=$(curl -s -H "${headers[@]}" -d "$request_body" "$url")

# 检查响应是否为有效的JSON
if echo "$response" | jq . &> /dev/null; then
  echo "     校园网已登陆成功" | lolcat
  	killall nmcli
else
  echo "抱歉出现了一些错误"
  echo "Error: 响应不是有效的JSON格式"
  echo "Response content: $response"
  exit 1
fi
elif echo $nmline | grep full >/dev/null 2>&1;then
	echo 已登录2 | lolcat
	killall nmcli
fi
unset nmline
done
