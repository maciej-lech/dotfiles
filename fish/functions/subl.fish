function subl --wraps='flatpak run com.sublimetext.three -a' --description 'alias subl "flatpak run com.sublimetext.three -a"'
    flatpak run com.sublimetext.three -a $argv
end
