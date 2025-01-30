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


# nessary mounting efs utility
sudo yum -y install git rpm-build make rust cargo openssl-devel
git clone https://github.com/aws/efs-utils
cd efs-utils
make rpm
sudo yum -y install build/amazon-efs-utils*rpm

# environment variable
EFS_DNS_NAME=xxxxxx
EFS_ACCESS_POINT=xxxx
ENVIRONMENT_NAME=elevate-uat

# mount the efs to the html directory 
# echo "$EFS_DNS_NAME:/ /var/www/html nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" | sudo tee -a /etc/fstab
echo "$EFS_DNS_NAME /usr/share/nginx/html/$ENVIRONMENT_NAME efs _netdev,tls,context="system_u:object_r:httpd_sys_content_t:s0",accesspoint=$EFS_ACCESS_POINT 0 0" | sudo tee -a /etc/fstab
sudo mount -a

# set permissions
sudo chown nginx:nginx -R /usr/share/nginx/html/$ENVIRONMENT_NAME
sudo chmod 755 -R /usr/share/nginx/html/$ENVIRONMENT_NAME
# chcon -R -t httpd_sys_rw_content_t /elevate/

# restart the webserver
sudo systemctl restart nginx
sudo systemctl restart php-fpm

# install of code deploy agent
sudo yum install ruby -y
sudo yum install wget -y
mkdir ~/codedeploy_agent
cd ~/codedeploy_agent
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# install of cloud watch agent
mkdir ~/cloudwatch_agent
cd ~/cloudwatch_agent
wget https://amazoncloudwatch-agent.s3.amazonaws.com/redhat/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
sudo mkdir -p /usr/share/collectd/
sudo touch /usr/share/collectd/types.db
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

# install of ssm agent
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
# sudo systemctl status amazon-ssm-agent
