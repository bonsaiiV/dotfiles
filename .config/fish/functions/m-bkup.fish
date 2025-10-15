function m-bkup
	doas cryptsetup open "$argv[1]" bkup-drive
	mount /home/bonsaiiv/backups
end

function u-bkup
	umount /home/bonsaiiv/backups
	doas cryptsetup close bkup-drive
end
