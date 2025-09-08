#
# ~/.bashrc
#

if [ -f ~/.config/bash/.bash_aliases ]; then
	. ~/.config/bash/.bash_aliases
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'

export EDITOR='nvim'
export LEDGER_FILE='/home/bonsaiiv/Documents/orga/finances/2023.jounral'
export PYTHON_HISTORY='/home/bonsaiiv/.cache/python_history'
export PATH="$PATH:/home/bonsaiiv/.local/share/cargo/bin"
export R_ENVIRON_USER='/home/bonsaiiv/.config/R/Renviron'

PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\W\[\e[0m\]\$ '

