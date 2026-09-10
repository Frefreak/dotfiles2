function fsf
    printf '%s' (realpath -- $argv[1]) | wl-copy
end
