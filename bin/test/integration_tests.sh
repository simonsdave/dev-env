#!/usr/bin/env bash

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

get_function_name() {
    echo "${FUNCNAME[1]}"
}

get_circle_ci_executor_dot_sh() {
    TEST=${1:-}

    EXPECTED_EXIT_CODE_FILE=${SCRIPT_DIR_NAME}/get_circle_ci_executor_dot_sh/${TEST}.exit_code
    EXPECTED_EXIT_CODE=$(cat "${EXPECTED_EXIT_CODE_FILE}")

    CONFIG_DOT_YML="${SCRIPT_DIR_NAME}/get_circle_ci_executor_dot_sh/${TEST}.yml"

    CIRCLE_CI_EXECUTOR=$("${SCRIPT_DIR_NAME}/../get-circle-ci-executor.sh" "--config" "${CONFIG_DOT_YML}")
    EXIT_CODE=$?
    if [[ "${EXIT_CODE}" != "${EXPECTED_EXIT_CODE}" ]]; then
        echo "ERROR - $(get_function_name)(${TEST}): exit code >>>${EXIT_CODE}<<< not expected >>>${EXPECTED_EXIT_CODE}<<<" >&2
        exit 1
    fi

    EXPECTED_CIRCLE_CI_EXECUTOR_FILE=${SCRIPT_DIR_NAME}/get_circle_ci_executor_dot_sh/${TEST}.circle_ci_executor
    if [ -e "${EXPECTED_CIRCLE_CI_EXECUTOR_FILE}" ]; then
        EXPECTED_CIRCLE_CI_EXECUTOR=$(cat "${EXPECTED_CIRCLE_CI_EXECUTOR_FILE}")
    else
        EXPECTED_CIRCLE_CI_EXECUTOR=""
    fi

    if [[ "${CIRCLE_CI_EXECUTOR}" != "${EXPECTED_CIRCLE_CI_EXECUTOR}" ]]; then
        echo "ERROR - $(get_function_name)(${TEST}): CircleCI Executor >>>${CIRCLE_CI_EXECUTOR}<<< not expected >>>${EXPECTED_CIRCLE_CI_EXECUTOR}<<<" >&2
        exit 1
    fi
}

test_wrapper() {
    TEST_FUNCTION_NAME=${1:-}
    shift
    NUMBER_TESTS_RUN=$((NUMBER_TESTS_RUN+1))
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo "Running #${NUMBER_TESTS_RUN} '${TEST_FUNCTION_NAME}'"
    else
        echo -n "."
    fi
    "$TEST_FUNCTION_NAME" "$@"
}

VERBOSE=0

while true
do
    case "${1:-}" in
        --verbose)
            shift
            VERBOSE=1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 0 ]; then
    echo "usage: $(basename "$0") [--verbose]" >&2
    exit 1
fi

NUMBER_TESTS_RUN=0
test_wrapper get_circle_ci_executor_dot_sh 'ok'
test_wrapper get_circle_ci_executor_dot_sh 'multiple'
if [ "1" -ne "${VERBOSE:-0}" ]; then
    echo ""
fi
echo "Successfully completed $NUMBER_TESTS_RUN integration tests."

exit 0
