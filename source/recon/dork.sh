#!/usr/bin/env sh

ctrl_c() {
  echo "Ctrl-C received. Exiting gracefully..."
  exit 0
}

trap ctrl_c SIGINT

bulk() {
    while read -r q; do
        while read -r domain; do
            echo "site:$domain AND $q"
            DorXNG.py -q "site:$domain AND $q" -L 2 -d dorks.db
        done < "$1"
    done < "$2"
}



domain_spray() {
    while read -r domain; do
        echo "site:$domain AND $2"
        DorXNG.py -q "site:"$domain" AND $2" -L 2 -d dorks.db
    done < $1
}



case "$1" in
    "-b" | "--bulk")
           if [ $# -lt 3 ]; then
               echo "usage: dork.sh --bulk/-b domains.txt dorks.txt"
               exit 1
           fi
        bulk $2 $3
        ;;
    "-s" | "--spray")
        if [ $# -lt 3 ]; then
               echo "usage: dork.sh --spray/-s domains.txt <query>"
               exit 1
           fi
        domain_spray $2 $3;;
    *)
        echo "Invalid usage: use -b for bulk or -s for spray";;
esac
