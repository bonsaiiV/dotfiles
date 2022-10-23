#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH="$PATH:/home/bonsaiiv/.local/lib/python3.10/"

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	export WLR_NO_HARDWARE_CURSORS=1
	exec sway

fi
