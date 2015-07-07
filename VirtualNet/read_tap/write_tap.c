#include <sys/socket.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <signal.h>
#include <unistd.h>
#include <linux/if.h>
#include <linux/if_tun.h>
#include <stdio.h>
#include <string.h>
#include <getopt.h>
#include <fcntl.h>
#include <asm-generic/ioctl.h>
#include <errno.h>
#include <assert.h>
#include <stdlib.h>
#include "pcap_file.h"

#define VERSION  "0.0.1"
#define TYPE_TAP_STR "tap"
#define TYPE_TUN_STR "tun"

FILE *pf = NULL;

void usage(const char *name){
    fprintf(stdout,"usage: %s -t [%s|%s] devname -s filename\n", \
            name, TYPE_TAP_STR, TYPE_TUN_STR);
    fprintf(stdout,"\t -t %s: tap device\n", TYPE_TAP_STR);
    fprintf(stdout,"\t -t %s: tun device\n", TYPE_TUN_STR);
    fprintf(stdout,"\t -s name: save file name\n");
    exit(1);
}

void contrl_c(int i){
    printf("exit!");
    if(pf != NULL){
        pf_close(pf);
    }
    exit(1);
}

enum euType{
    eu_type_tap,
    eu_type_tun,
};

struct stConfig{
    enum euType type;
    char name[10];
};

void dump_errno(void){
    fprintf(stderr,"%d: %s\n",errno, strerror(errno));
}

void dump_conf(struct stConfig cf){
    fprintf(stdout, "name: %s\n", cf.name);
    fprintf(stdout, "type: %d\n", cf.type);
}

int tun_alloc(struct stConfig *cf){

    struct ifreq ifr;
    int fd = -1;
    int err;
    
    if((fd = open("/dev/net/tun", O_RDWR))<0){
        goto ERROR;       
    }

    memset(&ifr, 0 , sizeof(ifr));

    switch(cf->type){
        case eu_type_tap:
            ifr.ifr_flags = IFF_TAP|IFF_NO_PI;
            break;
        case eu_type_tun:
            ifr.ifr_flags = IFF_TUN|IFF_NO_PI;
            break;
        default:
            fprintf(stderr,"Unkown type %d\n",cf->type);
            goto ERROR;       
    }

    if(cf->name[0] != '\0'){
        strncpy(ifr.ifr_name, cf->name, IFNAMSIZ);
    }

    if((err = ioctl(fd,TUNSETIFF, (void*)&ifr))< 0){
        goto ERROR;
    }
    
    strcpy(cf->name, ifr.ifr_name);

    return fd;

ERROR:
    if(fd >= 0){
        close(fd);
    }
    return -1;
}

void dump_binary(char *buf, int size){
    int i;
    int j=0;
    for(i=0;i<=size;i++){
        unsigned char c = *(buf+i);
        if(i % 8 == 0 && i != 0){
            if(j == 0){
                printf(" --  ");
               j = 1;
            }else{
                j = 0;
            }
        }
        if(i % 16 == 0 && i != 0){
            printf("\n");
        }
        printf("%02x ",c);
    }
}

int save_pkt(FILE *pf, char *buf, int size){
    struct pcap_pkthdr hdr;
    struct timeval ts;
    gettimeofday(&ts,NULL);
    hdr.second = ts.tv_sec;
    hdr.microsecond = ts.tv_usec;
    hdr.caplen = size;
    hdr.len= size;
    return pf_append(pf,hdr,buf,size);
}


