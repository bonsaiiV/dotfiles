function hash_dirs -d 'create a list of eachfile in the directory and it\`s sha256 hash'
	if [ (count $argv) -gt 0 ]
		env -C $argv[1] find . -type f -exec sha256sum {} \; | sed 's/^\([0-9a-z]\+\)  \(.*\)$/\2\t\1/' | sort
	else
		echo 'no alt dir provided: hashing all files in current dir' 1>&2
		find . -type f -exec sha256sum {} \; | sed 's/^\([0-9a-z]\+\)  \(.*\)$/\2\t\1/' | sort
	end
end
