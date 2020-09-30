# FROM ubuntu:18.04
FROM ros:melodic-robot-bionic

WORKDIR /root
SHELL [ "bash", "-c"]
ENV ROS_WS /ros

RUN apt update \
&& apt install -y \
   git \
   vim \
   python \
   libi2c-dev \
   libeigen3-dev \
   libboost-program-options-dev \
   ninja-build \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# This is the fork of RTIMULib2 that has been ported to
# the Pololu MinIMU-9 v5
RUN git clone https://github.com/fjp/RTIMULib2.git \
&&  cd RTIMULib2/RTIMULib \
&& mkdir build \
&& cd build \
&& cmake .. \
&&  make \
&&  make install

ENV LD_LIBRARY_PATH /usr/local/lib
ENV QT_X11_NO_MITSHM 1

RUN apt-get update \
&& apt-get install -y \
   qt4-default \
&& cd RTIMULib2/Linux \
&& mkdir build \
&& cd build \
&& cmake .. \
&& make \
&& make install \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./calibration/RTIMULib.ini .ros/

RUN mkdir -p ${ROS_WS}/src \
&&  cd ${ROS_WS}/src

# Forked from https://github.com/jeskesen/i2c_imu.git
COPY i2c_imu ${ROS_WS}/src/i2c_imu
COPY b2_imu ${ROS_WS}/src/b2_imu

RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
&& cd ${ROS_WS}/src \
&& catkin_init_workspace \
&& cd ${ROS_WS} \
&& catkin_make 

COPY ./entrypoint.sh /
RUN echo "source /entrypoint.sh" >> .bashrc
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "bash" ]
