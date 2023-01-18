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
	xdpFlowsPath = "/sys/fs/bpf/eth0/xdp_flow_map"

	xdpBlockedFlowsPath = "/sys/fs/bpf/eth0/xdp_blocked_flows"
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
}

type FlowDatabaseValue struct {
	Packets uint32
	Bytes   uint64
	Blocked int
	Speed   float64

	// Timestamps
	Timestamp time.Time
}

// MapRecord:
// key: flow
// value: FlowInfo
type MapRecord struct {
	key   Flow
	value FlowInfo
}

// Map keys as bytes arrays
var FlowsDatabase = make(map[[16]byte]FlowDatabaseValue)

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
	// Read directly the flows.
	// A LOT OF PROBLEMS WITH THE HANDLING OF THE SLICES
	// flowMap, err := ebpf.LoadPinnedMap(xdpFlowsPath, nil)

	// Test
	w.WriteHeader(http.StatusOK)

	// Iterate map database
	for key, value := range FlowsDatabase {
		// Get if is blocked
		// isBlocked, err := isFlowBlocked(key[:])

		// if err != nil {
		// 	panic(err)
		// }

		flow, err := NewFlowFromBytes(key[:])

		if err != nil {
			panic(err)
		}

		// Print key as hex
		fmt.Fprintf(w, "%x,%s,%d,%f,%d\n", key, flow, value.Blocked, value.Speed, value.Bytes)
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
	// Loop forever
	for {
		// Every 2 seconds
		time.Sleep(2 * time.Second)

		flowMap, err := ebpf.LoadPinnedMap(xdpFlowsPath, nil)

		if err != nil {
			panic(err)
		}

		var key [16]byte
		var value FlowInfo

		// Iterate values
		iterator := flowMap.Iterate()

		// Create a new map
		var newFlowsDatabase = make(map[[16]byte]FlowDatabaseValue)

		for iterator.Next(&key, &value) {

			// Add to string with newline
			flow := MapRecord{
				key: Flow{
					saddr:    net.IP(key[:4]),
					daddr:    net.IP(key[4:8]),
					sport:    binary.BigEndian.Uint16(key[8:10]),
					dport:    binary.BigEndian.Uint16(key[10:12]),
					protocol: key[12],
				},
				value: value,
			}

			// Debug flow
			// log.Printf("-> Flow %s", flow.key)

			// Use the marshaler of the Flow struct as an id
			id, err := flow.key.MarshalBinary()

			if err != nil {
				panic(err)
			}

			// Get if is blocked
			isBlocked, err := isFlowBlocked(id)

			if err != nil {
				panic(err)
			}

			// Save to "database"
			// Take 16 bytes of the id and use it as a key
			var key [16]byte
			copy(key[:], id[:16])

			// Load previous value
			previousValue, ok := FlowsDatabase[key]

			if !ok {
				// If not found, create a new one
				newFlowsDatabase[key] = FlowDatabaseValue{
					Bytes:     value.Bytes,
					Packets:   value.Packets,
					Blocked:   isBlocked,
					Speed:     0,
					Timestamp: time.Now(),
				}
			} else {
				// Compute speed
				now := time.Now()
				elapsedTime := now.Sub(previousValue.Timestamp).Seconds()
				log.Printf("Elapsed time: %f\n", elapsedTime)

				// Compute speed
				log.Printf("Computed bytes: %d\n", value.Bytes-previousValue.Bytes)
				speed := float64(value.Bytes-previousValue.Bytes) / elapsedTime

				// Save to database
				newFlowsDatabase[key] = FlowDatabaseValue{
					Bytes:     value.Bytes,
					Packets:   value.Packets,
					Blocked:   isBlocked,
					Speed:     speed,
					Timestamp: now,
				}

			}
		}

		// Update the global database
		FlowsDatabase = newFlowsDatabase
	}
}

func main() {

	// Start monitoring flows
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
		Addr:    "0.0.0.0:8000",
	}

	log.Printf("Listening on %s", "8000")
	log.Fatal(server.ListenAndServe())
}
