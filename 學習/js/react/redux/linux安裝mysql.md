``` bash
sudo apt-get install mysql-server
vi /etc/mysql/mysql.conf.d/mysqld.cnf
mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
flush privileges;
service mysql restart
mysql -u root -p

mysql> CREATE USER 'root'@'%' IDENTIFIED BY 'PASSWORD';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
mysql> FLUSH PRIVILEGES;
service mysql restart


```