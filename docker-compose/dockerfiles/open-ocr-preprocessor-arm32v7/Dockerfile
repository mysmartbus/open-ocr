# Original Version: https://hub.docker.com/r/tleyden5iwx/open-ocr-preprocessor/
#
# Modified by mysmartbus (https://github.com/mysmartbus/) for use on the Raspberry Pi 2 & 3.
#
# Last Modified: 2018-01-26 2257
#
# Build time on a Raspberry Pi 2 is approximately 10m.

FROM mysmartbus/stroke-width-transform-arm32v7

RUN apt-get update && \
    apt-get install -y wget

WORKDIR /

RUN wget https://dl.google.com/go/go1.9.3.linux-armv6l.tar.gz && \
    tar -xvzf /go1.9.3.linux-armv6l.tar.gz -C /usr/local

ENV PATH="/usr/local/go/bin:${PATH}"

ENV GOPATH /opt/go

RUN mkdir -p $GOPATH

RUN mkdir -p /opt/open-ocr

RUN apt-get -q -y update && \
        apt-get install -y \
        git \
        golang \
        gcc

# since we are gonna install open-ocr, we need all the tesseract / leptonica deps
RUN apt-get -y install \
    libleptonica-dev \
    libtesseract3 \
    libtesseract-dev \
    tesseract-ocr-eng

RUN go get -u -v github.com/tleyden/open-ocr

# build open-ocr-preprocessor binary and copy it to /usr/bin
RUN cd $GOPATH/src/github.com/tleyden/open-ocr/cli-preprocessor && \
    go build -v -o open-ocr-preprocessor && \
    cp open-ocr-preprocessor /usr/bin

