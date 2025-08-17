function t --wraps='alacritty & && disown' --description 'alias t alacritty & && disown'
	alacritty 2>/dev/null & 
	disown
end
