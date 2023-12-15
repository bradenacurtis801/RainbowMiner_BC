# Use NVIDIA CUDA base image with Ubuntu 20.04
FROM nvidia/cuda:11.6.1-base-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install sudo
RUN apt-get update && \
    apt-get install -y sudo && \
    apt-get clean

# Install dependencies and Git
RUN apt-get update && \
    apt-get install -y git wget && \
    apt-get clean

# Install the appropriate version of libicu
RUN apt-get install -y libicu66 && \
    apt-get clean

# Download PowerShell package version 7.2.16
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.2.16/powershell-lts_7.2.16-1.deb_amd64.deb

# Install PowerShell package
RUN dpkg -i powershell-lts_7.2.16-1.deb_amd64.deb

# Install PowerShell dependencies
RUN apt-get install -f

# Clone the RainbowMiner repository
RUN git clone https://github.com/rainbowminer/RainbowMiner /rainbowminer

# Change directory to RainbowMiner
WORKDIR /rainbowminer

# Make shell scripts executable
RUN chmod +x *.sh

# Copy your sudoers file to allow specific commands
COPY sudoers /etc/sudoers

# Set correct permissions for the sudoers file
RUN chmod 440 /etc/sudoers

# Copy setup.json to the root directory inside the container
COPY setup.json /rainbowminer

# Run the installation script (you may need to adapt this step)
# Note: Running 'sudo' within a Docker container may not work as expected,
# so you might need to modify the install.sh script accordingly.
# For this example, we'll comment out the installation step.
# RUN sudo ./install.sh

# Expose any necessary ports
# (add EXPOSE statements if RainbowMiner requires specific ports to be open)

# Define the command to start RainbowMiner (choose one of the options below)
# CMD ["./start.sh"]
# CMD ["./start-screen.sh"]
# CMD ["./start-nohup.sh"]
CMD echo

# You can choose one of the above CMD statements based on your preferred way of starting RainbowMiner.
