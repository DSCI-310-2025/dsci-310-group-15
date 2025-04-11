#!/bin/bash

IMAGE_NAME="heart_attack_prediction"
PORT=8815


docker build --platform=linux/amd64 -t $IMAGE_NAME .
docker run --platform=linux/amd64 --rm -it -p $PORT:8888 -v "$(pwd)":/home/jovyan $IMAGE_NAME
echo "Please Access Jupyter Notebook at: http://localhost:$PORT"