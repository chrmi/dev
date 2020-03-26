#!/bin/bash

# Enable to enable specific GKE cluster in config upon SSH.
gcloud auth activate-service-account $GCP_ACCOUNT --key-file=/home/me/auth/gcp.json
gcloud config set project $GCP_PROJECT
gcloud container clusters get-credentials $GCP_CLUSTER --zone $GCP_REGION

# Start tmux on SSH if desired.
# tmux
