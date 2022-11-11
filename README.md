# my-ubuntu
This repository contains files used to create a Ubuntu GUI running through Docker. This material is provided by prof. Davide Salomoni for the Master in Bioinformatics at the University of Bologna.

## Introduction

A _base Docker image_ was prepared, to create a simple Ubuntu GUI in Docker. Here you will find instructions on how to customize and use this base image.

It is assumed that you have already installed Docker on your system, and that it is working correctly. You should also know how to edit a file, and how to run a Docker command from the terminal (in Windows, Linux or Mac OS).

## Copy and update a Dockerfile

A _Dockerfile_ is a text file used to create or customize a Docker image. For details, refer to the courses <a href="https://www.unibo.it/it/didattica/insegnamenti/insegnamento/2022/433238">Introduction to Big Data Processing Infrastructures"</a> (__BDP1__) and <a href="https://www.unibo.it/it/didattica/insegnamenti/insegnamento/2022/435337">Infrastructures for Big Data Processing</a> (__BDP2__), part of the <a href="https://corsi.unibo.it/2cycle/Bioinformatics">Two year master in Bioinformatics</a> at the University of Bologna, where details about Docker (among other things) are discussed.

Open the terminal, download to your machine the file called `Dockerfile` from this repository and open an editor to modify it.

In this Dockerfile, you can add whatever packages you want to be installed on your Ubuntu installation by simply adding them _after_ the line reading `RUN sudo apt-get install ...`. 

As an example, the Dockerfile by default installs the `nano` editor. If, for instance, you wanted to install the Thunderbird email client in addition to the `nano` editor, you would need to have the following lines:

```
[...]
# --> Install your own packages here <--
RUN sudo apt-get install -y -q --no-install-recommends \
    nano thunderbird
[...]
```

## Build your custom Docker image

Once you have edited the `Dockerfile`, you need to build a new Docker image, containing the packages you have specified. Build the new image with the following command:

```
docker build -t my_ubuntu .
```

This will create a new Docker image, called `my_ubuntu`, on your system. Note that you must issue the command above from the same directory where you have put the `Dockerfile`. 

The first time you execute this command it will take some time because several files will have to be downloaded. However, subsequent changes will be much faster.

## Run the Ubuntu GUI through Docker

Now that you have created your new image, run it with the following command:

```
docker run -d --rm --name my_desktop -e TZ=Europe/Rome -v desktop_data:/root -v /dev/shm:/dev/shm -p 6080:80 my_ubuntu
```

All the data you write under `/root` will be saved in a persistent Docker volume called `desktop_data`. 

Now, simply open http://127.0.0.1:6080 on a browser to access your Ubuntu desktop.

Note that you may directly install other programs, for example using `apt install <program>`. _However_, be warned that once the container is stopped (for instance, because you reboot your system) these programs will have to be installed again. If you want your changes to be persistent, edit the `Dockerfile` as stated above and rebuild the image. 

## Acknowledgments

This work is based on the `docker-ubuntu-vnc-desktop` image, available at <a href="https://github.com/fcwu/docker-ubuntu-vnc-desktop">https://github.com/fcwu/docker-ubuntu-vnc-desktop</a>.