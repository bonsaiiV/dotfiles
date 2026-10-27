function name
	# syntax 'shortopt/longopt' plus "=" für required parameter rest in man argpars /OPTION SPECIFICATION
	# argparse set variables
	argparse 'u/usb=' 'd/db=' -- $argv

	# you can query for existance
	if set -q _flag_db
		# and use their value
		set db $_flag_db
	end
end
