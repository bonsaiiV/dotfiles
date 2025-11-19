function start-tmux -d "start a tmux session in given directory"
	set name $argv[1]
	set dir $argv[1]
	if [ (count $argv) -ge 2 ]
		set name $argv[2]
	end

	set tmux_env_list "-e" "SESSION_NAME=$name"
	if [ (count $argv) -ge 3 ]
		if [ (jq 'has("env")' < $argv[3]) = true ]
			for line in (jq '.["env"].[]' < $argv[3])
				set tmux_env_list $tmux_env_list "-e" "$(echo $line | sed -e 's|\"||g')"
			end
		end
	end

	set session_file "$XDG_CACHE_HOME/sessions/$name.vim"
	if [ -f $session_file ]
		set nvim_param "-S $session_file"
	else
		set nvim_param "\."
	end

	tmux new-session -dc "$dir" $tmux_env_list -s $name "nvim $nvim_param"

	tmux new-window -dc "$dir" -t "$name"":"
	tmux attach -t $name
end

function enter -d 'enter a tmux session'
	set current_sessions (tmux list-sessions -F "#{session_name}" 2> /dev/null)
	if [ (count $argv) -ge 1 ]
		set name $argv[1]
		set p (path resolve "$argv[1]")
	else
		set name '.'
		set p $PWD
	end
	for session in $current_sessions
		if [ $session = $name ]
			tmux attach -t $name
			return
		end
		if [ $session = $p ]
			tmux attach -t $p
			return
		end
	end
	if [ $name = "tmp" ]
		set tmpdir session
		mkdir -p /tmp/$tmpdir
		start-tmux "/tmp/$tmpdir" tmp
		return
	end
	if path is -d $p
		start-tmux $p
		return
	end
	set preset_file "$HOME/.dotfiles/sessions/$name"
	if [ -f $preset_file ]
		set preset_path (jq '.["dir"]' < $preset_file  | sed -e "s|\"||g" | sed -e "s|\$HOME|$HOME|")
		set preset_path (path resolve $preset_path)
		start-tmux $preset_path $name $preset_file
		return
	end
	echo -e "can not enter \"$argv[1]\": not found"
end
