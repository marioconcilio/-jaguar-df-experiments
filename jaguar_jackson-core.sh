#!/bin/bash -v

readonly PROJECT_NAME=JacksonCore

for i in {1..26}; do 
	./docker_jaguar.sh ${PROJECT_NAME} "${i}b";
	./docker_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
