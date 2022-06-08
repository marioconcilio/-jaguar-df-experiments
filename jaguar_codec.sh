#!/bin/bash -v

readonly PROJECT_NAME=Codec

for i in {1..18}; do 
	./run_jaguar.sh ${PROJECT_NAME} "${i}b";
	./run_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
