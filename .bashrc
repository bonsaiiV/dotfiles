#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.config/bash/.bash_aliases ]; then
	. ~/.config/bash/.bash_aliases
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'

export MOZ_ENABLE_WAYLAND=1
export EDITOR='nvim'
export LEDGER_FILE='/home/bonsaiiv/Documents/orga/finances/2023.jounral'
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_HOME="$HOME/.config"
export JAVA_HOME="/usr"

PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\W\[\e[0m\]\$ '


