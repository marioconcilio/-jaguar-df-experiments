#!/bin/bash -v

readonly PROJECT_NAME=JacksonXml

for i in {1..6}; do 
	./run_jaguar.sh ${PROJECT_NAME} "${i}b";
	./run_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
