# Original Version: https://hub.docker.com/r/tleyden5iwx/stroke-width-transform/~/dockerfile/
#
# Modified by mysmartbus (https://github.com/mysmartbus/) for use on the Raspberry Pi 2 & 3.
#
# Last Modified: 2018-01-26 2257
#
# Build time on a Raspberry Pi 2 is approximately 2m.

FROM arm32v7/ubuntu:16.04

# ca-certificates is needed for the "git clone" command.
RUN apt-get -q -y update && \
        apt-get install -y --no-install-recommends \
        ca-certificates\
        g++ \
        git \
        libboost1.58-all-dev \
        libopencv-calib3d2.4v5 \
        libopencv-calib3d-dev \
        libopencv-contrib2.4v5 \
        libopencv-contrib-dev \
        libopencv-core2.4v5 \
        libopencv-core-dev \
        libopencv-features2d2.4v5 \
        libopencv-features2d-dev \
        libopencv-flann2.4v5 \
        libopencv-flann-dev \
        libopencv-highgui2.4v5 \
        libopencv-highgui-dev \
        libopencv-imgproc2.4v5 \
        libopencv-imgproc-dev \
        libopencv-ml2.4v5 \
        libopencv-ml-dev \
        libopencv-objdetect2.4v5 \
        libopencv-objdetect-dev \
        libopencv-photo2.4v5 \
        libopencv-photo-dev \
        libopencv-video2.4v5 \
        libopencv-video-dev \
        unzip \
        wget

RUN mkdir -p /opt/open-ocr

RUN cd /opt && git clone https://github.com/tleyden/DetectText.git

RUN cd /opt/DetectText && g++ -o DetectText TextDetection.cpp FeaturesMain.cpp -lopencv_core -lopencv_highgui -lopencv_imgproc -I/opt/DetectText

RUN cd /opt/DetectText && cp DetectText /usr/local/bin



