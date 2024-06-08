#!/usr/bin/env bash

set -eu

path=${0%/*}
cd "$path/system_files/"

targets="$(find -type f)"
for target in $targets; do
	location="$(sed	-e s/^.// <<< $target)"
	install -DCm644 --backup "${target}" -T "${location}"
done
