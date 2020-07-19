#!/usr/bin/env bash

readonly NOCOLOR="\033[0m"
readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033[1;33m"

readonly PROJECT_NAME=$1
readonly VERSION=$2

LOG_LEVEL=$3

function run_jaguar() {
	local project_dir=$1
	local d4j_projects="d4jprojects"
	local project_path="$d4j_projects/$project_dir"
	local jaguar_jar="jaguar-df/br.usp.each.saeg.jaguar.core/target/br.usp.each.saeg.jaguar.core-1.0.0-jar-with-dependencies.jar"
	local agent_jar="ba-dua/ba-dua-agent-rt/target/ba-dua-agent-rt-0.4.1-SNAPSHOT-all.jar"
	local badua_jar="ba-dua/ba-dua-cli/target/ba-dua-cli-0.4.1-SNAPSHOT-all.jar"
	local classes_dir=$(defects4j export -p dir.bin.classes -w $project_path)
	local tests_dir=$(defects4j export -p dir.bin.tests -w $project_path)
	local classpath="$(defects4j export -p cp.test -w $project_path)"
	local output_dir="output/$project_dir/$VERSION"
	local coverage_ser="coverage.ser"
	local root=$(pwd)

	# create dir
	mkdir -p $output_dir/jaguar

	# run tests without jaguar
	echo -e "${YELLOW}[$PROJECT_NAME] running tests${NOCOLOR}"
	cd project_path
	(time defects4j test) &> $output_dir/tests.out
	cd $root

	# run jaguar
	echo -e "${YELLOW}[$PROJECT_NAME] running jaguar${NOCOLOR}"
	(time java -jar $jaguar_jar \
			--agent $agent_jar \
			--classpath $classpath \
			--projectDir $project_path \
			--classesDir $classes_dir \
			--testsDir $tests_dir \
			--logLevel $LOG_LEVEL \
			--dataflow) &> $output_dir/jaguar.out

	# ba-dua report
	echo -e "${YELLOW}[$PROJECT_NAME] generating ba-dua report${NOCOLOR}"
	java -jar $badua_jar report \
			-show-classes \
			-input $coverage_ser \
			-classes $classes_dir \
			-xml $output_dir/jaguar/badua_report.xml

	rm $coverage_ser

	cp -rf $project_path/.jaguar $output_dir/jaguar
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
		# ALL / TRACE / DEBUG / INFO / WARN / ERROR
		LOG_LEVEL="INFO"
	fi

	local project_dir=$(cat projects.d4j | grep $PROJECT_NAME | sed "s/$PROJECT_NAME//g" | xargs)

	if [ -z "$project_dir" ]
	then
		echo "Wrong project identifier. Possible values are:"
		cat projects.d4j
		echo
		exit 1
	fi

	source ./checkout_project.sh $PROJECT_NAME
	run_jaguar $project_dir
	chmod -R 777 output
}

main

