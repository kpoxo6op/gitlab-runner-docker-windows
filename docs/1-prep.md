# install terraform and google sdk

```sh
#!/bin/bash

# Installation directories
INSTALL_DIR="/usr/local/bin"
GCP_SDK_DIR="$HOME/google-cloud-sdk"

# Update and install dependencies
sudo apt-get update && sudo apt-get install -y curl unzip

# Download and install Terraform
curl -fsSL https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip -o terraform.zip
unzip terraform.zip
sudo mv terraform $INSTALL_DIR
rm terraform.zip

# Download and install Google Cloud SDK
curl -fsSL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-430.0.0-linux-x86_64.tar.gz -o google-cloud-sdk.tar.gz
tar -xzf google-cloud-sdk.tar.gz -C $HOME
rm google-cloud-sdk.tar.gz

# Initialize Google Cloud SDK
$GCP_SDK_DIR/install.sh
$GCP_SDK_DIR/bin/gcloud init --no-launch-browser

gcloud config set compute/region australia-southeast1

# choose create a new project
# create uniquely named project for tf state
# example: gitlab-agent-pwsh-tf-state

# enable billing account for the project
```
