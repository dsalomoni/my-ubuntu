# my-ubuntu <!-- omit in toc -->
This repository contains files used to create a Ubuntu system complete with its GUI, through Docker. This is significantly faster than using for example a Virtual Machine.

This material is provided by prof. Davide Salomoni for the Master in Bioinformatics at the University of Bologna.

**Table of Contents**
- [1. Introduction](#1-introduction)
- [2. Use the provided base Docker image as is](#2-use-the-provided-base-docker-image-as-is)
  - [2.1. Details](#21-details)
- [3. Customize the Docker image](#3-customize-the-docker-image)
  - [3.1. Copy and update a Dockerfile](#31-copy-and-update-a-dockerfile)
  - [3.2. Build your custom Docker image](#32-build-your-custom-docker-image)
  - [3.3. Run the customized image through Docker](#33-run-the-customized-image-through-docker)
- [4. Other uses](#4-other-uses)
  - [4.1. Accessing a directory on your system from Ubuntu](#41-accessing-a-directory-on-your-system-from-ubuntu)
  - [4.2. Logging in to your Ubuntu system without the GUI](#42-logging-in-to-your-ubuntu-system-without-the-gui)
  - [4.3. Restarting from scratch](#43-restarting-from-scratch)
  - [4.4. If some software does not run](#44-if-some-software-does-not-run)
- [5. Acknowledgments](#5-acknowledgments)

## 1. Introduction

A _base Docker image_ was prepared to create a Ubuntu GUI in Docker. The GUI will be accessible via a browser, such as Chrome, Edge, Safari or Firefox.

Here you will find instructions on how to use and possibly customize this base image to create your own Ubuntu installation using Docker images.

**Important**: it is assumed that you have already installed Docker on your system, and that it works correctly. You should know how to edit a file, and how to run a Docker command from a terminal on your system.

What is written here should work with systems running Windows, Linux or Mac OS.

This guide has two main sections:

- You can run the provided base Docker image as is. This is fine if you want just to test how the Ubuntu GUI works, or if you are happy with using just the programs that are pre-installed on the provided Ubuntu system.

- Or, you can modify the base Docker image to customize it, for example installing any other programs you want to have available straight away on your Ubuntu system.

## 2. Use the provided base Docker image as is

All you need to do to get a Ubuntu system complete with a GUI via Docker is to issue the following command from a terminal:

```
docker run -d --rm --name my_desktop -e TZ=Europe/Rome -e USER=ubuntu -e PASSWORD=my_password --mount src=desktop_data,dst=/home/ubuntu --mount src=/dev/shm,dst=/dev/shm,type=bind -p 6080:80 dsalomoni/ubuntu-desktop:1.0
```
The first time you execute this command it will take a while, because the Docker image has to be downloaded and stored on your system.

Once the command is executed, access Ubuntu via a browser by opening the URL http://127.0.0.1:6080. 

When you are done using your Ubuntu system, stop it with the command

```
docker stop my_desktop
```

### 2.1. Details

- The `docker run` command above runs the Docker image called `dsalomoni/ubuntu-desktop:1.0`, creating a container with Ubuntu called `my_desktop`. You can check that the container is running with the command `docker ps`. 
- The Ubuntu system will have a user called `ubuntu`, whose password will be the string specified after `PASSWORD=`. _You are encouraged to change that password in the command above_.
- Any data written to `/home/ubuntu/` in the Ubuntu system will be saved in a "Docker volume" called `desktop_data` (you will learn about Docker volumes in the course <a href="https://www.unibo.it/it/didattica/insegnamenti/insegnamento/2022/433238">Introduction to Big Data Processing Infrastructures</a>, or __BDP1__). 
- The Ubuntu system has some useful programs already installed. These include, for instance, the `Firefox` browser, `python` and some editors, such as `vi` and `nano`. You may install other programs using the standard ways to install software in Ubuntu. For instance, to install the Spyder editor, you could open a terminal in Ubuntu, and type `sudo update && sudo apt install -y spyder` (you will be prompted for the password of the `ubuntu` user). **However**, be warned that any programs you manually install in your Ubuntu system will **disappear** after you stop the container, and will have to be installed again the next time you start the container through the `docker run` command above. So, if you find that you need to have other programs installed in Ubuntu beyond what is already available, go to the next section and learn how to customize the Docker image used here.

## 3. Customize the Docker image

If you want that your Ubuntu system contains software in addition to what was already pre-installed in the base image, you need to create a new Docker image, _derived_ from the base image used in the section above. To do this, a _Dockerfile_ is used.

### 3.1. Copy and update a Dockerfile

A _Dockerfile_ is a text file used to create or customize a Docker image. For details, refer to the courses <a href="https://www.unibo.it/it/didattica/insegnamenti/insegnamento/2022/433238">Introduction to Big Data Processing Infrastructures</a> (__BDP1__) and <a href="https://www.unibo.it/it/didattica/insegnamenti/insegnamento/2022/435337">Infrastructures for Big Data Processing</a> (__BDP2__), part of the <a href="https://corsi.unibo.it/2cycle/Bioinformatics">Two year master in Bioinformatics</a> at the University of Bologna, where details about Docker (among other things) are discussed.

On your machine (Windows, Linux or Mac), open the terminal, download the file called `Dockerfile` from this repository and open an editor to modify it.

In this Dockerfile, you can add whatever packages you want installed on your Ubuntu system by simply adding them _after_ the line reading `RUN sudo apt install ...`. 

As an example, the provided Dockerfile by default installs the `nmon` program, a computer performance system monitor. If, for instance, you wanted to install the `spyder` editor in addition to `nmon`, you would write the following lines:

```
[...]
# --> Install your own packages here <--
RUN sudo apt install -y -q --no-install-recommends \
    nmon spyder
[...]
```
If the program you are interested in is installed by other methods than `apt`, just use those methods as arguments of the `RUN` command. For instance, if you want to install a Python package via `pip`, first make sure that `pip` is installed, and then run `pip`, with something like this:

```
[...]
RUN sudo apt install -y -q --no-install-recommends \
    pip
RUN sudo pip install <your_package>
[...]
```

### 3.2. Build your custom Docker image

Once you have edited the `Dockerfile`, you need to create (or _build_) a new Docker image, containing the packages you have specified. Build the new image with the following command:

```
docker build -t my_ubuntu .
```

This will create a new Docker image on your system, called `my_ubuntu`. Note that you must issue the command above from the same directory where you have put the `Dockerfile`. 

The first time you execute this command it may take some time because several files will have to be downloaded. However, subsequent rebuilds will be faster.

### 3.3. Run the customized image through Docker

You can run your newly built image with the following command:

```
docker run -d --rm --name my_desktop -e TZ=Europe/Rome -e USER=ubuntu -e PASSWORD=my_password --mount src=desktop_data,dst=/home/ubuntu --mount src=/dev/shm,dst=/dev/shm,type=bind -p 6080:80 my_ubuntu
```

This `docker run` command is identical to the one provided in the previous section, with the exception of the last string, which specifies the name of the Docker image to run (`my_ubuntu` here).

Refer to the previous section for an explanation of what the command does. As above, you are advised to change the password for the `ubuntu` user modifying the string after `PASSWORD=`.

As before, open http://127.0.0.1:6080 on a browser to access your customized Ubuntu desktop.

When you are done using your Ubuntu system, stop it with the command

```
docker stop my_desktop
```

## 4. Other uses

### 4.1. Accessing a directory on your system from Ubuntu

If you want to make a directory on your host system (running Windows, Linux or Mac OS) visible to Ubuntu, all you need to do is to add a `--mount` flag to the `docker run` command above. The `--mount` flag should have the following syntax here:

```
--mount src=<host_dir>,dst=<container_dir>,type=bind,readonly
```

For example, if you are on Windows and want to make the Windows directory `C:\bdb` visible to Ubuntu under the directory `/host`, add the following part to the `docker run` command (just add it _after_ the `run`):

```
--mount src=C:\bdb,dst=/host,type=bind,readonly
```

Similarly, if you have a Linux or Mac OS system instead, and want for example to make the directory `/bdb` on your system visible to Ubuntu under the directory `/host`, just add 

```
--mount src=/bdb,dst=/host,type=bind,readonly
```

If you then open a terminal in Ubuntu and type for instance `ls -l /host`, you should see the files stored under your Windows `C:\bdb` (or Linux/Mac OS `/bdb`) directory. The `readonly` part above prevents Ubuntu from modifying the files on the host. If you want to be able to read _and_ write files present on your host system (**be careful**), remove `readonly`. 

### 4.2. Logging in to your Ubuntu system without the GUI

If you want to connect to the Ubuntu system using a terminal, i.e. without the GUI, run the image according to the sections above, and then issue the following command from the terminal:

```
docker exec -it -u ubuntu -w /home/ubuntu my_desktop bash
```

You will be then logged in to Ubuntu. Type `exit` to logout. As usual, type `docker stop my_desktop` when you are done using your Ubuntu system.


### 4.3. Restarting from scratch

If you want to reset everything you did with your system, **including any changes you made to `/home/ubuntu`** on the Ubuntu system, issue the following commands:

```
docker stop my_desktop
docker volume rm desktop_data
```

The first command stops the Ubuntu container if it is running. The second command deletes the Docker volume holding data present under `/home/ubuntu`. **Be careful** if you stored anything there.

### 4.4. If some software does not run

The Docker container providing the Ubuntu environment, started with the `docker run` commands above, has "standard" container privileges. These are OK to install and run many programs on the dockerized Ubuntu environment. However, there are some programs that require special privileges. These are normally programs that need low-level access to some devices on your host system. 

**A general but important warning: before downloading and using any software (on your host system, on a container, or anywhere else), you should be sure it’s trustworthy.**

For example, Visual Studio Code can be easily installed into the Ubuntu system, but it won't run if it is started with the `docker run` commands above. In the case of Visual Studio Code, you can fix this by adding the flag `--cap-add=SYS_ADMIN` to the `docker run` command. This grants the container the possibility to perform a range of system administration operations, since these are required by Visual Studio Code. Other software may need different privileges. 

Note that granting special privileges to Docker containers is **not recommended** and should be avoided if not strictly necessary. More info can be found in the <a href="https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities">Runtime privilege and Linux capabilities</a> documentation of the Docker run reference manual.


## 5. Acknowledgments

This work is based on a modified version of the `docker-ubuntu-vnc-desktop` image, available at <a href="https://github.com/fcwu/docker-ubuntu-vnc-desktop">https://github.com/fcwu/docker-ubuntu-vnc-desktop</a>, where you can also find several possible additional customizations. If you are curious to know how that image was modified here, have a look at the Dockerfile in the `modified` folder.