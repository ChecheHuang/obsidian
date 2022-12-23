# WAF
Web應用防護牆（Web Application Firewall，簡稱WAF）是通過執行一系列針對HTTP/HTTPS的安全策略來專門為Web應用提供保護的一款產品，主要用於防禦針對網絡應用層的攻擊，像SQL注入、跨站腳本攻擊、參數篡改、應用平台漏洞攻擊、拒絕服務攻擊等。

---
![](https://i.imgur.com/zm11QG9.png)

---
## WAF與傳統Firewall的差異
WAF是Web Application Firewall的縮寫，為針對網站服務內容的防護，WAF與傳統Firewall的最主要差異在於辨識特徵的資料層級不同。

傳統Firewall主要辨識的範圍為封包傳輸位置（IP address）與應用程式的傳輸埠號（port number），而這兩個資訊分屬OSI模型的第三層（Ｎetwork layer）與第四層（Transport layer），因此一般也稱傳統Firewall為 L4 Firewall，意指它的工作層級最多到第四層，所以無法辨識包在傳輸資訊裡的第七層應用程式內容。

WAF主要的防護目標為OSI 7 layer第七層的Web應用服務，意味著WAF能辨識包在傳輸資訊內的Web應用程式內容。

---

![](https://i.imgur.com/JVObw3x.png)

---
## WAF與傳統Firewall各自如何應對L7攻擊，？
以下以惡意爬蟲為例，說明WAF（Web Application Firewall）優於傳統Firewall之處。

---
傳統Firewall（L4 Firewall）阻擋惡意爬蟲的限制

傳統Firewall只能針對來源IP或端口（port number）阻攔惡意請求，意思是只能辨識「來自那裡」、「要去那裡」、「要找誰」，無法辨識包在傳輸資訊內與網路爬蟲相關的HTTP表頭。因此，只能依靠網站管理者分析爬蟲的內容來自那裡，再以來源位置區分該阻攔、允許或限制頻寬。倘若攻擊來源來自多個位置，因來源不停更換，管理者也必須不斷更新阻攔名單才能正確阻擋。否則如果直接阻攔一整個區域，極有可能會攔阻到來自相同區域的正常使用者。

---
WAF能過濾、監控、阻擋Http流量，阻攔特定爬蟲行為
WAF（Web Application Firewall）能辨識包在傳輸資訊內的HTTP表頭，讓網站管理者除了能依照來源IP位置作阻攔外，WAF能針對HTTP的User-Agent表頭內的網路爬蟲資訊，如：Baiduspider、Googlebot、Bingbot等阻攔特定爬蟲行為。

---
![](https://i.imgur.com/FEjYiKy.png)
