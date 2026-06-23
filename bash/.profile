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

# set PATH so it includes user's bun bin if it exists
if [ -d "$HOME/.bun/bin" ] ; then
    PATH="$HOME/.bun/bin:$PATH"
fi

# SSH agent — attach to the same socket Fish uses
_SSH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
_SSH_SOCK="${_SSH_SOCK%/}/ssh-agent.socket"
export SSH_AUTH_SOCK="$_SSH_SOCK"

# Test the agent status (0=has keys, 1=empty, 2=unreachable/dead)
ssh-add -l >/dev/null 2>&1
_AGENT_STATUS=$?

if [ $_AGENT_STATUS -eq 2 ]; then
    rm -f "$SSH_AUTH_SOCK"
    ssh-agent -a "$SSH_AUTH_SOCK" > /dev/null 2>&1
    _AGENT_STATUS=1
fi

# Load default key if the agent is active but empty
if [ $_AGENT_STATUS -eq 1 ] && [ -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-add "$HOME/.ssh/id_ed25519" >/dev/null 2>&1
fi

unset _SSH_SOCK _AGENT_STATUS
