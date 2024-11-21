function show_unpushed -v PWD -d 'Show unpushed git commits'
	set unstaged $(git diff --shortstat . 2>/dev/null)
	set staged $(git diff --shortstat --staged . 2>/dev/null)
	if [ -n unstaged ];
        #	echo -e "local unstaged changes:\n\t$unstaged"
	end
	if [ -n staged ];
        #echo -e "local staged changes:\n\t$staged"
	end
	git log -n8 --oneline @{u}..HEAD -- 2>/dev/null
end
function fish_greeting
	show_unpushed
end
