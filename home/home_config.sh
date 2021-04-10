#!/bin/bash

cd $(dirname $0)

# Check that user has root access
if (( $EUID != 0 ))
then
  echo "You must run home_config.sh as root"
  exit 1
fi

chmod 600 ./client-key/id_rsa
chmod 644 ./client-key/id_rsa.pub
chmod 644 ./known/known_host

mkdir ~/.ssh/original-holder
mkdir ~/.ssh/snitch
cp ./client-key/id_rsa ~/.ssh/snitch/id_rsa
cp ./client-key/id_rsa.pub ~/.ssh/snitch/id_rsa.pub
cp ./known/known_host ~/.ssh/snitch/known_host

chmod +x creds_swap.sh
./creds_swap.sh