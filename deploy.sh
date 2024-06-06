#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Add your script code here
RESOURCE_GROUP=[YOUR-RESOURCE-GROUP-NAME]
APPLICATION_NAME=[YOUR-WEB-APP-NAME]

pushd source

cp main.py ../deployment/
cp requirements.txt ../deployment/

popd
pushd deployment

pip install -r requirements.txt -t .python_packages

zip -r deployment.zip .

popd

az webapp deploy \
    --resource-group $RESOURCE_GROUP \
    --name $APPLICATION_NAME \
    --src-path deployment/deployment.zip

az webapp config set \
    --resource-group $RESOURCE_GROUP \
    --name $APPLICATION_NAME \
    --startup-file "uvicorn main:app"