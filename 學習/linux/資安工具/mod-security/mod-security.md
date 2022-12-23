# ModSecurity
## 什麼是ModSecurity
### ModSecurity是免費的開源Web應用程式，防止典型Web應用程式攻擊，如[[XSS]]和[[SQL注入]]
---
部屬的方式有兩種架構Embedded及Reverse proxy
Embedded是直接在Apache上開啟模組，跟被保護網頁共用一個Web伺服器
Reverse proxy是在前端在建立一個Web伺服器，用Proxy建立反向代理的方式保護後端Web
--- 

## 安裝流程
1. 安裝相依套件然後從modsecurity github複製
2. 初始化與更新執行腳本
3. 下載連接器
4. nginx建立所需的modules
5. 設定規則(從OWASP-CRS)
6. 在nginx調整modsecurity設定
7. 重啟

---


## 介紹modsecurity



--- 


ModSecurity是有分五個階段，這五個階段，基本就是從一個web請求，到達服務器到服務器響應的一個過程，分別是以下階段：

--- 
1. Phase Request Headers 請求頭階段:
Apache完成讀取請求頭（post-read-request階段）後立即處理此階段中的規則。在這個時候還沒有讀取請求體，所以這個時候對所有請求參數並不是都可用。如果需要提前運行規則（在Apache對請求執行某些操作之前），在請求體讀取之前執行某些操作，您需確定是否應該緩存請求體，或者決定如何將規則置於此階段（例如，是否將其解析為XML）。
--- 

2. Phase Request Body 請求體階段:
請求體階段是通用的輸入分析階段，大多數面向應用程序的規則都放在這裡。在這個階段是可以收到所有的請求參數，當然這個前提是請求主體是已經讀取的。在此階段ModSecurity支持請求正文階段的三種編碼類型：

    1. application/x-www-form-urlencoded 用於傳輸表單數據
    2. multipart/form-data 用於文件上傳
    3. text/xml 用於傳遞XML數據
大多數Web應用程序不使用其他編碼。

--- 
3. Phase Response Headers 響應頭階段:
此階段發生在響應頭被發送回客戶端之前。如果要在此之前檢查響應，以及是否要使用響應頭來決定是否要緩存響應體，可以講將規則配置為此階段。需要注意的是，某些響應狀態碼（例如404）由於在Apache請求週期的早期處理，因此此類訪問是無法觸發ModSecurity的規則。此外，還有一些響應頭由Apache在稍後的掛鉤（例如日期，服務器和連接）中添加，ModSecurity也無法觸發或檢查。這應該在代理設置中或階段5（日誌記錄）中進行配置。

--- 
4. Phase Response Body 響應體階段:
響應體階段是通用輸出分析階段。此時的響應體是應該要已經被緩存的，然後運行規則檢查響應體。在此階段，可以檢查出站HTML來判斷是否有信息洩露，是否包含錯誤消息或是失敗的身份驗證文本。

