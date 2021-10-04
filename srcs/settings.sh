#!/bin/sh
# fix NGINX and php 8
rm /etc/php/7.3/fpm/php.ini
cp ./php.ini /etc/php/7.3/fpm/
service php7.3-fpm start
# SSL
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/html.pem -keyout /etc/nginx/ssl/html.key -subj "/C=RU/ST=Kazan/L=Kazan/O=21 School/OU=rchallie/CN=html"
# Config NGINX
ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*
rm /var/www/html/index.nginx-debian.html
service nginx start && service mysql start && service php7.3-fpm restart
echo "CREATE USER 'admin'@'localhost' IDENTIFIED BY '123456';" | mysql -u root --skip-password
echo "CREATE DATABASE myDB;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON myDB.* TO 'admin'@'localhost';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password
echo "CREATE DATABASE wp_database;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wp_database.* TO 'admin'@'localhost';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
cd /var/www/html
wp core download --allow-root
wp core config --allow-root --dbname=wp_database --dbuser=admin --dbpass=123456 --dbhost=localhost --dbprefix=wp_
wp core install --allow-root --url="localhost"  --title="ecole 21" --admin_user="admin" --admin_password="123456" --admin_email="denis.nadey@gmail.com"
bash
