# Base Image
FROM nvidia/cuda:12.3.1-runtime-ubuntu20.04

# Set timezone to Mountain Time (for Utah)
ENV TZ=America/Denver
RUN apt update && apt install -y tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone


# Install dependencies and tools
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common \
    sudo \
    nano \
    dkms \
    build-essential \
    wget \
    xz-utils \
    git \
    systemd

# Add NVIDIA repository
RUN add-apt-repository ppa:graphics-drivers/ppa && \
    apt-get update

# Install NVIDIA packages
RUN apt-get install -y \
    nvidia-cuda-toolkit \
    nvidia-headless-535 \
    nvidia-driver-535 \
    nvidia-compute-utils-535

# Clone and setup RainbowMiner
RUN git clone https://github.com/rainbowminer/RainbowMiner && \
    cd RainbowMiner && \
    chmod +x *.sh && \
    ./install.sh

# Set the working directory
WORKDIR /RainbowMiner

# Expose the port for the web interface
EXPOSE 4000

# Set the default command to start RainbowMiner
CMD ["./start.sh"]

# Setting environment variables for RainbowMiner
ENV USERNAME=root \
    PASSWORD=root
