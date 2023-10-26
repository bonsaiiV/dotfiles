#!/usr/bin/env bash

set -eu

path=${0%/*}
cd "$path/system_files/"

install -Dm644 --backup ./pam_env.conf -t /etc/security/
