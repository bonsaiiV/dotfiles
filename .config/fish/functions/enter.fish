function start-tmux -d "start a tmux session in given directory"
	set name $argv[1]
	set dir $argv[1]
	if [ (count $argv) -ge 2 ]
		set name $argv[2]
	end
	set name (echo "$name" | sed -e "s/\./_/g")

	set nvim_max_session_age "-1 hour"

	set tmux_env_list "-e" "SESSION_NAME=$name"
	if [ (count $argv) -ge 3 ]
		set session_file $argv[3]
		if [ (jq 'has("pre")' < $session_file) = true ]
			for line in (jq -r '.["pre"].[]' < $session_file)
				$line
			end
		end
		if [ (jq 'has("env")' < $session_file) = true ]
			for line in (jq -r '.["env"].[]' < $session_file)
				set tmux_env_list $tmux_env_list "-e" "$line"
			end
		end
		if [ (jq 'has("nvim_max_session_age")' < $session_file) = true ]
			set nvim_max_session_age "-$(jq -r '."nvim_max_session_age"' < $session_file)"
		end
	end

	set nvim_param "\."
	set nvim_session_file "$XDG_CACHE_HOME/sessions/$name.vim"
	if [ -f $nvim_session_file ]
		set m_date "$(stat -c '%Y' $nvim_session_file)"
		set cmp_date "$(date -d "$nvim_max_session_age" '+%s')"
		if [ $m_date -gt $cmp_date ]
			set nvim_param "-S $nvim_session_file"
		end
	end

	tmux new-session -dc "$dir" $tmux_env_list -s $name "nvim $nvim_param"

	#tmux new-window -dc "$dir" -t "$name"":"
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
	if [ false -a $name = "tmp" ]
		set tmpdir session
		mkdir -p /tmp/$tmpdir
		start-tmux "/tmp/$tmpdir" tmp
		return
	end
	if path is -d $p
		start-tmux $p
		return
	end
	set preset_file "$HOME/.dotfiles/sessions/$name.json"
	if [ -f $preset_file ]
		set preset_path (jq -r '.["dir"]' < $preset_file  |  sed -e "s|\$HOME|$HOME|")
		set preset_path (path resolve $preset_path)
		start-tmux $preset_path $name $preset_file
		return
	end
	echo -e "can not enter \"$argv[1]\": not found"
end
