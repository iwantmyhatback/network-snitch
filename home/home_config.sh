#!/bin/bash

cd $(dirname $0)

chmod 600 ./client-key/id_rsa
chmod 644 ./client-key/id_rsa.pub
chmod 644 ./known/known_hosts

mkdir ~/.ssh/original-holder
mkdir ~/.ssh/snitch
cp ./client-key/id_rsa ~/.ssh/snitch/id_rsa
cp ./client-key/id_rsa.pub ~/.ssh/snitch/id_rsa.pub
cp ./known/known_hosts ~/.ssh/snitch/known_hosts

chmod +x creds_swap.sh
./creds_swap.sh