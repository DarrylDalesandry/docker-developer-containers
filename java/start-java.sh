#!/bin/bash

IDENTITY="dd-java"
USERNAME="dd-container"

CONTAINER=$(docker images --filter "label=identity=$IDENTITY" -q)

docker run -it --rm -v ~/.ssh:/home/$USERNAME/.ssh:ro $CONTAINER
