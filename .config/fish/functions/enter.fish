function enter -d 'enter a zellij session'
	for session in (zellij ls --short)
		if [ $session = $argv[1] ]
			zellij attach $argv[1]
			return
		end
	end
	for layout in (ls ~/.config/zellij/layouts | sed -e "s/.kdl//")
		if [ $layout = $argv[1] ]
			zellij -n $argv[1] -s $argv[1]
			return
		end
	end
	for dir in (ls -A)
		if [ ! -d $dir ] 
			continue
		end
		if [ $dir = $argv[1] ]
			cd $argv[1]
			zellij
			cd -
			return
		end
	end
	echo -e "can not enter \"$argv[1]\": not found"
end
