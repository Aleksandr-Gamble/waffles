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

# Ensure you have a URI for an AWS Elastic Container Registry
if [ -z "$ECR_URI" ]; then
    echo "environment variable ECR_URI is not set!"
    echo "try something like this example:"
    echo "export ECR_URI=1234567890.abc.ecr.us-east-1.amazonaws.com"
    exit 1
fi


# Build the image
echo "bulding ${VERSIONED_IMAGE}..."
sudo docker build -t $VERSIONED_IMAGE ${FOLDER}/ 

# Create an ECR repository if it does not exist already
aws ecr describe-repositories --repository-names ${IMAGE} || aws ecr create-repository --repository-name ${IMAGE}

# Tag the image so it can be uploaded to ECR
sudo docker tag $VERSIONED_IMAGE ${ECR_URI}/${VERSIONED_IMAGE}

# Login to the AWS ECR image repository:
aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin $ECR_URI

# Push the image
sudo docker push ${ECR_URI}/${VERSIONED_IMAGE}



