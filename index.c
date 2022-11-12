#include <stdio.h>
#include <pcap.h>
#include <netinet/ip.h>
#include <time.h>

/* Ethernet addresses are 6 bytes */
#define ETHER_ADDR_LEN 6
#define SIZE_ETHERNET 14

/* IP struct */
/* TCP struct */
/* UDP struct */
/* QUIC Long Header struct */
struct quic_long_header
{
};
/* QUIC Short Header struct */

void process_packet(u_char *arg, const struct pcap_pkthdr *pkthdr, const u_char *packet)
{
    const struct ip *ip;
    ip = (struct ip *)(packet + SIZE_ETHERNET);

    printf("Origin -> %s\n", inet_ntoa(ip->ip_src));
    printf("Destination -> %s\n", inet_ntoa(ip->ip_dst));
    printf("Timestamp: %d\n", pkthdr->ts);
    printf("Received Packet Size: %d\n", pkthdr->len);
    printf("***************************\n");
}

int main(int argc, char *argv[])
{
    pcap_t *handle;                  /* Session handle */
    char device[] = "wlp2s0";        /* Device to sniff on */
    char errbuf[PCAP_ERRBUF_SIZE];   /* Error string */
    struct bpf_program fp;           /* The compiled filter expression */
    char filter_exp[] = "port 4001"; /* The filter expression */
    bpf_u_int32 net;                 /* The IP of our sniffing device */

    /* Capture data */
    handle = pcap_open_live(device, BUFSIZ, 1, 1000, errbuf);
    if (handle == NULL)
    {
        fprintf(stderr, "Couldn't open device %s: %s\n", device, errbuf);
        return (2);
    }

    /* Capture */
    if (pcap_compile(handle, &fp, filter_exp, 0, net) == -1)
    {
        fprintf(stderr, "Couldn't parse filter %s: %s\n", filter_exp, pcap_geterr(handle));
        return (2);
    }
    if (pcap_setfilter(handle, &fp) == -1)
    {
        fprintf(stderr, "Couldn't install filter %s: %s\n", filter_exp, pcap_geterr(handle));
        return (2);
    }

    /* Loop forever and run process packet for every packet */
    pcap_loop(handle, -1, process_packet, NULL);

    return (0);
}