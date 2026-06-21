function shaz-info -d 'add metadata to mp3 through shazam'
	argparse 'l/album=' 'y/year=' 'f/force' -- $argv
		if set -ql _flag_album[1]
			set args_for_all $args_for_all -l $_flag_album[1]
		end
		if set -ql _flag_year[1]
			set args_for_all $args_for_all -y $_flag_year[1]
		end
	for f in $argv
		if [ ! -f "$f" ]
			echo "$f does not exist or is not a regular file"
			continue
		end
		set -ql _flag_force; or if [ -n "$(mp3info $f -p "%t" 2>/dev/null)" ]
			if set -ql args_for_all
				mp3info $f $args_for_all
			else
				echo "$f is already tagged, skipping"
			end
			continue
		end

		# shazam it
		set response $(songrec recognize --json $f)
		set -ql response
		or continue
		set genre "$(echo $response | jq ".[\"track\"][\"genres\"][\"primary\"]" -r)"
		set title "$(echo $response | jq ".[\"track\"][\"title\"]" -r)"
		set artist "$(echo $response | jq ".[\"track\"][\"subtitle\"]" -r)"

		set args -a $artist -t $title -g $genre $args_for_all

		echo "artist: $artist"
		echo "title: $title"

		# set artist and title
		mp3info $f $args
		set newfilename "$(dirname $f)/$title.mp3"
		if [ "$f" = "$newfilename" ]
			echo "$f is already in place"
			return
		end
		if [ -e $newfilename ]
			read -p "echo \"File $newfilename already exists. Overwrite file? [y/N] \"" reply
			if [ $reply = y -o $reply = Y ]
				mv $newfilename "$title.mp3"
			else
				echo "file not moved"
			end
		else
			mv $newfilename "$title.mp3"
		end
	end
end
