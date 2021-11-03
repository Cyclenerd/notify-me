#!/usr/bin/env bash

# Create a new Artifact Registry repository for Docker images
# https://cloud.google.com/artifact-registry/docs/manage-repos

MY_DEFAULT_CONFIG="./default_config"
MY_CONFIG="./my_config"
echo "Load default config file '$MY_DEFAULT_CONFIG'"
if [ -e "$MY_DEFAULT_CONFIG" ]; then
	# ignore SC1090
	# shellcheck source=/dev/null
	source "$MY_DEFAULT_CONFIG"
else
	echo "ERROR: Default config file not found!"
	exit 9
fi
if [ -e "$MY_CONFIG" ]; then
	echo "Load config file '$MY_CONFIG'"
	# ignore SC1090
	# shellcheck source=/dev/null
	source "$MY_CONFIG"
fi

echo
echo "Create Container registry"
echo "-------------------------"
echo "Name     : $MY_GCP_REPOSITORY_NAME"
echo "Type     : Docker"
echo "Region   : $MY_GCP_REGION"
echo "Project  : $MY_GCP_PROJECT"
echo
gcloud artifacts repositories create "$MY_GCP_REPOSITORY_NAME" \
--repository-format=docker \
--location="$MY_GCP_REGION" \
--project="$MY_GCP_PROJECT"
echo