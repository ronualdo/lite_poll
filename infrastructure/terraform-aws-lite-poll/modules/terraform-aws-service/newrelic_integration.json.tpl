[
  {
    "secrets": [
      {
        "valueFrom": "NRIA_LICENSE_KEY",
        "name": "NRIA_LICENSE_KEY"
      }
    ],
    "portMappings": [],
    "cpu": 200,
    "memory": 384,
    "environment": [
      {
        "name": "NRIA_OVERRIDE_HOST_ROOT",
        "value": "/host"
      },
      {
        "name": "NRIA_PASSTHROUGH_ENVIRONMENT",
        "value": "ECS_CONTAINER_METADATA_URI,ECS_CONTAINER_METADATA_URI_V4"
      },
      {
        "name": "NRIA_VERBOSE",
        "value": "0"
      },
      {
        "name": "NRIA_CUSTOM_ATTRIBUTES",
        "value": "{\"nrDeployMethod\":\"downloadPage\"}"
      }
    ],
    "mountPoints": [
      {
        "readOnly": true,
        "containerPath": "/host",
        "sourceVolume": "host_root_fs"
      },
      {
        "readOnly": false,
        "containerPath": "/var/run/docker.sock",
        "sourceVolume": "docker_socket"
      }
    ],
    "volumesFrom": [],
    "image": "newrelic/nri-ecs:1.9.0",
    "essential": true,
    "readonlyRootFilesystem": false,
    "privileged": true,
    "name": "newrelic-infra"
  }
]
