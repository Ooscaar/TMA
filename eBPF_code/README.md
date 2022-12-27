# eBPF logic

This directory contains the code of the eBPF program.

## File recap
* __LIBBPF_DIR:__ File that stores the path of the forked eBPF project.

* __block_flow.c:__ Program that blocks a specific flow that receives as input.

* __unblock_flow.c:__ Program that unblocks a specific flow that receives as input.

* __xdp_list_blocked.c:__ Program that prints the content of the blocked flows list.

* __xdp_loader.c:__ Program that loads the eBPF program and empties the maps.

* __xdp_stats.c:__ Program that prints the content of the monitored flows list.

* __xdp_prog_kern.c:__ Program that contains the main eBPF logic.

* __common_kern_user_datastructure.h:__ Auxiliar header file that is used to define common elements for the eBPF program and the userspace programs.

* __Makefile:__ File used to compile all the project.

## Dependencies
```
	cd $HOME
	mkdir XDP_tutorial ; cd XDP_tutorial
	git clone https://github.com/xdp-project/xdp-tutorial .
	git submodule update --init
	git clone --recurse-submodules https://github.com/xdp-project/xdp-tutorial

	sudo apt install clang llvm libelf-dev libpcap-dev gcc-multilib build-essential
	sudo apt install linux-tools-$(uname -r)
	sudo apt install linux-headers-$(uname -r)
	sudo apt install linux-tools-common linux-tools-generic
	sudo apt install tcpdump
	sudo apt install ethtool
	sudo apt install socat
	sudo apt install traceroute
```

## Setup the virtual interface
```
sudo ./testenv/testenv.sh --legacy-ip setup --name veth
```

How to give Internet access to the machine:
* From the main Machine:
```
		sudo iptables -A FORWARD -i wlp4s0 -o veth -j ACCEPT
		sudo iptables -A FORWARD -o wlp4s0 -i veth -j ACCEPT
		sudo iptables -t nat -A POSTROUTING -s 10.11.1.2/24 -o wlp4s0 -j MASQUERADE
		echo 1 > sudo /proc/sys/net/ipv4/ip_forward
		sysctl -a
		mkdir -p /etc/netns/veth
		ln -s /run/systemd/resolve/resolv.conf /etc/netns/veth/resolv.conf
```

* From the virtual interface:

```
 		sudo ip netns exec veth /bin/bash
		ip route add default via 10.11.1.1
```

## Load eBPF program
Every program is compiled using the make command.

```
echo "/home/albert/Documents/TMA_Project/" > LIBBPF_DIR
sudo ./xdp_loader --dev veth --force
```

The second time you want to load it, you have to force it, as there already is one loaded.

```
sudo ./xdp_loader --force --dev veth
```

## Interact with eBPF program
```
sudo ip netns exec veth /bin/bash
ping 10.11.1.1
socat - 'udp4:[10.11.1.2]:2000' # Test UDP in IPv4, does not always work
```

## Load the stats of the eBPF program
```
sudo ./xdp_stats --dev veth
```

## Test the eBPF program

Please be aware that the eBPF may only work with applications that generate flows.

Open netcat connection in the virtual ethernet:

```
ncat -lp 6969 -e /bin/bash
```

Open the same netcat connection in the machine:
```
nc -p 7070 10.11.1.2 6969
```

Load the eBPF program, block the flow, check the status, etc:

```
sudo ./xdp_loader --force --dev veth
sudo ./xdp_stats --dev veth
sudo ./xdp_list_blocked --dev veth
echo "10.11.1.2 10.11.1.1 6969 7070 6" | sudo ./block_flow --dev veth
echo "10.11.1.2 10.11.1.1 6969 7070 6" | sudo ./unblock_flow --dev veth
```

## Block and unblock a flow

The programs reads stdin, so it can be executed in two different styles:
```
sudo ./block_flow --dev veth
	10.11.1.2 10.11.1.1 6969 7070 6

sudo ./unblock_flow --dev veth
	10.11.1.2 10.11.1.1 6969 7070 6
```

```
echo "10.11.1.2 10.11.1.1 6969 7070 6" | sudo ./block_flow --dev veth
echo "10.11.1.2 10.11.1.1 6969 7070 6" | sudo ./unblock_flow --dev veth
```

## Clear the eBPF maps
You can load again the eBPF pogram or manually remove the maps.

```
sudo rm /sys/fs/bpf/veth/xdp_flow_map
sudo rm /sys/fs/bpf/veth/xdp_stats_map
sudo rm /sys/fs/bpf/veth/xdp_blocked_flows
```

## Teardowm or reset the virtual interface
```
sudo ./testenv/testenv.sh teardown --name veth
sudo ./testenv/testenv.sh reset --name veth
```

## How to debug an eBPF program
Printf does not work on eBPF, but there is an alternative:
```
bpf_printk("%d", nh_type);
```

From another terminal, 
```
cat /sys/kernel/debug/tracing/trace_pipe
```
