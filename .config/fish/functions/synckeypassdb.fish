function synckeypassdb
	set tmp_db_dir "/tmp/keepass_dbs"
	mkdir -p "$tmp_db_dir"

	if [ (count $argv) -ge 1 ]
		set db $argv[1]
	else
		set db "default"
	end

	set local_db_file "$XDG_DATA_HOME/keepassxc/$db"".kdbx"

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
