#!/bin/bash
if [ ! -d $RECON/$1/portscan ]; then
:
mkdir $RECON/$1/portscan
fi

echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Rustscan is scanning for open ports'>> $RECON/$1/log.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/ips/ip-range.txt);do rustscan -a $i --ulimit 5000 -g | anew $RECON/$1/portscan/rust-range.txt;done
for i in $(cat $RECON/$1/ips/ips.txt);do rustscan -a $i --ulimit 5000 -g | anew $RECON/$1/portscan/rust-ips.txt;done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
cat $RECON/$1/portscan/rust-range.txt | anew $RECON/$1/portscan/rust_out.txt
cat $RECON/$1/portscan/rust-ips.txt | anew $RECON/$1/portscan/rust_out.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
if [ -f $RECON/$1/portscan/rust-range.txt ]; then
    echo 'rust-range is not present' >> $RECON/$1/log.txt
else
    echo 'rm rust-range....' >> $RECON/$1/log.txt
    rm $RECON/$1/portscan/rust-range.txt
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
if [ -f $RECON/$1/portscan/rust-ips.txt ]; then
    echo 'rust-ips is not present' >> $RECON/$1/log.txt
else
    echo 'rm rust-ips....' >> $RECON/$1/log.txt
    rm $RECON/$1/portscan/rust-ips.txt
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Rustscan Done'>> $RECON/$1/log.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'