[
  {
    "essential": true,
     "memory": 512,
     "name": "worker",
     "cpu": 2,
     "image": "${REPOSITORY_URL}:0.0.1",
     "command": ["bundle", "exec", "rackup", "-p", "3000", "-E", "production"],
     "dependsOn": [
       { "containerName": "lite-poll-migration", "condition": "SUCCESS" }
     ],
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
       }
     ]
  },
  {
    "essential": false,
     "memory": 256,
     "name": "lite-poll-migration",
     "cpu": 1,
     "image": "${REPOSITORY_URL}:0.0.1",
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
         "name": "DB_PORT",
         "value": "${DB_PORT}"
       }
     ]
  }
]
