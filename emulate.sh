#!/bin/bash
# This script accepts both the name of a folder and a version number
# Example usage: $ ./push.sh demo-lambda-python 1.0
# NOTE: It is expected the ECR_URI has a format like this:
# "1234567890.abc.ecr.us-east-1.amazonaws.com" etc.

# The first argument should be an image: i.e. the name of a folder
FOLDER="$1"
IMAGE="$1"
FILE="${FOLDER}/Dockerfile"
if ! [ -f "$FILE" ]; then
    echo "'$FILE' DOES NOT EXIST!"
    echo "Enter the name of the image (folder) and version you want to use: for example:"
    echo "./push.sh demo-lambda-python 1.0 # builds and pushes the demo-lambda-python:1.0 image"
    exit 1
fi

# The second argument should be the image version
VERSION="$2"
if [ -z "$VERSION" ]; then
    echo "NO IMAGE VERSION SPECIFIED!"
    echo "Enter the name of the image (folder) and version you want to use: for example:"
    echo "./push.sh demo-lambda-python 1.0 # builds and pushes the demo-lambda-python:1.0 image"
    exit 1
fi 
VERSIONED_IMAGE="${IMAGE}:${VERSION}"


# Build the image
echo "bulding ${VERSIONED_IMAGE}..."
sudo docker build -t $VERSIONED_IMAGE ${FOLDER}/ 

# run the image locally
echo "try invoking your function locally with this command:"
echo "curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{\"key\":\"value\" etc.}'"
sudo docker run -p 9000:8080 $VERSIONED_IMAGE


