if status is-interactive
	set -U fish_greeting
	fish_config theme choose Dracula
end

#export EDITOR='nvim'

export CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config"
export PATH="$PATH:$HOME/.ghcup/bin"
export PATH="$PATH:$HOME/.cabal/bin"
export SHELL="/bin/fish"

if [ "$(tty)" = "/dev/tty1" ]
	exec sway
end
