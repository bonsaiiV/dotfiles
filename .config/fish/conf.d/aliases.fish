alias open='xdg-open'
alias ll='ls -All'
alias doas='doas '
alias vi='nvim'
alias vim='nvim'
alias pacinstall='doas pacman -S'
alias uninstall='doas pacman -Runs'
alias pacupgrade='doas pacman -Sy && doas pacman -S --needed --noconfirm archlinux-keyring && doas pacman -Su'

alias dotgit='git --git-dir={$HOME}/.dotfiles/.git --work-tree={$HOME}'
alias sudo='sl -d10lFaw'
alias xprop='echo "This is sway, try: \"swaymsg -t get_tree\""'
