function nmake --wraps='cmake -G Ninja -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .' --description 'alias nmake cmake -G Ninja -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .'
  cmake -G Ninja -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=1 . $argv
        
end
