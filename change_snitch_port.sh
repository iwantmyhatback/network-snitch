#!/bin/bash

# Check new port number is passed
if [ $# -eq 0 ]
then
echo " A new port number is required between 1024 and 65535"
exit 1
fi

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${red}!!!    WARNING THIS SCRIPT ONLY RUNS SUCCESSFULLY      !!!${reset}"
echo "${red}!!!    ONE TIME IF YOU NEED TO CHANGE THE PORT A       !!!${reset}"
echo "${red}!!!    SECOND TIME THEN YOU NEED TO RECLONE THE REPO   !!!${reset}"

sed -i '' "s/21285/$1/g" ./jump/firewall/rules.v4
sed -i '' "s/21285/$1/g" ./target/target_config.sh

echo "${green} PORT CHANGED${reset}"

echo "${green} ..............${reset}"
echo "${green} ..............${reset}"
echo "${green} .... DONE ....${reset}"
echo "${green} ..............${reset}"
echo "${green} ..............${reset}"