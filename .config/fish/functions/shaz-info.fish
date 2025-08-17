function shaz-info -d 'add metadata to mp3 through shazam'
	for f in $argv
		if [ ! -f $argv ]
			echo "$argv does not exist or is not a regular file"
			continue
		end
		if [ -n "$(mp3info $argv -p "%t" 2>/dev/null)" ]
			echo "$argv is already tagged, skipping"
			continue
		end
		set response $(songrec recognize $f)
		set split $(string split ' - ' $response)
		echo $split[1]
		echo $split[2]
		mp3info $f -a $split[1] -t $split[2]
		set newfilename "$split[2].mp3"
		if [ -e $newfilename ]
			read -p "echo 'File $newfilename already exists. Overwrite file? [y/N] '" reply
			if [ $reply = y -o $reply = Y ]
				mv $f "$split[2].mp3"
			else
				echo "file not moved"
			end
		else
			mv $f "$split[2].mp3"
		end
	end
end
