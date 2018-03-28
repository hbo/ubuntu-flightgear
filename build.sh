#!/bin/bash

version=$1
fgversion=${2:-2017.3.1}
nvversion="390.25"
if [ -z "$version" ] ; then
    echo "parameter required: nv or default"
    exit 1
fi

uid=$( id -u )

docker build -f Dockerfile_$version --build-arg=NVVERSION="$nvversion" --build-arg=FGVERSION="$fgversion"  --build-arg=UID=$uid -t fg_$version:"$fgversion"_"$version""$nvversion" .