--- 
5. Phase Logging 日誌階段:
該階段在日誌記錄發生之前運行。進入此階段的規則只會影響日誌記錄的執行方式。此階段可用於檢查Apache記錄的錯誤消息。但是不能在此階段拒絕/阻斷連接，因為已經太晚了。此階段還允許檢查在階段3或者階段4期間不可用的其他響應頭。需要注意的是，在這個階段不要將拒絕/阻斷操作繼承到規則中，因為這樣本身是一個配置的錯誤。
--- 
### 規則配置
modsecurity.conf
![](https://i.imgur.com/VTUeyGB.png)
SecRuleEngine
```
SecRuleEngine DetectionOnly|On|Off
```
改為On 開啟

--- 
所以需要載入
[owasp-modsecurity-crs](https://github.com/SpiderLabs/owasp-modsecurity-crs/tree/v3.3/dev/rules)

nginx設定檔開啟modsecurity並指定規則檔案路徑(main.conf)
![](https://i.imgur.com/T4Mtnvi.png)

--- 
main.conf內容
![](https://i.imgur.com/BgUo3ch.png)

---
1. modsecurity.conf  
上述配置檔
2. crs-setup.conf   
使用默認配置
4. rules/*.conf
一堆規則
![](https://i.imgur.com/h9fbd3t.png)

--- 

參考
[ModSecurity安装了，不懂原理和规则？这篇帮你搞定](https://cloud.tencent.com/developer/article/1791249)
[Modsecurity原理分析--从防御方面谈WAF的绕过](https://wooyun.js.org/drops/Modsecurity%E5%8E%9F%E7%90%86%E5%88%86%E6%9E%90--%E4%BB%8E%E9%98%B2%E5%BE%A1%E6%96%B9%E9%9D%A2%E8%B0%88WAF%E7%9A%84%E7%BB%95%E8%BF%87%EF%BC%88%E4%B8%80%EF%BC%89.html)
[開源OWASP CRS規則](https://blog.51cto.com/u_14153008/4562371)

--- 
### modsecurity-crs
目前規則對應連結
[Web 應用程式防火牆 CRS 規則群組和規則 (機器翻譯)](https://docs.microsoft.com/zh-tw/azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules?tabs=owasp32)

[OWASP ModSecurity CRS 3.0 核心规则集详解](https://f2ex.cn/modsecurity-crs-3-list/)

[中文舊版對照](https://blog.slogra.com/doc/modsecurity_crs.html)

---
## 安裝ModSecurity
### 安裝建構和編譯過程所需要依賴項
```
sudo apt update
```
```
sudo apt install make gcc build-essential autoconf automake libtool libfuzzy-dev ssdeep gettext pkg-config libcurl4-openssl-dev liblua5.3-dev libpcre3 libpcre3-dev libxml2 libxml2-dev libyajl-dev doxygen libcurl4 libgeoip-dev libssl-dev zlib1g-dev libxslt-dev liblmdb-dev libpcre++-dev libgd-dev
```
### 從ModSecurity Github 複製
```
cd /opt 
```
```
sudo git clone https://github.com/SpiderLabs/ModSecurity
```

---

### 初始化與更新及執行腳本
```
cd ModSecurity
```
```
sudo git submodule init
```
```
sudo git submodule update
```
```
sudo ./build.sh
```
```
sudo ./configure
```
```
sudo make
```
```
sudo make install
```

--- 

### 下載ModSecurity-Nginx Connector
```
cd /opt
```
```
sudo git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git
```

--- 

### nginx建立modSecurity所需modules
```
apt install nginx
```
先看版本
```
nginx -v
```
假設版本為nginx-1.18.0
```
cd /opt
```
```
sudo wget http://nginx.org/download/nginx-1.18.0.tar.gz
```
解壓縮
```
sudo tar -xvzmf nginx-1.18.0.tar.gz
```
```
cd nginx-1.18.0
```

--- 

看詳細配置
```
nginx -V
```
顯示如下
```
nginx version: nginx/1.18.0 (Ubuntu)
built with OpenSSL 1.1.1  11 Sep 2018
TLS SNI support enabled
configure arguments:<Configure Arguments>
```
需要複製configure arguments後的Configure Arguments
```
sudo ./configure --add-dynamic-module=../ModSecurity-nginx <Configure Arguments>
```
建構modules
```
sudo make modules
```

--- 

到nginx配置中建立目錄把編譯好的modules複製過去
```
sudo mkdir /etc/nginx/modules
```
```
sudo cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules
```
nginx加載modSecurity modules
```
vim /etc/nginx/nginx.conf
```
內容如下
```
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;
```

--- 

### 設定OWASP-CRS
刪除當前規則
```
sudo rm -rf /usr/share/modsecurity-crs
```
下載OWASP-CRS GitHub到/usr/share/modsecurity-crs
```
sudo git clone https://github.com/coreruleset/coreruleset /usr/local/modsecurity-crs
```
重新命名crs-setup.conf.example跟預設排除規則文件
```
sudo mv /usr/local/modsecurity-crs/crs-setup.conf.example /usr/local/modsecurity-crs/crs-setup.conf
```
```
sudo mv /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
```

--- 

### 設定ModSecurity
在nginx建立modsec
```
sudo mkdir -p /etc/nginx/modsec
```
複製clone出來的unicode.mapping及modsecurity.conf-recommended到modsec
```
sudo cp /opt/ModSecurity/unicode.mapping /etc/nginx/modsec 
```
```
sudo cp /opt/ModSecurity/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf
```

--- 

改掉modsecurity裡面的-recommended檔名
```
cd /opt/ModSecurity
```
```
mv modsecurity.conf-recommended modsecurity.conf
```
```
cp modsecurity.conf /etc/nginx/modsec/
```
```
```
更改/etc/nginx/modsec/modsecurity.conf的值：`SecRuleEngine On`
```
vim /etc/nginx/modsec/modsecurity.conf
```
--- 

//更改為下
```
SecRuleEngine On
```
nginx配置下引入一些規則
```
vim /etc/nginx/modsec/main.conf
```
內容如下
```
Include /etc/nginx/modsec/modsecurity.conf 
Include /usr/local/modsecurity-crs/crs-setup.conf 
Include /usr/local/modsecurity-crs/rules/*.conf
```

--- 

### 配置nginx
將規則加入及打開modsecurity
```
vim /etc/nginx/sites-available/default
```
--- 

內容如下
```
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        modsecurity on;
        modsecurity_rules_file /etc/nginx/modsec/main.conf;

        index index.html index.htm index.nginx-debian.html;

        server_name _;
        location / {
                try_files $uri $uri/ =404;
	        }
	    }
```
重啟nginx
```
nginx -t
sudo systemctl restart nginx
```
### 測試
網址輸入
http://ip/?exec=/bin/bash
http://ip/<script>alert(document.cookie)</script>
http://ip?productid=123 or 1=1


--- 
