FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
WORKDIR /binwalk

COPY /patch_deps_script.patch /

RUN apt-get update -y; \
 \
 apt-get install -y \
 wget \
 curl \
 python3 \
 python3-pip \
 xvfb \
 git;

RUN git clone https://github.com/ReFirmLabs/binwalk.git /binwalk; \
 cd /binwalk; \
 git apply /patch_deps_script.patch; \
 ./deps.sh --yes; \
 python3 setup.py install;

RUN apt-get clean; \
 rm -rf /var/lib/apt/lists/*

# TODO: Run binwalk as non-root user

WORKDIR /target
ENTRYPOINT ["/usr/local/bin/binwalk"]
