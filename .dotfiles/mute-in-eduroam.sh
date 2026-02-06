#!/usr/bin/env bash

while true; do
	read
	nm_active=$(nmcli c show --active)
	if (echo $nm_active | grep -q eduroam) then
		wpctl set-mute @DEFAULT_SINK@ 1
	fi
done
