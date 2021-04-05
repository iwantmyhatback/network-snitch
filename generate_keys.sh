#!/bin/bash

if [ $# -eq 0 ]
then
echo "Script requires that you pass a password string for all key files"
exit 1
fi

cd $(dirname $0)

# Create machine directories
echo "Making Machine Directories"
mkdir ./jump
mkdir ./home
mkdir ./target
# Directories for *CLIENT* keys
echo "Making client-key Directories"
mkdir ./home/client-key
mkdir ./target/client-key
# Generate keys for *CLIENT* machines that need access to JUMP
echo "Generating client keys"
ssh-keygen -t rsa -b 4096 -f ./home/client-key/id_rsa -N $1 -C "HOME-ID-KEY"
ssh-keygen -t rsa -b 4096 -f ./target/client-key/id_rsa -N $1 -C "TARGET-ID-KEY"
# Directories for *SERVER* machine authorized_keys files
echo "Making server-auth Directories"
mkdir ./jump/server-auth
mkdir ./jump/server-auth/dummy
mkdir ./target/server-auth
# Authorize HOME to access JUMP and TARGET
echo "Populating authorized_keys files"
cat ./home/client-key/id_rsa.pub > ./target/server-auth/authorized_keys
cat ./home/client-key/id_rsa.pub > ./jump/server-auth/authorized_keys
# Authorized TARGET to access JUMP
cat ./target/client-key/id_rsa.pub > ./jump/server-auth/dummy/authorized_keys
# Directories for *SERVER* machine keys
echo "Making server-key Directories"
mkdir ./jump/server-key
mkdir ./target/server-key
# Generate keys for *SERVER* machines
echo "Generating server keys"
ssh-keygen -t ecdsa -b 256 -f ./jump/server-key/ssh_host_ecdsa_key -N $1 -C "JUMP-HOST-KEY"
ssh-keygen -t ecdsa -b 256 -f ./target/server-key/ssh_host_ecdsa_key -N $1 -C "TARGET-HOST-KEY"
# Directories for known hosts
echo "Making known_host Directories"
mkdir ./home/known
mkdir ./target/known
# Set JUMP and TARGET as known hosts for HOME
echo "Populating known_host files"
echo -n "* " > ./home/known/known_hosts
cat ./jump/server-key/ssh_host_ecdsa_key.pub >> ./home/known/known_hosts
echo -n "* " >> ./home/known/known_hosts
cat ./target/server-key/ssh_host_ecdsa_key.pub >> ./home/known/known_hosts
# Set JUMP as known host for TARGET
echo -n "* " > ./target/known/known_hosts
cat ./jump/server-key/ssh_host_ecdsa_key.pub >> ./target/known/known_hosts

echo ".............."
echo ".............."
echo ".... Done ...."
echo ".............."
echo ".............."