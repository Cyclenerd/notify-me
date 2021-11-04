#!/usr/bin/env bash

# Deploy and run Google Cloud Run container
# https://cloud.google.com/sdk/gcloud/reference/run/deploy

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

# Create service account
if gcloud iam service-accounts create "$MY_GCP_SA_NAME" \
--display-name="$MY_GCP_SA_DISPLAY_NAME" \
--description="$MY_GCP_SA_DESCRIPTION" \
--project="$MY_GCP_PROJECT"; then
	echo "Please wait... (15sec)"
	sleep 15
fi

# Get service account ID
gcloud iam service-accounts list \
	--filter="email ~ ^$MY_GCP_SA_NAME\@" \
	--project="$MY_GCP_PROJECT"
MY_GCP_SA_ID=$(gcloud iam service-accounts list --filter="email ~ ^$MY_GCP_SA_NAME\@" --format="value(email)" --project="$MY_GCP_PROJECT")
if [[ "$MY_GCP_SA_ID" == *'@'* ]]; then
	echo "Service account identifier: $MY_GCP_SA_ID"
else
	echo "ERROR: Service account identifier could not be detected"
	exit 5
fi

# Do not change
MY_GCP_RUN_IMAGE="$MY_GCP_REGION-docker.pkg.dev/$MY_GCP_PROJECT/$MY_GCP_REPOSITORY_NAME/notify-me:http-latest"
PTSV2_URL="https://ptsv2.com/t/cloud-run-notify-me-$MY_GCP_PROJECT-$MY_GCP_RUN_SERVICE_NAME/post"
# API key
MY_CGP_RUN_ENV_VARS="API_KEY=$API_KEY"
# test.pl
MY_CGP_RUN_ENV_VARS+=",PTSV2_URL=$PTSV2_URL"
# mailgun.pl
MY_CGP_RUN_ENV_VARS+=",APP_KEY=$APP_KEY"
MY_CGP_RUN_ENV_VARS+=",APP_DOMAIN=$APP_DOMAIN"
MY_CGP_RUN_ENV_VARS+=",APP_FROM=$APP_FROM"
MY_CGP_RUN_ENV_VARS+=",APP_TO=$APP_TO"
# ms-teams.pl
MY_CGP_RUN_ENV_VARS+=",APP_URL=$APP_URL"
# pushover.pl
MY_CGP_RUN_ENV_VARS+=",APP_USER=$APP_USER"
MY_CGP_RUN_ENV_VARS+=",APP_TOKEN=$APP_TOKEN"
# sipgate-sms.pl
MY_CGP_RUN_ENV_VARS+=",APP_ID=$APP_ID"
#MY_CGP_RUN_ENV_VARS+=",APP_TOKEN=$APP_TOKEN" # already from pushover.pl
MY_CGP_RUN_ENV_VARS+=",APP_TEL=$APP_TEL"

echo
echo "Deploy container to Cloud Run service"
echo "-------------------------------------"
echo "Name                 : $MY_GCP_RUN_SERVICE_NAME"
echo "Image                : $MY_GCP_RUN_IMAGE"
echo "CPU                  : $MY_GCP_RUN_CPU"
echo "Memory               : $MY_GCP_RUN_MEMORY"
echo "Concurrency          : $MY_GCP_RUN_CONCURRENCY"
echo "Service Account ID   : $MY_GCP_SA_ID"
echo "Instances (min/max)  : $MY_GCP_RUN_MIN_INSTANCES / $MY_GCP_RUN_MAX_INSTANCES"
echo "Region               : $MY_GCP_REGION"
echo "Project              : $MY_GCP_PROJECT"
echo
echo "PTSV2 URL (for test) : $PTSV2_URL"
echo
gcloud run deploy "$MY_GCP_RUN_SERVICE_NAME" \
--region="$MY_GCP_REGION"                    \
--image="$MY_GCP_RUN_IMAGE"                  \
--platform=managed                           \
--cpu="$MY_GCP_RUN_CPU"                      \
--memory="$MY_GCP_RUN_MEMORY"                \
--concurrency="$MY_GCP_RUN_CONCURRENCY"      \
--allow-unauthenticated                      \
--service-account="$MY_GCP_SA_ID"            \
--min-instances="$MY_GCP_RUN_MIN_INSTANCES"  \
--max-instances="$MY_GCP_RUN_MAX_INSTANCES"  \
--set-env-vars="$MY_CGP_RUN_ENV_VARS"        \
--project="$MY_GCP_PROJECT"
echo

echo
echo "List service"
echo "------------"
gcloud run services list \
--filter="metadata.name:$MY_GCP_RUN_SERVICE_NAME" \
--limit=1 \
--project="$MY_GCP_PROJECT"
MY_GCP_RUN_URL=$(gcloud run services list \
--filter="metadata.name:$MY_GCP_RUN_SERVICE_NAME" \
--format="value(status.url)" \
--limit=1 \
--project="$MY_GCP_PROJECT")
echo

#
# Test Cloud Run service
#

echo
echo "Check NotifyMe-HTTP version"
echo "---------------------------"
curl -i "$MY_GCP_RUN_URL/?key=$API_KEY"
curl -i "$MY_GCP_RUN_URL/ptsv2?key=$API_KEY"
echo

echo
echo "Create PTSV2 toilet for test"
echo "----------------------------"
curl -s "https://ptsv2.com/t/cloud-run-notify-me-$MY_GCP_PROJECT-$MY_GCP_RUN_SERVICE_NAME" >> /dev/null
curl -s "https://ptsv2.com/t/cloud-run-notify-me-$MY_GCP_PROJECT-$MY_GCP_RUN_SERVICE_NAME/flush_all"
echo

echo
echo "Send test message"
echo "-----------------"
curl -i \
	-H "Content-Type: application/json" \
	--data @../http/NotifyMe-HTTP/t/test.json \
	"$MY_GCP_RUN_URL/v1/test.pl?key=$API_KEY"
echo

echo
echo "Test message"
echo "------------"
if curl -s "https://ptsv2.com/t/cloud-run-notify-me-$MY_GCP_PROJECT-$MY_GCP_RUN_SERVICE_NAME/d/latest/text" | grep '{"message":"Test message"}'; then
	echo "OK"
else
	echo
	echo "ERROR: Test message not found"
	echo "       Please check deployment and previous output"
	echo
	exit 2
fi
echo

echo
echo "Clean up"
echo "--------"
curl -s "https://ptsv2.com/t/cloud-run-notify-me-$MY_GCP_PROJECT-$MY_GCP_RUN_SERVICE_NAME/flush_all"
echo

echo
echo "ALL DONE"
echo "--------"
echo "Your Cloud Run service URL: $MY_GCP_RUN_URL"
echo "Dashboard: https://console.cloud.google.com/run?project=$MY_GCP_PROJECT"
echo