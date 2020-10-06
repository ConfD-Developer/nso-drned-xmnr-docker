#!/bin/bash

NSO_VERSION="5.4.0.2"

if [ -f nso-$NSO_VERSION.linux.x86_64.installer.bin ]
then
    echo "Using:"
    echo "nso-$NSO_VERSION.linux.x86_64.installer.bin"
else
    echo >&2 "This docker build requires that the NSO SDK installers has been placed in this folder."
    echo >&2 "E.g.:"
    echo >&2 "nso-$NSO_VERSION.linux.x86_64.installer.bin"
    echo >&2 "Aborting..."
    exit 1
fi

DOCKERPS=$(docker ps -q -n 1 -f name=nso-drned-xmnr)
if [ -z "$DOCKERPS" ] ;
then
    echo "Build & run"
else
    echo "Stop any existing nso-drned-xmnr container, then build & run"
    docker stop nso-drned-xmnr
fi
docker build -t nso-drned-xmnr --build-arg NSO_VERSION=$NSO_VERSION -f Dockerfile .
