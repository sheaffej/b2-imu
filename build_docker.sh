#!/bin/bash

DOCKER_IMAGE="sheaffej/b2-imu"

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker build -t $DOCKER_IMAGE ${MYDIR}
