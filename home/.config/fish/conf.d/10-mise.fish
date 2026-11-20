# mise: tools and per-directory versions. Interactive shells get the full
# activation (switches versions on cd); scripts get the shims.
type -q mise; or return

if status is-interactive
    mise activate fish | source
else
    fish_add_path -g ~/.local/share/mise/shims
end
