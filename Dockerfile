FROM ubuntu:16.04

#MAINTAINER Gary Bradski

########################################################################
# Running this docker to set up a shared directory and display with the host:
#
# To newly create and build this docker image:
# ============================================
#
# Create a directory <container_name>: 
#    $ mkdir <container_name>
# Copy this Dockerfile into that directory:
#    cp Dockerfile <container_name>/.
# Move to that directory:
#    $ cd <container_name>
# To build the docker file (might have to run with sudo 
#    $ sudo docker build -t <container_name> .
#
# To run the image, or run it again retaining its state 
# =====================================================
#    but also exporting display from the container and
#    sharing a directory between host and container:
#
# Allow other processes to share the display:
#    $ xhost +    #Allows or other processes to capture (show) the display
# Now run the docker (Usually $DISPLAY is :0) and allow use of the camera -- you may need sudo privalage
#    $ sudo docker run  -it  -e DISPLAY=$DISPLAY  -v /tmp/.X11-unix:/tmp/.X11-unix \
#                       --device /dev/video0 \
#                       -v /<path_to_a host_directory>/<directory_on_host>/:/<directory_path/name>/  <container_name>
#
# =======================================================
# Handy docker commands:
# List all the docker images
#    $ sudo docker ps -a  
# If the docker image is stopped (otherwise can skip the first command below if not stopped)
#    $ sudo docker start <container ID from ps -a above>
#    $ sudo docker attach <container ID from ps -a above>
########################################################################
# This is a docker file which will, from scratch:
#
#   * pull in all the dependencies needed for OpenCV 3.2 including python 2 dependencies
#   * pull in OpenCV 3.2 and opencv_contrib and build them
#       + executable files end up in opencv-3.2.0/build/bin
#   * pull in the Learning OpenCV 3 example code and build it
#       + executable files end up in Learning_OpenCV-3_examples/build
#   * To get to the top level directory, just type: cd
#
# If you just want to do this "by hand" in your home, replace the "RUN"s below with "sudo"
#
# This Docker uses the ubuntu 16.04 version of ffmpeg, which is older than the ones in my other dockerfiles.
# this shouldn't cause you any problems but definitely *DO NOT* use this for generating audiofiles / movies for redistribution.
#
# But it is somewhat less capable than the ones in the ffmpeg containers.
########################################################################


# First: get all the dependencies:
#
RUN apt-get update
RUN apt-get install -y build-essential cmake git pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev unzip

RUN apt-get install -y wget

# Just get a simple editor for convienience (you could just cancel this line)
RUN apt-get install -y vim


# Second: get and build OpenCV 3.2
#
ARG OPEN_CV_VERSION=4.1.0
RUN cd \
    && wget https://github.com/opencv/opencv/archive/${OPEN_CV_VERSION}.zip \
    && unzip ${OPEN_CV_VERSION}.zip \
    && rm ${OPEN_CV_VERSION}.zip \
    && wget https://github.com/opencv/opencv_contrib/archive/${OPEN_CV_VERSION}.zip \
    && unzip ${OPEN_CV_VERSION}.zip \
    && rm ${OPEN_CV_VERSION}.zip \
    && mkdir build

WORKDIR /root/build 
RUN cmake -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-${OPEN_CV_VERSION}/modules ../opencv-${OPEN_CV_VERSION} \
    && make -j8 \
    && make install

WORKDIR /home