[
  {
    "essential": true,
      "memory": 512,
      "name": "worker",
      "cpu": 2,
      "image": "${REPOSITORY_URL}:0.0.1",
      "environment": [],
      "command": ["bundle", "exec", "rackup", "-p", "8080", "-E", "production"],
      "portMappings": [
        { "containerPort": 8080, "protocol": "tcp" }
      ],
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
  }
]
