function get-nvim-params
	set session_name $argv[1]
	set nvim_max_session_age $argv[2]

	set nvim_params "\."
	set nvim_session_file "$XDG_CACHE_HOME/sessions/$session_name.vim"

	if [ -f $nvim_session_file ]
		set m_date "$(stat -c '%Y' $nvim_session_file)"
		set cmp_date "$(date -d "$nvim_max_session_age" '+%s')"
		if [ $m_date -gt $cmp_date ]
			set nvim_params "-S $nvim_session_file"
		end
	end
	echo $nvim_params
end

function start-tmux-by-path -d "start a tmux session in given directory"
	set dir $argv[1]
	if [ (count $argv) -ge 2 ]
		set session_name $argv[2]
	else
		set session_name (echo $argv[1] | sed -e "s/\./_/g")
	end

	set nvim_max_session_age "-1 hour"

	set tmux_env_list "-e" "SESSION_NAME=$session_name"

	set nvim_params $(get-nvim-params $session_name $nvim_max_session_age)

	tmux new-session -dc "$dir" $tmux_env_list -s $session_name "nvim $nvim_params"

	tmux new-window -dc "$dir" -t "$session_name"":"
	tmux attach -t $session_name
end

function start-tmux-by-config -d "start a tmux session, that is setup according to the preset"
	set session_config $argv[1]
	set session_name $argv[2]

	if [ ! (jq 'has("dir")' < $session_config) ]
		echo "mandatory field dir is missing from config"
		return
	end

	set session_path (jq -r '.["dir"]' < $session_config  |  sed -e "s|\$HOME|$HOME|")
	set session_path (path resolve $session_path)


	set tmux_env_list "-e" "SESSION_NAME=$session_name"

	# why is = true important?
	if [ (jq 'has("pre")' < $session_config) = true ]
		for line in (jq -r '.["pre"].[]' < $session_config)
			$line
		end
	end
	if [ (jq 'has("env")' < $session_config) = true ]
		for line in (jq -r '.["env"].[]' < $session_config)
			set tmux_env_list $tmux_env_list "-e" "$line"
		end
	end

	if [ (jq 'has("nvim_max_session_age")' < $session_config) = true ]
		set nvim_max_session_age "-$(jq -r '."nvim_max_session_age"' < $session_config)"
	else
		set nvim_max_session_age "-1 hour"
	end

	set nvim_params $(get-nvim-params $session_name $nvim_max_session_age)

	tmux new-session -dc "$session_path" $tmux_env_list -s $session_name "nvim $nvim_params"

	tmux new-window -dc "$session_path" -t "$session_name"":"
	tmux attach -t $session_name
end

function add-to-tmux-by-path -d "add to existing tmux session"
	set dir $argv[1]
	if [ (count $argv) -ge 2 ]
		set session_name $argv[2]
	else
		set session_name (echo $argv[1] | sed -e "s/\./_/g")
	end

	tmux new-window -dc "$dir" $tmux_env_list "nvim \."

	tmux new-window -dc "$dir"
end

function add-to-tmux-by-config -d "add to existing tmux session"
	set session_config $argv[1]
	set session_name $argv[2]

	if [ ! (jq 'has("dir")' < $session_config) ]
		echo "mandatory field dir is missing from config"
		return
	end

	set session_path (jq -r '.["dir"]' < $session_config  |  sed -e "s|\$HOME|$HOME|")
	set session_path (path resolve $session_path)

	if [ (jq 'has("pre")' < $session_config) = true ]
		for line in (jq -r '.["pre"].[]' < $session_config)
			$line
		end
	end
	if [ (jq 'has("env")' < $session_config) = true ]
		echo "can not set env when adding to session"
		echo "continuing without setting env"
		echo ""
	end

	tmux new-window -dc "$session_path" $tmux_env_list "nvim \."

	tmux new-window -dc "$session_path"
end


function enter -d 'enter a tmux session'
	# get session name and path from parameter of use current dir as path
	if [ (count $argv) -ge 1 ]
		set session_name (echo $argv[1] | sed -e "s/\./_/g")
		set session_path (path resolve "$argv[1]")
	else
		set session_name '_'
		set session_path $PWD
	end

	# if already in session, add to it
	if printf "%s" $TERM | grep tmux 1> /dev/null
		if path is -d $session_path
			add-to-tmux-by-path $session_path
			return
		end
		set session_config "$HOME/.dotfiles/sessions/$session_name.json"
		if [ -f $session_config ]
			add-to-tmux-by-config $session_config $session_name
			return
		end
		echo "already inside tmux"
		return
	end

	# if a matching session exists, attach to it
	if tmux has -t "=$session_name" 2> /dev/null
		tmux attach -t "=$session_name"
		return
	end
	if tmux has -t "=$session_path" 2> /dev/null
		tmux attach -t "$session_path"
		return
	end

	# create new session at given location
	# prefer this over presets as it matches more strict
	set session_path_no_dots (echo $session_path | sed -e "s/\./_/g")
	if path is -d $session_path_no_dots
		start-tmux-by-path $session_path (echo $session_path_no_dots | sed -e "s:/:_:g")
		return
	end

	# create new session from session config
	set session_config "$HOME/.dotfiles/sessions/$session_name.json"
	if [ -f $session_config ]
		start-tmux-by-config $session_config $session_name
		return
	end
	echo -e "can not enter \"$argv[1]\": not found"
end
