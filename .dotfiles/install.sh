#!/usr/bin/env bash

set -eu

path=${0%/*}
cd "$path/system_files/"

install -DCm644 --backup ./pacman.conf -t /etc/
install -DCm644 --backup ./pam_env.conf -t /etc/security/
install -DCm644 --backup ./custom_xkb -t /usr/share/X11/xkd/symbols/
