#!/bin/bash

export GOSS_FILES_PATH=test
export GOSS_SLEEP=5

# build image
docker build -t norrkin/sabnzbd . || exit 1

# run some tests
i=0
time dgoss run -e UID=100 -e GID=100 norrkin/sabnzbd || ((i++))

exit $i
