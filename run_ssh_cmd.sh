#!/bin/bash

# ANSI escape codes for colors
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[38;2;106;255;0m'
NC='\033[0m' # No Color

echo > /home/datacare/.ssh/known_hosts

while getopts "f:" opt; do
  case "$opt" in
    f) script_file="$OPTARG" ;;
    *) echo "Usage: $0 -f <scriptfile>"; exit 1 ;;
  esac
done

if [ -z "$script_file" ]; then
  echo "Error: -f <scriptfile> argument is required"
  exit 1
fi

# Run the script on each machine and categorize the output
while IFS= read -r ip; do
  for i in {1..20}; do
    new_ip="${ip}.${i}"
    (
      result=$(ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oLogLevel=ERROR "ubuntu@$new_ip" 'bash -s' < "$script_file" 2>&1)
      if [[ "$result" == *"No route to host"* ]]; then
        echo -e "${LIGHT_BLUE}${new_ip}:${NC} ${YELLOW}No route to host.${NC}"
      elif [[ "$result" == *"kex_exchange_identification: read: Connection reset by peer"* ]]; then
        echo -e "${LIGHT_BLUE}${new_ip}:${NC} ${LIGHT_GREEN}kex_exchange_identification: read: Connection reset by peer${NC}"
      else
        echo "$result"
      fi
    ) &
  done
done < client-list

wait
