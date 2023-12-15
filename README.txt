installing NVIDIA Container Toolkit
https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

watch:
https://www.youtube.com/watch?v=CO43b6XWHNI


sudo docker build -t rainbowminer-image .
sudo docker run --rm -it --gpus all -p 4000:4000 rainbowminer-image bash

