/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/



#include<stdio.h>
#include<stdlib.h>

#ifdef _WIN32
	#include<winsock2.h>
	#include<time.h>
	#pragma comment(lib,"ws2_32.lib")
#else
	#include<sys/socket.h>
	#include<arpa/inet.h>
	#include<netinet/in.h>
	#include<netdb.h>
	#include<sys/select.h>
	#include<sys/time.h>
    #include<unistd.h>
#endif
#include<stdint.h>
#include<string.h>
#include<fcntl.h>
#include <math.h>


////////////////////////////////////////////////////////////

//Input vectors size:
#define X_IN_LENGTH 40
#define NUM_ITER_IN_LENGTH 1
//Output vectors size:
#define X_OUT_LENGTH 40


////////////////////////////////////////////////////////////
//Test configuration:
#define TYPE_TEST 0


////////////////////////////////////////////////////////////

//Ethernet interface configuration:
#define TYPE_ETH 0 //1 for TCP, 0 for UDP
#define FPGA_IP "192.168.1.10" //FPGA IP
#define FPGA_NM "255.255.255.0" //Netmask
#define FPGA_GW "192.168.1.1" //Gateway
#define FPGA_PORT 2007


///////////////////////////////////////////////////////////////

//FPGA interface data specification:
#define ETH_PACKET_LENGTH 256+2 //Ethernet packet length in double words (32 bits) (from Matlab to  FPGA)
#define ETH_PACKET_LENGTH_RECV 64+2 //Ethernet packet length in double words (32 bits) (from FPGA to Matlab)




///////////////////////////////////////////////////////////////

int FPGAclient(double input_data[], unsigned packet_input_size, unsigned Packet_type, unsigned packet_internal_ID, unsigned packet_output_size, double output_data[], double *FPGA_time)
{
	
	double input_data_eth[ETH_PACKET_LENGTH];
	double output_data_eth[ETH_PACKET_LENGTH_RECV];
	double packet_internal_ID_offset;
	int float_fix;
	int fraction_length;
	unsigned FPGA_port_number;
	unsigned FPGA_link;
	char *FPGA_ip_address;
	unsigned i;
	unsigned j;
	int flag;
	int count_send;
	double flag_IP_running;
	
	//FPGA IP address
	FPGA_ip_address = FPGA_IP;

	//FPGA port
	FPGA_port_number=FPGA_PORT;

	//FPGA link
	FPGA_link=TYPE_ETH;
	
	packet_internal_ID_offset=0;
	
	   #if (TYPE_TEST==0) //IP design build, IP prototype
    
	   if (Packet_type==4) //data read
	    {
		
	       //read the output vector in chunks of ETH_PACKET_LENGTH_RECV-2 elements
	       for (i=0; i<packet_output_size; i=i+ETH_PACKET_LENGTH_RECV-2)
	       //     for (i=0; i<1; i++)
		{
		
					//fill in the vector buffer to be sent to Ethernet
					
					//vector label
					input_data_eth[ETH_PACKET_LENGTH-2]=(double)pow(2,16)*packet_internal_ID+Packet_type; 
					input_data_eth[ETH_PACKET_LENGTH-1]=packet_internal_ID_offset;
					
					
					// main call
					if (FPGA_link==1) //TCP interface
						flag=TCPclient_wrap(FPGA_ip_address,FPGA_port_number,input_data_eth,Packet_type,output_data_eth,float_fix,fraction_length);
				    else
					   flag=UDPclient_wrap(FPGA_ip_address,FPGA_port_number,input_data_eth,Packet_type,output_data_eth,float_fix,fraction_length);
	 
					*FPGA_time=output_data_eth[ETH_PACKET_LENGTH_RECV-1];
		    
		    // assemble the read chucks into the output vector 
		    for (j=0; ((j<ETH_PACKET_LENGTH_RECV-2) && (packet_internal_ID_offset*(ETH_PACKET_LENGTH_RECV-2)+j<packet_output_size)); j++) {
			output_data[(unsigned)packet_internal_ID_offset*(ETH_PACKET_LENGTH_RECV-2)+j]=output_data_eth[j];
		    } 
		    
		    packet_internal_ID_offset++;
			
		}
	    }
	    else
	    {
	    count_send=0;
		//split the input vector in chunks of ETH_PACKET_LENGTH-2 elements
		for (i=0; i<packet_input_size; i=i+ETH_PACKET_LENGTH-2)
		{
		   
		   count_send++;
				if ( count_send == 8 ) //every 8 packets sent, FPGAclientAPI wait the server have finished all the writing operations.
				{
	    			count_send=0;
					Packet_type=5;
					//vector label
					input_data_eth[ETH_PACKET_LENGTH-2]=(double)pow(2,16)*packet_internal_ID+Packet_type;
					input_data_eth[ETH_PACKET_LENGTH-1]=packet_internal_ID_offset;
					// main call, it is a read request: blocking operation
					if (FPGA_link==1) //TCP interface
					   flag=TCPclient_wrap(FPGA_ip_address,FPGA_port_number,input_data_eth,Packet_type,output_data_eth,float_fix,fraction_length);
					else
						flag=UDPclient_wrap(FPGA_ip_address,FPGA_port_number,input_data_eth,Packet_type,output_data_eth,float_fix,fraction_length);
		   
					Packet_type=3;
				 }
		
		    //fill in the vector buffer to be sent to Ethernet
		    
		    //vector data
		    for (j=0; (j<(ETH_PACKET_LENGTH-2) && (packet_internal_ID_offset*(ETH_PACKET_LENGTH-2)+j<packet_input_size)); j++) {
			input_data_eth[j]=input_data[(unsigned)packet_internal_ID_offset*(ETH_PACKET_LENGTH-2)+j];
		    }  
		    //vector label
		    input_data_eth[ETH_PACKET_LENGTH-2]=(double)pow(2,16)*packet_internal_ID+Packet_type;   
		    input_data_eth[ETH_PACKET_LENGTH-1]=packet_internal_ID_offset;

		    

		    // main call 
		    if (FPGA_link==1) //TCP interface
		       flag=TCPclient_wrap(FPGA_ip_address,FPGA_port_number,input_data_eth,Packet_type,output_data_eth,float_fix,fraction_length);
		   else
		       flag=UDPclient_wrap(FPGA_ip_address,FPGA_port_number,input_data_eth,Packet_type,output_data_eth,float_fix,fraction_length);
		   
		   packet_internal_ID_offset++;

		}
		
	    }
		#else // IP design test
			switch (Packet_type)
			{
			case 2:
				start_simulation();
				break;
			case 3:
				write_stimuli(input_data, packet_internal_ID);
				break;
			case 4:
				read_results(output_data, packet_internal_ID, packet_output_size);
				break;
			default:
				break;
			}
		#endif
	
	
}



