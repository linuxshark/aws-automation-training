#!/bin/bash
#
# AWS AUTOMATION TRAINING
# Sec-group creation script
# Raúl E. Linares N.
# August 15, 2017
#
# This script automates the secgroup creation for the main 
# production environment in the custom vpc
#
#

secgroupname="aws-training-secgrp-01"

mycidr="192.168.0.0/16"

# We need to know the ID of the VPC to which we will apply the rules of the security group

vpcid=`aws ec2 describe-vpcs --output=text --filters Name=cidr,Values=$mycidr --query "Vpcs[*].VpcId"`

if [ -f ~/.aws/credentials ]
then
        aws ec2 create-security-group --group-name $secgroupname --description "AWS TAC-training Frontend Sec-Group 01" --vpc-id $vpcid
	mygroupid=`aws ec2 describe-security-groups --filters Name=group-name,Values=$secgroupname Name=vpc-id,Values=$vpcid --output=text --query "SecurityGroups[*].GroupId"`
	echo "GroupID: $mygroupid"

	# Inbound traffic rules
        aws ec2 authorize-security-group-ingress --group-id $mygroupid --protocol tcp --port 22 --cidr 0.0.0.0/0
        aws ec2 authorize-security-group-ingress --group-id $mygroupid --protocol tcp --port 80 --cidr 0.0.0.0/0
        aws ec2 authorize-security-group-ingress --group-id $mygroupid --protocol tcp --port 443 --cidr 0.0.0.0/0
        aws ec2 authorize-security-group-ingress --group-id $mygroupid --protocol tcp --port 8080 --cidr 0.0.0.0/0

	# Tags
        aws ec2 create-tags --resources $mygroupid --tags Key=Environment,Value=testing
        aws ec2 create-tags --resources $mygroupid --tags Key=Applayer,Value=webfrontend
        aws ec2 create-tags --resources $mygroupid --tags Key=Name,Value=$secgroupname
        aws ec2 create-tags --resources $mygroupid --tags Key=Group,Value=training

fi

