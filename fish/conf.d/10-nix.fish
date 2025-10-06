if command -q nixd
    if test -e ~/.nix-profile/etc/profile.d/nix.fish; . ~/.nix-profile/etc/profile.d/nix.fish; end

    set -p fish_complete_path ~/.nix-profile/share/fish/vendor_completions.d

    replay source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
end
