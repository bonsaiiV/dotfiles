if status is-interactive
	set -U fish_greeting
	fish_config theme choose Dracula
end

#export EDITOR='nvim'

export CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config"

if [ "$(tty)" = "/dev/tty1" ]
	exec sway
end
