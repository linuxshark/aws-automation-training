#!/bin/bash
#
# By Raúl E. Linares N.
# linares.voip@gmail.com
# August 15, 2017
#
# AWS Automation training.
# General account provisioning script
#

# Basic PATH Set here.
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Bucket name
bucketname="aws-tac-training-bucket"
s3keyMASTER="keys/id_rsa_MASTER.pub"
keyMASTER="id_rsa_MASTER.pub"

mkdir -p /home/infrastructure/.ssh
mkdir -p /home/development/.ssh

mkdir /tmp/PROVTEMP

aws s3 cp s3://$bucketname/$s3keyMASTER  /tmp/PROVTEMP/

cat /tmp/PROVTEMP/$keyMASTER > /home/infrastructure/.ssh/authorized_keys
cat /tmp/PROVTEMP/$keyMASTER > /home/development/.ssh/authorized_keys
chown -R infrastructure.infrastructure /home/infrastructure/.ssh
chown -R development.development /home/development/.ssh
chmod 700 /home/infrastructure/.ssh
chmod 700 /home/development/.ssh
chmod 600 /home/infrastructure/.ssh/authorized_keys
chmod 600 /home/development/.ssh/authorized_keys

rm -rf /tmp/PROVTEMP
