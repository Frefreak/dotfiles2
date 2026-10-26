function pass --wraps pass
    env PATH="$HOME/.local/libexec:$PATH" /usr/bin/pass $argv
end
