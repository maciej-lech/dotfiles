function cat --description 'Concatenate files and print on the standard output'
    if command -q bat
        command bat -pP $argv
    else
        command cat $argv
    end
end
