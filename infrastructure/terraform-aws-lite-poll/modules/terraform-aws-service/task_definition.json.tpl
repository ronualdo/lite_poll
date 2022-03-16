[
  {
    "essential": true,
     "memory": 512,
     "name": "worker",
     "cpu": 2,
     "image": "${REPOSITORY_URL}:0.0.1",
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
         "name": "RAILS_LOG_TO_STDOUT",
         "value": "true"
       }
     ]
  }
]
