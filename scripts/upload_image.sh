#!/bin/bash

IMAGE_REPO_URL="$(docker-compose run --rm -w /lite_poll/infrastructure/terraform-aws-lite-poll web terraform output --raw image_repo_url)"

docker build . -t $IMAGE_REPO_URL:$1

aws ecr get-login-password --region us-west-2 | docker login --username AWS \
  --password-stdin $IMAGE_REPO_URL:$1

docker push $IMAGE_REPO_URL:$1
