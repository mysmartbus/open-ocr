#!/bin/bash

# Created: 2018-02-08 1709
# Modfied: 2018-02-10 1059

usage() {
    echo
    echo "Usage: $(basename $0) --registry <registry_name> --stack-name <stack_name>"
    echo
    echo " Both --registry and --stack-name are required for this script to work."
    echo
    echo " --registry <registry_name>"
    echo -e "\tThis is the docker registry you want to push the images to."
    echo -e "\tThis can be any docker registry you have permission to upload to."
    echo -e "\tDo not include any image names as doing so will cause docker push to fail."
    echo
    echo -e " --stack-name <stack_name>"
    echo -e "\tThis is the name to give the stack when it is deployed."
    echo
    echo " Spaces, tabs, and newlines are not allowed in the registry name and in the stack name."
    echo
    echo " To view this help page, run '$(basename $0) --help'"
    echo
    echo " Unrecognized options will be ignored."
    echo
}

if [ $# -lt 2 ];
then
    usage
    exit 1
fi

REGNAME=''
STACKNAME=''

while [ "$1" != "" ]; do
    case $1 in
        -r | --registry )       shift
                                REGNAME=$1
                                ;;
        -s | --stack-name )     shift
                                STACKNAME=$1
                                ;;
        -h | --help )           usage
                                exit 0
                                ;;
    esac
    shift
done

# Remove trailing forward slash if any
REGNAME=${REGNAME%/}

# Remove all whitespace (space, tab, newline)
REGNAME_NO_WHITESPACE="$(echo -e "${REGNAME}" | tr -d '[:space:]')"
STACKNAME_NO_WHITESPACE="$(echo -e "${STACKNAME}" | tr -d '[:space:]')"

# A space, tab, or newline was entered as the name
if [ "${REGNAME_NO_WHITESPACE}x" = "x" ] || [ "${STACKNAME_NO_WHITESPACE}x" = "x" ];
then
    usage
    exit 1
fi

# Whitespace is not allowed in name
if [ ${#REGNAME_NO_WHITESPACE} != ${#REGNAME} ] || [ ${#STACKNAME_NO_WHITESPACE} != ${#STACKNAME} ];
then
    usage
    exit 1
fi

echo -e "Registry the images will be uploaded to:\n\t$REGNAME\n"
echo -e "Stack the services will assigned to:\n\t$STACKNAME"
echo

# User must input a 'y' or the word 'yes' to build, push, and deploy the images.
while true; do
    read -p "Is the above info correct? [N/y]: " yn
    case $yn in
    [Yy]* ) answer=true ; break;;
    [Nn]* ) answer=false ; break;;
    * ) answer=false ; break;;
    esac
done

echo
if $answer;
then
    ./rebuild_images.sh $regname

    if [ $? -ne 0 ];
    then
        exit $?
    fi

    ./push.sh $regname

    if [ $? -ne 0 ];
    then
        exit $?
    fi

    ./deploy_stack.sh $stackname
else
    echo "Build, push, and deployment of images canceled."
fi
