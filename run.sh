#!/bin/bash
#docker run --rm --env DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -it --privileged fg /bin/bash


docker run --rm --init \
       -v $HOME/.fgfs:/home/henrik/.fgfs \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v /fgfs/fgdata:/fgfs \
       -it --privileged fg \
       /usr/local/bin/fgfs  

