#!/usr/bin/env bash

readonly NOCOLOR="\033[0m"
readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033[1;33m"

readonly D4J_PROJECTS="d4jprojects"
readonly PROJECT_NAME=$1
readonly VERSION=$2

LOG_LEVEL=$3 # ALL / TRACE / DEBUG / INFO / WARN / ERROR

function install_project() {
	local project_dir=$1
	local project_path="$D4J_PROJECTS/$project_dir"
	local root=$(pwd)

	# create d4j projects folder
	mkdir -p $D4J_PROJECTS

	# checkout project version
	echo -e "${YELLOW}[${project_dir}] checkout${NOCOLOR}"
	defects4j checkout -p $PROJECT_NAME -v $VERSION -w $project_path

	# compile project
	cd $project_path
	echo -e "${YELLOW}[${project_dir}] compiling${NOCOLOR}"
	defects4j compile

	# run tests
	echo -e "${YELLOW}[${project_dir}] running tests${NOCOLOR}"
	defects4j test
	echo -e "${GREEN}[${project_dir}] done${NOCOLOR}"

	# back to root folder
	cd $root
}

function run_jaguar() {
	local project_dir=$1
	local project_path="$D4J_PROJECTS/$project_dir"
	local jaguar_jar="jaguar-df/br.usp.each.saeg.jaguar.core/target/br.usp.each.saeg.jaguar.core-1.0.0-jar-with-dependencies.jar"
	local agent_jar="ba-dua/ba-dua-agent-rt/target/ba-dua-agent-rt-0.4.1-SNAPSHOT-all.jar"
	local classes_dir=$(defects4j export -p dir.bin.classes -w $project_path)
	local tests_dir=$(defects4j export -p dir.bin.tests -w $project_path)
	local classpath="$(defects4j export -p cp.test -w $project_path)"
	local output_dir="output/$project_dir"

	# create dir
	mkdir -p $output_dir/$VERSION

	# run jaguar
	echo -e "${YELLOW}[$PROJECT_NAME] running jaguar${NOCOLOR}"
	java -jar $jaguar_jar \
			--agent $agent_jar \
			--classpath $classpath \
			--projectDir $project_path \
			--classesDir $classes_dir \
			--testsDir $tests_dir \
			--logLevel $LOG_LEVEL \
			--dataflow > $output_dir/$VERSION/jaguar_$VERSION.txt

	rm coverage.ser

	cp -rf $project_path/.jaguar $output_dir/$VERSION
	echo -e "${GREEN}[$PROJECT_NAME] done${NOCOLOR}"
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

	if [ -z "$LOG_LEVEL" ]
	then
		LOG_LEVEL="DEBUG"
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
	run_jaguar $project_dir
}

main
