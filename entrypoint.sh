#!/bin/sh
set -e

export HOME=/tmp

OUTPUT_PATH="${1:-herodevs.report.json}"
TEMP_OUTPUT="/tmp/herodevs.report.json"
FINAL_OUTPUT="/github/workspace/${OUTPUT_PATH}"

hd scan eol --save --output "${TEMP_OUTPUT}"

cp "${TEMP_OUTPUT}" "${FINAL_OUTPUT}"

#chmod 777 "$GITHUB_OUTPUT" 2>/dev/null || true
#echo "report-path=${GITHUB_WORKSPACE}/${OUTPUT_PATH}" >> $GITHUB_OUTPUT && echo "GITHUB_OUTPUT write succeeded" || echo "GITHUB_OUTPUT write FAILED"
