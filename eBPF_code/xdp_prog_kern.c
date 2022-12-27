/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <linux/in.h>

#include <linux/if_ether.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

#include "./common/parsing_helpers.h"
#include "./common/rewrite_helpers.h"

#include "./common/xdp_stats_kern_user.h"
#include "./common/xdp_stats_kern.h"

#include "common_kern_user_datastructure.h"

// Maps ref: https://docs.kernel.org/bpf/map_hash.html

struct bpf_map_def SEC("maps") xdp_flow_map = {
	.type        = BPF_MAP_TYPE_HASH,
	.key_size    = sizeof(struct flow),
	.value_size  = sizeof(__u32),
	.max_entries = MAX_FLOWS_ENTRIES,
};

struct bpf_map_def SEC("maps") xdp_blocked_flows = {
	.type        = BPF_MAP_TYPE_HASH,
	.key_size    = sizeof(struct flow),
	.value_size  = sizeof(__u32),
	.max_entries = MAX_FLOWS_ENTRIES,
};


SEC("xdp_program")
int  xdp_pass_func(struct xdp_md *ctx) {
	__u32 action = XDP_PASS;
	int eth_type, ip_type;
	struct ethhdr *eth;
	struct iphdr *iphdr;
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
	} else {
		goto out;
	}

	__be16 sport, dport;
	sport = dport = 0;

	if (ip_type == IPPROTO_UDP) {
		if (parse_udphdr(&nh, data_end, &udphdr) < 0) {
			action = XDP_ABORTED;
			goto out;
		}
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
	
	__u32 *blocked = bpf_map_lookup_elem(&xdp_blocked_flows, &curr_flow);
	if (blocked && *blocked == 1) {
		bpf_printk("This flow is in the black list, so the program will abort\n");
		return XDP_DROP;
	}
	
	int times = 1;
	__u32 *n_times = bpf_map_lookup_elem(&xdp_flow_map, &curr_flow);
	
	if (!n_times) {
		bpf_printk("Writing in the new element of the eBPF map\n");
		bpf_map_update_elem(&xdp_flow_map, &curr_flow, &times, BPF_ANY);
	} else {
		*n_times = *n_times+1;
	}

	
	
out:
	return action;
}

char _license[] SEC("license") = "GPL";
