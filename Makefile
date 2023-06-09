SHELL := /bin/bash

include Makefile.config


.PHONY: help tf-fmt s3-creation tf-check tf-init tf-plan tf-deploy tf-destroy kubeconfig build-app push-app
.SILENT: help tf-fmt s3-creation tf-check tf-init tf-plan tf-deploy tf-destroy kubeconfig build-app push-app


DOCKER_USER =? dcristobal
DOCKER_APP_NAME =? node-get-open-ports
DOCKER_APP_VERSION =? latest


help:
	echo "s3-creation: Create S3 bucket for terraform state"
	echo "tf-check: Check terraform files"
	echo "tf-fmt: Format terraform files"
	echo "tf-init: Initialize terraform"
	echo "tf-plan: Create terraform plan"
	echo "tf-deploy: Deploy terraform plan"
	echo "tf-destroy: Destroy terraform plan"
	echo "kubeconfig: Get kubeconfig file"
	echo "build-app: Build docker image"
	echo "push-app: Push docker image to registry"
	echo "fetch-report: Fetch report from S3"

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

build-app:
	docker build -t dcristobal/node-get-open-ports:latest ./app_report/

push-app:
	docker push dcristobal/node-get-open-ports:latest

fetch-report:
	@cd report_puller && go build -o bin/fetch_report main.go
	@cd report_puller/bin && ./fetch_report