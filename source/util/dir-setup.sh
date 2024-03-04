#!/usr/bin/env sh


if [ -z "$HACKMODE_PATH" ]; then
    echo "HACKMODE_PATH environment variable is not set. Exiting."
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "usage: dir-setup.sh: <tool name>"
    exit 1

fi
scan_dir="$HACKMODE_PATH/scans"
now=$(date '+%Y-%m-%d')
current_dir="$scan_dir/$now"
dir="$current_dir/$1"
#dir=$(echo $dir | sed 's/\/\//\//g')
if [[ ! -e $scan_dir ]]; then
    mkdir $scan_dir
fi

if [[ ! -e $current_dir ]]; then
    mkdir $current_dir
fi
if [[ ! -e $dir ]]; then
    mkdir $dir
fi
export $dir

echo "$PWD/scans/$now/$1"
