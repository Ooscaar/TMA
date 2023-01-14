#!/bin/bash

if [ $# -ne 2 ]
then
	echo "Usage: ./script_results.sh IP_ADDRESS FILENAME"
	echo "Eg: ./script_results.sh 10.11.1.1 results_100_iptables.txt"
	exit -1
fi

if [ -f "$2" ]
then
	echo "File $2 already exists, please select another name for the file"
	exit -1
fi

i=0
N=10
ACCUMULATED=0.0

while [ $i -lt $N ]
do
	RESULT=$(bc <<< "scale = 4; $(iperf3 -c $1 -J | jq -r '.end' | jq -r '.sum_received' | jq -r '.bits_per_second') / 1000000000")
	ACCUMULATED=$(bc <<< "scale=4; $ACCUMULATED + $RESULT")
	echo "$RESULT" >> $2
	((i++))
done

MEAN=$(bc <<< "scale = 4; $ACCUMULATED/10")
echo "$2 - $MEAN" >> "mean.txt"
