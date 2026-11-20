# Prompt, navigation, fuzzy finding and aliases.
status is-interactive; or return

type -q starship; and starship init fish | source

# zoxide: z <dir>, zi (interactive picker)
type -q zoxide; and zoxide init fish | source

# fzf: Ctrl+T files, Ctrl+R history, Alt+C cd. fd lists the files (fast, and
# respects .gitignore); bat and eza draw the previews. Colors: Catppuccin Mocha.
if type -q fzf
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
    set -gx FZF_DEFAULT_OPTS (string join ' ' -- \
        '--height=60% --layout=reverse --border --info=inline' \
        '--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8' \
        '--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc' \
        '--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8' \
        '--color=selected-bg:#45475a,border:#6c7086,label:#cdd6f4')
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers --line-range=:300 {}' --bind 'ctrl-/:toggle-preview'"
    set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --level=2 --icons --color=always {}'"
    set -gx FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window=down:3:wrap"
    set -gx _ZO_FZF_OPTS "$FZF_DEFAULT_OPTS --preview 'eza --tree --level=2 --icons --color=always {2..}'"
    fzf --fish | source
end

if type -q eza
    alias ls 'eza --icons --group-directories-first'
    alias ll 'eza -l --icons --git --group-directories-first'
    alias la 'eza -la --icons --git --group-directories-first'
    alias lt 'eza --tree --level=2 --icons'
end

type -q bat; and alias cat 'bat --paging=never'
