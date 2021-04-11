#!/bin/bash

# Output coloring
red=`tput setaf 001`
green=`tput setaf 002`
yellow=`tput setaf 003`
reset=`tput sgr0`

# Check new port number is passed
if [[ ($# -eq 0) || ($1 < "1024") || ($1 > "65535") ]]
then
echo "${red} Please provide a valid argument... ${reset}"
echo "${red} A new port number is required between 1024 and 65535${reset}"
exit 1
fi

echo "${green} Finding the current port${reset}"
currentPort=$(head -n 1 ./jump/firewall/rules.v4 | sed 's/#//')

echo "${green} Replacing current port (${yellow}$currentPort${green}) with the new port (${yellow}$1${green})${reset}"
sed -i '' "s/$currentPort/$1/g" ./jump/firewall/rules.v4
sed -i '' "s/$currentPort/$1/g" ./target/target_config.sh

echo "${green} Port changed${reset}"

echo "${green} ..............${reset}"
echo "${green} ..............${reset}"
echo "${green} .... ${yellow}DONE${green} ....${reset}"
echo "${green} ..............${reset}"
echo "${green} ..............${reset}"