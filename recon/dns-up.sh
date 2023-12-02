#!/usr/bin/env sh

dir=$(dir-setup.sh "massdns")
servers="$HOME/wordlists/resolvers/resolvers.txt"
file_raw="$dir/massdns.json"
alive=$dir/alive.txt
echo "saying raw output to $file_raw"
massdns -o J -r $servers  -w $file_raw  $1

echo "saying alive domains to $alive"
cat $file_raw  | jq -r '. | select(.status == "NOERROR") | .name | sub("\\.$";"")' > $alive
