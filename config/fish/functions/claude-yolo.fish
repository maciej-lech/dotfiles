function claude-yolo --wraps claude --description 'Run claude with bypassPermissions mode'
    command claude --permission-mode bypassPermissions $argv
end
