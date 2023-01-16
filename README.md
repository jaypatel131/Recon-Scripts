# Recon-scripts
<h2>This scripts are made as my system so you have to change it little</h2>

Install kali and run the script, For the script ./install.sh😎<br />
<br />
<h3>#Installation steps:<br /></h3>
git clone https://github.com/jaypatel131/Kali-setup<br />
chmod +x install.sh<br />
./install.sh<br />

<br />
<h2>changes that you have to do for script</h2><br />

follow the staps<br />
1. cd ~<br />
2. nano .zshrc<br />
&nbsp;&nbsp;&nbsp;1. add export RECON=~/test<br />
3. mkdir test<br />
4. copy all the <b>scripts<b> on home page.<br />
5. chmod +x *<br />
6. ./subdomain.sh domain.com<br />
Then, Just wait for the time😉........

<br />
<h2>If you face this issue</h2><br />
./subdomain.sh vulnweb.com<br />
zsh: ./subdomain.sh: bad interpreter: /bin/bash^M: no such file or directory<br /><br />
So just run this command <br />
`sed -i -e 's/\r$//' subdomain-find.sh`
