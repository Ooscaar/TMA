# Performance analysis

This directory contains the tools used to analyze the performance of our solution.

## Dependencies
```
sudo apt install iperf3
```

## How to replicate the results
### Set up the virtual interface
```
sudo ./testenv/testenv.sh --legacy-ip setup --name veth
sudo iptables -A FORWARD -i wlp4s0 -o veth -j ACCEPT
sudo iptables -A FORWARD -o wlp4s0 -i veth -j ACCEPT
sudo iptables -t nat -A POSTROUTING -s 10.11.1.2/24 -o wlp4s0 -j MASQUERADE
echo 1 > sudo /proc/sys/net/ipv4/ip_forward
sysctl -a
sudo mkdir -p /etc/netns/veth
sudo ln -s /run/systemd/resolve/resolv.conf /etc/netns/veth/resolv.conf
```

* Go to the virtual interface:
```
sudo ip netns exec veth /bin/bash
ip route add default via 10.11.1.1
```

### Test the iptables
* From the main machine:
```
sudo ./iptables_500_rules.sh # or iptables_10000_rules.sh
iperf3 -s
```

* From the virtual interface:
```
iperf3 -c 10.11.1.1
```

### Test the XDP programs
* From the main machine:
```
sudo ./xdp_loader --force --dev veth
sudo ./XDP_5000_rules.sh # or XDP_10000_rules.sh
iperf3 -s
```

* From the virtual interface:
```
iperf3 -c 10.11.1.1
```

### Other useful tools:
* Check if the interface veth has an XDP program loaded:
```
sudo ip link show veth
```

* Remove the loaded XDP program from veth:
```
sudo ./xdp_loader --dev veth --unload
```

* The easiest way to empty the maps is by loading the XDP eBPF program again:
```
sudo ./xdp_loader --force --dev veth
```

* Check the list of XDP non-blocked flows:
```
sudo ./xdp_list_blocked --dev veth
```

* Clear iptables:
```
sudo iptables -F
```

### Results recap
Please be aware that the bitrate depends on your machine's specs, so the results may vary. However, the results should show a similar result as ours, where iptables does not scale as well as XDP.

The results have been obtained using iperf3.

* NOTHING in it: <br />
	[ ID] Interval           Transfer     Bitrate         Retr <br />
	[  5]   0.00-10.00  sec  32.4 GBytes  **27.8 Gbits/sec**    0             sender <br />
	[  5]   0.00-10.04  sec  32.4 GBytes  **27.7 Gbits/sec**                  receiver <br />


* IPTABLES ACCEPT, 5000: <br />
	[ ID] Interval           Transfer     Bitrate         Retr <br />
	[  5]   0.00-10.00  sec  7.26 GBytes  **6.24 Gbits/sec**  508             sender <br />
	[  5]   0.00-10.04  sec  7.26 GBytes  **6.21 Gbits/sec**                  receiver <br />

* IPTABLES ACCEPT, 10000: <br />
	[ ID] Interval           Transfer     Bitrate         Retr <br />
	[  5]   0.00-10.00  sec  4.39 GBytes  **3.77 Gbits/sec**    0             sender <br />
	[  5]   0.00-10.04  sec  4.39 GBytes  **3.75 Gbits/sec**                  receiver <br />


* XDP ACCEPT, 0 flows blocked + monitoring: <br />
	[ ID] Interval           Transfer     Bitrate         Retr <br />
	[  5]   0.00-10.00  sec  5.40 GBytes  **4.64 Gbits/sec**    0             sender <br />
	[  5]   0.00-10.04  sec  5.40 GBytes  **4.62 Gbits/sec**                  receiver <br />

* XDP ACCEPT, 5000 flows non-blocked + monitoring: <br />
	[ ID] Interval           Transfer     Bitrate         Retr <br />
	[  5]   0.00-10.00  sec  5.41 GBytes  **4.64 Gbits/sec**    0             sender <br />
	[  5]   0.00-10.04  sec  5.41 GBytes  **4.62 Gbits/sec**                  receiver <br />

* XDP ACCEPT, 10000 flows non-blocked + monitoring: <br />
	[ ID] Interval           Transfer     Bitrate         Retr <br />
	[  5]   0.00-10.00  sec  5.25 GBytes  **4.51 Gbits/sec**  635             sender <br />
	[  5]   0.00-10.04  sec  5.25 GBytes  **4.49 Gbits/sec**                  receiver <br />



