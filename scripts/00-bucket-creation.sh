#!/bin/bash
#
# AWS AUTOMATION TRAINING
# Bucket automation script
# Raúl E. Linares N.
# August 11, 2017
#
# This script creates and provision our private bucket
#

# Note the name of the bucket must be unique, because it's a global namespace
bucketname="aws-tac-training-bucket"
bucketregion="us-east-1"

if [ -f ~/.aws/credentials ]
then 
	aws s3api create-bucket \
		--bucket $bucketname \
		--acl private \
		--region $bucketregion

# Examples to copy any file on your PC/Laptop to the bucket. You may need excecute:
#	aws s3 cp ~/aws-gowlook-infra/bucket/placeholder s3://$bucketname/keys/placeholder.txt

	aws s3 cp ~/my-aws-training/bucket/placeholder.txt s3://$bucketname/files/placeholder.txt
	aws s3 cp ~/my-aws-training/bucket/placeholder.txt s3://$bucketname/keys/placeholder.txt
	aws s3 cp ~/my-aws-training/bucket/metadata-scripts/placeholder.txt s3://$bucketname/metadata-scripts/placeholder.txt
	aws s3 cp ~/my-aws-training/bucket/metadata-scripts/infrastructure/placeholder.txt s3://$bucketname/metadata-scripts/infrastructure/placeholder.txt
	aws s3 cp ~/my-aws-training/scripts/general-scripts/00-general-account-and-key-provisioning.sh s3://$bucketname/metadata-scripts/infrastructure/00-general-account-and-key-provisioning.sh

	# Tags for that bucket:
	aws s3api put-bucket-tagging \
		--bucket $bucketname \
		--tagging 'TagSet=[{Key=Group,Value=Training},{Key=Environment,Value=all}]'
fi

