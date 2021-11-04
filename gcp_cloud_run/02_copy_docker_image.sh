#!/usr/bin/env bash

# Copy Docker image from GitHub Container Registry to Artifact Registry
# https://cloud.google.com/artifact-registry/docs/docker/copy-from-gcr

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

# Check gcrane
# https://github.com/google/go-containerregistry/blob/main/cmd/gcrane/README.md
if ! command -v "gcrane" >/dev/null 2>&1; then
	echo "WARNING: 'gcrane' not installed."
	echo "Try to install gcrane..."
	echo
	curl -L \
		"https://github.com/google/go-containerregistry/releases/latest/download/go-containerregistry_Linux_x86_64.tar.gz" \
		-o "/tmp/go-containerregistry.tar.gz"
	mkdir     "/tmp/go-containerregistry"
	tar -zxvf "/tmp/go-containerregistry.tar.gz" --directory "/tmp/go-containerregistry" >> /dev/null
	chmod +x  "/tmp/go-containerregistry/gcrane"
	sudo mv   "/tmp/go-containerregistry/gcrane" "/usr/local/bin/"
	rm -rf    "/tmp/go-containerregistry"
	echo "Done"
	echo
fi

# Do not change
MY_GCP_RUN_IMAGE="$MY_GCP_REGION-docker.pkg.dev/$MY_GCP_PROJECT/$MY_GCP_REPOSITORY_NAME/notify-me:http-latest"

echo
echo "List repositories"
echo "-----------------"
gcloud artifacts repositories list \
--filter="format:docker" \
--location="$MY_GCP_REGION" \
--project="$MY_GCP_PROJECT"
echo

echo
echo "Docker auth"
echo "-----------"
gcloud auth configure-docker "$MY_GCP_REGION-docker.pkg.dev" -q
echo

echo
echo "Copy Docker image to GCP Container registry"
echo "-------------------------------------------"
echo "Source : $MY_DOCKER_SOURCE_IMAGE"
echo "Target : $MY_GCP_RUN_IMAGE"
echo

gcrane cp "$MY_DOCKER_SOURCE_IMAGE" "$MY_GCP_RUN_IMAGE"
echo