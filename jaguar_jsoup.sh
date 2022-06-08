#!/bin/bash -v

readonly PROJECT_NAME=Jsoup

for i in {34..93}; do 
	./run_jaguar.sh ${PROJECT_NAME} "${i}b";
	./run_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
