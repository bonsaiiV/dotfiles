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

export EDITOR='nvim'
export LEDGER_FILE='/home/bonsaiiv/Documents/orga/finances/2023.jounral'

PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\W\[\e[0m\]\$ '


