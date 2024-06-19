#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset



script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ -f "$script_dir/.env" ]]; then
	echo "Loading .env"
	source "$script_dir/.env"
else
    echo "No .env file found - copy sample.env and fille out the values"
    exit 1
fi

if [[ -z "$LOCATION" ]]; then
  echo "LOCATION not specified"
  exit 1
fi
if [[ -z "$RESOURCE_GROUP" ]]; then
  echo "RESOURCE_GROUP not specified"
  exit 1
fi
if [[ -z "$APPLICATION_NAME" ]]; then
  echo "APPLICATION_NAME not specified"
  exit 1
fi

plan_name="${APPLICATION_NAME}-plan"

az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION

az appservice plan create \
    --name $plan_name \
    --resource-group $RESOURCE_GROUP \
    --sku B1 \
    --is-linux

az webapp create \
    --resource-group $RESOURCE_GROUP \
    --plan $plan_name \
    --name $APPLICATION_NAME \
    --runtime "PYTHON|3.9"

az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $APPLICATION_NAME \
    --settings SCM_DO_BUILD_DURING_DEPLOYMENT=True

az webapp config set \
    --resource-group $RESOURCE_GROUP \
    --name $APPLICATION_NAME \
    --startup-file "gunicorn main:app --worker-class uvicorn.workers.UvicornWorker"
