if isatty stdin
    set -gx GPG_TTY (tty)
end

# Use a per-client marker because gpg-agent may predate this SSH session.
if set -q SSH_CONNECTION; or set -q SSH_TTY
    set -gx PINENTRY_USER_DATA carson-terminal
else
    set -gx PINENTRY_USER_DATA carson-desktop
end
