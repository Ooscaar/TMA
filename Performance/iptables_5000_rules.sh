#!/bin/bash

for address in $(echo 135.1.{0..20}.{0..255})
do
	iptables -A INPUT -p tcp -s $address -j ACCEPT
done
