#!/bin/bash

# Created: 2018-02-09 1709
# Modfied: 2018-02-10 1102

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

echo
echo "====="
echo "Pushing all images to registry: ${regname}"
echo

docker login

if [ $? -ne 0 ];
then
    exit $?
fi

docker push $regname/open-ocr-arm32v7

if [ $? -ne 0 ];
then
    exit $?
fi

sleep 5

docker push $regname/open-ocr-preprocessor-arm32v7

if [ $? -ne 0 ];
then
    exit $?
fi

sleep 5

docker push $regname/stroke-width-transform-arm32v7

if [ $? -ne 0 ];
then
    exit $?
fi

sleep 5

echo
echo "All images uploaded"
echo "====="
