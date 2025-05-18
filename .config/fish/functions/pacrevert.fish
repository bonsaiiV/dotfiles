function pacrevert -d "revert update"

	set lines $(grep -a upgraded /var/log/pacman.log | grep $(date --date=2025-05-05 "+%Y-%m-%d"))
	set pacman_cache /var/cache/pacman/pkg/
	for i in $lines
		set name $(echo $i  | awk '{print $4}')
		set pacversion $(echo $i  | awk '{print $5}' | sed "s/(/-/")
		set package $(echo "$name$pacversion")
		doas pacman -Up $pacman_cache$package*.pkg.tar.zst
		#echo -e $pacman_cache$package*.pkg.tar.zst
	end
	#for i in $(cat /tmp/packages)
	#	doas pacman --noconfirm -U $(pacman_cache)"$i"\*.zst
	#	echo $(pacman_cache)"$i"\*.zst
	#end

end
