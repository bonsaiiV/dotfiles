
# 'i:' bedeutet, dass i einen parameter nimmt
while getopts 'hi:o:' OPTION; do
	case "$OPTION" in
		h)
			echo "-h\n\tDiese Hilfe ausgeben"
			echo "-i <path/to/file>\n\tinput-datei"
			echo "-o <path/to/file>\n\toutput-datei"
			exit
			;;
		i)
			file_input=$OPTARG
			;;
		o)
			file_output=$OPTARG
			;;
	esac
done

echo "output file: $file_output"
echo "input file: $file_input"
