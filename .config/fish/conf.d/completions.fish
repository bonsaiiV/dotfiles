complete -c add-to-playlist -a '(ls "$XDG_CONFIG_HOME/cmus/playlists")'
complete -c enter -a '(ls "$HOME/.dotfiles/sessions" | sed -e "s/\.json//g")'
