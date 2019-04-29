## Dockerfile and scripts to create flightgear docker image based on ubuntu and run it, too.

### Why?

I was fed up with cluttering my PC with all the development
dependencies in order to get flightgear to compile.



### What do we have here?

This depends partly on https://github.com/hbo/ubuntu-nv

The images that are built here are hardly fit to be pushed onto docker hub. 

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

### Requirements

- A recent version of Docker (18.03.0-ce at the time of writing), configured for access to Internet.
- source packages of flightgear and simgear in the version
  desired. Place the compressed tar balls in the directory together
  with the Dockerfile. Each version needs its own tweaks. You are on your own.

### How to build?

```bash build.sh nv```

Creates image in different stages, of which image fg_nv:2017.3.1_nv390.25 is
the outcome.

### How to run?

```bash run.sh fgfs <flightgear options>```


The run script tries to start the image according to the given
parameters (fg_nv:2017.3.1_nv390.25 as a default).

It mounts the following devices, files and directories into the
container:


- /dev/nvidia*
- /dev/snd
- /dev/input/js*
- /fgfs (assumed to be the data directory)
- /tmp/.X11-unix
- $HOME/.Xauthority
- $HOME/.fgfs
- $HOME/.config (for pulseaudio to work)
- ${XDG_RUNTIME_DIR}/pulse

The hostname of the container is set to the name of the docker host
itself, in order to be connect to the X server using
$HOME/.Xauthority.



