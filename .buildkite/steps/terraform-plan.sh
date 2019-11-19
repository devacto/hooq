#!/bin/bash

set -euo pipefail

echo "--- :docker: Pulling Docker image"
docker pull hashicorp/terraform:light

echo "--- :hammer_and_wrench: Configuring"
docker run --rm -v "$(pwd)":/data --workdir=/data \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  hashicorp/terraform:light init -input=false

echo "+++ :terraform: Planning"
docker run --rm -v "$(pwd)":/data --workdir=/data \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  hashicorp/terraform:light plan -out=plans/microservice.plan

echo "👌 Looks good to me!"