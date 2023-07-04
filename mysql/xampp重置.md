```bash
cd /c/xampp/mysql
mv data dataold
cp -r backup data
cp -f dataold/ibdata1 data/ibdata1
cp -r -n "dataold"/* "data"
```



![](files/Pasted%20image%2020230704080518.png)