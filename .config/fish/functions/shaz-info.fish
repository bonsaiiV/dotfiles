function shaz-info -d 'add metadata to mp3 through shazam'
	argparse 'l/album=' 'y/year=' 'f/force' -- $argv
	for f in $argv
		if [ ! -f "$f" ]
			echo "$f does not exist or is not a regular file"
			continue
		end
		set -ql _flag_force; or if [ -n "$(mp3info $f -p "%t" 2>/dev/null)" ]
			echo "$f is already tagged, skipping"
			continue
		end

		# shazam it
		set response $(songrec recognize --json $f)
		set -ql response
		or continue
		set genre "$(echo $response | jq ".[\"track\"][\"genres\"][\"primary\"]" -r)"
		set title "$(echo $response | jq ".[\"track\"][\"title\"]" -r)"
		set artist "$(echo $response | jq ".[\"track\"][\"subtitle\"]" -r)"

		set args -a $artist -t $title -g $genre
		set -ql _flag_album[1]
		and set args $args -l $_flag_album[1]
		set -ql _flag_year[1]
		and set args $args -y $_flag_year[1]

		echo "artist: $artist"
		echo "title: $title"

		# set artist and title
		mp3info $f $args
		set newfilename "$title.mp3"
		if [ -e $newfilename ]
			read -p "echo \"File $newfilename already exists. Overwrite file? [y/N] \"" reply
			if [ $reply = y -o $reply = Y ]
				mv $f "$title.mp3"
			else
				echo "file not moved"
			end
		else
			mv $f "$title.mp3"
		end
	end
end
