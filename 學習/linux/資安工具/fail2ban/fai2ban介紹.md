Fail2ban是什麼?
Fail2ban 是一個用來防止暴力法攻擊的防護工具，它會定期掃描系統的紀錄檔，尋找符合條件的網路攻擊來源，當次數達到門檻值的時候，就透過設置防火牆的方式暫時阻擋網路攻擊的來源 IP 位址，過了一段時間之後才會再度開放。

---
etc/fail2ban結構
![[Pasted image 20220822111457.png]]

---

action.d/*.conf 
阻擋攻擊的規則設定

---

jail.conf 與 jail.d/*.conf
定義各系統服務用的 filters 與 actions 組合。
![[Pasted image 20220822114122.png]]

---

filter.d/*.conf
識別攻擊的規則設定
![[Pasted image 20220822114257.png]]

依據nginx/access.log裡面的規則去限制
![[Pasted image 20220822114806.png]]

---
測試
![[Pasted image 20220822115820.png]]
---


啟用fail2ban
兩種方式查看是否自訂規則有啟用
查看log
```
more /var/log/fail2ban.log
```

![[Pasted image 20220822115133.png]]

---
使用fail2ban-client
```
fail2ban-client status
```
![[Pasted image 20220822115940.png]]
```
fail2ban-client status http-get-dos
```
![[Pasted image 20220822120035.png]]

