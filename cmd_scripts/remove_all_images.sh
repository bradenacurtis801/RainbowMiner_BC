#!/bin/bash

#img_name='bradenacurtis801'
img_name='70c126a71edd'
# cst_img variable not used in the corrected script, assuming it's an error

echo "Deleting all Docker images with name containing '$img_name' on ${HOSTNAME}..."

# List images with names containing 'bradenacurtis801' and extract their IDs
images=$(sudo docker images | grep "$img_name" | awk '{print $3}')

if [ -n "$images" ]; then
    # Stop and remove containers that are using the images
    for image_id in $images; do
        containers=$(sudo docker ps -a | grep "$image_id" | awk '{print $1}')
        if [ -n "$containers" ]; then
            echo "Stopping and removing containers using image ID $image_id..."
            sudo docker -f stop $containers
            sudo docker rm $containers
        fi
    done

    # Remove the images
    echo "Removing images..."
    sudo docker rmi -f $images
else
    echo "No images found with name containing '$img_name'."
fi

