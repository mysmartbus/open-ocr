# Using the .sh files

The files `run_all.sh`, `rebuild_images.sh`, `push.sh`, and `deploy_stack.sh` are bash scripts to automate the process of updating and deploying open-ocr to your docker swarm.

**Compatibility Note**: These scripts have only been tested on the [Raspbian OS](https://www.raspberrypi.org/downloads/raspbian/) and [Ubuntu.](https://www.ubuntu.com/)

# run_all.sh

Updates your open-ocr service with the changes you made to `docker-compose.yml` and the docker files.

**Note**: Any changes you made to the golang code on your computer will be ignored because the golang code is downloaded from github when rebuilding the images.

```
    Usage: ./run_all.sh --registry <registry_name> --stack-name <stack_name>
    
    Both --registry and --stack-name are required for this script to work.
    
    --registry <registry_name>
        This is the docker registry you want to push the images to.
        This can be any docker registry you have permission to upload to.
        Do not include any image names as doing so will cause docker push to fail.
    
    --stack-name <stack_name>
        This is the name to give the stack when it is deployed.
    
    Spaces, tabs, and newlines are not allowed in the registry name and in the stack name.
    
    To view this help page, run './run_all.sh --help'
    
    Unrecognized options will be ignored.
```

# rebuild_images.sh

Uses the `Dockerfiles` to update your local versions of the docker images.

```
    Usage: ./rebuild_images.sh registry_name
    
    registry_name
        This is the docker registry you want to push the images to.
        This can be any docker registry you have permission to upload to.
        Do not include any image names as doing so will cause docker push to fail.
    
    Spaces, tabs, and newlines are not allowed in the registry name.
    
    To view this help page, run './rebuild_images.sh'
```

# push.sh

Uploads your version of the docker images to the docker registry you specify.

```
    Usage: ./push.sh registry_name
    
    registry_name
        This is the docker registry you want to push the images to.
        This can be any docker registry you have permission to upload to.
        Do not include any image names as doing so will cause docker push to fail.
    
    Spaces, tabs, and newlines are not allowed in the registry name.
    
    To view this help page, run './push.sh'
```

# deploy_stack.sh

Deploy the open-ocr service to your docker swarm.

```
    Usage: ./deploy_stack.sh stack_name
    
    stack_name
        All of the open-ocr services will be placed on this stack.
    
        Docker stacks isolate the services to minimize interference
        with other services already running on your docker swarm.
    
    Spaces, tabs, and newlines are not allowed in the registry name.
    
    To view this help page, run './deploy_stack.sh'
```
