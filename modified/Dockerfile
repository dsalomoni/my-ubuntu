# This is the Dockerfile used to build the new base image
# starting from https://github.com/fcwu/docker-ubuntu-vnc-desktop

FROM dorowu/ubuntu-desktop-lxde-vnc:latest

# Set environment variables
ENV QT_X11_NO_MITSHM=1

# Prevent prompts
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Remove unwanted packages
RUN sudo dpkg --remove google-chrome-stable && \
    sudo apt -y autoremove

# Upgrade packages
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4EB27DB2A3B88B8B
RUN sudo apt update -y && sudo apt upgrade -y

# --> Install your own packages here <--
RUN sudo apt-get install -y -q --no-install-recommends \
    wget iputils-ping ssh build-essential curl git unzip zip

# APT autoremove
RUN sudo apt -y autoremove