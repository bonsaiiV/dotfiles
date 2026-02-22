if status is-interactive
	set -U fish_greeting
	fish_config theme choose Dracula
	set -g fish_key_bindings fish_vi_key_bindings
end

export CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config"
export PATH="$PATH:$HOME/.ghcup/bin"
export PATH="$PATH:$HOME/.cabal/bin"
export SHELL="/bin/fish"
export BROWSER="/usr/bin/firefox"
export EDITOR="/usr/bin/nvim"
export LD_LIBRARY_PATH="/usr/local/lib"

if [ "$(tty)" = "/dev/tty1" ]
	exec sway
end
