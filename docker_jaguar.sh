#!/usr/bin/env bash

readonly PROJECT_ID=$1
readonly VERSION=$2
readonly LOG_LEVEL=$3

readonly JAGUAR_CONTAINER="jaguar_container"

docker run \
		--name $JAGUAR_CONTAINER \
		--volume $(pwd)/output:/ppgsi/output \
		jaguar \
		./run_jaguar.sh $PROJECT_ID $VERSION $LOG_LEVEL
		
docker rm $JAGUAR_CONTAINER
