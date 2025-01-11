# Deploying WordPress on AWS EC2

<!-- ![Three-Tier Architecture for WordPress](images/three-tier.png) -->

## Introduction
WordPress setup that’s scalable, secure, and resilient to traffic spikes! In this guide, we’ll deploy WordPress, dividing the setup into **Web**, **Application**, and **Database** layers for separation, security, and scalability.

## File Storage: EFS Setup
For scalable file storage, **Amazon Elastic File System (EFS)** will serve WordPress files across instances and mounted to `/var/www/html/`. 

### EFS Mount Script:
```bash
#!/bin/bash
# Mount EFS to /var/www/html
EFS_DNS_NAME=xxxxxxx
sudo mkdir -p /var/www/html
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "$EFS_DNS_NAME":/ /var/www/html
```
This ensures our `/var/www/html` directory (where WordPress lives) is backed by **EFS**, providing persistent storage that scales independently of the instances.