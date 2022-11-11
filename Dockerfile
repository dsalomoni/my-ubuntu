# Dockerfile to create a Ubuntu GUI in Docker
# prof. Davide Salomoni

FROM dsalomoni/ubuntu-desktop:1.0

# Upgrade packages
RUN sudo apt update -y && sudo apt upgrade -y

# --> Install your own packages here <--
RUN sudo apt-get install -y -q --no-install-recommends \
    nano