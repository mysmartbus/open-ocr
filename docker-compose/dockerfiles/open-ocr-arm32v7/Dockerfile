# Original Version: https://hub.docker.com/r/tleyden5iwx/open-ocr/~/dockerfile/
#
# Modified by mysmartbus (https://github.com/mysmartbus/) for use on the Raspberry Pi 2 & 3.
#
# Last Modified: 2018-02-09 0716
#
# Build time on a Raspberry Pi 2 is approximately 12m.

FROM arm32v6/alpine:3.7

RUN apk update && \
    apk upgrade

# This also installs gcc
RUN apk add --update \
    go \
    git \
    musl-dev

ENV PATH="/usr/local/go/bin:${PATH}"

# Source code goes here
ENV GOPATH /opt/go

# Verification that golang was installed correctly
# The 'echo' is to make it easier to read as it scrolls by
#RUN echo && which go && whereis go && go version && echo

# Install tesseract
RUN apk add \
    leptonica-dev \
    tesseract-ocr-dev \
    tesseract-ocr

# Get language data.
RUN apk add \
  tesseract-ocr-data-ara \
  tesseract-ocr-data-bel \
  tesseract-ocr-data-ben \
  tesseract-ocr-data-bul \
  tesseract-ocr-data-ces \
  tesseract-ocr-data-chi_sim \
  tesseract-ocr-data-chi_tra \
  tesseract-ocr-data-dan \
  tesseract-ocr-data-deu \
  tesseract-ocr-data-ell \
  tesseract-ocr-data-fin \
  tesseract-ocr-data-fra \
  tesseract-ocr-data-heb \
  tesseract-ocr-data-hin \
  tesseract-ocr-data-ind \
  tesseract-ocr-data-isl \
  tesseract-ocr-data-ita \
  tesseract-ocr-data-jpn \
  tesseract-ocr-data-kor \
  tesseract-ocr-data-nld \
  tesseract-ocr-data-nor \
  tesseract-ocr-data-pol \
  tesseract-ocr-data-por \
  tesseract-ocr-data-ron \
  tesseract-ocr-data-rus \
  tesseract-ocr-data-spa \
  tesseract-ocr-data-swe \
  tesseract-ocr-data-tha \
  tesseract-ocr-data-tur \
  tesseract-ocr-data-ukr \
  tesseract-ocr-data-vie

RUN mkdir -p $GOPATH

RUN mkdir -p /opt/open-ocr

# go get open-ocr
RUN go get -u -v -t github.com/tleyden/open-ocr

# build open-ocr-httpd binary and copy it to /usr/bin
RUN cd $GOPATH/src/github.com/tleyden/open-ocr/cli-httpd && go build -v -o open-ocr-httpd && cp open-ocr-httpd /usr/bin

# build open-ocr-worker binary and copy it to /usr/bin
RUN cd $GOPATH/src/github.com/tleyden/open-ocr/cli-worker && go build -v -o open-ocr-worker && cp open-ocr-worker /usr/bin 
