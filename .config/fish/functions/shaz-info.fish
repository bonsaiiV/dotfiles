function shaz-info -d 'add metadata to mp3 through shazam'
	for f in $argv
		set response $(songrec recognize $f)
		set split $(string split ' - ' $response)
		echo $split[1]
		echo $split[2]
		mp3info $f -a $split[1] -t $split[2]
		mv $f "$split[2].mp3"
	end
end
