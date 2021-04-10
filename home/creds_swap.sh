#!/bin/bash

cd ~/.ssh

snitchCount=$(ls ~/.ssh/snitch | wc -l)
orgCount=$(ls ~/.ssh/original-holder | wc -l)

if [ $snitchCount == "3" ]
then
   mv ./id_rsa ./original-holder/id_rsa
   mv ./id_rsa.pub ./original-holder/id_rsa.pub
   mv ./known_hosts ./original-holder/known_hosts
   mv ./snitch/id_rsa ./id_rsa
   mv ./snitch/id_rsa.pub ./id_rsa.pub
   mv ./snitch/known_hosts ./known_hosts
   echo "Snitch credentials loaded"
elif [ $orgCount == "3" ]
then
   mv ./id_rsa ./snitch/id_rsa
   mv ./id_rsa.pub ./snitch/id_rsa.pub
   mv ./known_hosts ./snitch/known_hosts
   mv ./original-holder/id_rsa ./id_rsa
   mv ./original-holder/id_rsa.pub ./id_rsa.pub
   mv ./original-holder/known_hosts ./known_hosts
   echo "Original credentials loaded"
fi