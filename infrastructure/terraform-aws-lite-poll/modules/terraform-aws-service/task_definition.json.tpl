[
  {
    "essential": true,
      "memory": 512,
      "name": "worker",
      "cpu": 2,
      "image": "${REPOSITORY_URL}:latest",
      "environment": [],
      "command": ["bundle", "exec", "rackup", "-p", "8080", "-E", "production"],
      "portMappings": [
        { "containerPort": 8080, "protocol": "tcp" }
      ]
  }
]
