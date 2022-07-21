#!/bin/bash

pushd .
cd lightning/parser
docker build . -f docker/Dockerfile -t registry:8087/lightning
docker push registry:8087/lightning
popd

pushd .
cd rawinsonde
docker build . -t registry:8087/rawinsonde
docker push registry:8087/rawinsonde
popd
