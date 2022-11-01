#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'

export MOZ_ENABLE_WAYLAND=1
export EDITOR='nvim'
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"

PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\W\[\e[0m\]\$ '


