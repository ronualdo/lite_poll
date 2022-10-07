[
  {
    "essential": true,
     "memory": 256,
     "name": "lite-poll-migration",
     "cpu": 1,
     "image": "${REPOSITORY_URL}:0.0.4",
     "command": ["bin/rails", "db:prepare"],
     "logConfiguration": {
       "logDriver": "awslogs",
       "options": {
         "awslogs-group": "lite-poll-migration-container",
         "awslogs-region": "us-west-2",
         "awslogs-create-group": "true",
         "awslogs-stream-prefix": "lite-poll-migration"
       }
     },
     "environment": [
       {
         "name": "RAILS_ENV",
         "value": "production"
       },
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
         "name": "NEW_RELIC_LICENSE_KEY",
         "value": "${NEW_RELIC_LICENSE_KEY}"
       },
       {
         "name": "DB_PORT",
         "value": "${DB_PORT}"
       }
     ]
  }
]
