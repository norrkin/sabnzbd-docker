# Base image to be used
FROM debian:bullseye

# Tweaked by me
LABEL maintainer "mark <norrkin@icloud.com>"

# Define what release we want to use
ENV SABNZBD_VERSION=4.0.3
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# adding startup script
COPY entrypoint.sh /usr/bin/entrypoint.sh

# Set permissions, create SAB user and group, install dependencies, Build SABnzbd & par2cmdline (multithreaded)
WORKDIR /tmp
RUN chmod 755 /usr/bin/entrypoint.sh && \
    sed -i "s/ main$/ main contrib non-free/" /etc/apt/sources.list && \
    apt-get update -q && \
    apt-get install -qy --no-install-recommends \
        automake \
        autotools-dev \
        build-essential \
        ca-certificates \
        curl \
        git \
        libgomp1 \
        p7zip-full \
        python3-dev \
        python3-pip \
        unrar \
        unzip && \
    curl -o /tmp/sabnzbd.tar.gz https://codeload.github.com/sabnzbd/sabnzbd/tar.gz/${SABNZBD_VERSION} && \
    tar xzf /tmp/sabnzbd.tar.gz && \
    mv sabnzbd-* sabnzbd && \
    pip3 install --no-cache-dir --upgrade pip==22.3.1 && \
    pip3 install -r sabnzbd/requirements.txt --upgrade --no-cache-dir && \
    git clone https://github.com/jkansanen/par2cmdline-mt.git /tmp/par2cmdline-mt && \
    cd /tmp/par2cmdline-mt && \
    aclocal && \
    automake --add-missing && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    mv /tmp/sabnzbd /sabnzbd && \
    apt-get -y remove \
        automake \
        build-essential \
        python-dev && \
    apt-get -y autoremove && apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Mount volumes
VOLUME ["/datadir", "/download"]

# Set working directory
WORKDIR /sabnzbd

# Open port
EXPOSE 8080

# Start SABnzbd
CMD ["/usr/bin/entrypoint.sh"]
HEALTHCHECK CMD curl --fail http://localhost:8080 || exit 1
