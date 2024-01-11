#!/bin/bash

container_id="360bcda3a316"  # Replace with your container ID or name
check_interval=300  # 5 minutes in seconds

while true; do
  if [[ "$(docker ps -q -f id=${container_id})" ]]; then
    echo "Container is already running."
  else
    echo "Container is not running. Starting..."
    docker start ${container_id}
  fi
  sleep ${check_interval}
done
