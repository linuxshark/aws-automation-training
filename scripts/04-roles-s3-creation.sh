#!/bin/bash
#
# AWS AUTOMATION TRAINING
# S3-RO Roles automation script
# Raúl E. Linares N.
# August 24, 2017
#
# This script creates the ROLES for S3 Access/PUT
# 
#

if [ -f ~/.aws/credentials ]
then

	# First, S3 RO Access
	aws iam create-role \
		--role-name aws-tac-prod-s3-ro \
		--assume-role-policy-document \
		file://~/my-aws-training/aws-roles/role-instance-basic.json

	aws iam put-role-policy \
		--role-name aws-tac-prod-s3-ro \
		--policy-name s3-ro-access --policy-document \
		file://~/my-aws-training/aws-roles/s3-list-role.json

	aws iam create-instance-profile \
		--instance-profile-name aws-tac-prod-s3-ro-profile

	aws iam add-role-to-instance-profile \
		--instance-profile-name aws-tac-prod-s3-ro-profile --role-name aws-tac-prod-s3-ro


	# Second, S3 RO plus PUT Access
	aws iam create-role \
		--role-name aws-tac-prod-s3-ro-put \
		--assume-role-policy-document \
		file://~/my-aws-training/aws-roles/role-instance-basic.json

	aws iam put-role-policy \
		--role-name aws-tac-prod-s3-ro-put \
		--policy-name s3-ro-put-access --policy-document \
		file://~/my-aws-training/aws-roles/s3-list-put-role.json

	aws iam create-instance-profile \
		--instance-profile-name aws-tac-prod-s3-ro-put-profile

	aws iam add-role-to-instance-profile \
		--instance-profile-name aws-tac-prod-s3-ro-put-profile --role-name aws-tac-prod-s3-ro-put

fi

