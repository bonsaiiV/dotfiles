function cmake
	command cmake -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=1 $argv
end
