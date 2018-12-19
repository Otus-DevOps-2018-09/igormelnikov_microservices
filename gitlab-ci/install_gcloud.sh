#!/bin/bash
apt-get update
apt-get --assume-yes install make ca-certificates openssl python
update-ca-certificates
echo $GCLOUD_SERVICE_KEY > ${HOME}/gcloud-service-key.json
echo $GCLOUD_SERVICE_KEY
wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz
tar zxvf google-cloud-sdk.tar.gz && ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true
google-cloud-sdk/bin/gcloud --quiet components update
google-cloud-sdk/bin/gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
