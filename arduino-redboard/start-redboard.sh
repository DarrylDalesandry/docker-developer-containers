#!/bin/bash

# User editable variables
BUILDPATH="./"

# Constants, do not change
IDENTITY="dd-redboard"
USERNAME="dd-container"

CONTAINER=$(docker images --filter "label=identity=$IDENTITY" -q)

if [[ -z "$CONTAINER" ]]; then
    echo "No Docker image found..."
    sleep 1
    echo -e "\nBuilding image..."
    docker build -t "dd-docker:$IDENTITY" $BUILDPATH

    CONTAINER=$(docker images --filter "label=identity=$IDENTITY" -q)
fi

docker run -it \
    --rm \
    --device=/dev/ttyUSB0 \
    -v ~/.ssh:/home/$USERNAME/.ssh:ro \
    $CONTAINER
