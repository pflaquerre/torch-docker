FROM ubuntu:14.04
MAINTAINER Soumith Chintala <soumith@gmail.com>
###############################
#### Install dependencies for torch
###############################
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get -y dist-upgrade
RUN apt-get -y install python-software-properties \
                       software-properties-common
RUN apt-get update
RUN apt-get install -y build-essential \
                       gcc g++ \
                       cmake \
                       curl \
                       libreadline-dev \
                       git-core \
                       libqt4-core libqt4-gui libqt4-dev \
                       libjpeg-dev \
                       libpng-dev \
                       ncurses-dev \
                       imagemagick \
                       libzmq3-dev \
                       gfortran \
                       unzip \
                       gnuplot \
                       gnuplot-x11 \
                       libsdl2-dev \
                       libgraphicsmagick1-dev \
                       nodejs \
                       npm \
                       libfftw3-dev sox libsox-dev libsox-fmt-all
RUN git clone https://github.com/xianyi/OpenBLAS.git /tmp/OpenBLAS
RUN cd /tmp/OpenBLAS && make NO_AFFINITY=1 USE_OPENMP=1 && make install

###########################################
### Now install torch
###########################################
ENV CMAKE_LIBRARY_PATH /opt/OpenBLAS/include:/opt/OpenBLAS/lib:$CMAKE_LIBRARY_PATH
ENV PATH /usr/local/bin:$PATH
RUN git clone https://github.com/torch/luajit-rocks.git /tmp/luajit-rocks
WORKDIR /tmp/luajit-rocks
RUN mkdir build
WORKDIR /tmp/luajit-rocks/build
RUN git checkout master
RUN git pull
RUN rm -f CMakeCache.txt

RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DWITH_LUAJIT21=ON \
    && make \
    && make install

ADD bin/luarocks_install /usr/bin/luarocks_install
RUN chmod +x /usr/bin/luarocks_install
RUN luarocks_install sundown \
                     cwrap  \
                     paths  \
                     torch  \
                     nn     \
                     dok    \
                     gnuplot  \
                     qtlua  \
                     qttorch  \
                     luafilesystem \
                     penlight \
                     sys         \
                     xlua        \
                     image       \
                     optim       \
                     lua-cjson   \
                     trepl       \
                     nnx \
                     threads \
                     graphicsmagick \
                     argcheck \
                     audio \
                     signal \
                     gfx.js
ENV LD_LIBRARY_PATH /usr/local/lib:/opt/OpenBLAS/lib:$LD_LIBRARY_PATH

