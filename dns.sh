#!/bin/bash
if [ ! -d $RECON/$1/dns ]; then
:
mkdir $RECON/$1/dns
fi

echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Downloading resolvers.txt🫡'>> $RECON/$1/log.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
if [ -f all.txt ]; then
    echo 'all.txt is present'
else
    echo 'Downloading all.txt🫡....' >> $RECON/$1/log.txt
    wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
if [ -f resolvers.txt ]; then
    echo 'resolvers.txt is present'
else
    echo 'Downloading resolvers.txt🫡....' >> $RECON/$1/log.txt
    wget https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Scanning for Massdns🫡' >> $RECON/$1/log.txt
if [ -f $RECON/$1/dns/massdns-out ]; then
    echo 'massdns already done. Skipping command.'
else
    echo 'running massdns....' >> $RECON/$1/log.txt
    massdns -r resolvers.txt -t A -o S -w $RECON/$1/dns/massdns-out $RECON/$1/final/1
    cat $RECON/$1/dns/massdns-out | cut -d" " -f3 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | anew $RECON/$1/ips/ips.txt
    cat $RECON/$1/dns/massdns-out | greo CNAME | tee $RECON/$1/dns/cname.txt
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Scanning for Dnsx🫡' >> $RECON/$1/log.txt
if [ -f $RECON/$1/dns/dnsx_out.txt ]; then
    echo 'dnsx already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo 'running dnsx....' >> $RECON/$1/log.txt
    # cat $RECON/$1/final/1 | dnsx -silent -a -resp | anew $RECON/$1/dns/dnsx_out.txt
    dnsx -l $RECON/$1/final/1 -a -cname -axfr -t $treads -rl $rate -o $RECON/$target/DNS/dnsx_out.txt -silent -r resolvers.txt
	cat $RECON/$1/dns/dnsx_out.txt  | grep -Eo '[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}' | sort -u >> $RECON/$1/final/2
	grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $RECON/$1/dns/dnsx_out.txt | anew $RECON/$1/ips/ips.txt
	grep -E -o "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $RECON/$1/dns/dnsx_out.txt | anew $RECON/$1/ips/ip-range.txt
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'

echo '[+] Scanning Done for Dns🫡' >> $RECON/$1/log.txt