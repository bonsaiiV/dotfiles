#!/bin/bash
find -L $(sed 's/:/\/applications /g' <<< "$XDG_DATA_HOME:$XDG_DATA_DIRS:") -type f -name \*.desktop 2> /dev/null \
	| grep -Ev "wine|electron|jdk|applications/Qt" \
    | xargs gawk -f ~/.config/sway/parse-desktop-entry.awk \
    | sort \
    | gawk -F "\t" -v menu='bemenu -ipλ --ab="#303030" --fb="#303030" --tb="#F4F4F4" --hb="#993399" --hf="#FFFFFF" --nb="#303030"' '
        {
            print $1 |& menu
            cmds[$1] = $2
        }

        END {
            close(menu, "to")
            menu |& getline name
            print cmds[name]
        }'
