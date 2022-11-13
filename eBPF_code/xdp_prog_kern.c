/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <linux/in.h>

#include <linux/if_ether.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

// The parsing helper functions from the packet01 lesson have moved here
#include "./common/parsing_helpers.h"
#include "./common/rewrite_helpers.h"

/* Defines xdp_stats_map */
#include "./common/xdp_stats_kern_user.h"
#include "./common/xdp_stats_kern.h"

/*	DEBUG eBPF:
		bpf_printk("%d", nh_type);
	From another terminal, cat /sys/kernel/debug/tracing/trace_pipe
*/
struct sniff_quic_long_header {
	uint8_t header;    /* first header */
	uint32_t version;  /* version */
	uint8_t d_length; /* lengt destionation id*/
	/* rest of the payload */
};

#define MAX_CONN_ID_SIZE 20 // 160 bits = 20 Bytes

struct connection_ID {
	uint8_t val[MAX_CONN_ID_SIZE] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
};


void process_quic_long_header(const void *payload, uint32_t in_version, const void *data_end) {
/*	struct quic_long_header quic = {
		uint8_t header = payload[0];
		uint32_t version = in_version;
		uint8_t len_d_connection_id = payload[1];
	} */
	struct quic_long_header *quic = payload;
	
	uint8_t *raw_ID = (void*)(payload + sizeof(struct quic_long_header));
	
	struct connection_ID dest_ID, src_ID;
	
	int i;
	for (i = 0; i < quic.d_length; i++) {
		dest_ID[MAX_CONN_ID_SIZE-quic.d_length+i] = raw_ID[i];
	}
	
	raw_ID = raw_ID+quic.d_length;
	uint8_t s_length = raw_ID[0];
	raw_ID += 1;
	for (i = 0; i < s_length; i++) {
		src_ID[MAX_CONN_ID_SIZE-s_length+i] = raw_ID[i];
	}
	raw_ID = raw_ID+s_length;
	
	
	
	bpf_printk("   -> LENGTH %d\n", len_d_connection_id);
}

void process_udp(const struct udphdr *udphdr, const struct iphdr *iphdr, int size_ip, const void *payload, const void *data_end) {
	bpf_printk("   Src port: %d\n", ntohs(udp->uh_sport));
	bpf_printk("   Dst port: %d\n", ntohs(udp->uh_dport));

	/******************************************************************/
	// Check if is QUIC packet
	unsigned long size_payload = (unsigned long)data_end - (unsigned long)payload;
	bpf_printk("The size of the payload is %lu\n", size_payload);

	// Minimum QUIC paquet length
	// - Flag (1B)
	// - Connection ID's (8B)
	// - Version (4B)
	if (size_payload < 13) {
		return;
	}

	// Parse 1 bytes
	uint8_t header = (uint8_t)payload[0];
	const uint8_t XOR_HEADER = 0x80;
	int longForm = 0;

	if ((header & XOR_HEADER) == 0) {
		bpf_printk("   Possible SHORT HEADER");
		return;
	}

	uint32_t version;
	version = ((((uint32_t)payload[1]) << 24) +
	       (((uint32_t)payload[2]) << 16) +
	       (((uint32_t)payload[3]) << 8) +
	       (((uint32_t)payload[4]) << 0));
	bpf_printk("   VERSION: %8x \n", version);

	if (version == spindump_quic_version_rfc) {
		bpf_printk("  *********************\n");
		bpf_printk("   DETECTED QUIC PACKET\n");
		bpf_printk("   VERSION: IETF %8x\n", version);
		process_quic_long_header(payload, version, data_end);
		bpf_printk("  *********************\n");

		return;
	}
	if (version == spindump_quic_version_draft29) {
		bpf_printk("  *********************\n");
		bpf_printk("   DETECTED QUIC PACKET\n");
		bpf_printk("   VERSION: DRAFT 29 %8x\n", version);
		process_quic_long_header(payload, version, data_end);
		bpf_printk("  *********************\n");
		return;
	}
	bpf_printk("   QUIC OR NOT, VERSION NOT FOUND\n");
}

SEC("xdp_program")
int  xdp_pass_func(struct xdp_md *ctx) {
	__u32 action = XDP_PASS; /* XDP_PASS = 2 */
		int eth_type, ip_type;
	struct ethhdr *eth;
	struct iphdr *iphdr;
	struct ipv6hdr *ipv6hdr;
	struct udphdr *udphdr;
	struct tcphdr *tcphdr;
	void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;
	struct hdr_cursor nh = { .pos = data };

	eth_type = parse_ethhdr(&nh, data_end, &eth);
	if (eth_type < 0) {
		action = XDP_ABORTED;
		goto out;
	}

	if (eth_type == bpf_htons(ETH_P_IP)) {
		ip_type = parse_iphdr(&nh, data_end, &iphdr);
	} else if (eth_type == bpf_htons(ETH_P_IPV6)) {
		ip_type = parse_ip6hdr(&nh, data_end, &ipv6hdr);
	} else {
		goto out;
	}

	if (ip_type == IPPROTO_UDP) {
		if (parse_udphdr(&nh, data_end, &udphdr) < 0) {
			action = XDP_ABORTED;
			goto out;
		}
		// udphdr->dest = bpf_htons(bpf_ntohs(udphdr->dest) - 1);
	        process_udp(udp, ip, size_ip, nh.pos, data_end);
	} else if (ip_type == IPPROTO_TCP) {
		if (parse_tcphdr(&nh, data_end, &tcphdr) < 0) {
			action = XDP_ABORTED;
			goto out;
		}
		// tcphdr->dest = bpf_htons(bpf_ntohs(tcphdr->dest) - 1);
		// TODO: complete in the future
	}

	

out:
	return xdp_stats_record_action(ctx, action);
}

char _license[] SEC("license") = "GPL";

/* Copied from: $KERNEL/include/uapi/linux/bpf.h
 *
 * User return codes for XDP prog type.
 * A valid XDP program must return one of these defined values. All other
 * return codes are reserved for future use. Unknown return codes will
 * result in packet drops and a warning via bpf_warn_invalid_xdp_action().
 *
enum xdp_action {
	XDP_ABORTED = 0,
	XDP_DROP,
	XDP_PASS,
	XDP_TX,
	XDP_REDIRECT,
};

 * user accessible metadata for XDP packet hook
 * new fields must be added to the end of this structure
 *
struct xdp_md {
	// (Note: type __u32 is NOT the real-type)
	__u32 data;
	__u32 data_end;
	__u32 data_meta;
	// Below access go through struct xdp_rxq_info
	__u32 ingress_ifindex; // rxq->dev->ifindex
	__u32 rx_queue_index;  // rxq->queue_index
};
*/
