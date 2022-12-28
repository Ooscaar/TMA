package main

import (
	"encoding/binary"
	"fmt"
	"net"

	"github.com/cilium/ebpf"
)

// from eBPF_code/common_kern_user_datastructure.h
// struct flow { // Stored in BIG ENDIAN!
//
//	        __be32  saddr;
//	        __be32  daddr;
//	        __be16  sport;
//	        __be16  dport;
//	        __u8    protocol;
//	};
type flow struct {
	saddr    net.IP
	daddr    net.IP
	sport    uint16
	dport    uint16
	protocol uint8
}

func (f flow) String() string {
	return fmt.Sprintf("%s:%d -> %s:%d %d", f.saddr, f.sport, f.daddr, f.dport, f.protocol)
}

// Implement encoding.BinaryMarshaler
// See: https://pkg.go.dev/github.com/cilium/ebpf#Map.
//
// Implement encoding.BinaryMarshaler or encoding.BinaryUnmarshaler if you require custom encoding.
func (f flow) MarshalBinary() ([]byte, error) {
	var data [16]byte

	copy(data[:4], f.saddr.To4())
	copy(data[4:8], f.daddr.To4())

	binary.BigEndian.PutUint16(data[8:10], f.sport)
	binary.BigEndian.PutUint16(data[10:12], f.dport)

	data[12] = f.protocol

	return data[:], nil
}

func main() {

	// Path to the pinned map
	// xdpBlockedFlows := "/sys/fs/bpf/veth/xdp_blocked_flows"
	xdpFlows := "/sys/fs/bpf/veth/xdp_flow_map"
	// xdpStats := "/sys/fs/bpf/veth/xdp_stats_map"

	flowMap, err := ebpf.LoadPinnedMap(xdpFlows, nil)

	if err != nil {
		panic(err)
	}

	// Get map info
	mapinfo, err := flowMap.Info()

	if err != nil {
		panic(err)
	}

	// Print all values formatted
	fmt.Printf("%+v\n", mapinfo)

	var key [16]byte
	var value uint32

	// Iterate values
	counter := 0
	iterator := flowMap.Iterate()

	for iterator.Next(&key, &value) {
		// Print key as hex
		fmt.Printf("%x times = %d\n", key, value)

		flow := flow{
			saddr:    net.IP(key[:4]),
			daddr:    net.IP(key[4:8]),
			sport:    binary.BigEndian.Uint16(key[8:10]),
			dport:    binary.BigEndian.Uint16(key[10:12]),
			protocol: key[12],
		}

		fmt.Printf("%+v times = %d\n", flow, value)

		counter++
	}

	// Update value
	flowToUpdate := flow{
		saddr:    net.IPv4(10, 11, 1, 2),
		daddr:    net.IPv4(10, 11, 1, 1),
		sport:    8282,
		dport:    3213,
		protocol: 6,
	}

	err = flowMap.Lookup(&flowToUpdate, &value)

	if err != nil {
		panic(err)
	}

	fmt.Printf("Before update: %+v times = %d\n", flowToUpdate, value)

	value = 100
	err = flowMap.Update(&flowToUpdate, &value, 0)

	if err != nil {
		panic(err)
	}

	err = flowMap.Lookup(&flowToUpdate, &value)

	if err != nil {
		panic(err)
	}

	fmt.Printf("After update: %+v times = %d\n", flowToUpdate, value)

}
