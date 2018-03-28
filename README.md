## dockerfile to create flightgear docker image based on ubuntu

### Why?

I was fed up with cluttering my PC with all the development
dependencies in order to get flightgear to compile.



### What do we have here?

This depends partly on https://github.com/hbo/ubuntu-nv


There are two Dockerfiles:

#### Dockerfile_default

Builds flighgear from source using the mesa opengl libraries.

This was basically only a proof of concept (that succeeded) and is not
developed further atm. Ideally this will be integrated with the _nv
version below

#### Dockerfile_nv 

Builds flighgear from source on basis of
https://github.com/hbo/ubuntu-nv to  run on a system with NVIDIA
hardware and the official nvidia driver installed.

build.sh as well as run.sh is currently tailored toward this
Dockerfile.  


