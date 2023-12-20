docker pull nvidia/cuda:12.0.1-runtime-ubuntu22.04

sudo docker run -d -it --name=rainbowminer nvidia/cuda:12.0.1-runtime-ubuntu22.04

sudo docker exec -it rainbowminer /bin/bash

apt-get update
apt-get install software-properties-common
apt-get install sudo
apt-get install nano
sudo apt update && sudo apt upgrade -y
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt -y install dkms build-essential
sudo apt update
sudo apt-get install nvidia-cuda-toolkit
sudo apt -y install nvidia-headless-535 nvidia-driver-535 nvidia-compute-utils-535

bash -c 'apt-get -y update; apt-get -y install wget xz-utils git sudo systemd;
git clone https://github.com/rainbowminer/RainbowMiner;
cd RainbowMiner; chmod +x *.sh;
./install.sh'
