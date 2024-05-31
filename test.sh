#!/usr/bin/env bash

# SPDX-License-Identifier: Apache-2.0
# Copyright 2024 The LMinux Foundation <matthew.watkins@linuxfoundation.org>

# shellcheck disable=all

### Nexus Test Upload Script ###

DATETIME="DATETIME=$(date '+%Y%m%d-%H%M')"
NEXUS_USERNAME="upload-test"
NEXUS_SERVER="nexus3.o-ran-sc.org"
NEXUS_REPOSITORY="testing"
UPLOAD_DIRECTORY="files"
FILENAME_SUFFIX=".txt"

# Set the variable below to the current test user password from 1Password
# e.g. ORAN Nexus3 [Test User]
# Then uncomment and run the script locally
# NEXUS_PASSWORD="********"

# Create test file to upload
echo "Test file $DATETIME" > "files/upload-$DATETIME.txt"

# Invoke the script to upload the test file
source nexus-upload.sh
