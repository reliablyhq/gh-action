#!/bin/sh

# `$*` expands the `args` supplied in an `array` individually
# or splits `args` in a string separated by whitespace.
sh -c "echo $*"

for file in ${INPUT_FILES}
do
  echo "Process manifest $file"
  opa eval $file -d ${INPUT_POLICIES} --format pretty "data" || true
done
