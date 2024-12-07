#!/bin/bash
printer=""
ssh_target=""
while getopts ':p:' OPTION; do
    case "$OPTION" in
        p)
            case "$OPTARG" in

                "fsr")
                    printer=fsi-buero
                    ssh_target=eins
                    ;;

                "oh14")
                    printer=ohs14pr1
                    ssh_target=uran
                    ;;

                "net")
                    printer=net
                    ;;

            esac
    esac
done
shift "$(($OPTIND -1))"
if [ "$printer" = "" ]; then
    echo "no printer selected"
    exit 1
fi
if [ "$ssh_target" = "" ]; then
    print_command="lpr -P $printer"
    location_info="in current network"
else
    print_command="ssh $ssh_target \"lpr -P $printer\""
    location_info="accessing through $ssh_target"
fi
success=""
failed=""
while [ $# -gt 0 ]; do
    if [ ! -e "$1" ]; then
        failed+="\n\t- \"$1\" not found"
        shift 1
        continue
    fi
    if [ ! -f "$1" ]; then
        failed+="\n\t- \"$1\" is not a regular file"
        shift 1
        continue
    fi
    success+="\n\t- \"$1\""
    echo "printing $1 at $printer $location_info"
    cat "$1" | ssh $ssh_target "lpr -P $printer"
    #print_command="echo test"
    #cat "$1" | eval $print_command
    shift 1
done
echo ""
if [ "$success" != "" ]; then
    echo -e "successfully printed:" $success
fi
if [ "$failed" != "" ]; then
    echo -e "failed to print:" $failed
fi
echo 
