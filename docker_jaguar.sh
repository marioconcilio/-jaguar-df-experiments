#!/usr/bin/env bash

readonly PROJECT_ID=$1
readonly VERSION=$2

readonly CONTAINER="jaguar_container_$PROJECT_ID"

docker run \
	--name $CONTAINER \
	--volume $(pwd)/output:/ppgsi/output \
	jaguar \
	./run_jaguar.sh $PROJECT_ID $VERSION
		
docker rm $CONTAINER