int UDPclient_wrap(char ip_address[], unsigned port_number, double din[ETH_PACKET_LENGTH], unsigned Packet_type, double dout[ETH_PACKET_LENGTH_RECV], int float_fix, int fraction_length)
{
    
    int socket_handle; // Handle for the socket
    int connect_id; // Connection ID
    struct sockaddr_in server_address;	// Server address
	struct sockaddr_in client_address;	// client address
    int saddr_len = sizeof(server_address); // Server address length
	int caddr_len = sizeof(client_address); // Client address length
    struct hostent *server;		// Server host entity
	struct hostent *client;		// Client host entity
    int n;						// Iterator
    int k;						// Iterator
	int i;
    struct timeval tv;			// Select timeout structure
    fd_set Reader;				// Struct for select function
    int err;					// Error flag for return data
    int ss;						// Return from select function
	
	int timeout;				//timeout [s]
	char host_name[256];		// Host name of this computer 
    
    int32_t tmp_databuffer;
	
    float databuffer_float[ETH_PACKET_LENGTH];		// Buffer for outgoing data
    float incoming_float[ETH_PACKET_LENGTH_RECV];			// Buffer for return data
	

	#ifdef _WIN32
		WSADATA wsaData;
	#endif

    int tmp_time;

	// Platform specific variables for timing 
    #ifdef _WIN32
        LARGE_INTEGER t1;
        LARGE_INTEGER t2;
        LARGE_INTEGER freq;
   #else
        struct timeval t1;          // For timing call length
        struct timeval t2;          // For timing call length
   #endif 

 
    #ifdef _WIN32
    	int iResult;
		// Open windows connection
		iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
		if (iResult != 0) {
	    	printf("Could not open Windows connection. WSAStartup failed: %d\n", iResult);
    		return 1;
		}
	#endif



	server = gethostbyname(ip_address);
	port_number = port_number;
	timeout=86400; //timeout in seconds: 1 day

	


    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host1\n");
		#ifdef _WIN32
			WSACleanup();
		#endif
		return 1;
    }
    
    // Open a datagram socket.
    socket_handle = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (socket_handle == 0xFFFF){
        printf("Could not create socket.\n");
		#ifdef _WIN32
			WSACleanup();
		#endif
		return 1;
    }
    
    
    // Clear out server struct
    memset( (void *) &server_address, 0, sizeof(server_address));
   
	//Set family and port
    server_address.sin_family = AF_INET;
	server_address.sin_port = htons(port_number);
    
    //Set server address
	memcpy((char *)&server_address.sin_addr.s_addr,
          (char *)server->h_addr,
          server->h_length);

	


	
	#ifdef _WIN32
        QueryPerformanceCounter(&t1);
    #else
        gettimeofday(&t1, NULL);
    #endif
    
    // Set timeout values
   
    tv.tv_sec = timeout;
    tv.tv_usec = 0;
    
    // Set FDS u/p
    
    FD_ZERO(&Reader);
    FD_SET(socket_handle, &Reader);


	// Input data cast to float
	for ( i = 0; i < ETH_PACKET_LENGTH; i++)
		databuffer_float[i]=(float)din[i];
    
	// Send data to FPGA
    err = sendto(socket_handle, (void *)databuffer_float, sizeof(databuffer_float), 0,(struct sockaddr *)&server_address, saddr_len);
    if (!err){
        printf("Error transmitting data.\n");
		#ifdef _WIN32
			closesocket(socket_handle);
			WSACleanup();
		#else
			close(socket_handle);
		#endif
		return 1;
    }
    
    
    // --------read from DDR--------
    
    if (Packet_type==4 || Packet_type==5)
    {
    
        ss = select(socket_handle+1, &Reader, NULL, NULL, &tv);

        if (ss)
        {
			// receive data from FPGA
            err = recvfrom(socket_handle, (void *)incoming_float, sizeof(incoming_float), 0,NULL,NULL);
            if (err < 0) 
                {printf("Error receiving data.\n");
                #ifdef _WIN32
                    closesocket(socket_handle);
                    WSACleanup();
                #else
                    close(socket_handle);
                #endif
                return 1;
            }
            else
            {
                 //Output data cast to double
                 for ( i = 0; i < ETH_PACKET_LENGTH_RECV; i++)
                     dout[i] = (double)incoming_float[i];
            }
        } 
        else 
        {
               printf("Time out \n");
                #ifdef _WIN32
                    closesocket(socket_handle);
                    WSACleanup();
                #else
                    close(socket_handle);
                #endif
                return 1;
        }


    }
    
