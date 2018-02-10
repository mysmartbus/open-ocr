[![GoDoc](http://godoc.org/github.com/tleyden/open-ocr?status.png)](http://godoc.org/github.com/tleyden/open-ocr) 
[![Join the chat at https://gitter.im/tleyden/open-ocr](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/tleyden/open-ocr?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

OpenOCR makes it simple to host your own OCR REST API.

This fork of https://github.com/tleyden/open-ocr has been modified to run on the Rapsberry Pi 3. It should also work on other armhf/arm32v7 based computers but this has not been tested.

The heavy lifting OCR work is handled by [Tesseract OCR](https://code.google.com/p/tesseract-ocr/).

[Docker](http://www.docker.io) is used to containerize the various components of the service.

![screenshot](http://tleyden-misc.s3.amazonaws.com/blog_images/openocr-architecture.png)

# Features

* Scalable message passing architecture via RabbitMQ.
* Platform independence via Docker containers.
* [Kubernetes support](https://github.com/tleyden/open-ocr/tree/master/kubernetes): workers can run in a Kubernetes Replication Controller
* Supports 31 languages in addition to English 
* Ability to use an image pre-processing chain.  An example using [Stroke Width Transform](https://github.com/tleyden/open-ocr/wiki/Stroke-Width-Transform) is provided.
* Pass arguments to Tesseract such as character whitelist and page segment mode.
* [REST API docs](http://docs.openocr.apiary.io/)
* A [Go REST client](http://github.com/tleyden/open-ocr-client) is available.


# Launching OpenOCR on a Docker PAAS

OpenOCR can easily run on any PAAS that supports Docker containers.  Here are the instructions for a few that have already been tested:

* [Launch on Google Container Engine GKE - Kubernetes](https://github.com/tleyden/open-ocr/wiki/Installation-on-Google-Container-Engine)
* [Launch on AWS with CoreOS](https://github.com/tleyden/open-ocr/wiki/Installation-on-CoreOS-Fleet)
* [Launch on Google Compute Engine](https://github.com/tleyden/open-ocr/wiki/Installation-on-Google-Compute-Engine)

If your preferred PAAS isn't listed, please open a [Github issue](https://github.com/tleyden/open-ocr/issues) to request instructions.

# Installing as a Docker Service

 * [Install docker](https://docs.docker.com/installation/)
 * `git clone https://github.com/mysmartbus/open-ocr.git`
 * `cd open-ocr/docker-compose`
 * Type `./install.sh stack_name` (in case you don't have execute right type `sudo chmod +x install.sh`

The Docker nodes will begin downloading the images from hub.docker.com and extracting them to the SD card. This will take a couple of minutes to complete.

To view progress, run `watch -n 5 'docker service ls'`. This will run the `docker service ls` command every 5 seconds until you press Ctrl-C.

There will be four new services:

* [RabbitMQ](https://hub.docker.com/r/arm32v7/rabbitmq/)
* [OpenOCR Worker](https://hub.docker.com/r/mysmartbus/open-ocr-arm32v7/)
* [OpenOCR HTTP API Server](https://hub.docker.com/r/mysmartbus/open-ocr-arm32v7/)
* [OpenOCR Transform Worker](https://hub.docker.com/r/mysmartbus/open-ocr-preprocessor-arm32v7/)

You are now ready to decode images to text via your REST API.

# Rebuilding the Images

* `cd open-ocr/docker-compose`
* Type `./rebuild_images.sh tag` (in case you don't have execute right type `sudo chmod +x rebuild_images.sh`

`tag` is passed onto `docker build -t` to identify the images and so docker knows which registry to upload them to. Read the [Docker build](https://docs.docker.com/engine/reference/commandline/build/#tag-an-image--t) docs if you are unsure of what to enter for the tag.

It will take about 30 minutes on a Raspberry Pi 2 to build the images. After the images have been built, they will be uploaded to either the docker public registry (hub.docker.com) or a registry of your choice.

# Testing Your OCR Service

## Find your host address

Log onto any of your Docker swarm managers and run the following command.

`docker info | grep "Node Address"`

This will print something similar to `Node Address: 192.168.17.107`.

## The Test

**Request**

```
$ curl -X POST -H "Content-Type: application/json" -d '{"img_url":"http://bit.ly/ocrimage","engine":"tesseract"}' http://IP_ADDRESS_OF_DOCKER_HOST:HTTP_PORT/ocr
```

Assuming the values are 192.168.17.107 and 9292, replace `IP_ADDRESS_OF_DOCKER_HOST` with the IP Address (e.g. 192.168.17.107) and replace `HTTP_PORT` with the port number inside the `docker-compose.yml` file. Default port numer is 9292.

```
$ curl -X POST -H "Content-Type: application/json" -d '{"img_url":"http://bit.ly/ocrimage","engine":"tesseract"}' http://192.168.17.107:9292/ocr
```

**Response**

It will return the decoded text for the [test image](http://bit.ly/ocrimage):

```
You can create local variables for the pipelines within the template by
prefixing the variable name with a "$" sign. Variable names have to be
composed of alphanumeric characters and the underscore. In the example
below I have used a few variations that work for variable names.
```

## With image base64


**Request**

```
$ curl -X POST -H "Content-Type: application/json" -d '{"img_base64":"<YOUR BASE 64 HERE>","engine":"tesseract"}' http://192.168.17.107:9292/ocr
```

**Response**

It will return the decoded text for the [test image](http://bit.ly/ocrimage):

```
You can create local variables for the pipelines within the template by
prefixing the variable name with a "$" sign. Variable names have to be
composed of alphanumeric characters and the underscore. In the example
below I have used a few variations that work for variable names.
```

You can use a website such as https://www.base64-image.de/ to convert an image to base64. Keep in mind that this will create a very long string of letters and numbers. The base64 representation of the test image resulted in a string of 79,109 characters.


## The REST API also supports:

* Uploading the image content via `multipart/related`, rather than passing an image URL.  (example client code provided in the [Go REST client](http://github.com/tleyden/open-ocr-client))
* Tesseract config vars (eg, equivalent of -c arguments when using Tesseract via the command line) and Page Seg Mode 
* Ability to use an image pre-processing chain, eg [Stroke Width Transform](https://github.com/tleyden/open-ocr/wiki/Stroke-Width-Transform).
* Non-English languages

See the [REST API docs](http://docs.openocr.apiary.io/) and the [Go REST client](http://github.com/tleyden/open-ocr-client) for details.


# Uploading local files using curl

The supplied `docs/upload-local-file.sh` provides an example of how to upload a local file using curl with `multipart/related` encoding of the json and image data:
* usage: `docs/upload-local-file.sh <urlendpoint> <file> [mimetype]`
* download the example ocr image `wget http://bit.ly/ocrimage`
* example: `docs/upload-local-file.sh http://10.0.2.15:$HTTP_PORT/ocr-file-upload ocrimage` 


# Community

* Follow [@OpenOCR](https://twitter.com/openocr) on Twitter
* Checkout the [Github issue tracker](https://github.com/mysmartbus/open-ocr/issues)

# Client Libraries

* **Go** [open-ocr-client](https://github.com/tleyden/open-ocr-client)
* **C#** [open-ocr-dotnet](https://github.com/alex-doe/open-ocr-dotnet)

# License

OpenOCR is Open Source and available under the Apache 2 License.
