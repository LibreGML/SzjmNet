$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36 Edg/129.0.0.0"
Invoke-WebRequest -UseBasicParsing -Uri "http://10.255.254.13/api/portal/v1/login" `
-Method "POST" `
-WebSession $session `
-Headers @{
"Accept"="application/json, text/javascript, */*; q=0.01"
  "Accept-Encoding"="gzip, deflate"
  "Accept-Language"="zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
  "Origin"="http://10.255.254.13"
  "Referer"="http://10.255.254.13/portal/mobile.html?v=202108261127"
  "X-Requested-With"="XMLHttpRequest"
} `
-ContentType "application/x-www-form-urlencoded; charset=UTF-8" `
-Body "{`"domain`":`"telecom`",`"username`":`"2403290222`",`"password`":`"Sjm027312`"}"