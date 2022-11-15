/* This common_kern_user_datastructure.h is used by kernel side BPF-progs and
 * userspace programs, for sharing common struct's and DEFINEs.
 */
#ifndef __COMMON_KERN_USER_H_DATASTRUCTURE
#define __COMMON_KERN_USER_H_DATASTRUCTURE

/* This is the data record stored in the map */
struct flow { // Stored in BIG ENDIAN!
        __be32  saddr;
        __be32  daddr;
        __be16  sport;
        __be16  dport;
        __u8    protocol;
};

#ifndef XDP_ACTION_MAX
#define XDP_ACTION_MAX (XDP_REDIRECT + 1)
#endif

#define MAX_FLOWS_ENTRIES 1000

#endif /* __COMMON_KERN_USER_DATASTRUCTURE */
