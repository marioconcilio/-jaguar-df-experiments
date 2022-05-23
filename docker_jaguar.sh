#!/usr/bin/env bash

readonly PROJECT_ID=$1
readonly VERSION=$2

readonly PROJECT_LOWER=$(echo $PROJECT_ID | awk '{print tolower($0)}')
readonly JAGUAR_IMAGE="jaguar-$PROJECT_LOWER"
readonly CONTAINER="jc-$PROJECT_LOWER-$VERSION"

docker build -t=$JAGUAR_IMAGE .

docker run \
	--name $CONTAINER \
	--volume $(pwd)/output:/ppgsi/output \
	$JAGUAR_IMAGE \
	./run_jaguar.sh $PROJECT_ID $VERSION DEBUG
		
docker rm $CONTAINER
