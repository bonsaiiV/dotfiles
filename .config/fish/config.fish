if status is-interactive
	set -U fish_greeting
	fish_config theme choose Dracula
end
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_HOME="$HOME/.config"

export MOZ_ENABLE_WAYLAND=1
export EDITOR='nvim'

export JAVA_HOME="/usr"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

export CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config"

if [ "$(tty)" = "/dev/tty1" ]
	exec sway
end
