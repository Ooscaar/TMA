#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: ./XDP_N_rules.sh N"
	echo "Eg: ./XDP_N_rules.sh 5000"
	exit -1
fi

N=$1
i=0

for address in $(echo 13{0..9}.1.{0..20}.{0..255})
do
	if [ $i == $N ]; then	break;	fi
	echo "$address $address 6969 7070 6" | sudo ./block_flow --dev veth
	echo "$address $address 6969 7070 6" | sudo ./unblock_flow --dev veth
	((i++))
done
