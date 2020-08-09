#!/usr/bin/env bash

DOCKER_IMAGE="sheaffej/b2-imu"
LABEL="b2"
CONTAINER_NAME="imu_node"

[ -z "$ROS_MASTER_URI" ] && echo "Please set ROS_MASTER_URI env" && exit 1

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR=$MYDIR/../..  # Directory containing the cloned git repos
DOWNLOADS_DIR=~/Downloads

docker run -d --rm \
--name ${CONTAINER_NAME} \
--label ${LABEL} \
--net host \
--privileged \
--env DISPLAY \
--env ROS_MASTER_URI \
--mount type=bind,source=$PROJ_DIR/b2-imu/b2_imu,target=/ros/src/b2_imu \
--mount type=bind,source=${DOWNLOADS_DIR},target=/root/Downloads \
$DOCKER_IMAGE roslaunch b2_imu minimu9.launch 


