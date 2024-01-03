#!/bin/bash

# Function to stop the docker container on a remote machine and reboot if necessary
stop_docker_container() {
    local ip="$1"
    local container_image="$2"
    ssh -o StrictHostKeyChecking=no -t "ubuntu@${ip}" << EOF
    output=\$(sudo docker ps -q --filter "ancestor=${container_image}" | xargs -r sudo docker stop 2>&1)
    echo "\$output"
    if echo "\$output" | grep -q "Error response from daemon: cannot stop container"; then
        echo "Error encountered. Rebooting \$HOSTNAME..."
        sudo reboot
    fi
EOF
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
)

# Loop through the IP ranges
for range in "${ip_ranges[@]}"; do
    for i in $(seq 1 20); do
        ip="${range}.${i}"
        echo "Stopping containers on ${ip} (rbm-client:1.0) ..."
        stop_docker_container "${ip}" "bradenacurtis801/rbm-client:1.0" &
    done
done

# Additional IP ranges with a different container
additional_ranges=(
    "10.10.121"
    "10.10.122"
    "10.10.123"
    "10.10.124"
    "10.10.125"
)

# Loop through the additional IP ranges
for range in "${additional_ranges[@]}"; do
    for i in $(seq 1 20); do
        ip="${range}.${i}"
        echo "Stopping containers on ${ip} (rbm-client-a4000x2:1.0) ..."
        stop_docker_container "${ip}" "bradenacurtis801/rbm-client-a4000x2:1.0" &
    done
done

# Wait for all background processes to complete
wait
echo "All containers have been processed."
