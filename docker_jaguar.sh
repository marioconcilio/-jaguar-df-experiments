#!/usr/bin/env bash

readonly PROJECT_ID=$1
readonly VERSION=$2

readonly JAGUAR_IMAGE="jaguar_$PROJECT_ID"
readonly CONTAINER="jaguar_container_$PROJECT_ID"

docker build -t=$JAGUAR_IMAGE .

docker run \
	--name $CONTAINER \
	--volume $(pwd)/output:/ppgsi/output \
	$JAGUAR_IMAGE \
	./run_jaguar.sh $PROJECT_ID $VERSION
		
docker rm $CONTAINER
