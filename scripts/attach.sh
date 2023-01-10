#!/bin/bash
set -x	

aws eks update-kubeconfig --name "$1" --region "$2"

gcloud container attached clusters register $1 \
  --distribution=eks \
  --platform-version=$3 \
  --fleet-project=$4 \
  --issuer-url=$5 \
  --project=$6 --quiet --location=us-west1 --context=$(kubectl config current-context)
