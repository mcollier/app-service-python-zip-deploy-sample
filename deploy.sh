#!/bin/bash

# Add your script code here
RESOURCE_GROUP=rg-app-service-python-sample
LOCATION=westeurope
APPLICATION_NAME=python-msc-hello

cp main.py deployment
cp requirements.txt deployment

pip install -r deployment/requirements.txt -t deployment

pushd deployment

zip -r deployment.zip .

popd

az webapp deploy \
    --resource-group $RESOURCE_GROUP \
    --name $APPLICATION_NAME \
    --src-path deployment/deployment.zip