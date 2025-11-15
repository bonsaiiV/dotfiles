function start-tmux -d "start a tmux session in given directory"
	set name $argv[1]
	set dir $argv[1]
	if [ (count $argv) -ge 2 ]
		set name $argv[2]
	end
	tmux new-session -dc "$dir" -s $name "nvim ."
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
	set preset (grep -m 1 -e "$name"";" "$HOME/.config/tmux/presets")
	if [ "$preset" != "" ]
		set preset_path (path resolve (echo $preset | sed -e "s|$name"";||" | sed -e "s|\$HOME|$HOME|"))
		start-tmux $preset_path $name
		return
	end
	echo -e "can not enter \"$argv[1]\": not found"
end
