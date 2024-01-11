#!/bin/bash
sudo apt-get update
sudo apt-get install -y nfs-common docker.io
sudo usermod -aG docker ubuntu
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
sudo apt-get upgrade -y
sudo apt-get install -y nvidia-driver-535
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo reboot
