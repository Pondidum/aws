#!/bin/bash

sudo apt-get update
sudo apt-get install -y --no-install-recommends curl jq unzip git

PACKER_LATEST_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r -M '.current_version')

curl https://releases.hashicorp.com/packer/${PACKER_LATEST_VERSION}/packer_${PACKER_LATEST_VERSION}_linux_amd64.zip --output /tmp/packer_linux_amd64.zip

sudo unzip /tmp/packer_linux_amd64.zip -d /usr/local/bin/

rm -f /tmp/packer_linux_amd64.zip
