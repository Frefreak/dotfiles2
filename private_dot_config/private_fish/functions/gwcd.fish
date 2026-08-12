function gwcd --description 'Change directory to a Git worktree selected with fzf'
    set -l choices
    set -l paths
    set -l path
    set -l branch

    for line in (git worktree list --porcelain 2>/dev/null)
        if string match -q 'worktree *' -- "$line"
            if test -n "$path"
                set -a choices "$path ($branch)"
                set -a paths "$path"
            end
            set path (string replace 'worktree ' '' -- "$line")
            set branch '(detached)'
        else if string match -q 'branch *' -- "$line"
            set branch (string replace 'branch refs/heads/' '' -- "$line")
        end
    end

    if test -n "$path"
        set -a choices "$path ($branch)"
        set -a paths "$path"
    end

    set -l selected (printf '%s\n' $choices | fzf --prompt='worktree> ')
    set -l selected_index (contains --index -- "$selected" $choices)
    set -l worktree $paths[$selected_index]

    test -n "$worktree"; and cd "$worktree"
end
