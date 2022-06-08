#!/bin/bash -v

readonly PROJECT_NAME=Mockito

for i in {1..38}; do 
	./docker_jaguar.sh ${PROJECT_NAME} "${i}b";
	./docker_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
