#!/bin/bash

cd $(dirname $0)

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

#Setting up credential permissions
echo "${green} Setting key permissions and known hosts${reset}"
chmod 600 ./client-key/id_rsa
chmod 644 ./client-key/id_rsa.pub
chmod 644 ./known/known_hosts

echo "${green} Creating credential directories in ~/.ssh${reset}"
mkdir ~/.ssh/original-holder
mkdir ~/.ssh/snitch
echo "${green} Copying snitch credentials to ~/.ssh/snitch${reset}"
cp ./client-key/id_rsa ~/.ssh/snitch/id_rsa
cp ./client-key/id_rsa.pub ~/.ssh/snitch/id_rsa.pub
cp ./known/known_hosts ~/.ssh/snitch/known_hosts

echo "${green} Setting creds_swap.sh permissions${reset}"
chmod +x creds_swap.sh
echo "${green} Swapping credentials${reset}"
./creds_swap.sh

echo "${green} ..............${reset}"
echo "${green} ..............${reset}"
echo "${green} .... DONE ....${reset}"
echo "${green} ..............${reset}"
echo "${green} ..............${reset}"