package main

import (
	"encoding/binary"
	"encoding/hex"
	"fmt"
	"log"
	"net"
	"net/http"

	"github.com/cilium/ebpf"
	"github.com/gorilla/mux"
)

// Define global const variables for the paths of the ebpf maps
const (
	xdpFlows = "/sys/fs/bpf/veth/xdp_flow_map"

	xdpBlockedFlows = "/sys/fs/bpf/veth/xdp_blocked_flows"
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

func getFlows() ([]Flow, error) {
	flowMap, err := ebpf.LoadPinnedMap(xdpFlows, nil)

	if err != nil {
		return nil, err
	}

	var key [16]byte
	var value uint32

	// Iterate values
	flows := []Flow{}
	iterator := flowMap.Iterate()

	for iterator.Next(&key, &value) {
		flow, _ := NewFlowFromBytes(key[:])

		// Add to string with newline
		flows = append(flows, flow)
	}

	log.Printf("Found %d flows", len(flows))
	return flows, nil
}

func blockFlow(key []byte) error {
	// Key must be 16 bytes
	if len(key) != 16 {
		log.Printf("Key must be 16 bytes")
		return fmt.Errorf("key must be 16 bytes")
	}
	flowsMap, err := ebpf.LoadPinnedMap(xdpFlows, nil)

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
	flowsBlockedMap, err := ebpf.LoadPinnedMap(xdpBlockedFlows, nil)

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
	flowsMap, err := ebpf.LoadPinnedMap(xdpFlows, nil)

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
	flowsBlockedMap, err := ebpf.LoadPinnedMap(xdpBlockedFlows, nil)

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
	flows, err := getFlows()

	if err != nil {
		log.Printf("failed read flows: %v", err)
		http.Error(w, "Failed to read flows", http.StatusInternalServerError)
		return
	}

	// Test
	w.WriteHeader(http.StatusOK)

	// Print all values formatted
	counter := 0
	for _, flow := range flows {

		// Use the marshaler of the Flow struct as an id
		id, err := flow.MarshalBinary()

		if err != nil {
			panic(err)
		}

		// Print key as hex
		fmt.Fprintf(w, "%x,%s\n", id, flow)
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

func main() {

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
