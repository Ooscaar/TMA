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

#include "common_kern_user_datastructure.h"

struct bpf_map_def SEC("maps") xdp_flow_map = {
	.type        = BPF_MAP_TYPE_HASH,
	.key_size    = sizeof(struct flow),
	.value_size  = sizeof(__u32),
	.max_entries = MAX_FLOWS_ENTRIES,
};
// Maps ref: https://docs.kernel.org/bpf/map_hash.html

/*	DEBUG eBPF:
		bpf_printk("%d", nh_type);
	From another terminal, cat /sys/kernel/debug/tracing/trace_pipe
*/

SEC("xdp_program")
int  xdp_pass_func(struct xdp_md *ctx) {
	__u32 action = XDP_PASS; /* XDP_PASS = 2 */
	int eth_type, ip_type;
	struct ethhdr *eth;
	struct iphdr *iphdr;
	// struct ipv6hdr *ipv6hdr;
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
	} /*else if (eth_type == bpf_htons(ETH_P_IPV6)) {
		ip_type = parse_ip6hdr(&nh, data_end, &ipv6hdr);
	} */ else {
		goto out;
	}

	__be16 sport, dport;
	sport = dport = 0;

	if (ip_type == IPPROTO_UDP) {
		if (parse_udphdr(&nh, data_end, &udphdr) < 0) {
			action = XDP_ABORTED;
			goto out;
		}
		// Port to little endian: bpf_ntohs(udphdr->dest)
	        sport = udphdr->source;
	        dport = udphdr->dest;
	} else if (ip_type == IPPROTO_TCP) {
		if (parse_tcphdr(&nh, data_end, &tcphdr) < 0) {
			action = XDP_ABORTED;
			goto out;
		}
	        sport = tcphdr->source;
	        dport = tcphdr->dest;		
	} else {
		goto out;
	}
	
	struct flow curr_flow;
	__builtin_memset(&curr_flow, 0, sizeof(curr_flow)); // PAD, otherwise the verifier may not be happy!!
	curr_flow.saddr = iphdr->saddr;
	curr_flow.daddr = iphdr->daddr;
	curr_flow.sport = sport;
	curr_flow.dport = dport;
	curr_flow.protocol = iphdr->protocol;
	
	bpf_printk("Looking up eBPF element\n");
	int times = 1;
	__u32 *n_times = bpf_map_lookup_elem(&xdp_flow_map, &curr_flow);
	
	if (!n_times) {
		bpf_printk("writing in the new element of the eBPF map\n");
		bpf_map_update_elem(&xdp_flow_map, &curr_flow, &times, BPF_ANY);
	} else {
		*n_times = *n_times+1;
	}

	
	
out:
	return action;
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
