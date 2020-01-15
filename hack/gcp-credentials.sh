#!/usr/bin/env bash
#
# Forked and modified from https://github.com/crossplaneio/crossplane/blob/master/cluster/examples/gcp-credentials.sh
#
# This is a helper script to create a project, service account, and credentials.json
# file for use in the Minimal GCP Stack for Crossplane
#
# gcloud is required for use and must be configured with privileges to perform these tasks
#
# PROJECT_ID and ORGANIZATION_ID may be provided as environment variables
#

set -e -o pipefail
ROLES=(roles/iam.serviceAccountUser roles/cloudsql.admin roles/container.admin roles/redis.admin roles/compute.networkAdmin)
SERVICES=(container.googleapis.com sqladmin.googleapis.com redis.googleapis.com compute.googleapis.com servicenetworking.googleapis.com)
KEYFILE=$(mktemp crossplane.XXXXXXXX)
RAND=$RANDOM

if ! command -v gcloud > /dev/null; then
	echo "Please install gcloud: https://cloud.google.com/sdk/install"
	exit 1
fi

if command -v pbcopy > /dev/null; then
	COPY="pbcopy"
elif command -v xclip > /dev/null; then
	COPY="xclip -selection -clipboard"
fi

tab () { sed 's/^/    /' ; }


if [ -z "${PROJECT_ID}" ]; then
	# list your organizations (if applicable), take note of the specific organization ID you want to use
	# if you have more than one organization (not common)
	gcloud organizations list --format '[box]' 2>&1 | tab

	if [ -z "${ORGANIZATION_ID}" ]; then
		ORGANIZATION_ID=$(gcloud organizations list --format 'value(ID)' --limit 1)
		read -e -p "Choose an Organization ID [$ORGANIZATION_ID]: " PROMPT_ORGANIZATION_ID
		ORGANIZATION_ID=${PROMPT_ORGANIZATION_ID:-$ORGANIZATION_ID}
	fi

	gcloud projects list --format '[box]' 2>&1 | tab

	# create a new id
	PROJECT_ID="crossplane-project-$RAND"
	read -e -p "Choose or create a Project ID [$PROJECT_ID]: " PROMPT_PROJECT_ID
	PROJECT_ID=${PROMPT_PROJECT_ID:-$PROJECT_ID}

	PROJECT_ID_FOUND=$(gcloud projects list --filter PROJECT_ID="$PROJECT_ID" --format="value(PROJECT_ID)")

	if [[ -z $PROJECT_ID_FOUND ]]; then
		ACCOUNT_ID=$(gcloud beta billing accounts list --format 'value(ACCOUNT_ID)' --limit 1)
		gcloud beta billing accounts list --format '[box]' 2>&1 | tab
		read -e -p "Choose a Billing Account ID [$ACCOUNT_ID]: " PROMPT_ACCOUNT_ID
		ACCOUNT_ID=${PROMPT_ACCOUNT_ID:-$ACCOUNT_ID}

		echo -e "\n* Creating Project $PROJECT_ID ... "
		gcloud projects create $PROJECT_ID --enable-cloud-apis --organization $ORGANIZATION_ID 2>&1 | tab

		echo "* Linking Billing Account $ACCOUNT_ID with Project $PROJECT_ID ... "
		gcloud beta billing projects link $PROJECT_ID --billing-account=$ACCOUNT_ID 2>&1 | tab
	else
		echo -n "\n* Using Project $PROJECT_NAME ... $PROJECT_ID"
	fi
fi

# enable Kubernetes API
for service in "${SERVICES[@]}"; do
	# enable Google API
	echo "* Enabling Service $service on $PROJECT_ID"
	gcloud --project $PROJECT_ID services enable $service 2>&1 | tab
done

# create service account
SA_NAME="stack-gcp-minimal-$RAND"
echo " * Creating a Service Account"
gcloud --project $PROJECT_ID iam service-accounts create $SA_NAME --display-name "Crossplane GCP Minimal Stack SA" 2>&1 | tab
# export service account email
SA="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

# assign roles
for role in "${ROLES[@]}"; do
	echo "* Adding Role $role to $SA on $PROJECT_ID"
	gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:$SA" --role="$role" 2>&1 | tab
done

# create service account key
echo " * Creating $SA Key File $KEYFILE"
gcloud --project $PROJECT_ID iam service-accounts keys create --iam-account $SA $KEYFILE 2>&1 | tab


CONTENTS=$(cat $KEYFILE)
rm "$KEYFILE"

cat <<EOS

********************
$CONTENTS
********************

Your Minimal GCP Stack keyfile is shown above, between the asterisks.
EOS


if [ -n "$COPY" ]; then
	echo $CONTENTS | $COPY
	echo The contents of the keyfile have been placed in your copy buffer and can now be pasted.
fi
