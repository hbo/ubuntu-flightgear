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
for d in /dev/nvidia*  ; do
    [ -d $d  ]  && continue
    devices=( ${devices[*]} "--device" "$d":"$d" )
done

docker run --rm --name fgfs \
       --init  \
       ${devices[*]} \
       --device /dev/snd \
       -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
       -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
       -v ~/.config/pulse/cookie:/home/henrik/.config/pulse/cookie \
       --group-add $(getent group audio | cut -d: -f3) \
       -v $HOME/.fgfs:/home/henrik/.fgfs \
       -v /fgfs:/fgfs \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       --env DISPLAY=unix$DISPLAY -it \
       fg_$vers \
       fgfs --fg-root=/fgfs/fgdata \
       --fg-scenery=/fgfs/Scenery \
       --download-dir=/fgfs/downloads \
       --enable-terrasync \
       $*
