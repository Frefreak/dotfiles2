function jnvc
    if test (uname) = "Darwin"
        pbpaste | jnv
    else
        wl-paste | jnv
    end
end
