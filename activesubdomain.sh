#!/bin/bash

if [ ! -d $RECON/$1 ]; then
:
mkdir $RECON/$1
fi

if [ ! -d $RECON/$1/subdomains ]; then
:
mkdir $RECON/$1/subdomains
fi

if [ ! -d $RECON/$1/final ]; then
:
mkdir $RECON/$1/final
fi

if [ ! -d $RECON/$1/ips ]; then
:
mkdir $RECON/$1/ips
fi

if [ ! -d $RECON/$1/dns ]; then
:
mkdir $RECON/$1/dns
fi

if [ ! -d $RECON/$1/portscan ]; then
:
mkdir $RECON/$1/portscan
fi

if [ ! -d $RECON/$1/portscan ]; then
:
mkdir $RECON/$1/portscan
fi

count=1
while true; do
  read -p "Enter inscope $count (or press Enter to finish): " website
  if [ -z "$website" ]; then
    break
  fi
  echo $website >> $RECON/$1/wildcards
  count=$((count+1))
done


echo "Finding Active subdomain........" >> $RECON/$1/log.txt
for i in $(cat $RECON/$1/wildcards);do amass enum -active -nocolor -d $i -src -ip -v -config .config/amass/config.ini -o $RECON/$1/subdomains/$i-ami;done
grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $RECON/$1/subdomains/$i-ami | anew $RECON/$1/ips/ips.txt
grep -E -o "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $RECON/$1/subdomains/$i-ami | anew $RECON/$1/ips/ip-range.txt
grep -Eo '[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}' | anew $RECON/$1/final.txt


echo '[+] Downloading resolvers.txt🫡' >> $RECON/$1/log.txt
echo 'wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt'
wget https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt
echo '[+] Scanning for Dns🫡'>> $RECON/$1/log.txt
for i in $(cat $RECON/$1/wildcards);do massdns -r resolvers.txt -t A -o S -w $RECON/$1/dns/massdns-out $RECON/$1/final.txt;done
cat $RECON/$1/dns/massdns-out | cut -d" " -f3 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | anew $RECON/$1/ips/ips.txt
cat $RECON/$1/final.txt | dnsx -silent -a -resp | anew $RECON/$1/dns/arec.txt
cat $RECON/$1/dns/arec.txt  | grep -Eo '[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}' | sort -u >> $RECON/$1/final/2
grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $RECON/$1/dns/arec.txt | anew $RECON/$1/ips/ips.txt
grep -E -o "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $RECON/$1/dns/arec.txt | anew $RECON/$1/ips/ip-range.txt
cat $RECON/$1/final.txt | dnsx -silent -cname -resp | anew $RECON/$1/dns/cname.txt
cat $RECON/$1/ips/ip-range.txt | dnsx -silent -resp-only -ptr | anew $RECON/$1/dns/domains.txt
cat $RECON/$1/dns/domains.txt | anew $RECON/$1/final/3
for i in $(cat $RECON/$1/wildcards);do dnsx -silent -d $i -w all.txt | anew $RECON/$1/dns/domains-all.txt;done
cat $RECON/$1/dns/domains-all.txt | anew $RECON/$1/final/4
cat $RECON/$1/final.txt | dnsx dnsx -silent -w jira,grafana,jenkins -d - | anew $RECON/$1/dns/jira.txt
cat $RECON/$1/dns/jira.txt | anew $RECON/$1/final/5
echo '[+] Scanning for Dns🫡'



# echo '[+] naabu is scanning for open ports🫡' >> $RECON/$1/log.txt
# for i in $(cat $RECON/$1/final.txt);do naabu -host $i -silent -nc | anew $RECON/$1/portscan/naabu.txt;done
# for i in $(cat $RECON/$1/final.txt);do naabu -p "21,22,80,81,280,300,443,583,591,593,832,981,1010,1099,1311,2082,2087,2095,2096,2480,3000,3128,3333,4243,4444,4445,4567,4711,4712,4993,5000,5104,5108,5280,5281,5601,5800,6543,7000,7001,7002,7396,7474,8000,8001,8008,8009,8014,8042,8060,8069,8080,8081,8083,8088,8090,8091,8095,8118,8123,8172,8181,8222,8243,8280,8281,8333,8337,8443,8500,8530,8531,8834,8880,8887,8888,8983,9000,9001,9043,9060,9080,9090,9091,9092,9200,9443,9502,9800,9981,10000,10250,10443,11371,12043,12046,12443,15672,16080,17778,18091,18092,20720,28017,32000,55440,55672" -silent -nc -host $i | anew $RECON/$1/portscan/naabu_out.txt;done
# echo '[+] naabu Done😤'

echo '[+] Rustscan is scanning for open ports' >> $RECON/$1/log.txt
for i in $(cat $RECON/$1/ips/ip-range.txt);do rustscan -a $i --ulimit 5000 -g | anew $RECON/$1/portscan/rust-range.txt;done
for i in $(cat $RECON/$1/ips/ips.txt);do rustscan -a $i --ulimit 5000 -g | anew $RECON/$1/portscan/rust-ips.txt;done
cat $RECON/$1/portscan/rust-range.txt | anew $RECON/$1/portscan/rust_out.txt
cat $RECON/$1/portscan/rust-range.txt | anew $RECON/$1/portscan/rust_out.txt
rm $RECON/$1/portscan/rust-range.txt
rm $RECON/$1/portscan/rust-range.txt
echo '[+] Rustscan Done'