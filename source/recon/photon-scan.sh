#!/bin/env sh

# Input URL or file list
input=$1

function crawl() {
    dir=$(dir-setup.sh "photon")
    # Pass any extra arguments to photon by using "$@"
    full_dir="$dir"/"$(echo $1 | sed 's/\//-/'g | sed 's/--//g' )"
    mkdir -p $full_dir
    photon --wayback -l 3 -u "$1" -t 10 -e json  -o "$full_dir" ${@:2}
}

if [ -f "$input" ]; then
    # If the input is a file, read each line and crawl
    while read -r line; do
        crawl "$line" "${@:2}"
    done < "$input"
else
    # If the input is a single URL, crawl it
    crawl "$input" "${@:2}"
fi
