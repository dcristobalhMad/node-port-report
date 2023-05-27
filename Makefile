SHELL := /bin/bash

.PHONY: help tf-fmt s3-creation tf-check tf-init tf-plan tf-deploy tf-destroy kubeconfig
.SILENT: help tf-fmt s3-creation tf-check tf-init tf-plan tf-deploy tf-destroy kubeconfig

help:
	echo "s3-creation: Create S3 bucket for terraform state"
	echo "tf-check: Check terraform files"
	echo "tf-fmt: Format terraform files"
	echo "tf-init: Initialize terraform"
	echo "tf-plan: Create terraform plan"
	echo "tf-deploy: Deploy terraform plan"
	echo "tf-destroy: Destroy terraform plan"
	echo "kubeconfig: Get kubeconfig file"

s3-creation:
	bash .github/s3_creation.sh

tf-fmt:
	cd infra && terraform fmt

tf-check:
	cd infra && terraform fmt -check

tf-init: s3-creation
	cd infra && terraform init

tf-plan: tf-init
	cd infra && terraform plan -out=tfplan

tf-deploy: tf-plan
	cd infra && terraform init && terraform apply -auto-approve tfplan

tf-destroy:
	cd infra && terraform destroy -auto-approve

kubeconfig:
	bash .github/get_kubeconfig.sh
