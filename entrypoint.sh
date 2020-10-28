#!/bin/sh
set -x

# `$*` expands the `args` supplied in an `array` individually
# or splits `args` in a string separated by whitespace.
sh -c "echo $*"

# create a temporary folder that will contain all split files for resources
# to validate, `opa eval` can only validate one input (ie object) at a time
MANIFESTS=.reliably/manifests
mkdir -p $MANIFESTS
error=false
violationCount=0

for file in ${INPUT_FILES}
do
  echo "Process manifest '$file'"

  # split manifest into multiples files, in case it contain several resources
  csplit --quiet --prefix="$MANIFESTS/manifest" $file "/---/" "{*}"

  echo "list manifests subfolder '$MANIFESTS'"
  ls $MANIFESTS

  echo "list policies subfolder '${INPUT_POLICIES}'"
  ls ${INPUT_POLICIES}

  # iterate over the split files
  for manifest in $MANIFESTS/*
  do

    echo "Validate manifest $manifest"

    # convert the manifest from yaml to json (opa only accepts json)
    yaml2json $manifest > $manifest.json

    # run the policies/rules validation - NON-breaking call
    opa eval -i $manifest.json -d ${INPUT_POLICIES} --format pretty 'data' > opa.json

    # display the report to user
    cat opa.json

    # count the number of violations to exit with non-zero status code
    count=$(cat opa.json | jq 'first(.[])[].violations' | grep -v '\[' | grep -v '\]' | wc -l)
    violationCount=$(( $violationCount + $c ))

  done

  # cleanup temporary manifests for next file
  rm $MANIFESTS/*
done

# fails the action globally if at least one violation was found
echo "error boolean value is $error"
if [ $violationCount -ne 0 ]; then
  echo "Manifest(s) have $violationCount violation(s)"
  echo "force exit with non-zero return code"
  exit 1
fi