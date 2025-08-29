function aria2c_server
    set -l max_downloads 5
    if test -n "$argv[1]"
        set max_downloads $argv[1]
    end

    echo "Starting aria2c server with a max of $max_downloads concurrent downloads..."

    # The main command
    aria2c --enable-rpc \
           --rpc-allow-origin-all \
           --max-concurrent-downloads=$max_downloads
        #    --rpc-listen-all=true \
end