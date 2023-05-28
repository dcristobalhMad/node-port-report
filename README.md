# Node report assessment

## Description

Periodic report of all the Kubernetes nodes opened ports, with an easy-to-parse output, similar to:

Node1: [22,80,443]
Node2: [22,443]
Master1: [22,443]

## Requirements

If you want to run the code locally you will need:

- Set the environment variables AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, MAIL_PASSWORD, MAIL_USER
- aws credentials configured
- awscli
- terraform

## Infrastructure

The infrastructure is composed by a Kubernetes cluster in AWS with 2 managed node groups and an S3 bucket to push/pull the daily report. All will be created by Terraform and automated by github actions when push to master branch but you can also run it manually with the following steps:

- To check all Makefile commands you can run:

```bash
make help
```

- Create a S3 bucket to store the Terraform state

```bash
make s3-creation
```

- Check the Terraform plan

```bash
make tf-plan
```

- Deploy the eks cluster and the node groups

```bash
make tf-deploy
```

- Get the kubeconfig file

```bash
make kubeconfig
```

## Application

In app_report folder there are 4 files:

- Dockerfile: to build the docker image
- check_ports.py: the python script to check the opened ports
- requirements.txt: the python dependencies
- whitelist.txt: the whitelist of ports to ignore

The script will check the opened ports in all the nodes and will generate a report in the following format:

```bash
Node1: [22,80,443]
Node2: [22,443]
Master1: [22,443]
```

In kubernetes folder there are 4 files:

- cronjob.yaml: the cronjob to run the script every day at 00:00
- rbac.yaml: the role and rolebinding to allow the cronjob to have permissions to run the script for getting node information
- serviceaccount.yaml: the service account for the cronjob with the aws role attached
- kustomization.yaml: the kustomization file to deploy all the previous files

The cronjob will run the script and will push the report to the S3 bucket called "s3-report-bucket-diego"

## Fetch report

## Pipelines

The pipelines are configured in .github/workflows folder:

- infra.yml: to deploy the terraform infrastructure from every push to master branch
- app-build.yml: to build and to deploy the application from a tag in semver format

## Improvements

- Add gitops paradigm to deploy the manifests
- Add a helm chart to deploy the application
- Build a lightweight docker image
- Add a e2e test in the pipeline raising a kind cluster and running the script
- Add shellcheck and linters to the pipeline
