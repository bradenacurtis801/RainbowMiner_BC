#!/bin/bash
# Define the Docker image name and tag to check
IMAGE_NAME="bradenacurtis801/client-base"
IMAGE_TAG="1.0"

# Get the hostname and use it as the IP
ip="$(hostname)"

# Check if the image exists locally and output the result
if sudo docker images | grep -q "$IMAGE_NAME\s*$IMAGE_TAG"; then
  echo "$ip has image"
else
  echo "$ip does not have image"
fi