int main(int argc,  char *argv[])
{
    // char buf[1024] ={0x08,0x00,0x27,0x53,0xbf,0x0c,0xc2,0xa0,  0x36,0xaa,0x48,0x3a,0x08,0x06,0x00,0x01,
    //                  0x08,0x00,0x06,0x04,0x00,0x01,0xc2,0xa0,  0x36,0xaa,0x48,0x3a,0xac,0x0a,0x0a,0x02,
    //                  0x00,0x00,0x00,0x00,0x00,0x00,0xac,0x0a,  0x0a,0x2d,0x00};
    char buf[1024] ={0xff,0xff,0xff,0xff,0xff,0xff,0xc2,0xa0,  0x36,0xaa,0x48,0x3a,0x08,0x06,0x00,0x01,
                     0x08,0x00,0x06,0x04,0x00,0x01,0xc2,0xa0,  0x36,0xaa,0x48,0x3a,0xac,0x0a,0x0a,0x02,
                     0x00,0x00,0x00,0x00,0x00,0x00,0xac,0x0a,  0x0a,0x2d,0x00};

    signal(SIGINT,contrl_c);
    signal(SIGKILL,contrl_c);
    struct stConfig conf;
    int choice;
    int fd = -1;
    if(argc < 2){
        usage(argv[0]);
    }

    memset(&conf,'\0',sizeof(conf));

    while (1)
    {
        static struct option long_options[] =
        {
            /* Use flags like so:
            {"verbose",	no_argument,	&verbose_flag, 'V'}*/
            /* Argument styles: no_argument, required_argument, optional_argument */
            {"version", no_argument,	0,	'v'},
            {"help",	no_argument,	0,	'h'},
            {"type",	required_argument,	0,	't'},
            {"savefile",	required_argument,	0,	's'},
            {0,0,0,0}
        };

        int option_index = 0;

        /* Argument parameters:
            no_argument: " "
            required_argument: ":"
            optional_argument: "::" */

        choice = getopt_long( argc, argv, "vht:s:",
                    long_options, &option_index);

        if (choice == -1){
            break;
        }

        switch( choice )
        {
            case 'v':
                fprintf(stdout,"%s",VERSION);
                goto Exit;

            case 'h':
                usage(argv[0]);
                break;
            case 't':
                if (0 == strncmp(optarg,TYPE_TAP_STR,strlen(TYPE_TAP_STR))){
                    conf.type = eu_type_tap;
                }else if (0 == strncmp(optarg,TYPE_TUN_STR,strlen(TYPE_TUN_STR))){
                    conf.type = eu_type_tun;     
                }else{
                    fprintf(stderr, "Unknow type: %s\n",optarg);
                    goto Exit;
                }
                break;
            case 's':
                pf = pf_new((const char *)optarg);
                if(pf == NULL){
                    fprintf(stderr,"Create file failed: %s", optarg);
                    goto Exit;
                }
                break;

            case '?': 
                /* getopt_long will have already printed an error */
                goto Exit;
                break;
            case ':': 
                /* getopt_long will have already printed an error */
                goto Exit;
                break;

            default:
                /* Not sure how to get here... */
                usage(argv[0]);
                return 0;
        }
    }

    /* Deal with non-option arguments here */
    if ( optind < argc )
    {
        int i = optind;
        strncpy(conf.name, argv[i], sizeof(conf.name)-1);
        conf.name[sizeof(conf.name)-1] = '\0';
    }
    
    fd = tun_alloc(&conf);
    if (fd < -1){
        fprintf(stderr,"tun alloc fail!\n");
        goto Exit;
    }

    dump_conf(conf);

    int conti = 0;
    while(1){
        int ret = write(fd, buf, 42);
        if(ret == 0){
            printf("End of data\n");
        }
        printf("Write Bytes: %d\n",ret);
        dump_binary(buf,ret);
        save_pkt(pf, buf, ret);
        printf("\n");
        char cmd = '\0';
        if(conti == 1){
            continue;
        }
        while(cmd == '\0'){
            printf("Quit[q] Conti[c] Next[n]:");
            fflush(stdout);
            cmd = getchar();
            if (cmd != '\n'){
                while(getchar() != '\n'){
                    if(getchar() == '\n') break;
                }
            }
            switch(cmd){
                case 'n':
                    continue;
                    break;
                case 'q':
                    goto Exit;
                case 'c':
                    conti = 1;
                    break;
                default:
                    cmd = '\0';
            }
        }
    }
Exit:
    if(fd>0){
        close(fd);
    }
    if(pf != NULL){
        pf_close(pf);
    }
    return 0;
}
