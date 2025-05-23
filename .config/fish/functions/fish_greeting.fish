function show_unpushed -v PWD -d 'Show unpushed git commits'
	git ls-files -z --others --exclude-standard . 2>/dev/null \
		| grep -cze '^' \
		| sed -e '/^0$/d' -e 's/[[:digit:]]\+/ \0 untracked files/' \
		| cat - (git diff --shortstat . 2>/dev/null | psub) \
		| sed -ze 's/\n/,/g' -e 's/,$/\n/'
	git log -n8 @{u}..HEAD -- 2>/dev/null
end
function fish_greeting
	show_unpushed
end
