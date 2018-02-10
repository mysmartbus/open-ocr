#!/bin/bash

# Created: 2018-02-07 1853
# Modfied: 2018-02-10 1045

if [ -z "$1" ];
then
    echo "Usage: $(basename $0) registry_name"
    echo
    echo " registry_name"
    echo -e "\tThis is the docker registry you want to push the images to."
    echo -e "\tThis can be any docker registry you have permission to upload to."
    echo -e "\tDo not include any image names as doing so will cause docker push to fail."
    echo
    echo -e " Spaces, tabs, and newlines are not allowed in the registry name."
    echo
    echo -e " To view this help page, run '$(basename $0)'"

    exit 1
fi

regname=$1

echo "====="
echo "Rebuilding all images"
echo

dockerpath="${HOME}/open-ocr/docker-compose/dockerfiles"


echo "Image: ${regname}/open-ocr-arm32v7"
echo
cd $dockerpath/open-ocr-arm32v7
docker build -t $regname/open-ocr-arm32v7 .

if [ $? -ne 0 ];
then
    exit $?
fi

echo
echo "Image: ${regname}/stroke-width-transform-arm32v7"
echo
cd $dockerpath/stroke-width-transform-arm32v7
docker build -t $regname/stroke-width-transform-arm32v7 .

if [ $? -ne 0 ];
then
    exit $?
fi

echo
echo "Image: ${regname}/open-ocr-preprocessor-arm32v7"
echo
cd $dockerpath/open-ocr-preprocessor-arm32v7
docker build -t $regname/open-ocr-preprocessor-arm32v7 .

if [ $? -ne 0 ];
then
    exit $?
fi

echo
echo "All images rebuilt"
echo "====="
