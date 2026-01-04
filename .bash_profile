#
# ~/.bash_profile
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f ~/.config/bash/bashrc ]] && . ~/.config/bash/bashrc

# This has to be last, since it may exec
[[ -f ~/.config/bash/bash_display ]] && . ~/.config/bash/bash_display
