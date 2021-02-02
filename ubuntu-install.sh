#!/bin/sh
reset
# update and upgrade 
sudo apt-get update && apt-get upgrade
# LAMP Stack
sudo apt-get update && apt-get upgrade
sudo apt-get install apache2
sudo ufw allow in "Apache Full"
sudo apt-get install curl
sudo apt install mysql-server
sudo mysql_secure_installation
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
exit
sudo apt install php libapache2-mod-php php-mysql
sudo systemctl restart apache2
sudo systemctl status apache2
sudo apt install php-cli
sudo apt install package1 package2
sudo mkdir /var/www/orbit
sudo chown -R $USER:$USER /var/www/orbit
sudo chmod -R 755 /var/www/orbit
nano /var/www/orbit/index.php
sudo nano /etc/apache2/sites-available/orbit.conf
      <VirtualHost *:80>
				ServerAdmin webmaster@localhost
				ServerName orbit.collfuse.com
				ServerAlias orbit.collfuse.com
				DocumentRoot /var/www/orbit
				ErrorLog ${APACHE_LOG_DIR}/error.log
				CustomLog ${APACHE_LOG_DIR}/access.log combined
			</VirtualHost>
sudo a2ensite orbit.conf
sudo systemctl reload apache2
sudo a2dissite 000-default.conf
sudo a2ensite orbit.conf

# ROOT remote Login
sudo nano /etc/ssh/sshd_config
at the NEd add:
PermitRootLogin yes
sudo systemctl restart sshd

# Lets Encrypt
sudo apt-add-repository ppa:certbot/certbot
sudo apt install certbot
wget https://github.com/joohoi/acme-dns-certbot-joohoi/raw/master/acme-dns-auth.py
chmod +x acme-dns-auth.py
nano acme-dns-auth.py (add the 3 on first line)
#!/usr/bin/env python3
sudo mv acme-dns-auth.py /etc/letsencrypt/
sudo certbot certonly --manual --manual-auth-hook /etc/letsencrypt/acme-dns-auth.py --preferred-challenges dns --debug-challenges -d \*.collfuse.com -d collfuse.com
  Add CNAME on DNS Server
  certificate file:	/etc/letsencrypt/live/collfuse.com/fullchain.pem
  key file: /etc/letsencrypt/live/collfuse.com/privkey.pem
sudo nano /etc/apache2/sites-available/default-ssl.conf
  SSLCertificateFile      /etc/letsencrypt/live/collfuse.com/fullchain.pem
  SSLCertificateKeyFile /etc/letsencrypt/live/collfuse.com/privkey.pem
sudo nano /etc/apache2/sites-available/orbit.conf (add line inside)
  <VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName orbit.collfuse.com
    ServerAlias orbit.collfuse.com
    DocumentRoot /var/www/orbit
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    Redirect "/" "https://orbit.collfuse.com"
  </VirtualHost>
sudo nano /etc/apache2/sites-available
DocumentRoot /var/www/orbit
sudo ufw allow 'Apache Full'
sudo a2enmod ssl
sudo a2enmod headers
sudo a2ensite default-ssl
sudo apache2ctl configtest
sudo a2ensite orbit.conf
sudo systemctl reload apache2
sudo a2dissite 000-default.conf
sudo apache2ctl configtest
