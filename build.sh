#!/bin/bash

version=$1

if [ -z "$version" ] ; then
    echo "parameter required: nv or default"
    exit 1
fi

uid=$( id -u )

docker build -f Dockerfile_$version --build-arg=HOST=$( hostname )  --build-arg=UID=$uid -t fg_$version .
