#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=/home/$USER/.Xauthority
SHARED_DIR=/home/autoware/shared_dir
HOST_DIR=/home/$USER/shared_dir

if [ "$1" = "kinetic" ] || [ "$1" = "indigo" ]
then
    echo "Use $1"
else
    echo "Select distribution, kinetic|indigo"
    exit
fi

if [ "$2" = "" ]
then
    # Create Shared Folder
    mkdir -p $HOST_DIR
else
    HOST_DIR=$2
fi
echo "Shared directory: ${HOST_DIR}"

setfacl -m user:1000:r ${XAUTH}

docker run \
    --runtime nvidia\
    -it --rm \
    --volume=$XAUTH:$XAUTH:rw \
    --volume=$XAUTH:/home/autoware/.Xauthority:rw \
    --volume=$HOST_DIR:$SHARED_DIR:rw \
    --volume=$XSOCK:$XSOCK:rw \
    --env="DISPLAY=${DISPLAY}" \
    -u autoware \
    --privileged -v /dev/bus/usb:/dev/bus/usb \
    --net=host \
    autoware-$1
