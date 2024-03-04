#!/usr/bin/env sh
unix() {
    date +%s
}
read_and_randomize_hosts() {
    mapfile -t hosts < "$1"
    shuffled_hosts=($(shuf -e "${hosts[@]}"))
}

setup_cent() {
    if [[ ! -d "$HACKMODE_PATH/cent"  ]]; then
        cent init
    fi
}

# Function to iterate over the randomized hosts list
loop_over_hosts() {
    dir=$(dir-setup.sh nuclei)
    time=$(unix)
    for host in "${shuffled_hosts[@]}"; do
        outfile=
        echo "saving to $outfiles"
        echo $host | nuclei  -j -hm -silent | tee -a "$host-$time.json"
    done
}

if [ -f "$1" ]; then
    read_and_randomize_hosts "$1"
    loop_over_hosts
else
    echo "Usage: bash nuclei-bulk.sh <path_to_hosts_file>"
fi
