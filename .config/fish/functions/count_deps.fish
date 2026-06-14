function count_deps
	for p in $(pacman -Qe)
		set package_name "$(string split ' ' $p)[1]"
		set deps $(pacman -Qi $package_name | grep 'Depends On')
		set deps $(string split ':' "$deps")[2]
		set number_of_deps $(count $(string split ' ' $deps))
		if [ $number_of_deps -gt 30 ]
			echo "$package_name $number_of_deps"
		end
	end
end
