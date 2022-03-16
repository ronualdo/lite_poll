#!/bin/bash

docker build ./load_test -t lite_poll_load_test

LITE_POLL_URL="$(docker-compose run --rm -w /lite_poll/infrastructure/terraform-aws-lite-poll web terraform output --raw lite_poll_url)"

docker run -i --rm -e LITE_POLL_URL=http://$LITE_POLL_URL lite_poll_load_test run script.js
