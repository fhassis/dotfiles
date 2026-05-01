# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# SSH agent — attach to the same socket Fish uses (conf.d/ssh-agent.fish),
# so VSCode's bash processes (started via `bash --login`) share the agent
# without re-prompting for a passphrase.
# Falls back to /run/user/<uid> if XDG_RUNTIME_DIR is not set.
_SSH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
_SSH_SOCK="${_SSH_SOCK%/}/ssh-agent.socket"
if [ ! -S "$_SSH_SOCK" ]; then
    ssh-agent -a "$_SSH_SOCK" > /dev/null 2>&1
fi
export SSH_AUTH_SOCK="$_SSH_SOCK"
unset _SSH_SOCK
