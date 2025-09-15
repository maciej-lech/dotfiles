function smerge --wraps='flatpak run com.sublimemerge.App' --description 'alias smerge "flatpak run com.sublimemerge.App"'
    flatpak run com.sublimemerge.App $argv
end
