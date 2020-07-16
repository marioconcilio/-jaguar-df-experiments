#!/usr/bin/env bash

readonly PROJECT_ID=$1
readonly VERSION=$2

readonly CONTAINER="badua_container_$PROJECT_ID"

docker run \
	--name $CONTAINER \
	--volume $(pwd)/output:/ppgsi/output \
	jaguar \
	./run_badua.sh $PROJECT_ID $VERSION INFO
		
docker rm $CONTAINER
