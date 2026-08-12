function synckeepassdb
	argparse 'u/usb=' 'd/db=' -- $argv
	set tmp_db_dir "/tmp/keepass_dbs"
	mkdir -p "$tmp_db_dir"

	if set -q _flag_db
		set db $_flag_db
	else
		set db "default"
	end

	set local_db_file "$XDG_DATA_HOME/keepassxc/$db"".kdbx"

	if set -q _flag_usb
		echo $_flag_usb
		set usb_db "$_flag_usb""/$db"".kdbx"
		if [ ! -f "$usb_db" ]
			echo "no keepassxc database found in the given location"
			return
		end
		if [ ! -f  "$local_db_file" ]
			mv $usb_db "$local_db_file"
			return
		end
		cp "$local_db_file" "$local_db_file"".bkup"
		keepassxc-cli merge --same-credentials "$local_db_file" "$_flag_usb""/$db"".kdbx"
		cp "$local_db_file" "$usb_db"
		return
	end

	if rsync "pi:/usr/local/share/keepassxc/$db"".kdbx" "$tmp_db_dir""/$db"".kdbx"
		if [ ! -f  "$local_db_file" ]
			mv "$tmp_db_dir""/$db"".kdbx" "$local_db_file"
			return
		end
		cp "$local_db_file" "$local_db_file"".bkup"
		keepassxc-cli merge --same-credentials "$local_db_file" "$tmp_db_dir""/$db"".kdbx"
	end

	rsync "$local_db_file" "pi:/usr/local/share/keepassxc/$db"".kdbx"
end
