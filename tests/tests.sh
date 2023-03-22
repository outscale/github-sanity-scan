#!/bin/bash
ROOT=$(cd "$(dirname $0)/.." && pwd)
exit_code=0

echo -n "Testing --no-pull-request-target on workflow without pull_request_target... "
if $ROOT/scan.sh --path "$ROOT/tests/ok" --no-pull-request-target &> /dev/null; then
    echo "ok"
else
    echo "ko"
    exit_code=1
fi

echo -n "Testing --no-pull-request-target on workflow with pull_request_target... "
if ! $ROOT/scan.sh --path "$ROOT/tests/ko" --no-pull-request-target &> /dev/null; then
    echo "ok"
else
    echo "ko"
    exit_code=1
fi

echo -n "testing with shellcheck... "
if shellcheck $ROOT/scan.sh &> /dev/null; then
    echo "ok"
else
    echo "fail!"
    exit_code=1
fi

if [[ "$exit_code" = "1" ]]; then
    echo "!!! Tests failed !!!"
fi
exit $exit_code
