// 登录脚本

const url = 'http://10.255.254.13/api/portal/v1/logout';

const headers = {
  'Accept': 'application/json, text/javascript, */*; q=0.01',
  'Accept-Encoding': 'gzip, deflate',
  'Accept-Language': 'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
  'Connection': 'keep-alive',
  'Content-Type': 'application/json; charset=UTF-8', 
  'DNT': '1',
  'Host': '10.255.254.13',
  'Origin': 'http://10.255.254.13',
  'Priority': 'u=0',
  'Referer': 'http://10.255.254.13/portal/index.html?v=202102142343',
  'Sec-GPC': '1',
  'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:131.0) Gecko/20100101 Firefox/131.0',
  'X-Requested-With': 'XMLHttpRequest'
};

// 构建请求体
const requestBody = {domain: "default"};

// 将请求体转换为JSON字符串
const body = JSON.stringify(requestBody);

fetch(url, {
  method: 'POST',
  headers: headers,
  body: body
})
  .then(response => response.json())
  .then(data => {
    console.log('Success:', data);
  })
  .catch((error) => {
    console.error('Error:', error);
  });