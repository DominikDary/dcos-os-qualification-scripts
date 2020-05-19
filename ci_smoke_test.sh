#!/bin/bash
# Required environment variables:
# GOOGLE_APPLICATION_CREDENTIALS=the path to your service account credentials file - or - GCP_CREDENTIALS: your service account json string
# GCP_PROJECT=the name of your project e.g. development-12345
# TERRAFORM_PATH=the path to your terraform binary; will default to "terraform"
set -euxo pipefail

ssh-keygen -f id_rsa -t rsa -N ''
chmod 600 id_rsa

# Download the terraform binary in the current directory
wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
unzip ./terraform*.zip
chmod +x terraform
rm ./terraform*.zip

if [[ ! -v TERRAFORM_PATH ]]
then
  TERRAFORM_PATH="terraform"
fi


cd ../aws
${TERRAFORM_PATH} init
${TERRAFORM_PATH} validate
${TERRAFORM_PATH} plan
${TERRAFORM_PATH} validate -var-file desired_cluster_profile.tfvars.example
${TERRAFORM_PATH} plan -var-file desired_cluster_profile.tfvars.example