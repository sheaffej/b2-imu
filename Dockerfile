FROM ubuntu:18.04

WORKDIR /root
SHELL [ "bash", "-c"]

RUN apt update \
&& apt install -y \
   git \
   vim \
   python \
   libi2c-dev \
   libeigen3-dev \
   libboost-program-options-dev

RUN git clone https://github.com/DavidEGrayson/minimu9-ahrs.git \
&&  cd minimu9-ahrs \
&&  make \
&&  make install

RUN echo "i2c-bus=/dev/i2c-1" > .minimu9-ahrs \
&&  echo "-1633 2856 -4837 1031 1537 7805" > .minimu9-ahrs-cal




