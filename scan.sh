#!/bin/bash
set -eu

function test_command {
    cmd=${*:1}
    set +e
    if ! $cmd &> /dev/null; then
        echo "error: command $cmd not found"
        exit 1
    fi
    set -e
}

function dependencies_check {
    test_command grep --help
    test_command find --help
    test_command cat --help
}

function scan_no_pull_request_target {
    local result_path
    result_path=$(mktemp)
    echo 0 > "$result_path"
    find "$project_path/.github/workflows" -type f -regex ".*\.\(yaml\|yml\)" | while read -r workflow; do
        echo -n "Scanning for pull_request_target in $workflow... "
        if grep "pull_request_target" "$workflow" &> /dev/null; then
            echo "ko"
            echo 1 > "$result_path"
            continue
        fi
        echo "ok"
    done
    result=$(cat "$result_path")
    rm "$result_path"
    return "$result"
}

function print_help {
    echo "Check for dangerous github configuration"
    echo "$0 [--no-pull-request-target] [--path PROJECT_PATH]"
}

project_path="."
no_pull_request_target=false
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        --no-pull-request-target)
            no_pull_request_target=true
            shift
            ;;
        --path)
            shift
            project_path=$1
            shift
            ;;
        -h|--help)
            print_help
            exit
            ;;
        *)
            echo "unrecognized option $1"
            print_help
            exit 1
            ;;
    esac
done

exit_code=0
if $no_pull_request_target; then
    if ! scan_no_pull_request_target; then
        echo "Error: found pull_request_target usage"
        exit_code=1
    fi
fi

exit $exit_code