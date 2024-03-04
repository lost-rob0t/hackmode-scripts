#!/usr/bin/env sh
# NOTE requires bbrf to be installed!
# taken from here https://github.com/honoki/bbrf-client
for p in $(bbrf programs); do
  bbrf domains --view unresolved -p $p | \
  dnsx -silent -a -resp | tr -d '[]' | tee \
      >(awk '{print $1":"$2}' | bbrf domain update - -p $p -s dnsx) \
      >(awk '{print $1":"$2}' | bbrf domain add - -p $p -s dnsx) \
      >(awk '{print $2":"$1}' | bbrf ip add - -p $p -s dnsx) \
      >(awk '{print $2":"$1}' | bbrf ip update - -p $p -s dnsx)
done