#ifdef _WIN32
    closesocket(socket_handle);
    WSACleanup();
#else
    close(socket_handle);
#endif

return 0;
}




int TCPclient_wrap(char ip_address[], unsigned port_number,double din[ETH_PACKET_LENGTH],unsigned Packet_type, double dout[ETH_PACKET_LENGTH_RECV], int float_fix, int fraction_length)
{
    
    int socket_handle; // Handle for the socket
    int connect_id; // Connection ID
    struct sockaddr_in server_address;	// Server address
	struct sockaddr_in client_address;	// client address
    int saddr_len = sizeof(server_address); // Server address length
	int caddr_len = sizeof(client_address); // Client address length
    struct hostent *server;		// Server host entity
	struct hostent *client;		// Client host entity
    int n;						// Iterator
    int k;						// Iterator
	int i;
    struct timeval tv;			// Select timeout structure
    fd_set Reader;				// Struct for select function
    int err;					// Error flag for return data
    int ss;						// Return from select function
	
	int timeout;				//timeout [s]
	char host_name[256];		// Host name of this computer 

    int tmp_time;
    int32_t tmp_databuffer;
        
    float databuffer_float[ETH_PACKET_LENGTH];		// Buffer for outgoing data
    float incoming_float[ETH_PACKET_LENGTH_RECV];			// Buffer for return data
    
    
	#ifdef _WIN32
		WSADATA wsaData;
	#endif


	// Platform specific variables for timing 
    #ifdef _WIN32
        LARGE_INTEGER t1;
        LARGE_INTEGER t2;
        LARGE_INTEGER freq;
    #else
        struct timeval t1;          // For timing call length
        struct timeval t2;          // For timing call length
    #endif 

 
    #ifdef _WIN32
    	int iResult;
		// Open windows connection
		iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
		if (iResult != 0) {
	    	printf("Could not open Windows connection. WSAStartup failed: %d\n", iResult);
    		return 1;
		}
	#endif

	server = gethostbyname(ip_address);
	port_number = port_number;
	timeout=86400; //timeout in seconds: 1 day

	


    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host1\n");
		#ifdef _WIN32
			WSACleanup();
		#endif
		return 1;
    }
    
    // Open a datagram socket.
    socket_handle = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (socket_handle == 0xFFFF){
        printf("Could not create socket.\n");
		#ifdef _WIN32
			WSACleanup();
		#endif
		return 1;
    }
    
    
    // Clear out server struct
    memset( (void *) &server_address, 0, sizeof(server_address));
   
	//Set family and port
    server_address.sin_family = AF_INET;
	server_address.sin_port = htons(port_number);
    
    //Set server address
	memcpy((char *)&server_address.sin_addr.s_addr,
          (char *)server->h_addr,
          server->h_length);

    // Connect to the server
	if (connect(socket_handle, (struct sockaddr *)&server_address, sizeof(struct sockaddr_in)))
	{
		fprintf(stderr, "Cannot bind address to socket.\n");
		#ifdef _WIN32
			closesocket(socket_handle);
			WSACleanup();
		#else
			close(socket_handle);
		#endif
		return 1;
	}     



	
	#ifdef _WIN32
       QueryPerformanceCounter(&t1);
    #else
        gettimeofday(&t1, NULL);
    #endif
    
    // Set timeout values
    
    tv.tv_sec = timeout;
    tv.tv_usec = 0;
    
    // Set FDS u/p
    
    FD_ZERO(&Reader);
    FD_SET(socket_handle, &Reader);


	// Input data cast to float
	for ( i = 0; i < ETH_PACKET_LENGTH; i++)
	{
		databuffer_float[i]=(float)din[i];
	}
    
	// Send data to FPGA
	err = send(socket_handle, (void *)databuffer_float, sizeof(databuffer_float), 0);
         

    if (!err){
        printf("Error transmitting data.\n");
		#ifdef _WIN32
			closesocket(socket_handle);
			WSACleanup();
		#else
			close(socket_handle);
		#endif
		return 1;
    }
    

    // --------read from DDR--------
    
    if (Packet_type==4 || Packet_type==5)
    {
        
        ss = select(socket_handle+1, &Reader, NULL, NULL, &tv);

        if (ss)
        {
			// receive data from FPGA
            err = recv(socket_handle, (void *)incoming_float, sizeof(incoming_float), 0);
            
            
            if (err < 0) 
                {printf("Error receiving data.\n");
                #ifdef _WIN32
                    closesocket(socket_handle);
                    WSACleanup();
                #else
                    close(socket_handle);
                #endif
                return 1;
            }
            else
            {
                 //Output data cast to double
                 for ( i = 0; i < ETH_PACKET_LENGTH_RECV; i++)
                 	dout[i] = (double)incoming_float[i];
				
            }
        } 
        else 
        {
                printf("Time out \n");
                #ifdef _WIN32
                    closesocket(socket_handle);
                    WSACleanup();
                #else
                    close(socket_handle);
                #endif
                return 1;
        }

       
       
    }


	
    
