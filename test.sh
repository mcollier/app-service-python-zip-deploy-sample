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

if [[ -z "$RESOURCE_GROUP" ]]; then
  echo "RESOURCE_GROUP not specified"
  exit 1
fi
if [[ -z "$APPLICATION_NAME" ]]; then
  echo "APPLICATION_NAME not specified"
  exit 1
fi

host_name=$(az webapp show --resource-group "$RESOURCE_GROUP" --name "$APPLICATION_NAME" -o json --query defaultHostName -o tsv)

echo "Host name: $host_name"

watch curl -s "https://$host_name"