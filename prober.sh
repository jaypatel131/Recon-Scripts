#!/bin/bash
if [ ! -d $RECON/$1/probed ]; then
:
mkdir $RECON/$1/probed
fi

if [ ! -d $RECON/$1/probed/httpxf ]; then
:
mkdir $RECON/$1/probed/httpxf
fi

echo '[+] Probing Start...😏'>> $RECON/$1/log.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
if [ -f $RECON/$1/probed/httprobe-four ]; then
    echo '[+] httprobe-443 already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running httprobe-443....' >> $RECON/$1/log.txt
    cat $RECON/$1/ultimate.txt | httprobe -s -p https:443 | anew $RECON/$1/probed/httprobe-four
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
if [ -f $RECON/$1/probed/httprobe-eighty ]; then
    echo '[+] httprobe-80 already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running httprobe-80....' >> $RECON/$1/log.txt
    cat $RECON/$1/ultimate.txt| httprobe -s -p http:80 | anew $RECON/$1/probed/httprobe-eighty
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
if [ -f $RECON/$1/probed/httpx ]; then
    echo 'httpx already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running httpx....' >> $RECON/$1/log.txt
    cat $RECON/$1/ultimate.txt| httpx -nc -sc -t $fl -title -tech-detect | anew $RECON/$1/probed/httpx
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Seperating and removing unwanted files' >> $RECON/$1/log.txt
cat $RECON/$1/probed/httprobe-four | anew $RECON/$1/probed/httprobe
cat $RECON/$1/probed/httprobe-eighty | anew $RECON/$1/probed/httprobe
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
if [ -f $RECON/$1/probed/httprobe-four ]; then
    echo 'httprobe-four is not present' >> $RECON/$1/log.txt
else
    echo 'rm httprobe-four....' >> $RECON/$1/log.txt
    rm $RECON/$1/probed/httprobe-four
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
if [ -f $RECON/$1/probed/httprobe-eighty ]; then
    echo 'httprobe-eighty is not present' >> $RECON/$1/log.txt
else
    echo 'rm httprobe-eighty....' >> $RECON/$1/log.txt
    rm $RECON/$1/probed/httprobe-eighty
fi
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Separating httpx Output🫣' >> $RECON/$1/log.txt
cat $RECON/$1/probed/httpx | grep 200 | awk  '{print $1}' | tee $RECON/$1/probed/httpxf/httpx-200
cat $RECON/$1/probed/httpx | grep 301 | awk  '{print $1}' | tee $RECON/$1/probed/httpxf/httpx-301
cat $RECON/$1/probed/httpx | grep 302 | awk  '{print $1}' | tee $RECON/$1/probed/httpxf/httpx-302
cat $RECON/$1/probed/httpx | grep 403 | awk  '{print $1}' | tee $RECON/$1/probed/httpxf/httpx-403
cat $RECON/$1/probed/httpx | grep 404 | awk  '{print $1}' | tee $RECON/$1/probed/httpxf/httpx-404
cat $RECON/$1/probed/httpx | grep 500 | awk  '{print $1}' | tee $RECON/$1/probed/httpxf/httpx-500
cat $RECON/$1/probed/httpx | grep 502 | awk  '{print $1}' | tee $RECON/$1/probed/httpxf/httpx-502
cat $RECON/$1/probed/httpx | grep 503 | awk  '{print $1}' | tee $RECON/$1/probed/httpxf/httpx-503
cat $RECON/$1/probed/httpx | awk  '{print $1}' | tee $RECON/$1/probed/httpxf/httpx
echo '[+] Completed😤'

./statuscollector.sh $1