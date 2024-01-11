#!/bin/bash

# Define the Docker image name and tag
IMAGE_NAME="bradenacurtis801/client-base"
IMAGE_TAG="1.0"
FULL_IMAGE="$IMAGE_NAME:$IMAGE_TAG"

# Check if a container from the image is already running
running_container=$(docker ps --filter "ancestor=$FULL_IMAGE" --format "{{.ID}}")

if [ -n "$running_container" ]; then
    echo "A container from the image $FULL_IMAGE is already running."
else
    echo "No running container found from the image $FULL_IMAGE. Checking for stopped containers."

    # Find the most recently created container from the image that is not running
    stopped_container=$(docker ps -a --filter "ancestor=$FULL_IMAGE" --filter "status=exited" --format "{{.CreatedAt}} {{.ID}}" | sort -r | head -n 1 | awk '{print $NF}')

    if [ -n "$stopped_container" ]; then
        echo "Starting the most recently created stopped container: $stopped_container"
        docker start "$stopped_container"
    else
        echo "No stopped container found from the image $FULL_IMAGE."
    fi
fi

