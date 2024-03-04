#!/usr/bin/env sh

TARGETS="$1"
cwd="$PWD"
FINDINGS="$HACKMODE_PATH/findings"
tmp="$cwd/.tmp"
wd=$(dir-setup dex)
MAX_WORKERS=$(nproc)
BBTZ_PATH="/usr/local/bin/bbzt"
RESOLVERS_FILE="$HOME/wordlists/resolvers/resolvers.txt"

function create_queue() {
    local fifo_name="$1"
    if [ ! -p "$fifo_name" ]; then
        mkfifo "$fifo_name"
    fi
}


function enq() {
    local fifo_name="$tmp/$1"
    local item="$2"
    echo "$item" >> "$fifo_name"
}

function spawn() {
    local fifo_name="$tmp/$1"
    local consumer_function="$2"
    typeset -fx "$consumer_function"
    cat "$fifo_name" | xargs -P "$MAX_WORKERS" -I {} bash "$consumer_function" {}
}

function send_log() {
    while read data; do
        local log_level="$3"
        local source="$1"
        local type="$2"
        data=$(echo "[$source]|[$(date '+%s')]|[$local_level]|[[$data]]")
        ntfy --title "New $type" --msg "$data" --tags "$type,$source" --topic "$HACKMODE_OP"
    done
}



function get_config () {
    echo "$HACKMODE_PATH/.config/targets"
}


function check_wildcard() {
    while read domain; do
    result=$(dig +short "*.${domain}")

    if [ -n "$result" ]; then
        return 0 # Wildcard DNS records found
    else
        echo "$domain"  # No wildcard DNS records found
    fi
    done
}

function send_alert() {
    while read data; do
        local source="$1"
        local type="$2"
        ntfy --title "New $type" --msg "$data" --tags "$type,$source" --topic "$HACKMODE_OP"
    done
}



function bb_bbot() {
    bbot -t "$1" --force -y -f safe -f subdomain-enum  cloud-enum web-basic -m httpx  -n bbot -o "$wd" --blacklist "$HACKMODE_PATH/.config/blacklist" | send_log
    cat "$wd/subdomains.txt" | check_wildcard | grep -vfx "$HACKMODE_PATH/.config/blacklist" | anewer "$FINDINGS/subdomains.txt" | send_alert "bbot" "Domain" | send_log "DNS" ""
    cat $wd/output.json | jq -r 'select(.type == "TECHNOLOGY") | .data.host + "," + .data.technology' | anewer $FINDINGS/tech.csv | send_alert "bbot" "Tech"
    cat $wd/output.json | jq -r 'select(.type == "URL") | .data.host' | anewer $FINDINGS/urls.txt | send_alert "bbot" "Url"
    cat $wd/output.json | jq -r 'select(.type == "FINDING") | .data.host + "," + .data.url + "," + .data.description'  | anewer $FINDINGS/bbot-findings.csv | send_alert "bbot" "Finding"
    cat $wd/output.json | jq -r 'select(.type == "EMAIL_ADDRESS") | .data' | xargs -I {} echo "$1,{}" | anewer $FINDINGS/emails.csv | send_alert "bbot" "Email"
    awk -F'\t' '{print $2}' $wd/wordcloud.tsv | anewer $FINDINGS/domain_wordlist.txt

}




function parse_katana() {
    while read jdata; do
        headers=$(jq -r '.response.headers' "$jdata")
        server=$(jq -r '.server' "$headers")
        cookies=$(jq -r '.set_cookie' "$headers")
        url=$(jq -r '.request.endpoint' "$jdata")
        echo "$url,$server,$cookies" | awk -F, -v OFS=',' '{for(i=1;i<=NF;i++) gsub(/"/, "\\\"", $i); print}' | anewer $FINDINGS/headers.csv
        echo "$url" | anewer "$FINDINGS"/urls.txt
    done
}

function spider() {
    gau "$target" | anewer $FINDINGS/urls_archived.txt
    cat $FINDINGS/urls_archived.txt | katana -j -d 5 -kf -jsl -jc -r "$RESOLVERS_FILE" | parse_katana | log
}

function dns() {
    local target="$1"
    subfinder -d "$target" -silent | check_wildcard | grep -vfx "$HACKMODE_PATH/.config/blacklist" | anewer $FINDINGS/subdomains.txt | sent_alert "subfinder" "Domain"
    cut -d "." -f 1
}

function wordlists {
    grep -E "$\.js" $FINDINGS/urls.txt | python3 $BBTZ/getjswords.py | anewer $FINDINGS/js_wordlists.txt
    cat $FINDINGS/*wordlist.txt | sort -u all_wordlist.txt
}

# probing
function bb_full_recon () {
    local target="$1"
    bb_bbot "$target"
    dns "$target"
    spider "$target"
}

# Fast(er) Recon
function door_kick {
    local target = "$1"
    bb_bbot "$target"
    spider "$target"

}

if [ -z "$1" ]; then
    $TARGETS=$(cat "$HACKMODE_PATH/.config/targets")
fi

if [ ! -d "$HACKMODE_PATH" ]; then
  mkdir -p "$HACKMODE_PATH"

fi

if [ ! -d "$FINDINGS" ]; then
    mkdir -p "$FINDINGS"
fi
