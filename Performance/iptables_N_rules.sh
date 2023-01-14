#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: ./iptables_N_rules.sh N"
	echo "Eg: ./iptables_N_rules.sh 5000"
	exit -1
fi

N=$1
i=0

for address in $(echo 13{0..9}.1.{0..20}.{0..255})
do
	if [ $i == $N ]; then	break;	fi
	iptables -A INPUT -p tcp -s $address -j ACCEPT
	((i++))
done
