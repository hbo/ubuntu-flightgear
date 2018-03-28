#!/bin/bash
#docker run --rm --env DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -it --privileged fg /bin/bash


#docker run --rm --init \
#       -v $HOME/.fgfs:/home/henrik/.fgfs \
#       -v /tmp/.X11-unix:/tmp/.X11-unix \
#       -v /fgfs/fgdata:/fgfs \
#       -it --privileged fg \
#       /usr/local/bin/fgfs  

function help(){
    cat <<EOF

$0 [options] [container params]



-h this help
-u same
-f <version>    flightgear version (default 2017.3.1)
-g <version>    graphics driver version (default 390.25)
-d <driver>     either nv or ... (default nv)

The script starts image fg_<driver>:<flightgear version>_<driver><driver version>

EOF
}

nvvers="390.25"
fgvers="2017.3.1"
driver="nv"

while [ $# -gt 0 ]; do 

    case "$1" in
        -[hu])
            help
            exit 0
            ;;
        -f)
            fgvers="$2"
            shift 2
            ;;
        -g)
            nvvers="$2"
            shift 2
            ;;
        -d)
            driver=$2
            shift 2
            ;;
        *)
            # we are now in the image params
            break
            ;;
    esac
done

imgvers="${driver}:${fgvers}_${driver}${nvvers}"


devices=()
for d in /dev/nvidia* /dev/snd /dev/input/js*   ; do
    [ -d $d  ]  && continue
    devices=( ${devices[*]} "--device" "$d":"$d" )
done

tflag=''
if [ -t 1 ]; then
    tflag='-t'
fi

docker run --rm --name fgfs \
       --init  \
       --hostname $( hostname ) \
       -p 9999:9999 \
       ${devices[*]} \
       -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
       -v ${XDG_RUNTIME_DIR}/pulse:${XDG_RUNTIME_DIR}/pulse \
       -v $HOME/.config:$HOME/.config \
       --group-add $(getent group audio | cut -d: -f3) \
       -v $HOME/.fgfs:$HOME/.fgfs \
       -v /fgfs:/fgfs \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v $HOME/.Xauthority:$HOME/.Xauthority \
       --env DISPLAY=unix$DISPLAY \
       -i $tflag \
       fg_"${imgvers}" \
       fgfs --fg-root=/fgfs/"${fgvers}"-data/fgdata \
       --fg-scenery=/fgfs/Scenery \
       --download-dir=/fgfs/downloads \
       --enable-terrasync \
       --httpd=9999 \
       $*
