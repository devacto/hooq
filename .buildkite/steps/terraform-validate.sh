#!/bin/bash

set -euo pipefail

echo "--- :docker: Pulling Docker image"
docker pull hashicorp/terraform:light

echo "+++ :terraform: Initialising"
docker run --rm -v "$(pwd)":/data \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  --workdir=/data hashicorp/terraform:light \
  init -input=false

echo "+++ :terraform: Validating"
docker run --rm -v "$(pwd)":/data \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  --workdir=/data hashicorp/terraform:light \
  validate

echo "👌 Looks good to me!"
