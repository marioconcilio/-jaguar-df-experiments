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

	local jaguar_jar_file="jaguar-df-0.1-SNAPSHOT-all.jar"
	local agent_jar_file="ba-dua-agent-rt-0.4.1-SNAPSHOT-all.jar"
	local badua_jar_file="ba-dua-cli-0.4.1-SNAPSHOT-all.jar"

	local jaguar_jar_path="jaguar-df/target/${jaguar_jar_file}"
	local agent_jar_path="ba-dua/ba-dua-agent-rt/target/${agent_jar_file}"
	local badua_jar_path="ba-dua/ba-dua-cli/target/${badua_jar_file}"

	local classes_dir=$(defects4j export -p dir.bin.classes -w .)
	local tests_dir=$(defects4j export -p dir.bin.tests -w .)
	local output_dir="output/$project_dir/$VERSION"
	
	local classpath="$(defects4j export -p cp.test -w .):$agent_jar_file:$jaguar_jar_file"

	local main_class="br.usp.each.saeg.jaguardf.cli.JaguarRunner"
	local junit_class="org.junit.runner.JUnitCore"
	
	local tests_file="tests.out"
	local coverage_ser="coverage.ser"

	# create dir
	mkdir -p $output_dir/jaguar

	# copy jar files into project folder
	cp -f $jaguar_jar_path $project_path
	cp -f $agent_jar_path $project_path
	cp -f $badua_jar_path $project_path

	cd $project_path

	# get tests to run
	defects4j export -p tests.all -w . -o $tests_file

	# run tests without jaguar
	echo -e "${YELLOW}[$PROJECT_NAME ${VERSION}] running tests${NOCOLOR}"
	local tests=$(cat $tests_file | tr "\n" " " | awk '{$1=$1};1')
	(time java -cp $classpath \
			$junit_class $tests) &> ../../$output_dir/tests.out

	# run jaguar
	echo -e "${YELLOW}[$PROJECT_NAME ${VERSION}] running jaguar${NOCOLOR}"
	(time java -javaagent:$agent_jar_file \
			-Dbadua.experimental.exception_handler=false \
			-Dbadua.experimental.ModifiedSystemClassRuntime=true \
			-Xmx1536m \
			-cp $classpath \
			$main_class \
			--projectDir . \
			--classesDir $classes_dir \
			--testsDir $tests_dir \
			--tests $tests_file \
			--logLevel $LOG_LEVEL) &> ../../$output_dir/jaguar.out

	# ba-dua report
	echo -e "${YELLOW}[$PROJECT_NAME ${VERSION}] generating ba-dua report${NOCOLOR}"
	java -jar $badua_jar_file report \
			-show-classes \
			-input $coverage_ser \
			-classes $classes_dir \
			-xml ../../$output_dir/jaguar/badua_report.xml

	rm $coverage_ser
	rm $tests_file

	cd ../..

	# pretty print report xml
	xmllint --format $output_dir/jaguar/badua_report.xml --output $output_dir/jaguar/badua_report.xml

	echo -e "${YELLOW}[$PROJECT_NAME ${VERSION}] copying output files${NOCOLOR}"
	cp -rf $project_path/.jaguar $output_dir/jaguar

	echo -e "${YELLOW}[$PROJECT_NAME ${VERSION}] comparig duas covered by jaguar and ba-dua${NOCOLOR}"
	python3 assert_jaguar.py $output_dir/jaguar &> $output_dir/jaguar/assert_duas.out

	echo -e "${GREEN}[$PROJECT_NAME ${VERSION}] jaguar done${NOCOLOR}"
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
