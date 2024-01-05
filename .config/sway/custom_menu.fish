#!/usr/bin/fish
sort $argv[1] \
| gawk -F "\t" -v menu='bemenu -ipλ --ab="#030303" --fb="#303030" --tb="#F4F4F4" --hb="#993399" --hf="#FFFFFF" --nb="#303030"' '
        {
            print $1 |& menu
            cmds[$1] = $2
        }

        END {
            close(menu, "to")
            menu |& getline name
            print cmds[name]
        }'
