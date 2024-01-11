docker_usrname='bradenacurtis801'
container_image="${docker_usrname}/client-base:1.0"
server_image='bradenacurtis801/server-image:1.0'
script="./inject_init_bc.sh -s 10.10.111.3"

# ANSI escape codes for colors
RED='\033[0;91m'
LIGHT_GREEN='\e[92m'
TEAl='\e[38;2;0;255;187m'
GREEN='\033[38;2;0;255;0m'
NC='\033[0m' # No Color

# Get the hostname of the machine
HOSTNAME=$(hostname)

if sudo docker ps --format "" | grep -q "${container_image}"; then 
        echo -e "${LIGHT_GREEN}${HOSTNAME}:${NC} ${GREEN}Container with image ${container_image} is already running${NC}"
    elif sudo docker ps --format "" | grep -q "$server_image"; then
        echo -e "${LIGHT_GREEN}${HOSTNAME}:${NC} ${TEAl}Container with image ${server_image} is already running${NC}"
    else
        output=$(sudo docker run --gpus all -d --rm -p 4000:4000 --network host ${container_image} ${script} 2>&1)

        if [[ "$output" == *"could not select device driver"* ]]; then
            echo -e "${LIGHT_GREEN}${HOSTNAME}:${NC} ${RED}${output}${NC}"
        else
            echo -e "${LIGHT_GREEN}${HOSTNAME}:${NC} Docker command executed successfully:\n ${output}"
        fi

    fi
