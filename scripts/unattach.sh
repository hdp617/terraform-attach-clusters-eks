#!/bin/bash
set -x	

gcloud container attached clusters delete $1 --project=$2 --location=us-west1 --quiet --ignore-errors