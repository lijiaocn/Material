#include <stdio.h>
#include "pcap_file.h"

FILE *pf_new(const char *name)
{
    struct pcap_file_header  pf_header;
    
    pf_header.magic = 0xa1b2c3d4;
    pf_header.version_major = 2;
    pf_header.version_minor = 4;
    pf_header.thiszone = 0;
    pf_header.sigfigs = 0;
    pf_header.snaplen = 65535;
    pf_header.linktype = 0x1;

    FILE *fp = fopen(name,"wb");
    if(fp == NULL){
        goto EXIT;
    }

    fwrite(&pf_header,sizeof(pf_header),1,fp);

EXIT:
    return fp;
}

int pf_append(FILE *fp, struct pcap_pkthdr hdr, char *buf, int size){

    fwrite(&hdr,sizeof(hdr),1,fp);
    fwrite(buf,1,size,fp);
    return 0;
}

int pf_close(FILE *fp){
    return fclose(fp);
}

