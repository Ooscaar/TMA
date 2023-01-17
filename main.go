package main

import (
	"encoding/binary"
	"encoding/hex"
	"fmt"
	"log"
	"net"
	"net/http"
	"time"

	"github.com/cilium/ebpf"
	"github.com/gorilla/mux"
)

// Define global const variables for the paths of the ebpf maps
const (
	xdpFlowsPath = "/sys/fs/bpf/veth/xdp_flow_map"

	xdpBlockedFlowsPath = "/sys/fs/bpf/veth/xdp_blocked_flows"
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
type Flow struct {
	saddr    net.IP
	daddr    net.IP
	sport    uint16
	dport    uint16
	protocol uint8
}

type FlowInfo struct {
	Packets uint32
	Bytes   uint64
	Speed   uint64 // Bytes per second
}

// Memory map for the flows
// Create a golang map of
// key: bytes id
// value: FlowInfo
var flowsDatabase = make(map[string]FlowInfo)

// TEMPORAL: returned as csv string
func (f Flow) String() string {
	return fmt.Sprintf("%s,%d,%s,%d,%d", f.saddr, f.sport, f.daddr, f.dport, f.protocol)
}

// Implement encoding.BinaryMarshaler
// See: https://pkg.go.dev/github.com/cilium/ebpf#Map.
//
// Implement encoding.BinaryMarshaler or encoding.BinaryUnmarshaler if you require custom encoding.
func (f Flow) MarshalBinary() ([]byte, error) {
	// We have to marsharl to a 16 byte array.
	// The struct has 13 bytes, but (we think) due alignment the key
	// is 16 bytes.
	var data [16]byte

	copy(data[:4], f.saddr.To4())
	copy(data[4:8], f.daddr.To4())

	binary.BigEndian.PutUint16(data[8:10], f.sport)
	binary.BigEndian.PutUint16(data[10:12], f.dport)

	data[12] = f.protocol

	return data[:], nil
}

// Flow constructor from bytes
func NewFlowFromBytes(data []byte) (Flow, error) {
	if len(data) != 16 {
		return Flow{}, fmt.Errorf("data must be 16 bytes")
	}

	return Flow{
		saddr:    net.IP(data[:4]),
		daddr:    net.IP(data[4:8]),
		sport:    binary.BigEndian.Uint16(data[8:10]),
		dport:    binary.BigEndian.Uint16(data[10:12]),
		protocol: data[12],
	}, nil
}

func isFlowBlocked(key []byte) (int, error) {
	// Key must be 16 bytes
	if len(key) != 16 {
		log.Printf("Key must be 16 bytes")
		return 0, fmt.Errorf("key must be 16 bytes")
	}

	flowsBlockedMap, err := ebpf.LoadPinnedMap(xdpBlockedFlowsPath, nil)

	if err != nil {
		return 0, err
	}

	// Check already blocked
	var value uint32
	_ = flowsBlockedMap.Lookup(&key, &value)

	if value == 1 {
		log.Printf("Flow already blocked")
		return 1, nil
	}

	return 0, nil
}

func blockFlow(key []byte) error {
	// Key must be 16 bytes
	if len(key) != 16 {
		log.Printf("Key must be 16 bytes")
		return fmt.Errorf("key must be 16 bytes")
	}
	flowsMap, err := ebpf.LoadPinnedMap(xdpFlowsPath, nil)

	if err != nil {
		log.Printf("Error loading pinned map: %s", err)
		return err
	}

	flowKey, _ := NewFlowFromBytes(key)

	// Value variable needed for the lookup
	var valueNotUsed uint32
	if err := flowsMap.Lookup(&flowKey, &valueNotUsed); err != nil {
		log.Printf("Error looking up flow: %s", err)
		return err
	}

	log.Printf("Flow found, blocking")

	// Check if flow exists
	flowsBlockedMap, err := ebpf.LoadPinnedMap(xdpBlockedFlowsPath, nil)

	if err != nil {
		return err
	}

	// Check already blocked
	var value uint32
	_ = flowsBlockedMap.Lookup(&key, &value)

	if value == 1 {
		log.Printf("Flow already blocked")
		return nil
	}

	// Update or create new value
	var newValue uint32 = 1
	err = flowsBlockedMap.Put(key, newValue)

	if err != nil {
		log.Printf("Error updating blocked flows map: %s", err)
		return err
	}

	return nil
}

func unblockFlow(key []byte) error {
	// Key must be 16 bytes
	if len(key) != 16 {
		log.Printf("Key must be 16 bytes")
		return fmt.Errorf("key must be 16 bytes")
	}
	flowsMap, err := ebpf.LoadPinnedMap(xdpFlowsPath, nil)

	if err != nil {
		log.Printf("Error loading pinned map: %s", err)
		return err
	}

	flowKey, _ := NewFlowFromBytes(key)

	// Value variable needed for the lookup
	var valueNotUsed uint32
	if err := flowsMap.Lookup(&flowKey, &valueNotUsed); err != nil {
		log.Printf("Error looking up flow: %s", err)
		return err
	}

	log.Printf("Flow found, unblocking")

	// Check if flow exists
	flowsBlockedMap, err := ebpf.LoadPinnedMap(xdpBlockedFlowsPath, nil)

	if err != nil {
		return err
	}

	// Check already blocked
	var value uint32
	err = flowsBlockedMap.Lookup(&key, &value)

	if err != nil {
		log.Printf("Flow not blocked")
		return nil
	}

	// Block the flow even if it is already blocked
	var newValue uint32 = 0
	err = flowsBlockedMap.Put(key, newValue)

	if err != nil {
		log.Printf("Error updating blocked flows map: %s", err)
		return err
	}

	return nil
}

func flowsGet(w http.ResponseWriter, req *http.Request) {
	w.WriteHeader(http.StatusOK)

	// Print all values formatted
	counter := 0
	for key, flow := range flowsDatabase {

		// Get if is blocked
		// Bytes from string to byte[]
		id, err := hex.DecodeString(key)

		if err != nil {
			panic(err)
		}

		isBlocked, err := isFlowBlocked(id)

		if err != nil {
			panic(err)
		}

		// Print key as hex
		fmt.Fprintf(w, "%x,%s,%d,%d,%d\n", id, key, isBlocked, flow.Bytes, flow.Packets)
		counter++
	}
}

func blockPost(w http.ResponseWriter, req *http.Request) {
	vars := mux.Vars(req)

	// Convert string to byte[]
	flowId, err := hex.DecodeString(vars["flowId"])

	if err != nil {
		log.Printf("failed to decode flowId: %v", err)
		http.Error(w, "Failed to decode flowId", http.StatusInternalServerError)
		return
	}

	// Block flow
	err = blockFlow(flowId)

	if err != nil {
		http.Error(w, "Failed to block flow", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func unblockPost(w http.ResponseWriter, req *http.Request) {
	vars := mux.Vars(req)

	// Convert string to byte[]
	flowId, err := hex.DecodeString(vars["flowId"])

	if err != nil {
		log.Printf("failed to decode flowId: %v", err)
		http.Error(w, "Failed to decode flowId", http.StatusInternalServerError)
		return
	}

	// Block flow
	err = unblockFlow(flowId)

	if err != nil {
		http.Error(w, "Failed to unblock flow", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func updateFlows() {
	// Infinite loop
	log.Printf("Starting update flows routine")

	for {
		// Wait one second
		time.Sleep(1 * time.Second)

		// Read map
		flowMap, err := ebpf.LoadPinnedMap(xdpFlowsPath, nil)

		if err != nil {
			panic(err)
		}

		var key [16]byte
		var value FlowInfo

		// Iterate values
		newFlowsDatabase := make(map[string]FlowInfo)

		iterator := flowMap.Iterate()
		log.Println("Iterating flows")
		for iterator.Next(&key, &value) {
			// Check if we have the flow in the database
			// If we do, update the value
			// If we don't, add it
			// Convert []byte to string
			stringKey := string(key[:])
			elem, found := flowsDatabase[stringKey]

			if found {
				// Update value and compute speed
				newFlowsDatabase[stringKey] = FlowInfo{
					Bytes:   elem.Bytes + value.Bytes,
					Packets: elem.Packets + value.Packets,
					Speed:   0,
				}

				// TOOO: compute speed

			} else {
				// Add value
				newFlowsDatabase[stringKey] = FlowInfo{
					Bytes:   value.Bytes,
					Packets: value.Packets,
					Speed:   0,
				}
			}
		}
	}
}

func main() {

	// Go routine which updates the flows every second
	go updateFlows()

	r := mux.NewRouter()

	// Flows
	r.HandleFunc("/flows", flowsGet).Methods(http.MethodGet)

	// Block
	r.HandleFunc("/flows/{flowId}/block", blockPost).Methods(http.MethodPost)

	// Unblock
	r.HandleFunc("/flows/{flowId}/unblock", unblockPost).Methods(http.MethodPost)

	server := &http.Server{
		Handler: r,
		Addr:    "127.0.0.1:8000",
	}

	log.Printf("Listening on %s", "8000")
	log.Fatal(server.ListenAndServe())
}
