#!/bin/bash

aws ecs run-task --task-definition db_prepare --region us-west-2 --cluster lite-poll-cluster &> /dev/null
