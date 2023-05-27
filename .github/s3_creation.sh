#!/bin/bash

# Set the name of your S3 bucket
bucket_name="terraform-state-assessment"

# Check if AWS access key ID is set
if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
    echo "AWS access key ID is not set. Please set the 'AWS_ACCESS_KEY_ID' environment variable."
    exit 1
fi

# Check if AWS secret access key is set
if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo "AWS secret access key is not set. Please set the 'AWS_SECRET_ACCESS_KEY' environment variable."
    exit 1
fi

# Check if AWS default region is set
if [[ -z "$AWS_DEFAULT_REGION" ]]; then
    echo "AWS default region is not set. Please set the 'AWS_DEFAULT_REGION' environment variable."
    exit 1
fi

# Check if the bucket already exists
bucket_exists=$(aws s3 ls "s3://$bucket_name" 2>&1)

if [[ $bucket_exists == *"NoSuchBucket"* ]]; then
    echo "Bucket '$bucket_name' does not exist. Creating..."
    aws s3 mb "s3://$bucket_name"
    echo "Bucket created successfully!"
else
    echo "Bucket '$bucket_name' already exists."
fi
