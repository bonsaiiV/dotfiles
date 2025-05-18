functions -c ls __ls_orig
function ls
	for i in (seq 1 5)
		__ls_orig $argv
	end
end
