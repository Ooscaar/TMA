# Performance analysis

This directory contains the tools used to analyze the performance of our solution.

## Dependencies
```
sudo apt install iperf3
sudo apt install jq
```

## File recap
* __iptables_N_rules.sh:__ Script that generates N iptables rules, all of them ACCEPT.

* __XDP_N_rules.sh:__ Script that populates the eBPF blocked flows map with N entries, but all of them are unblocked.

* __script_results.sh:__ Script that makes 10 samples of iperf3 to test the throughput of a specific setup.

* __Results:__ Directory with the raw results of the performance test.

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
sudo iptables -F && sudo ./iptables_N_rules.sh 5000 # where N=5000
iperf3 -s
```

* From the virtual interface:
```
iperf3 -c 10.11.1.1
```

### Test the XDP programs
* From the main machine:
```
sudo ./xdp_loader --force --dev veth && sudo ./XDP_N_rules.sh 5000 # where N=5000
iperf3 -s
```

* From the virtual interface:
By hand:
```
iperf3 -c 10.11.1.1
```

Using the automated script that obtains 10 samples and computes the mean:
```
cd Results
./script_results.sh 10.11.1.1 A_results_XDP_5000.txt
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

The results have been obtained using iperf3 in two different machines, using 10 samples for each number of blocked flows ({0, 100, 500, 1000, 5000, 7500, 10000, 12000}).
* Machine A, which is the slower one:
![Alt text](Results/Machine_A_slow.jpg?raw=true "Title")

* Machine B, which is faster:
![Alt text](Results/Machine_B_faster.jpg?raw=true "Title")
