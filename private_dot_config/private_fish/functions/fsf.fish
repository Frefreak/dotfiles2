function fsf
    set -l clipboard wl-copy
    if test (uname) = Darwin
        set clipboard pbcopy
    end
    printf '%s' (realpath -- "$argv[1]") | $clipboard
end
