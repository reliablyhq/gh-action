#!/bin/sh
set -x

# `$*` expands the `args` supplied in an `array` individually
# or splits `args` in a string separated by whitespace.
sh -c "echo $*"

# create a temporary folder that will contain all split files for resources
# to validate, `opa eval` can only validate one input (ie object) at a time
MANIFESTS=.reliably/manifests
mkdir -p $MANIFESTS

for file in ${INPUT_FILES}
do
  echo "Process manifest '$file'"

  # split manifest into multiples files, in case it contain several resources
  csplit --quiet --prefix="$MANIFESTS/manifest" $file "/---/" "{*}"

  # iterate over the split files
  for manifest in $MANIFESTS/*
  do

    # convert the manifest from yaml to json (opa only accepts json)
    yaml2json $manifest > "$manifest.json"

    # run the policies/rules validation - NON-breaking call
    opa eval "$manifest.json" -d ${INPUT_POLICIES} --format pretty "data" || true

  done

  # cleanup temporary manifests for next file
  rm $MANIFESTS/*
done
