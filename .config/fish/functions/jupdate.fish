function jupdate -d "updates a journal using the provided csv and rules files"
	if test (count $argv) -lt 2; or not test -e $argv[1] -a -e $argv[2]
		echo "usage: jupdate [csv-file] [rules-file]"
	else
		iconv -f cp1250 -t utf8 $argv[1] -o /tmp/konto.csv
		cp $argv[2] /tmp/konto.csv.rules
		if test (count $argv) -ge 3; and test -e $argv[3]
			cat $argv[3] | sed "s:include :include $PWD\/$(path dirname $argv[3])\/:" > /tmp/konto.journal
			set fdate (hledger -f /tmp/konto.journal bs | grep "Balance Sheet" | sed "s/Balance Sheet //")
			if [ $fdate != "" ]
				set fdate $(date --date=@(math (date --date="$fdate" "+%s") +86400) "+%Y-%m-%d")
				hledger -b $fdate -f /tmp/konto.csv print | sed "s/    /\t/" >> /tmp/konto.journal
			else
				hledger -f /tmp/konto.csv print | sed "s/    /\t/" >> /tmp/konto.journal
			end
			if hledger -f /tmp/konto.journal check 1> /dev/null 2>&1
				cat /tmp/konto.journal | sed "s:include $PWD\/$(path dirname $argv[3])\/:include :" > $argv[3]
			else
				echo "new journal wouldn't be consistant"
			end
		else
			hledger -b 2024-01-01 -f /tmp/konto.csv print | sed "s/    /\t/"
		end
	end
end
