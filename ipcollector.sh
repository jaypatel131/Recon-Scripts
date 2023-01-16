#!/bin/bash

if [ ! -d $RECON/$1/ips ]; then
:
mkdir $RECON/$1/ips
fi

echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo "[+] Fetching IPs from assets...🤞" >> $RECON/$1/log.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/ultimate.txt); do nslookup $i | grep "Address" | cut -d " " -f2 | cut -d "s" -f4 | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" | anew $RECON/$1/ips/ips.txt;done
for i in $(cat $RECON/$1/ultimate.txt); do nslookup $i | grep -E -o "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" | anew $RECON/$1/ips/ip-range.txt;done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo "[+] IPs Fetched🫡" >> $RECON/$1/log.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'