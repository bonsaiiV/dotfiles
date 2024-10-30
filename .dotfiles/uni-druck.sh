#!/bin/bash
printer="ohs14pr1"
ssh_target="uran"
while getopts ':p:' OPTION; do
    case "$OPTION" in
        p)
            case "$OPTARG" in

                "fsr")
                    printer=FSR-Buero
                    ssh_target=eins
                    ;;

                "oh14")
                    printer=ohs14pr1
                    ;;

            esac
    esac
done
shift "$(($OPTIND -1))"
while [ $# -gt 0 ]; do
    if [ ! -e "$1" ]; then
        echo "file not found"
        exit 1
    fi
    echo "printing $1 at $printer accessing through $ssh_target"
    cat "$1" | ssh $ssh_target "lpr -P $printer"
    shift 1
done
