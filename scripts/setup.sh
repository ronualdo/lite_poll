#!/bin/bash

./scripts/apply_infra.sh && 
  ./scripts/upload_image.sh 0.0.1 &&
  ./scripts/migrate.sh
