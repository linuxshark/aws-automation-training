#!/bin/bash
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install awscli
DEBIAN_FRONTEND=noninteractive apt-get -y install python-pip
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip
add-apt-repository -y -u ppa:certbot/certbot
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install certbot python-certbot
DEBIAN_FRONTEND=noninteractive apt-get -y install nginx-full
DEBIAN_FRONTEND=noninteractive apt-get -y install mariadb-client
DEBIAN_FRONTEND=noninteractive apt-get -y install default-jdk
# Choose only one of them:
# Apache:
# DEBIAN_FRONTEND=noninteractive apt-get -y install python-certbot-apache
# Nginx:
DEBIAN_FRONTEND=noninteractive apt-get -y install python-certbot-nginx
# Or, use "pip"
# pip install certbot-nginx
# pip install certbot-apache
# Now, let's install apache and change both apache and nginx to make
# them work along nicely
systemctl stop nginx
systemctl start nginx
systemctl enable nginx
#
mkdir -p /root/.aws
echo "[default]" > /root/.aws/config
echo "output = text" >> /root/.aws/config
echo "region = us-west-2" >> /root/.aws/config
groupadd infra
groupadd devel
echo "%infra ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10-tac-infra-users
echo "%devel ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/20-tac-devel-users
chmod 0440 /etc/sudoers.d/*tac*
useradd -c "Generic Infrastructure User" -s /bin/bash -m -d /home/infrastructure -G infra infrastructure
useradd -c "Generic Development User" -s /bin/bash -m -d /home/development -G devel development

# Account keys self-provisioning from the bucket
infrabucketname="aws-tac-training-bucket"
aws s3 cp \
s3://$infrabucketname/metadata-scripts/infrastructure/00-general-account-and-key-provisioning.sh \
/root/00-general-account-and-key-provisioning.sh
chmod 755 /root/00-general-account-and-key-provisioning.sh
/root/00-general-account-and-key-provisioning.sh

