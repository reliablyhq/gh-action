#!/bin/sh

# `$*` expands the `args` supplied in an `array` individually
# or splits `args` in a string separated by whitespace.
sh -c "echo $*"

opa eval manifest.yaml -d ${INPUT_POLICIES} --format pretty