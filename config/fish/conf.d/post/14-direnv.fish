if command -q direnv
    direnv hook fish | string replace -r '/Cellar/direnv/[^/]+/bin/direnv' '/bin/direnv' | source
end
