#!/bin/bash
echo '[+] Subdomains Finding...'
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

count=1
while true; do
  read -p "Enter inscope $count (or press Enter to finish): " website
  if [ -z "$website" ]; then
    break
  fi
  echo $website >> $RECON/$1/wildcards
  count=$((count+1))
done

while true; do
  read -p "Enter outofscope $count (or press Enter to finish🤔): " website
  if [ -z "$website" ]; then
    break
  fi
  echo $website >> $RECON/$1/outofscope.txt
  count=$((count+1))
done

while true; do
  read -p "Enter extra domain $count (or press Enter to finish🤔): " website
  if [ -z "$website" ]; then
    break
  fi
  echo $website >> $RECON/$1/extra.txt
  count=$((count+1))
done

echo "The websites have been added to the file."
echo "Enter the thread size😁: "
read th
echo "Enter the thread size For httpx😁: "
read fl
echo "Enter the thread size For dnsx: "
read treads
echo "Enter the rate limit For dnsx: "
read rate
echo '[+] Subdomain finding...😏'
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/wildcards)
do
if [ -f $RECON/$1/subdomains/$i-sf ]; then
    echo '[+] subfinder already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running subfinder....' >> $RECON/$1/log.txt
    subfinder -d $i -t $th -o $RECON/$1/subdomains/$i-sf
fi
done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/wildcards)
do
if [ -f $RECON/$1/subdomains/$i-as ]; then
    echo '[+] assetfinder already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running assetfinder....' >> $RECON/$1/log.txt
    assetfinder -subs-only $i | anew $RECON/$1/subdomains/$i-as
fi
done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/wildcards)
do
if [ -f $RECON/$1/subdomains/$i-fd ]; then
    echo '[+] findomain already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running findomain....' >> $RECON/$1/log.txt
    findomain -t $i --external-subdomains --threads $th -u $RECON/$1/subdomains/$i-fd
fi
done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/wildcards)
do
if [ -f $RECON/$1/subdomains/$i-amp ]; then
    echo '[+] amass already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running amass....' >> $RECON/$1/log.txt
    amass enum -passive -nocolor -nolocaldb -norecursive -noalts -d $i >> $RECON/$1/subdomains/$i-amp
    amass enum -src -nolocaldb -ip -d $i >> $RECON/$1/subdomains/$i-ami
fi
done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/wildcards)
do
if [ -f $RECON/$1/subdomains/$i-one ]; then
    echo '[+] oneforall already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running oneforall....' >> $RECON/$1/log.txt
    python3 /home/orayan/Tools/OneForAll/oneforall.py --target $i run
    mv /home/orayan/Tools/OneForAll/results/temp/*.txt $RECON/$1/subdomains/
    touch $RECON/$1/subdomains/$i-one
fi
done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/wildcards)
do
if [ -f $RECON/$1/subdomains/$i-kn ]; then
    echo '[+] knockpy already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running knockpy....' >> $RECON/$1/log.txt
    knockpy $i -th $th | tee $RECON/$1/subdomains/$i-kn
fi
done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/wildcards)
do
if [ -f $RECON/$1/subdomains/$i-jld ]; then
    echo '[+] curl already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running curl....' >> $RECON/$1/log.txt
    curl https://jldc.me/anubis/subdomains/$i | jq -r ".[]" | anew $RECON/$1/subdomains/$i-jld
fi
done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/wildcards)
do
if [ -f $RECON/$1/subdomains/$i-crt ]; then
    echo '[+] crt already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running crt....' >> $RECON/$1/log.txt
    curl https://crt.sh/?q=%.$i | grep "$i" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | sort -u | anew $RECON/$1/subdomains/$i-crt
fi
done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
for i in $(cat $RECON/$1/wildcards)
do
if [ -f $RECON/$1/subdomains/$i-api ]; then
    echo '[+] api already done. Skipping command.'>> $RECON/$1/log.txt
else
    echo '[+] running api....' >> $RECON/$1/log.txt
    curl https://api.hackertarget.com/hostsearch/\?q\=$i | grep -o '\w.*$i' | anew $RECON/$1/subdomains/$i-api
fi
done
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo 'running mv....' >> $RECON/$1/log.txt
mv ~/external_subdomains/subfinder/subfinder_subdomains_$i.txt $RECON/$1/subdomains/
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo 'running mv....' >> $RECON/$1/log.txt
mv ~/external_subdomains/amass/amass_subdomains_$i.txt $RECON/$1/subdomains/
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo 'running haktrails....' >> $RECON/$1/log.txt
cp $RECON/$1/wildcards $RECON/$1/wildcards.txt
cat $RECON/$1/wildcards.txt | haktrails subdomains | anew $RECON/$1/subdomains/$i-tr
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Completed😎'
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Separating Output😤'
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
cat $RECON/$1/subdomains/* | tee -a $RECON/$1/assets
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Subdomains Found'
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
cat $RECON/$1/assets  | grep -Eo '[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}' | anew $RECON/$1/final/1
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Running Dns.sh' >> $RECON/$1/log.txt
./dns.sh $1 $rate $treads
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
cat $RECON/$1/final/* | tee -a $RECON/$1/ultimate_temp.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Seperating outofscope' >> $RECON/$1/log.txt
comm -1 -3 <(sort $RECON/$1/outofscope.txt) <(sort $RECON/$1/ultimate_temp.txt) | tee $RECON/$1/ultimate_temp2.txt
cat $RECON/$1/ultimate_temp2.txt | grep -Eo '[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}' | anew $RECON/$1/ultimate.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Adding extra domains' >> $RECON/$1/log.txt
cat $RECON/$1/extra.txt | tee -a $RECON/$1/ultimate.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] extracting IPS and ip-ranges' >> $RECON/$1/log.txt
grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $RECON/$1/subdomains/$i-ami | anew $RECON/$1/ips/ips.txt
grep -E -o "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $RECON/$1/subdomains/$i-ami | anew $RECON/$1/ips/ip-range.txt
grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $RECON/$1/subdomains/$i-kn | anew $RECON/$1/ips/ips.txt
grep -E -o "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $RECON/$1/subdomains/$i-kn | anew $RECON/$1/ips/ip-range.txt
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Removing unwanted files' >> $RECON/$1/log.txt
rm -rf $RECON/$1/final/*
#rm -rf $RECON/$1/subdomains/*
#cat $RECON/$1/ultimate.txt | notify -bulk
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] ultimate Level Subs differentiated😮‍💨'
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Running prober.sh' >> $RECON/$1/log.txt
./prober.sh $1 $fl
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Running ipcollector.sh' >> $RECON/$1/log.txt
./ipcollector.sh $1
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Running rustscan.sh' >> $RECON/$1/log.txt
./rustscan.sh $1
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '[+] Running naabu.sh' >> $RECON/$1/log.txt
./naabu.sh $1
echo '----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '🤔✋🤔✋🤔✋🤔✋🤔✋🤔✋'
echo '[+] Run headers.sh in local kali machine' >> $RECON/$1/log.txt
rm resolvers.txt
rm -rf external_subdomains
rm -rf knockpy_report