#ifdef _WIN32
    closesocket(socket_handle);
    WSACleanup();
#else
    close(socket_handle);
#endif

return 0;
}




int write_stimuli(double input_data[], unsigned packet_internal_ID)
{
	FILE * pFile;
	int i;
	switch (packet_internal_ID)
	{
	case 0: //x_in
		// store x_in into ../../ip_design/test/stimuli/fgm_controller/x_in.dat
		pFile = fopen ("../../ip_design/test/stimuli/fgm_controller/x_in.dat","w+");

		for (i = 0; i < X_IN_LENGTH; i++)
		{
			fprintf(pFile,"%2.18f \n",input_data[i]);
		}
		fprintf(pFile,"\n");
		fclose (pFile);
		
	case 1: //num_iter_in
		// store num_iter_in into ../../ip_design/test/stimuli/fgm_controller/num_iter_in.dat
		pFile = fopen ("../../ip_design/test/stimuli/fgm_controller/num_iter_in.dat","w+");

		for (i = 0; i < NUM_ITER_IN_LENGTH; i++)
		{
			fprintf(pFile,"%2.18f \n",input_data[i]);
		}
		fprintf(pFile,"\n");
		fclose (pFile);
		
		default:
		break;
	}
}
int start_simulation()
{
	system("vivado_hls -f ../../.metadata/fgm_controller_ip_design_test.tcl");
}



int read_results(double output_data[], unsigned packet_internal_ID, unsigned packet_output_size)
{

	FILE * pFile;
	int i;
	double output_data_tmp;

	switch (packet_internal_ID)
	{
	case 0: //x_in
		// load ../../ip_design/test/results/fgm_controller/x_out.dat
		pFile = fopen ("../../ip_design/test/results/fgm_controller/x_out.dat","r");

		for (i = 0; i < packet_output_size; i++)
		{
			fscanf(pFile,"%lf",&output_data_tmp);
			output_data[i]=output_data_tmp;
		}
		fclose (pFile);
		
		default:
		break;
	}

}
