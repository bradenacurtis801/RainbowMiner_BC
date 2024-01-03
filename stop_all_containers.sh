#!/bin/bash

# Function to stop all containers based on image name pattern
stop_all_containers() {
    local ip="$1"
    ssh -o StrictHostKeyChecking=no -t "ubuntu@${ip}" << 'EOF'
    echo "Stopping all containers with image name containing 'bradenacurtis801' on ${HOSTNAME}..."
    sudo docker ps -q --filter "ancestor=bradenacurtis801" | xargs -r sudo docker stop
EOF
}

# Function to execute the stop_all_containers on a range of IPs
execute_on_range() {
    local range="$1"
    for i in $(seq 1 20); do
        ip="${range}.${i}"
        echo "Processing ${ip}..."
        stop_all_containers "${ip}" &
    done
}

# List of IP address ranges
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

# Loop through the IP ranges and execute stop_all_containers
for range in "${ip_ranges[@]}"; do
    execute_on_range "${range}"
done

# Wait for all background processes to complete
wait
echo "All containers have been processed."
