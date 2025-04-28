function ovpnctl --description 'OpenVPN control'
    command systemctl $argv[1] openvpn-client@$argv[2] $argv[3..]
end
