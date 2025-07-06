function add-to-playlist -d 'add song to playlist'
	set playlist_path "$HOME/.config/cmus/playlists/$argv[1]"
	if [ ! -e $playlist_path ]
		echo "Playlist does not exist"
		read -p "echo 'Create new playlist?[y/N] '" reply
		if [ $reply = y -o $reply = Y ]
			touch $playlist_path
		else
			echo "playlist not created"
			return 0
		end
	end
	set count 0
	for rel_f in $argv[2..-1]
		set f $(realpath $rel_f)
		if [ ! -f $f ]
			echo "\"$rel_f\" is not a regular file or does not exist"
			continue
		end
		if [ ! audio/mpeg = $(file -b --mime-type $f) ]
			echo "\"$rel_f\" has the wrong mime type"
			continue
		end
		if [ -z $(cat $playlist_path | grep $f - ) ]
			echo "$PWD/$f" >> $playlist_path
			set count $(math $count +1)
		end
	end
	echo "added $count songs to playlist $argv[1]"
end
