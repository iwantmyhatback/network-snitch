#!/bin/bash

# Check that user has root access
if (( $EUID != 0 ))
then
  echo "You must run jump_config as root"
  exit 1
fi

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8

echo "tplink-network-switch" > /etc/hostname
echo "127.0.0.1       localhost" > /etc/hosts
echo "::1             localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "ff02::1         ip6-allnodes" >> /etc/hosts
echo "ff02::2         ip6-allrouters" >> /etc/hosts
echo "127.0.1.1       tplink-network-switch" >> /etc/hosts

sudo apt update
sudo apt upgrade -y

cd $(dirname $0)

# Create a non-root user for the target server
echo "creating snitch account on this machine"
mkdir /home/snitch
mkdir /home/snitch/.ssh
useradd snitch -d /home/snitch
# Set snitch password
echo "Set a password for snitch"
passwd snitch
# Authorize home to login
echo "Setting snitch account rules"
cat ./server-auth/authorized_keys > /home/snitch/.ssh/authorized_keys
chmod 600 /home/snitch/.ssh/authorized_keys
cat ./known/known_hosts > /home/snitch/.ssh/known_hosts
chmod 644 /home/snitch/.ssh/known_hosts
# Set public and private keys and their permissions
echo "Writing ssh keys"
cat ./client-key/id_rsa > /home/snitch/.ssh/id_rsa
chmod 600 /home/snitch/.ssh/id_rsa
cat ./client-key/id_rsa > /home/snitch/.ssh/id_rsa.pub
chmod 644 /home/snitch/.ssh/id_rsa.pub
# Misc additional account settigs
chown -R snitch:snitch /home/snitch
chsh -s /bin/bash snitch
usermod -aG sudo snitch

# Configure ssh server keys and universal settings
echo "Setting universal ssh rules and server keys"
mkdir /etc/ssh
cat ./server-key/ssh_host_ecdsa_key > /etc/ssh/ssh_host_ecdsa_key
chmod 600 /etc/ssh/ssh_host_ecdsa_key
cat ./server-key/ssh_host_ecdsa_key.pub > /etc/ssh/ssh_host_ecdsa_key.pub
chmod 600 /etc/ssh/ssh_host_ecdsa_key.pub
cat ./server-config/ssh_config > /etc/ssh/ssh_config
chmod 644 /etc/ssh/ssh_config
cat ./server-config/sshd_config > /etc/ssh/sshd_config
chmod 644 /etc/ssh/sshd_config

# Remove setup files (enable after testing)
# echo "Cleaning Up"
# cd ~
# rm -rf ~/target

echo ".............."
echo ".............."
echo ".... Done ...."
echo ".............."
echo ".............."