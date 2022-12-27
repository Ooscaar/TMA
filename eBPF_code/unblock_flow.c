/* SPDX-License-Identifier: GPL-2.0 */
static const char *__doc__ = "XDP stats program\n"
	" - Finding xdp_flow_map via --dev name info\n";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <getopt.h>

#include <locale.h>
#include <unistd.h>
#include <time.h>

#include <endian.h>

#include <bpf/bpf.h>

#include <net/if.h>
#include <linux/if_link.h>

#include "./common/common_params.h"
#include "./common/common_user_bpf_xdp.h"
#include "common_kern_user_datastructure.h"
#include "bpf_util.h"

#define IP_ADDR_ARRAY_SIZE 16

static const struct option_wrapper long_options[] = {
	{{"help",        no_argument,		NULL, 'h' },
	 "Show help", false},

	{{"dev",         required_argument,	NULL, 'd' },
	 "Operate on device <ifname>", "<ifname>", true},

	{{"quiet",       no_argument,		NULL, 'q' },
	 "Quiet mode (no output)"},

	{{0, 0, NULL,  0 }}
};


static void add_blocked(int map_fd, struct flow *block_it)
{
	int times;
	
	
	if (!bpf_map_lookup_elem(map_fd, block_it, &times)) {
		times = 0;
		bpf_map_update_elem(map_fd, block_it, &times, BPF_ANY);
	} else {
		printf("The flow was not blocked!\n");
	}
}


#ifndef PATH_MAX
#define PATH_MAX	4096
#endif

const char *pin_basedir =  "/sys/fs/bpf";

int main(int argc, char **argv)
{
	struct bpf_map_info map_expect = { 0 };
	struct bpf_map_info info = { 0 };
	char pin_dir[PATH_MAX];
	int stats_map_fd;
	// int interval = 2;
	int len, err;

	struct config cfg = {
		.ifindex   = -1,
		.do_unload = false,
	};

	/* Cmdline options can change progsec */
	parse_cmdline_args(argc, argv, long_options, &cfg, __doc__);

	/* Required option */
	if (cfg.ifindex == -1) {
		fprintf(stderr, "ERR: required option --dev missing\n\n");
		usage(argv[0], __doc__, long_options, (argc == 1));
		return EXIT_FAIL_OPTION;
	}

	/* Use the --dev name as subdir for finding pinned maps */
	len = snprintf(pin_dir, PATH_MAX, "%s/%s", pin_basedir, cfg.ifname);
	if (len < 0) {
		fprintf(stderr, "ERR: creating pin dirname\n");
		return EXIT_FAIL_OPTION;
	}

	stats_map_fd = open_bpf_map_file(pin_dir, "xdp_blocked_flows", &info);
	if (stats_map_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	/* check map info */
	map_expect.key_size    = sizeof(struct flow);
	map_expect.value_size  = sizeof(__u32);
	map_expect.max_entries = MAX_FLOWS_ENTRIES;
	err = check_map_fd_info(&info, &map_expect);
	if (err) {
		fprintf(stderr, "ERR: map via FD not compatible\n");
		return err;
	}
	
	printf("Please introduce the flow you want to block using the following syntax: src_IP dst_IP src_port dst_port L4_protocol (Eg. 6 is TCP and 17 is UDP).\n");
	printf("For example: 10.11.1.2 80.58.61.250 38772 53 17\n");
	
	uint8_t src_IP_arr[4];
	uint8_t dst_IP_arr[4];
	uint16_t src_port;
	uint16_t dst_port;
	uint8_t protocol;
	
	scanf("%hhu.%hhu.%hhu.%hhu", &(src_IP_arr[0]), &(src_IP_arr[1]), &(src_IP_arr[2]), &(src_IP_arr[3]));
	scanf("%hhu.%hhu.%hhu.%hhu", &(dst_IP_arr[0]), &(dst_IP_arr[1]), &(dst_IP_arr[2]), &(dst_IP_arr[3]));
	scanf("%hu", &src_port);
	scanf("%hu", &dst_port);
	scanf("%hhu", &protocol);

	printf("Scanned valued: %hhu.%hhu.%hhu.%hhu, %hhu.%hhu.%hhu.%hhu, %hu, %hu, %hhu\n", src_IP_arr[0], src_IP_arr[1], src_IP_arr[2], src_IP_arr[3], dst_IP_arr[0], dst_IP_arr[1], dst_IP_arr[2], dst_IP_arr[3], src_port, dst_port, protocol);

	__be32 src_IP;
	__be32 dst_IP;
	__be16  sport;
	__be16  dport;
        
        src_IP = htobe32(((src_IP_arr[0] & 0xFF) << 24) + ((src_IP_arr[1] & 0xFF) << 16) + ((src_IP_arr[2] & 0xFF) << 8) + (src_IP_arr[3] & 0xFF));
        dst_IP = htobe32(((dst_IP_arr[0] & 0xFF) << 24) + ((dst_IP_arr[1] & 0xFF) << 16) + ((dst_IP_arr[2] & 0xFF) << 8) + (dst_IP_arr[3] & 0xFF));
        sport = htobe16(src_port);
        dport = htobe16(dst_port);
	
	struct flow block_it;
	
	__builtin_memset(&block_it, 0, sizeof(block_it));
	
	block_it.saddr = src_IP;
	block_it.daddr = dst_IP;
	block_it.sport = sport;
	block_it.dport = dport;
	block_it.protocol = protocol;

	add_blocked(stats_map_fd, &block_it);

	return EXIT_OK;
}
