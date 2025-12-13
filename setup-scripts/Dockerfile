from ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN \
    apt-get update && apt-get install -y tzdata curl git qemu-utils parted cloud-guest-utils && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN curl -L tinyurl.com/osprimer | sh
RUN mkdir -p /home/apham/virt/images