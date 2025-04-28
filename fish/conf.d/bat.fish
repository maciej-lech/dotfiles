if command -q bat
    set -gx BAT_STYLE numbers
    set -gx BAT_THEME Nord
    set -gx LESSOPEN "|bat --color always -pP %s"
end
