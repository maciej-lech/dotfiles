set NIX_PROFILE_PATH ~/.nix-profile

if test -e $NIX_PROFILE_PATH
    if test -e $NIX_PROFILE_PATH/etc/profile.d/nix.fish
        source $NIX_PROFILE_PATH/etc/profile.d/nix.fish
    end

    set -p fish_complete_path $NIX_PROFILE_PATH/share/fish/vendor_completions.d

    replay source $NIX_PROFILE_PATH/etc/profile.d/hm-session-vars.sh
end
