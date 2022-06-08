#!/bin/bash -v

readonly PROJECT_NAME=Cli

for i in {1..40}; do 
	if [[ "$i" == 6 ]]; then
		continue
	fi
	./run_jaguar.sh ${PROJECT_NAME} "${i}b";
	./run_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
