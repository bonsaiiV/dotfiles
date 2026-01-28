function find_in_pdf
	for f in $(find . -type f -name '*.pdf' -print )
		if pdftotext $f - | grep -cq $argv[1];
			echo $f
			pdftotext $f - | grep $argv[1]
		end
	end
end

