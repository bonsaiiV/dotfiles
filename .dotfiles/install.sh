#!/usr/bin/env bash

set -eu

path=${0%/*}
cd "$path/system_files/"

install -DCm644 --backup ./pacman.conf -t /etc/
install -DCm644 --backup ./pam_env.conf -t /etc/security/
install -DCm644 --backup ./custom_xkb -t /usr/share/X11/xkd/symbols/
install -DCm644 --backup ./personal.kbd -t /etc/kmonad/
install -DCm644 --backup ./70-kmonad.rules -t /etc/udev/rules.d/
install -DCm644 --backup ./dotfiles-kmonad@.service -t /etc/systemd/system/
install -DCm644 --backup ./sd-kmonad -t /etc/initcpio/install/
install -DCm644 --backup ./mkinitcpio.conf -t /etc/
