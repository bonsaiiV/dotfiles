function add-info -d 'add metadata to mp3'
	for f in $argv[2..-1]
		set artist $argv[1]
		mp3info $f -a $artist -t $(echo $f | sed -e "s/\.mp3//")
	end
end
