function rgf --description 'Search file contents (ripgrep), pick a match (fzf), open it in $EDITOR at that line'
    set -l match (rg --color=always --line-number --no-heading --smart-case -- (string join ' ' -- $argv) |
        fzf --ansi --delimiter : \
            --preview 'bat --color=always --style=numbers --highlight-line {2} {1}' \
            --preview-window '+{2}/2')
    or return
    set -l parts (string split -m2 : -- $match)
    $EDITOR +$parts[2] $parts[1]
end
