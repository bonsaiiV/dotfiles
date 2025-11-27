#!/bin/bash
printer=""
ssh_target=""
count=1
sides_arg="-o sides=one-sided"
while getopts ':p:c:s' OPTION; do
	case "$OPTION" in
		c)
			count=$OPTARG
			;;
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

				"ug")
					printer=oh14ug
					ssh_target=uran
					;;

				"fin")
					printer=oh14eg
					ssh_target=eins
					;;

				"net")
					printer=net
					;;
			esac
			;;
		s)
			sides_arg="-o sides=two-sided-long-edge"
			;;
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
	echo "printing $1 at $printer $location_info"
	cat "$1" | ssh $ssh_target "lpr -P $printer $sides_arg -# $count"
	if [ "$status" != 0 ]; then
		failed+="\n\t- issue with printer detected; stopping"
		exit 1
	fi
	success+="\n\t- \"$1\""
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
