#!/bin/bash

# Output coloring
red=`tput setaf 001`
green=`tput setaf 002`
yellow=`tput setaf 003`
reset=`tput sgr0`

cd $(dirname $0)

# Create machine directories
echo "${green} Making Machine Directories${reset}"
mkdir ./jump
mkdir ./home
mkdir ./target
# Directories for *CLIENT* keys
echo "${green} Making client-key Directories${reset}"
mkdir ./home/client-key
mkdir ./target/client-key
# Generate keys for *CLIENT* machines that need access to JUMP
echo "${green} Generating client keys${reset}"
ssh-keygen -t rsa -b 4096 -f ./home/client-key/id_rsa -N "" -C "HOME-ID-KEY"
ssh-keygen -t rsa -b 4096 -f ./target/client-key/id_rsa -N "" -C "TARGET-ID-KEY"
# Correct permissions for home machine key
chmod 600 ./home/client-key/id_rsa
# Directories for *SERVER* machine authorized_keys files
echo "${green} Making server-auth Directories${reset}"
mkdir ./jump/server-auth
mkdir ./jump/server-auth/dummy
mkdir ./target/server-auth
# Authorize HOME to access JUMP and TARGET
echo "${green} Populating authorized_keys files${reset}"
cat ./home/client-key/id_rsa.pub > ./target/server-auth/authorized_keys
cat ./home/client-key/id_rsa.pub > ./jump/server-auth/authorized_keys
# Authorized TARGET to access JUMP
cat ./target/client-key/id_rsa.pub > ./jump/server-auth/dummy/authorized_keys
# Directories for *SERVER* machine keys
echo "${green} Making server-key Directories${reset}"
mkdir ./jump/server-key
mkdir ./target/server-key
# Generate keys for *SERVER* machines
echo "${green} Generating server keys${reset}"
ssh-keygen -t ecdsa -b 256 -f ./jump/server-key/ssh_host_ecdsa_key -N "" -C "JUMP-HOST-KEY"
ssh-keygen -t ecdsa -b 256 -f ./target/server-key/ssh_host_ecdsa_key -N "" -C "TARGET-HOST-KEY"
# Directories for known hosts
echo "${green} Making known_host Directories${reset}"
mkdir ./home/known
mkdir ./target/known
# Set JUMP and TARGET as known hosts for HOME
echo "${green} Populating known_host files${reset}"
cat ./jump/server-key/ssh_host_ecdsa_key.pub > ./home/known/known_hosts
cat ./target/server-key/ssh_host_ecdsa_key.pub > ./home/known/known_hosts
# Set JUMP as known host for TARGET
cat ./jump/server-key/ssh_host_ecdsa_key.pub > ./target/known/known_hosts

echo "${green} ..............${reset}"
echo "${green} ..............${reset}"
echo "${green} .... ${yellow}DONE${green} ....${reset}"
echo "${green} ..............${reset}"
echo "${green} ..............${reset}"