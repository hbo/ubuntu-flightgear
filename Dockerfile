FROM ubuntu as buildbase

ENV DEBIAN_FRONTEND noninteractive
ARG VERSION='2017.3.1'

COPY 02proxy /etc/apt/apt.conf.d/02proxy

ADD simgear-${VERSION}.tar.bz2 /usr/src
ADD flightgear-${VERSION}.tar.bz2 /usr/src

RUN apt-get update
RUN apt-get install -y cmake make g++ 
RUN apt-get install -y libboost-dev
RUN apt-get install -y libgl-dev
RUN apt-get install -y libopenal-dev
RUN apt-get install -y libopenscenegraph-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libcurl4-openssl-dev

ADD nvidialayer.tar.gz /

RUN mkdir /usr/src/simbuild /usr/src/fgbuild

FROM buildbase as simbuild

ARG VERSION='2017.3.1'

WORKDIR /usr/src/simbuild 

RUN cmake ../simgear-${VERSION} -DCMAKE_BUILD_TYPE=Release
RUN make -j 3
RUN make install

FROM buildbase as fgbuild

ARG VERSION='2017.3.1'

COPY --from=simbuild /usr/local /usr/local

RUN ldconfig

WORKDIR /usr/src/fgbuild 

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y libplib-dev
RUN apt-get install -y libqt5opengl5-dev
RUN apt-get install -y  qtdeclarative5-dev
RUN cmake ../flightgear-${VERSION} -DCMAKE_BUILD_TYPE=Release
RUN make -j 3
RUN make install


FROM ubuntu  as runenv

ENV DEBIAN_FRONTEND noninteractive

COPY 02proxy /etc/apt/apt.conf.d/02proxy

RUN apt-get update \
    && apt-get install -y libopenal1 \
       libx11-6 \
       libplib1 \
       libcurl3 \
       libqt5widgets5 \
       libqt5qml5 \
       libopenthreads20 \
       libopenscenegraph100v5 \
       strace less man \
       mesa-utils \
    &&  apt-get autoclean && rm -rf /var/lib/apt/*

ADD nvidialayer.tar.gz /


FROM runenv

COPY --from=fgbuild /usr/local /usr/local
