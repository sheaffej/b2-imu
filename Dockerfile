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

# minimu9-ahrs
# RUN git clone https://github.com/DavidEGrayson/minimu9-ahrs.git \
# &&  cd minimu9-ahrs \
# &&  make \
# &&  make install \
# &&  echo "i2c-bus=/dev/i2c-1" > .minimu9-ahrs \
# &&  echo "-1633 2856 -4837 1031 1537 7805" > .minimu9-ahrs-cal

RUN git clone https://github.com/fjp/RTIMULib2.git \
&&  cd RTIMULib2/RTIMULib \
&& mkdir build \
&& cd build \
&& cmake .. \
&&  make \
&&  make install

ENV LD_LIBRARY_PATH /usr/local/lib

RUN mkdir -p ${ROS_WS}/src \
&&  cd ${ROS_WS}/src \
&&  git clone https://github.com/jeskesen/i2c_imu.git

RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
&& cd ${ROS_WS}/src \
&& catkin_init_workspace \
&& cd ${ROS_WS} \
&& catkin_make 

COPY ./entrypoint.sh /
RUN echo "source /entrypoint.sh" >> .bashrc
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "bash" ]

RUN apt update \
&& apt install -y \
   qt4-default \
&& cd RTIMULib2/Linux \
&& mkdir build \
&& cd build \
&& cmake .. \
&& make \
&& make install \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV QT_X11_NO_MITSHM 1
