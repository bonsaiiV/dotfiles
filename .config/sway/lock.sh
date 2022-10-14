#!/bin/bash
swayidle \
	timeout 10 'swaymsg "output * dpms off"' \
	resume 'swaymsg "output * dpms on"' &
swaylock -c 330055
kill %%
