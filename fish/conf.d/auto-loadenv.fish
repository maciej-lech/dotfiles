function _auto-loadenv --on-event fish_prompt
    if not functions -q loadenv
        return
    end

    if status --is-command-substitution
        return
    end

    if test -e "$PWD/.env"
        loadenv .env
    end
end
