if command -q nix
    set -p fish_complete_path ~/.nix-profile/share/fish/vendor_completions.d
end

bass . ~/.nix-profile/etc/profile.d/hm-session-vars.sh
