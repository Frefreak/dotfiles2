function jqc
    if test (uname) = "Darwin"
        pbpaste | jq
    else
        wl-paste | jq
    end
end
