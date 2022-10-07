[
  {
    "essential": true,
     "memory": 512,
     "name": "worker",
     "cpu": 2,
     "image": "${REPOSITORY_URL}:0.0.4",
     "command": ["bundle", "exec", "rackup", "-p", "3000", "-E", "production"],
     "portMappings": [
       { "containerPort": 3000, "protocol": "tcp" }
     ],
     "logConfiguration": {
       "logDriver": "awslogs",
       "options": {
         "awslogs-group": "lite-poll-container",
         "awslogs-region": "us-west-2",
         "awslogs-create-group": "true",
         "awslogs-stream-prefix": "lite-poll"
       }
     },
     "environment": [
       {
         "name": "DB_HOST",
         "value": "${DB_HOST}"
       },
       {
         "name": "DB_USER",
         "value": "${DB_USER}"
       },
       {
         "name": "DB_PASSWORD",
         "value": "${DB_PASSWORD}"
       },
       {
         "name": "DB_PORT",
         "value": "${DB_PORT}"
       },
       {
         "name": "NEW_RELIC_LICENSE_KEY",
         "value": "${NEW_RELIC_LICENSE_KEY}"
       },
       {
         "name": "RAILS_LOG_TO_STDOUT",
         "value": "true"
       }
     ]
  }
]
