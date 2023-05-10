function fish_prompt
	set_color D94379
	fish_is_root_user; and set_color red;
	echo -n $hostname
	set_color normal
	echo -n ':'(prompt_pwd)
	echo -n '>'
end
