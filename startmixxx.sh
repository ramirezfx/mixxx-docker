#!/bin/bash

HOME="$(echo ~)"
APPNAME=mixxx
CONTAINER=ramirezfx/mixxx:latest-en

set -e

if [[ -n "$(docker ps -qaf 'name=$CONTAINER')" ]]; then
	docker restart $CONTAINER
else
	USER_UID=$(id -u)
	USER_GID=$(id -g)
	xhost +local:docker

	docker run --shm-size=2g --rm \
                --security-opt seccomp=unconfined \
		--env=USER_UID=$USER_UID \
		--env=USER_GID=$USER_GID \
		--env=DISPLAY=unix$DISPLAY \
		-v ${HOME}/docker/$APPNAME-home:/home/$APPNAME \
		--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
		--volume=/run/user/$USER_UID/pulse:/run/pulse:ro \
		--name $APPNAME \
		$CONTAINER
fi
