#!/bin/bash

for address in $(echo 135.1.{0..20}.{0..255})
do
	echo "$address $address 6969 7070 6" | sudo ./block_flow --dev veth
	echo "$address $address 6969 7070 6" | sudo ./unblock_flow --dev veth
done
