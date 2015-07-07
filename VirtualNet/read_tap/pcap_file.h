#ifndef PCAP_FIEL_H
#define PCAP_FIEL_H

struct pcap_file_header {
	unsigned int magic;
	unsigned short version_major;
	unsigned short version_minor;
	int thiszone;	/* gmt to local correction */
	unsigned int sigfigs;	/* accuracy of timestamps */
	unsigned int snaplen;	/* max length saved portion of each pkt */
	unsigned int linktype;	/* data link type (LINKTYPE_*) */
};

struct pcap_pkthdr {
    unsigned int second;
    unsigned int microsecond;
	unsigned int caplen;	/* length of portion present */
	unsigned int len;	/* length this packet (off wire) */
};

FILE *pf_new(const char *name);
int pf_append(FILE *fp, struct pcap_pkthdr hdr, char *buf, int size);
int pf_close(FILE *fp);
#endif
