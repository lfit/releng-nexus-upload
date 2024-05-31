#!/usr/bin/env bash

# SPDX-License-Identifier: Apache-2.0
# Copyright 2024 The LMinux Foundation <matthew.watkins@linuxfoundation.org>

# Uncomment to enable debugging
# set -vx

CURL_CONFIG=".netrc"
# Count file upload successes/failures
SUCCESSES="0"; FAILURES="0"

# Shared functions

show_help() {
    # Command usage help
    cat << EOF
Usage: ${0##*/} [-h] -r repository -d directory [-e file extension]
    -h  display this help and exit
    -r  remote repository name (mandatory)
    -d  local directory of files to upload (mandatory)
    -e  match file extension (optional)
EOF
}

error_help() {
    show_help >&2
    exit 1
}

transfer_report() {
    echo "Successes: $SUCCESSES   Failures: $FAILURES"
    # Export allows values to be used in subsequent scripts
    if [ "$FAILURES" -gt 0 ]; then
        ERRORS="true"
        export SUCCESSES FAILURES ERRORS
        exit 1
    else
        ERRORS="false"
        export SUCCESSES FAILURES ERRORS
        exit 0
    fi
}

curl_upload() {
    FILE="$1"
    echo "Sending: ${FILE}"
    # echo "Running: $CURL --fail [CREDENTIALS] --upload-file $FILE $NEXUS_URL"
    # if ("$CURL" --fail --netrc-file ".netcrc" \
    if ("$CURL" --fail --netrc-file "$CURL_CONFIG" \
        --upload-file "$FILE" "$NEXUS_URL"); then #> /dev/null 2>&1
        SUCCESSES=$((SUCCESSES+1))
    else
        FAILURES=$((FAILURES+1))
    fi
}

process_files() {
    for FILE in "${UPLOAD_FILES_ARRAY[@]}"; do
        curl_upload "$FILE"
    done
}

# Check environment and set variables

CURL=$(which curl)
if [ ! -x "$CURL" ];then
    echo "cURL was not found in your PATH"; exit 1
fi

if [ ! -f "$CURL_CONFIG" ];then
    echo "Error: cURL configuration file was not found ($CURL_CONFIG)"
    exit 1
fi

while getopts hr:d:e: opt; do
    case $opt in
        r)  NEXUS_REPOSITORY="$OPTARG"
            if [ -z ${NEXUS_REPOSITORY+x} ]; then
                echo "Error: supplying the repository is mandatory"; exit 1
            fi
            ;;
        d)  UPLOAD_DIRECTORY="$OPTARG"
            if [ ! -d "$UPLOAD_DIRECTORY" ]; then
                echo "Error: specified upload directory not found"; exit 1
            fi
            ;;
        e)  FILE_EXTENSION="$OPTARG" # Not mandatory
            ;;

        # Not implemented; this parameter may be superfluous
        # REPOSITORY_FORMAT

        h|?)
            show_help
            exit 0
            ;;
        *)
            error_help
        esac
done
shift "$((OPTIND -1))" # Discard the options

# Gather files to upload into an array (does not traverse directories recursively)
mapfile -t UPLOAD_FILES_ARRAY < <(find "$UPLOAD_DIRECTORY" -name "*$FILE_EXTENSION" -maxdepth 1 -type f -print)

if [ "${#UPLOAD_FILES_ARRAY[@]}" -ne 0 ]; then
    echo "Number of files to upload: ${#UPLOAD_FILES_ARRAY[@]}"
else
    echo "Error: no files found to process matching pattern"
    FAILURES=$((FAILURES+1))
    transfer_report
fi

# Example .netrc configuration file format:
# machine $NEXUS_SERVER login $NEXUS_USERNAME password $NEXUS_PASSWORD

echo "Attempting uploads to: $NEXUS_SERVER"
process_files
removeConfig # Prevent subsequent theft of credentials
transfer_report
