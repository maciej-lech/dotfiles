## Environment
set -gx UID (id -u)
set -gx GID (id -g)
set -gx EDITOR vim

set -gx SSH_AUTH_SOCK /run/user/$UID/keyring/ssh
