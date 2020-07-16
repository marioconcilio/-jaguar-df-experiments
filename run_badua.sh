#!/usr/bin/env bash

readonly NOCOLOR="\033[0m"
readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033[1;33m"

readonly PROJECT_NAME=$1
readonly VERSION=$2

function run_badua() {
	local project_dir=$1
	local i=$2
	local d4j_projects="d4jprojects"
	local project_path="$d4j_projects/$project_dir"
	local agent_jar="ba-dua/ba-dua-agent-rt/target/ba-dua-agent-rt-0.4.1-SNAPSHOT-all.jar"
	local badua_jar="ba-dua/ba-dua-cli/target/ba-dua-cli-0.4.1-SNAPSHOT-all.jar"
	local classpath="$(defects4j export -p cp.test -w $project_path)"
	local classes_dir="$project_path/$(defects4j export -p dir.bin.classes -w $project_path)"
	local tests=$(defects4j export -p tests.all -w $project_path | tr "\n" " " | awk '{$1=$1};1')
	local junit_class="org.junit.runner.JUnitCore"
	local output_dir="output/$project_dir/$VERSION"
	local coverage_ser="coverage.ser"

	# create dir
	mkdir -p $output_dir/ba-dua

	# run tests with ba-dua
	echo -e "${YELLOW}[$PROJECT_NAME] running tests with ba-dua${NOCOLOR}"
	time java -javaagent:$agent_jar \
			-cp $classpath \
			$junit_class $tests > $output_dir/ba-dua_$i.out

	# ba-dua report
	echo -e "${YELLOW}[$PROJECT_NAME] generating ba-dua report${NOCOLOR}"
	time java -jar $badua_jar report \
			-show-classes \
			-input $coverage_ser \
			-classes $classes_dir \
			-xml $output_dir/ba-dua/report_$i.xml

	# pretty print report xml
	xmllint --format $output_dir/ba-dua/report_$i.xml --output $output_dir/ba-dua/report_$i.xml

	rm $coverage_ser
	echo -e "${GREEN}[$PROJECT_NAME] done${NOCOLOR}"
}

function diff_badua_report() {
	local project_dir=$1
	local output_dir="output/$project_dir/$VERSION/ba-dua"

	for i in 1 2
	do
		run_badua $project_dir $i
	done

	diff $output_dir/report_1.xml $output_dir/report_2.xml > $output_dir/report.diff
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

	source ./checkout_project.sh $PROJECT_NAME
	diff_badua_report $project_dir
	chmod -R 777 output
}

main
