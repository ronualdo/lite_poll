#!/bin/bash

docker-compose run -w /bitforma/infrastructure/terraform-aws-lite-poll web terraform apply \
  -var=db_password=$1 --auto-approve
