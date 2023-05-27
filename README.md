# Node report assessment

## Description

Periodic report of all the Kubernetes nodes opened ports, with an easy-to-parse output, similar to:

Node1: [22,80,443]
Master1: [22,443]

## Requirements

If you want to run the code locally you will need:

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
