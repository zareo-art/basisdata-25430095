select @@sql_mode;
select user, host from mysql.user where user = 'root';
ALTER USER 'root'@'localhost' IDENTIFIED BY 'penanda';
ALTER USER 'root'@'127.0.0.1' IDENTIFIED BY 'penanda';
ALTER USER 'root'@'::1'       IDENTIFIED BY 'penanda';
mysql -u root -p
CREATE DATABASE kopma_123
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON kopma_123.* TO 'mhs_123'@'localhost';
SHOW GRANTS FOR 'mhs_123'@'localhost';
show databases;
USE mysql;

git init
git add README.md p01_lingkungan_25430095.sql
git commit -m "p01: inisialisasi repositori dan skrip lingkungan"
git remote add origin https://github.com/zareo-art/basisdata-25430095.git
git push -u origin main