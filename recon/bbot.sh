#!/bin/env sh

# input url lis

function crawl () {
	now=$(date '+%Y-%m-%d')
	base=$(basename $1)
	dir="$PWD/scans/$now/"
	mkdir -p $PWD/bbot
	mkdir $PWD/bbot/$now/
	mkdir $PWD/bbot/$now
	echo $dir
	bbot --force -y -t $1 --blacklist blacklist.txt --name $1  -f subdomain-enum  cloud-enum web-basic   -m gowitness httpx   --output-module human csv json -o "$dir"
}

crawl $1
