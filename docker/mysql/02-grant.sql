-- schema.sql이 만든 moari_db에 대한 권한을 앱 계정(moari)에 부여
GRANT ALL PRIVILEGES ON moari_db.* TO 'moari'@'%';
FLUSH PRIVILEGES;
