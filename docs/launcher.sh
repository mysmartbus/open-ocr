#!/usr/bin/env bash

# Launches all components of the OpenOCR service on the Orchard Docker PAAS
# 
# To run this script:
# $ export ORCHARD_HOST=107.170.72.189
# $ export RABBITMQ_PASS=the_ns_effin_A!b!@tcH

# TODO
# export HTTP_PORT=8080  

if [ ! -n "$ORCHARD_HOST" ] ; then
  echo "You must define ORCHARD_HOST"
  exit
fi

if [ ! -n "$RABBITMQ_PASS" ] ; then
  echo "You must define RABBITMQ_PASS"
  exit
fi

export AMQP_URI=amqp://admin:${RABBITMQ_PASS}@${ORCHARD_HOST}/

orchard docker run -d -p 5672:5672 -p 15672:15672 -e RABBITMQ_PASS=${RABBITMQ_PASS} tutum/rabbitmq

orchard docker run -d tleyden5iwx/open-ocr open-ocr-worker -amqp_uri "${AMQP_URI}"

orchard docker run -d -p 8081:8081 tleyden5iwx/open-ocr open-ocr-httpd -amqp_uri "${AMQP_URI}"
