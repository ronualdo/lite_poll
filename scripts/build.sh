#!/bin/bash

IMAGE_REPO_URL="$(docker-compose run --rm -w /bitforma/infrastructure/terraform-aws-lite-poll web terraform output image_repo_url)"

echo $IMAGE_REPO_URL

docker build . -t $IMAGE_REPO_URL:$1
