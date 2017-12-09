#!/bin/bash
#docker run --rm --env DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -it --privileged fg /bin/bash


#docker run --rm --init \
#       -v $HOME/.fgfs:/home/henrik/.fgfs \
#       -v /tmp/.X11-unix:/tmp/.X11-unix \
#       -v /fgfs/fgdata:/fgfs \
#       -it --privileged fg \
#       /usr/local/bin/fgfs  

vers=$1

shift

devices=()
for d in /dev/dri/* ; do
    devices=( ${devices[*]} "--device" "$d":"$d" )
done

docker run --rm --name fgfs \
       --init  \
       ${devices[*]} \
       -v $HOME/.fgfs:/home/henrik/.fgfs \
       -v /space/fgfs/fgdata:/fgfs \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       --env DISPLAY=unix$DISPLAY \
       fg_$vers \
        $*
#       /usr/bin/glxgears $*
