#!/bin/bash
GREEN='\033[38;2;0;255;0m'
RED='\033[38;2;255;0;0m'
TEAL='\e[38;2;0;255;187m'
NC='\033[0m' # No Color

# Define the Docker image name and tag
IMAGE_NAME="bradenacurtis801/client-base"
IMAGE_TAG="1.0"
FULL_IMAGE="$IMAGE_NAME:$IMAGE_TAG"

# Get the hostname of the machine
HOSTNAME=$(hostname)

# Check if a container from the specified image is running
if sudo docker ps --format "" | grep -q "$FULL_IMAGE"; then
    # Output in green
    echo -e "${GREEN}$HOSTNAME:${NC} ${TEAL}$FULL_IMAGE is running${NC}"
else
    # Output in red
    echo -e "${RED}$HOSTNAME: $FULL_IMAGE is not running${NC}"
fi
