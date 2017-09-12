#!/bin/bash
#
# AWS AUTOMATION TRAINING
# SSH-Key automation script
# Raúl E. Linares N.
# August 14, 2017
#
# This script creates the ssh key (if not present)
# and import it to AWS interface.
#

mykeyname="tac-infra-01"
myawsregion="us-west-2"
bucketname="aws-tac-training-bucket"

if [ ! -f ~/.ssh/id_rsa_MASTER.pub ]
then
        ssh-keygen -t rsa -f ~/.ssh/id_rsa_MASTER -P ""
fi

if [ -f ~/.aws/credentials ]
then 
        aws --region $myawsregion ec2 \
        import-key-pair \
        --key-name $mykeyname \
        --public-key-material file://$HOME/.ssh/id_rsa_MASTER.pub

# Copy the newly created key to the bucket for later auto provisioning via metadata
	aws s3 cp ~/.ssh/id_rsa_MASTER.pub s3://$bucketname/keys/id_rsa_MASTER.pub
	aws s3 cp ~/.ssh/id_rsa_MASTER s3://$bucketname/keys/id_rsa_MASTER

fi

