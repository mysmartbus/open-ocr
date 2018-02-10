#!/bin/bash

# Created: 2018-02-06 1809
# Modfied: 2018-02-10 0924

if [ -z "$1" ];
then
    echo "Usage: $(basename $0) stack_name"
    echo
    echo " stack_name"
    echo -e "\tAll of the open-ocr services will be placed on this stack."
    echo
    echo -e "\tDocker stacks isolate the services to minimize interference"
    echo -e "\twith other services already running on your docker swarm."
    echo
    echo " Spaces, tabs, and newlines are not allowed in the registry name."
    echo
    echo " To view this help page, run '$(basename $0)'"

    exit 1
fi

stackname=$1

docker stack rm "$stackname"
echo
echo "10 second pause..."
sleep 10
echo
docker stack deploy --compose-file docker-compose.yml "$stackname"
