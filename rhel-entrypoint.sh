#!/bin/bash

# update the software packages on the ec2 instance 
sudo yum update -y

# install the apache web server, enable it to start on boot, and then start the server immediately
sudo yum install -y git nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# install php 8 along with several necessary extensions for wordpress to run
sudo yum install -y \
php \
php-cli \
php-cgi \
php-curl \
php-mbstring \
php-gd \
php-mysqlnd \
php-gettext \
php-json \
php-xml \
php-fpm \
php-intl \
php-zip \
php-bcmath \
php-ctype \
php-fileinfo \
php-openssl \
php-pdo \
php-tokenizer

# nessary mounting utilities
sudo yum install nfs-utils -y
sudo yum install cifs-utils -y

# environment variable
EFS_DNS_NAME=xxxxxx
EFS_FOLDER_NAME=
LOCAL_FOLDER_NAME=

# mount the efs to the html directory 
echo "$EFS_DNS_NAME:/$EFS_FOLDER_NAME /var/www/html nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" | sudo tee -a /etc/fstab
sudo mount -a

# set permissions
sudo chown nginx:nginx -R /var/www/html
sudo chmod 777 -R /var/www/html

# restart the webserver
sudo systemctl restart nginx
sudo systemctl restart php-fpm

# install code deploy agent
sudo yum install ruby -y
sudo yum install wget -y
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto