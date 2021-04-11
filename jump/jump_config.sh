#!/bin/bash

# Output coloring
red=`tput setaf 001`
green=`tput setaf 002`
yellow=`tput setaf 003`
reset=`tput sgr0`

cd $(dirname $0)

# Check if an argument is passed to confirm that loaded directory is uploaded to server
if [ $# -eq 0 ]
then
echo "${red} Script requires that you have copied the POPULATED ./jump-server/jump to the JUMP server${reset}"
echo "${red} Do this using the following command: scp -r /jump-server/jump jumpUser@jump.ip.address:~ ${reset}"
echo "${red} If you have done this you can run the jump_config script by passing 'yes' to the script as an argument${reset}"
exit 1
fi

# Confirm that initial upload requirement is met
if [ $1 != "yes" ]
then
echo "${red} Invalid argument... run script with no arguments to get instructions${reset}"
exit 1
fi

# Check that user has root access
if (( $EUID != 0 ))
then
  echo "${red} You must run jump_config.sh as root${reset}"
  exit 1
fi


# Create a non-root user for the jump server
echo "${green} Creating jumpuser account for this maching${reset}"
mkdir /home/jumpuser
mkdir /home/jumpuser/.ssh
useradd jumpuser -d /home/jumpuser
# Set jumpUser password
echo "${green} Set password for jumpuser${reset}"
passwd jumpuser
# Authorize home to login with a normal shell
echo "${green} Setting jumpuser account rules${reset}"
cp ./server-auth/authorized_keys /home/jumpuser/.ssh/authorized_keys
chmod 644 /home/jumpuser/.ssh/authorized_keys
chown -R jumpuser:jumpuser /home/jumpuser
chsh -s /bin/bash jumpuser
usermod -aG sudo jumpuser


# Create no-privlege "dummy" user to prevent reverse access from a stolen device
echo "${green} Creating dummy account on this machine${reset}"
mkdir /home/dummy
mkdir /home/dummy/.ssh
useradd dummy -d /home/dummy
# Set dummy password
echo "${green} Set a password for dummy${reset}"
passwd dummy
# Authorize dummy login, and prevent code execution
echo "${green} Setting dummy account rules${reset}"
cp ./server-auth/dummy/authorized_keys /home/dummy/.ssh/authorized_keys
chmod 644 /home/dummy/.ssh/authorized_keys
chown -R dummy:dummy /home/dummy
chsh -s /bin/false dummy

# Configure ssh server keys and universal settings
echo "${green} Setting universal ssh rules and server keys${reset}"
mkdir /etc/ssh
cp ./server-key/ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key
chmod 600 /etc/ssh/ssh_host_ecdsa_key
cp ./server-key/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub
chmod 644 /etc/ssh/ssh_host_ecdsa_key.pub
cp ./server-config/sshd_config /etc/ssh/sshd_config
chmod 644 /etc/ssh/sshd_config
chown -R root:root /etc/ssh

# Disabled by default because AWS does not require iptables

# # Setup firewall
# echo "${green} Setting initial firewall rules${reset}"
# iptables-legacy-restore < ./firewall/rules.v4
# ip6tables-legacy-restore < ./firewall/rules.v6
# update-alternatives --set iptables /usr/sbin/iptables-legacy
# update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
# echo "${green} Creating /etc/iptables if needed${reset}"
# mkdir /etc/iptables/
# echo "${green} Installing persistent firewall rules${reset}"
# cp ./firewall/rules.v4 /etc/iptables
# cp ./firewall/rules.v6 /etc/iptables
# echo "${green} installing persistent firewall and sudo${reset}"
# apt install iptables-persistent sudo -y
# iptables-save > /etc/iptables/rules.v4
# ip6tables-save > /etc/iptables/rules.v6

# Remove setup files
echo "${green} Cleaning up${reset}"
cd ..
rm -rf jump

echo "${green} ..............${reset}"
echo "${green} ..............${reset}"
echo "${green} .... ${yellow}DONE${green} ....${reset}"
echo "${green} ..............${reset}"
echo "${green} ..............${reset}"

reboot

