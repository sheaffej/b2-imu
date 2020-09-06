#!/usr/bin/env bash

DOCKER_IMAGE="sheaffej/b2-imu"
LABEL="b2"

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR=$MYDIR/../..  # Directory containing the cloned git repos


DOWNLOADS_DIR=~/Downloads

docker run -it --rm \
--label ${LABEL} \
--net host \
--privileged \
--env DISPLAY \
--env ROS_MASTER_URI \
--mount type=bind,source=${DOWNLOADS_DIR},target=/root/Downloads \
--mount type=bind,source=$PROJ_DIR/b2-imu/b2_imu,target=/ros/src/b2_imu \
$DOCKER_IMAGE $@


