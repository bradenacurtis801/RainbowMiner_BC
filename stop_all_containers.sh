#!/bin/bash

# Common SSH options for reusability and consistency
ssh_options="-o StrictHostKeyChecking=no -o ConnectTimeout=10"

# Array of IPs to exclude from the script's operations
exclude_ips=(
    "10.10.111.3"
)

# Array of IP address ranges to be processed
ip_ranges=(
    "10.10.11"
    "10.10.12"
    "10.10.13"
    "10.10.14"
    "10.10.21"
    "10.10.22"
    "10.10.23"
    "10.10.24"
    "10.10.25"
    "10.10.111"
    "10.10.112"
    "10.10.113"
    "10.10.121"
    "10.10.122"
    "10.10.123"
    "10.10.124"
    "10.10.125"
)

# Flag to determine whether to delete images
delete_images_flag=false

# Process command-line options
while getopts ":d" opt; do
    case $opt in
        d)
            delete_images_flag=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Enable debugging to track command execution
set -x

# Function to delete all images with a specified name pattern
delete_images() {
    local ip="$1"
    ssh $ssh_options "ubuntu@${ip}" << 'EOF'
    echo "Deleting all Docker images with name containing 'bradenacurtis801' on ${HOSTNAME}..."
    images=$(sudo docker images | grep "bradenacurtis801" | awk '{print $3}')
    if [ -n "$images" ]; then
        sudo docker rmi -f $images
    fi
EOF
}

# Function to stop all containers based on a specific image name pattern
stop_all_containers() {
    local ip="$1"
    ssh $ssh_options "ubuntu@${ip}" << 'EOF' || echo "SSH command failed or host ${ip} is not reachable."
    echo "Stopping all containers with image name containing 'bradenacurtis801' on ${HOSTNAME}..."
    output=$(sudo docker ps -a | grep "bradenacurtis801" | awk '{print $1}' | xargs -r sudo docker stop --rm 2>&1)
    echo "$output"
    if echo "$output" | grep -q "Error response from daemon: cannot stop container"; then
        echo "Error encountered. Rebooting ${HOSTNAME}..."
        sudo reboot
    fi
EOF
    # Call delete_images function to remove images
    if $delete_images_flag; then
        delete_images "$ip"
    fi
}

# Function to execute the stop_all_containers on a range of IPs
execute_on_range() {
    local range="$1"
    for i in $(seq 1 20); do
        local ip="${range}.${i}"

        # Check if the IP is in the exclude list and skip if it is
        if [[ " ${exclude_ips[@]} " =~ " ${ip} " ]]; then
            echo "Skipping ${ip}..."
            continue
        fi

        echo "Processing ${ip}..."
        stop_all_containers "${ip}" &
    done
}

# Main execution loop
for range in "${ip_ranges[@]}"; do
    execute_on_range "${range}"
done

# Wait for all background processes to complete
wait
echo "All containers have been processed."
