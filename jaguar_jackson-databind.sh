#!/bin/bash -v

readonly PROJECT_NAME=JacksonDatabind

for i in {1..112}; do 
	./docker_jaguar.sh ${PROJECT_NAME} "${i}b";
	./docker_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
