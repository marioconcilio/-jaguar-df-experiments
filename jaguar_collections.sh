#!/bin/bash -v

readonly PROJECT_NAME=Collections

for i in {25..28}; do 
	./run_jaguar.sh ${PROJECT_NAME} "${i}b";
	./run_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
