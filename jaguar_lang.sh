#!/bin/bash -v

readonly PROJECT_NAME=Lang

for i in {1..64}; do 
	if [[ "$i" == 2 ]]; then
		continue
	fi

	./docker_jaguar.sh ${PROJECT_NAME} "${i}b";
	./docker_jaguar.sh ${PROJECT_NAME} "${i}f"; 
done
