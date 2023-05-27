#!/bin/bash

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

# Set the name of your EKS cluster
cluster_name="diego-eks-assessment"

# Set the path to save the kubeconfig file
kubeconfig_path="./cluster-kubeconfig"

# Generate kubeconfig using AWS CLI
aws eks update-kubeconfig --name "$cluster_name" --region "$AWS_DEFAULT_REGION" --kubeconfig "$kubeconfig_path"

echo "kubeconfig file created successfully at $kubeconfig_path"
