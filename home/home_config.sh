#!/bin/bash

cd $(dirname $0)



if [ $# != 2 ]
then
echo " Script requires: ./home_config.sh target-username jump-ip-address"
exit 1
fi

cat ./known/known_hosts >> ~/.ssh/known_hosts

ssh -i ./client-key/id_rsa -p 21285 $1@$2