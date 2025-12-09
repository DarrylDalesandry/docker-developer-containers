#!/bin/bash

IDENTITY="dd-arduino"
USERNAME="dd-container"

CONTAINER=$(docker images --filter "label=identity=$IDENTITY" -q)

docker run --device=/dev/ttyUSB0 -it --rm -v ~/.ssh:/home/$USERNAME/.ssh:ro $CONTAINER
