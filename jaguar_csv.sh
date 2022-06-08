#!/bin/bash -v

readonly PROJECT_NAME=Csv

for i in {1..16}; do 
	./docker_jaguar.sh ${PROJECT_NAME} "${i}b";
	./docker_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
