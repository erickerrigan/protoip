/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/



#include <stdio.h>

#include "xparameters.h"

#include "netif/xadapter.h"

#include "platform.h"
#include "platform_config.h"
#include "lwipopts.h"
#ifdef __arm__
#include "xil_printf.h"
#endif



#define INVALID 0

#include"FPGAserver.h"

/* defined by each RAW mode application */
void print_app_header();
int start_application();
int transfer_data();
void platform_enable_interrupts();
/* missing declaration in lwIP */
void lwip_init();


static struct netif server_netif;
struct netif *echo_netif;



void print_ip(char *msg, struct ip_addr *ip) 
{
	printf(msg);
	printf("%d.%d.%d.%d\
\r", ip4_addr1(ip), ip4_addr2(ip), 
			ip4_addr3(ip), ip4_addr4(ip));
}

void print_ip_settings(struct ip_addr *ip, struct ip_addr *mask, struct ip_addr *gw)
{

	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}




unsigned int ip_to_int (const char * ip, unsigned int  *a1, unsigned int  *a2, unsigned int  *a3, unsigned int  *a4)
{
    /* The return value. */
   unsigned v = 0;
   /* The count of the number of bytes processed. */
    int i;
    /* A pointer to the next digit to process. */
    const char * start;

    start = ip;
    for (i = 0; i < 4; i++) {
        /* The digit being processed. */
        char c;
        /* The value of this byte. */
        int n = 0;
        while (1) {
           c = * start;
           start++;
            if (c >= '0' && c <= '9') {
               n *= 10;
                n += c - '0';
           }
            /* We insist on stopping at "." if we are still parsing
               the first, second, or third numbers. If we have reached
               the end of the numbers, we will allow any character. */
           else if ((i < 3 && c == '.') || i == 3) {
                break;
            }
            else {
                return INVALID;
            }
       }
        if (n >= 256) {
            return INVALID;
        }
        v *= 256;
        v += n;
    }


	*a1=(unsigned int )(v & 0x000000FF);
	*a2=(unsigned int )((v & 0x0000FF00)>>8);
	*a3=(unsigned int )((v & 0x00FF0000)>>16);
	*a4=(unsigned int )((v & 0xFF000000)>>24);


   return v;
}



int main()
{

	struct ip_addr ipaddr, netmask, gw;
	unsigned FPGA_port_number;
	char *FPGA_ip_address;
	char *FPGA_netmask;
	char *FPGA_gateway;
	unsigned integer_ip;

	unsigned int  FPGA_ip_address_a1,FPGA_ip_address_a2,FPGA_ip_address_a3,FPGA_ip_address_a4;
	unsigned int  FPGA_netmask_a1,FPGA_netmask_a2,FPGA_netmask_a3,FPGA_netmask_a4;
	unsigned int  FPGA_gateway_a1,FPGA_gateway_a2,FPGA_gateway_a3,FPGA_gateway_a4;

	//EXAMPLE: set FPGA IP and port number
	FPGA_ip_address=FPGA_IP;
	FPGA_netmask=FPGA_NM;
	FPGA_gateway=FPGA_GW;
	FPGA_port_number=FPGA_PORT;

	//extract FPGA IP address from string
	if (ip_to_int (FPGA_ip_address,&FPGA_ip_address_a1,&FPGA_ip_address_a2,&FPGA_ip_address_a3,&FPGA_ip_address_a4) == INVALID) {
		printf ("'%s' is not a valid IP address for FPGA server.\n", FPGA_ip_address);
		return 1;
	}

	//extract FPGA netmask address from string
	if (ip_to_int (FPGA_netmask,&FPGA_netmask_a1,&FPGA_netmask_a2,&FPGA_netmask_a3,&FPGA_netmask_a4) == INVALID) {
		printf ("'%s' is not a valid netmask address for FPGA server.\n", FPGA_netmask);
		return 1;
	}

	//extract FPGA gateway address from string
	if (ip_to_int (FPGA_gateway,&FPGA_gateway_a1,&FPGA_gateway_a2,&FPGA_gateway_a3,&FPGA_gateway_a4) == INVALID) {
		printf ("'%s' is not a valid gateway address for FPGA server.\n", FPGA_gateway);
		return 1;
	}

	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] =
	{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

	echo_netif = &server_netif;

	init_platform();
	Xil_DCacheDisable();

	/* initliaze IP addresses to be used */
	IP4_ADDR(&ipaddr,  FPGA_ip_address_a4, FPGA_ip_address_a3,   FPGA_ip_address_a2, FPGA_ip_address_a1);
	IP4_ADDR(&netmask, FPGA_netmask_a4, FPGA_netmask_a3, FPGA_netmask_a2,  FPGA_netmask_a1);
	IP4_ADDR(&gw,      FPGA_gateway_a4, FPGA_gateway_a3,   FPGA_gateway_a2,  FPGA_gateway_a1);
	print_app_header();
	print_ip_settings(&ipaddr, &netmask, &gw);
	lwip_init();



  	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(echo_netif, &ipaddr, &netmask,&gw, mac_ethernet_address,PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return -1;
	}
	netif_set_default(echo_netif);

	/* specify that the network if is up */
	netif_set_up(echo_netif);

	/* now enable interrupts */
	platform_enable_interrupts();


	/* start the application (web server, rxtest, txtest, etc..) */
	start_application();

	/* receive and process packets */
	while (1) {
		xemacif_input(echo_netif);
		transfer_data();
	}
  
	/* never reached */
	cleanup_platform();

	return 0;
}

