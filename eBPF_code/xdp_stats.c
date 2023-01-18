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
#include "bpf_util.h" /* bpf_num_possible_cpus */

#define IP_ADDR_ARRAY_SIZE 16

static const struct option_wrapper long_options[] = {
	{{"help", no_argument, NULL, 'h'},
	 "Show help",
	 false},

	{{"dev", required_argument, NULL, 'd'},
	 "Operate on device <ifname>",
	 "<ifname>",
	 true},

	{{"quiet", no_argument, NULL, 'q'},
	 "Quiet mode (no output)"},

	{{0, 0, NULL, 0}}};

void quick_parse_IP_addr(unsigned int addr, char *res)
{
	sprintf(res, "%d.%d.%d.%d", (addr & 0xFF000000) >> 24, (addr & 0xFF0000) >> 16, (addr & 0xFF00) >> 8, addr & 0xFF);
}

static void flows_poll(int map_fd)
{
	struct flow *cur_key = NULL;
	struct flow next_key;
	struct info_map value;
	int err;

	__builtin_memset(&next_key, 0, sizeof(next_key));

	err = bpf_map_get_next_key(map_fd, cur_key, &next_key);
	while (!err)
	{
		bpf_map_lookup_elem(map_fd, &next_key, &value);

		char src_addr[IP_ADDR_ARRAY_SIZE];
		char dst_addr[IP_ADDR_ARRAY_SIZE];
		quick_parse_IP_addr(be32toh(next_key.saddr), &src_addr[0]);
		quick_parse_IP_addr(be32toh(next_key.daddr), &dst_addr[0]);

		// printf("source IP addr %u, destination IP addr %u, source port %hu, destination port %hu, protocol %u, %u times\n", next_key.saddr, next_key.daddr, next_key.sport, next_key.dport, next_key.protocol, value);

		printf("source IP addr %s, destination IP addr %s, source port %hu, destination port %hu, protocol %u, %llu packets, %llu bytes\n", src_addr, dst_addr, be16toh(next_key.sport), be16toh(next_key.dport), next_key.protocol, value.packets, value.bytes);

		cur_key = &next_key;

		err = bpf_map_get_next_key(map_fd, cur_key, &next_key);
	}
}

#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

const char *pin_basedir = "/sys/fs/bpf";

int main(int argc, char **argv)
{
	struct bpf_map_info map_expect = {0};
	struct bpf_map_info info = {0};
	char pin_dir[PATH_MAX];
	int stats_map_fd;
	// int interval = 2;
	int len, err;

	struct config cfg = {
		.ifindex = -1,
		.do_unload = false,
	};

	/* Cmdline options can change progsec */
	parse_cmdline_args(argc, argv, long_options, &cfg, __doc__);

	/* Required option */
	if (cfg.ifindex == -1)
	{
		fprintf(stderr, "ERR: required option --dev missing\n\n");
		usage(argv[0], __doc__, long_options, (argc == 1));
		return EXIT_FAIL_OPTION;
	}

	/* Use the --dev name as subdir for finding pinned maps */
	len = snprintf(pin_dir, PATH_MAX, "%s/%s", pin_basedir, cfg.ifname);
	if (len < 0)
	{
		fprintf(stderr, "ERR: creating pin dirname\n");
		return EXIT_FAIL_OPTION;
	}

	stats_map_fd = open_bpf_map_file(pin_dir, "xdp_flow_map", &info);
	if (stats_map_fd < 0)
	{
		return EXIT_FAIL_BPF;
	}

	/* check map info, e.g. datarec is expected size */
	map_expect.key_size = sizeof(struct flow);
	map_expect.value_size = sizeof(struct info_map);
	map_expect.max_entries = MAX_FLOWS_ENTRIES;
	err = check_map_fd_info(&info, &map_expect);
	if (err)
	{
		fprintf(stderr, "ERR: map via FD not compatible\n");
		return err;
	}
	if (verbose)
	{
		printf("\nCollecting stats from BPF map\n");
		printf(" - BPF map (bpf_map_type:%d) id:%d name:%s"
			   " key_size:%d value_size:%d max_entries:%d\n",
			   info.type, info.id, info.name,
			   info.key_size, info.value_size, info.max_entries);
	}

	flows_poll(stats_map_fd);
	return EXIT_OK;
}
