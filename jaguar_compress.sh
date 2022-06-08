#!/bin/bash -v

readonly PROJECT_NAME=Compress

for i in {26..47}; do 
	./run_jaguar.sh ${PROJECT_NAME} "${i}b";
	./run_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
