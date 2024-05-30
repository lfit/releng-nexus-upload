# Nexus file upload shell script

Script to automate the upload of files to Nexus servers

- [Source Code in Gerrit](https://gerrit.linuxfoundation.org/infra/admin/repos/releng/nexus-upload,general)
- [Source Code on GitHub](https://github.com/lfit/releng-nexus-upload)

## Getting started

Make sure the script is executable on your system

```console
chmod a+x nexus-upload.sh
```

Help is available directly from the command-line:

```console
./nexus-upload.sh -h
Usage: nexus-upload.sh [-h] [-u user] [-p password] [-s upload-url] [-e extension] [-d folder]
 -h  display this help and exit
 -u  username (or export variable NEXUS_USERNAME)
 -p  password (or export variable NEXUS_PASSWORD)
 -s  upload URL (or export variable NEXUS_URL)
     e.g. https://nexus3.o-ran-sc.org/repository/datasets/
 -e  file extensions to match, e.g. csv, txt
 -d  local directory hosting files/content to be uploaded
```

You can set the username, password and URL for the nexus server by exporting the variables:

- NEXUS_URL (mandatory, must be set or -s flag supplied with a valid URL)
- NEXUS_USERNAME (if not set or supplied with -u flag, will be prompted)
- NEXUS_PASSWORD (if not set or supplied with -p flag, will be prompted)

A local folder containing files to upload can be supplied using the optional "-d" flag. If this is not set
then the current directory will be used, but caution should be exercised, as if no file extensions are
specified, then the script itself may be matched by the default wildcard (\*) file matching behaviour. To
prevent this, specify an extension restricting the files to be uploaded using the "-e" flag. Alternatively,
put the files into a local folder, and sepficy the folder location using the "-d" flag.

<!--
[comment]: # SPDX-License-Identifier: Apache-2.0
[comment]: # Copyright 2024 The Linux Foundation <matthew.watkins@linuxfoundation.org>
-->
