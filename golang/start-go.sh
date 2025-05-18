#!/bin/bash

IDENTITY="dd-go"
USERNAME="dd-container"

CONTAINER=$(docker images --filter "label=identity=$IDENTITY" -q)

docker run -it --rm -v ~/.ssh:/home/$USERNAME/.ssh:ro $CONTAINER
