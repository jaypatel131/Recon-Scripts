#!/bin/bash
if [ ! -d $RECON/$1/probed ]; then
:
mkdir $RECON/$1/probed
fi

echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Header Collecting...😏' >> $RECON/$1/log.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
cat $RECON/$1/probed/httpxf/httpx | fff -d 1 -S -o $RECON/$1/headers
find $RECON/$1/headers -name *.body | anew  $RECON/$1/headers/bodies.txt
find $RECON/$1/headers -name *.headers | anew  $RECON/$1/headers/headers.txt
paste $RECON/$1/headers/headers.txt $RECON/$1/headers/bodies.txt | anew $RECON/$1/headers/final.txt
cat $RECON/$1/ultimate.txt | filter-resolved | anew $RECON/$1/fff-filtered
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Headers Collected😎' >> $RECON/$1/log.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'