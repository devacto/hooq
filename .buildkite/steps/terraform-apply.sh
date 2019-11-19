#!/bin/bash

set -euo pipefail

echo "+++ :buildkite: Downloading plan"
buildkite-agent artifact download plans/microservice.plan .

echo "--- :hammer_and_wrench: Configuring"
docker run --rm -v "$(pwd)":/data --workdir=/data \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  hashicorp/terraform:light init -input=false

echo "+++ :terraform: Applying"
docker run --rm -v "$(pwd)":/data --workdir=/data \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  hashicorp/terraform:light apply plans/microservice.plan

echo "👌 Looks good to me!"