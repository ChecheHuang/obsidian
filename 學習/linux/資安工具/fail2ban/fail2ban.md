安裝fail2ban
```
apt-get install fail2ban
```
```
vim /etc/fail2ban/jail.local
```
```
[http-get-dos]
enabled = true
port = http
filter = http-get-dos
logpath = /var/log/nginx/access.log
maxretry = 5 
findtime = 10
bantime = 10
action = iptables[name=HTTP, port=http, protocol=tcp]
```
```
vim /etc/fail2ban/filter.d/http-get-dos.conf
```
```
[Definition]
failregex = ^<HOST> - - .*\"(GET|POST).*
ignoreregex =
```
```
service fail2ban restart
```
查看log
```
vi /var/log/fail2ban.log
```
```
fail2ban-client status
```
[[fai2ban介紹]]