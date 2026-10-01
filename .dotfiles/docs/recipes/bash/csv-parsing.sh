# convert frome windows stuff
iconv -f cp1250 -t utf8 "$file" -o "$file"".converted.csv"

while IFS=";" read -r fiel1 fiel2 field3 field4 rest; do

done < <(tail -n +2 "$file"".converted.csv")
