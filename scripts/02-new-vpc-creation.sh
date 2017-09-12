#!/bin/bash
#
# AWS AUTOMATION TRAINING
# VPC automation script
# Raúl E. Linares N.
# August 11, 2017
#
# This script creates the VPC and all its related elements
# 
#

mycidr="192.168.0.0/16"
subnetbase="192.168"
counter="0"
myazlist="us-west-2a us-west-2b us-west-2c"

if [ -f ~/.aws/credentials ]
then
	# First, we proceed to create the VPC with the desired cidr block
	aws ec2 create-vpc --cidr-block $mycidr

	# With the cidr block, we obtain the VPC id
	myvpcid=`aws ec2 describe-vpcs --output=text --filters Name=cidr,Values=$mycidr --query "Vpcs[*].VpcId"`

	aws ec2 modify-vpc-attribute --vpc-id $myvpcid --enable-dns-hostnames "{\"Value\":true}"
	aws ec2 modify-vpc-attribute --vpc-id $myvpcid --enable-dns-support "{\"Value\":true}"

	# With the VPC, our cidr base, and our subnet list, time to create our subnets
	for myaz in $myazlist
	do
		counter=$[counter+1]
		mysubnet="$subnetbase.$counter.0/24"
		echo $counter
		echo $mysubnet
		echo $myvpcid
		echo $myaz
		aws ec2 create-subnet --vpc-id $myvpcid --cidr-block $mysubnet --availability-zone $myaz
	done

	# Set all subnets to auto-assign the public IP:
	subnetlist=`aws ec2 describe-subnets --filter Name=vpc-id,Values=$myvpcid --output=text --query "Subnets[*].SubnetId"`
	for mysubnet in $subnetlist
	do
		aws ec2 modify-subnet-attribute --subnet-id $mysubnet --map-public-ip-on-launch
                aws ec2 create-tags --resources $mysubnet --tags Key=Environment,Value=testing
                aws ec2 create-tags --resources $mysubnet --tags Key=Group,Value=tactraining
                subnetaz=`aws ec2 describe-subnets --subnet-ids $mysubnet --output text --query Subnets[*].AvailabilityZone`
                aws ec2 create-tags --resources $mysubnet --tags Key=Name,Value=tac-training-vpc-subnet-$subnetaz
	done

	# Subnets and VPC readys. Let's create and attach an internet gateway:
	myinternetgw=`aws ec2 create-internet-gateway --output text|grep -i "INTERNETGATEWAY"|awk '{print $2}'`
	
	aws ec2 attach-internet-gateway --internet-gateway-id $myinternetgw --vpc-id $myvpcid

	# Finally, the route table for our VPC:
	myroutetable=`aws ec2 describe-route-tables --filters Name=vpc-id,Values=$myvpcid --output=text|grep -i ROUTETABLES|awk '{print $2}'`
	aws ec2 create-route --route-table-id $myroutetable --gateway-id $myinternetgw --destination-cidr-block 0.0.0.0/0

	# Tags
	aws ec2 create-tags --resources $myvpcid --tags Key=Environment,Value=training
	aws ec2 create-tags --resources $myvpcid --tags Key=Name,Value=main-tactraining-prod-vpc-cidr-192-168-0-0-us-west-1
	aws ec2 create-tags --resources $myvpcid --tags Key=Group,Value=tactraining
	
fi



