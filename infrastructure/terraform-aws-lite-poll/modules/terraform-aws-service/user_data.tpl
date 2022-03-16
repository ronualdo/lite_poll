#!/bin/bash

echo ECS_CLUSTER=lite-poll-cluster >> /etc/ecs/ecs.config

curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && \
  sudo NEW_RELIC_API_KEY=${NEW_RELIC_API_KEY} NEW_RELIC_ACCOUNT_ID=${NEW_RELIC_ACCOUNT_ID} \
  /usr/local/bin/newrelic install -n logs-integration"
