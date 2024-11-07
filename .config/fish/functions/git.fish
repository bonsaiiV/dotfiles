function show_unpushed -v PWD -d 'Show unpushed git commits'
	git log -n8 @{u}..HEAD -- 2>/dev/null
end
