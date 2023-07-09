if status is-interactive
    # Commands to run in interactive sessions can go here
end
export MOZ_ENABLE_WAYLAND=1
export EDITOR='nvim'
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_HOME="$HOME/.config"
export JAVA_HOME="/usr"
#if test -f $HOME/.config/fish/display.fish
#	$HOME/.config/fish/display.fish
#end
if [ "$(tty)" = "/dev/tty1" ]
	exec sway
end
