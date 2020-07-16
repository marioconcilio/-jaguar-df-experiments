#!/usr/bin/env bash

readonly NOCOLOR="\033[0m"
readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033[1;33m"

readonly PROJECT_NAME=$1
readonly VERSION=$2

function install_project() {
	local project_dir=$1
	local d4j_projects="d4jprojects"
	local project_path="$d4j_projects/$project_dir"
	local root=$(pwd)

	# create d4j projects folder
	mkdir -p $d4j_projects

	# checkout project version
	echo -e "${YELLOW}[${PROJECT_NAME}] checkout${NOCOLOR}"
	defects4j checkout -p $PROJECT_NAME -v $VERSION -w $project_path

	# compile project
	cd $project_path
	echo -e "${YELLOW}[${PROJECT_NAME}] compiling${NOCOLOR}"
	defects4j compile

	# run tests
	echo -e "${YELLOW}[${PROJECT_NAME}] running tests${NOCOLOR}"
	defects4j test
	echo -e "${GREEN}[${PROJECT_NAME}] done${NOCOLOR}"

	# back to root folder
	cd $root
}

function main() {
	if [ -z "$PROJECT_NAME" ]
	then
	    echo "Missing project identifier. Possible values are:"
	    cat projects.d4j
	    echo
	    exit 1
	fi

	if [ -z "$VERSION" ]
	then
	    echo "Missing project version. Possible values are (append 'b' for buggy and 'f' for fixed):"
	    cat versions.d4j
	    echo
	    exit 1
	fi

	local project_dir=$(cat projects.d4j | grep $PROJECT_NAME | sed "s/$PROJECT_NAME//g" | xargs)

	if [ -z "$project_dir" ]
	then
		echo "Wrong project identifier. Possible values are:"
		cat projects.d4j
		echo
		exit 1
	fi

	install_project $project_dir
}

main

