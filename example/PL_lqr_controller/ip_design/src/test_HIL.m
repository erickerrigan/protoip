%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% icl::protoip
% Author: asuardi <https://github.com/asuardi>
% Date: November - 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function test_HIL(project_name)


addpath('../../.metadata');
mex CFLAGS="$CFLAGS -std=c99" FPGAclientMATLAB.c
load_configuration_parameters(project_name)


load LQR_example.mat
nx=size(sysd.a,1); %number of states
nu=size(sysd.b,2); %number of inputs
ny=size(sysd.c,1); %number of outputs



x_ref_in=[0;0;0;0;0;0];


x_log_plot=[];
u_log_plot=[];


fpga_x0_in=x0_in;
matlab_x0_in=x0_in;

for i=1:NUM_TEST
	tmp_disp_str=strcat('Test number ',num2str(i));
	disp(tmp_disp_str)




	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%save fpga_x0_in_log
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/fpga_x0_in_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/fpga_x0_in_log.dat');
    end
    if i==1
        fid = fopen(filename, 'w+');
        fclose(fid);
    end
	fid = fopen(filename, 'a+');
   
	for j=1:length(fpga_x0_in)
		fprintf(fid, '%2.18f,',fpga_x0_in(j));
	end
	fprintf(fid, '\n');

	fclose(fid);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%save matlab_x0_in_log
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/matlab_x0_in_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/matlab_x0_in_log.dat');
    end
    if i==1
        fid = fopen(filename, 'w+');
        fclose(fid);
    end
	fid = fopen(filename, 'a+');
   
	for j=1:length(matlab_x0_in)
		fprintf(fid, '%2.18f,',matlab_x0_in(j));
	end
	fprintf(fid, '\n');

	fclose(fid);



	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%save x_ref_in_log
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/x_ref_in_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/x_ref_in_log.dat');
    end
   if i==1
        fid = fopen(filename, 'w+');
        fclose(fid);
    end
	fid = fopen(filename, 'a+');
   
	for j=1:length(x_ref_in)
		fprintf(fid, '%2.18f,',x_ref_in(j));
	end
	fprintf(fid, '\n');

	fclose(fid);


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Start Matlab timer
	tic

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% send the stimulus to the FPGA simulation model when IP design test or to FPGA evaluation borad when IP prototype, execute the algorithm and read back the results
	% reset IP
	Packet_type=1; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=1;
	data_to_send=1;
	FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);


	% send data to FPGA
	% send x0_in
	Packet_type=3; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=1;
	data_to_send=fpga_x0_in;
	FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);

	% send x_ref_in
	Packet_type=3; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=1;
	packet_output_size=1;
	data_to_send=x_ref_in;
	FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);


	% start FPGA
	Packet_type=2; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=1;
	data_to_send=0;
	FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);


	% read data from FPGA
	% read fpga_u_out
	Packet_type=4; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=U_OUT_LENGTH;
	data_to_send=0;
	[output_FPGA, time_IP] = FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);
	fpga_u_out=output_FPGA;
	% Stop Matlab timer
	time_matlab=toc;
	time_communication=time_matlab-time_IP;


	%save fpga_u_out_log.dat
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/fpga_u_out_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/fpga_u_out_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(fpga_u_out)
		fprintf(fid, '%2.18f,',fpga_u_out(j));
	end
	fprintf(fid, '\n');

	fclose(fid);



	%save fpga_time_log.dat
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/fpga_time_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/fpga_time_log.dat');
    end
    if i==1
        fid = fopen(filename, 'w+');
        fclose(fid);
    end
	fid = fopen(filename, 'a+');
   
	fprintf(fid, '%2.18f, %2.18f \n',time_IP, time_communication);

	fclose(fid);


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% compute with Matlab and save in a file simulation results
	[matlab_u_out] = foo_user(project_name,matlab_x0_in, x_ref_in);


	%save matlab_u_out_log
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/matlab_u_out_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/matlab_u_out_log.dat');
    end
    if i==1
        fid = fopen(filename, 'w+');
        fclose(fid);
    end
	fid = fopen(filename, 'a+');
   
	for j=1:length(matlab_u_out)
		fprintf(fid, '%2.18f,',matlab_u_out(j));
	end
	fprintf(fid, '\n');

	fclose(fid);
	
	
	%% Apply plant model (FPGA)
    fpga_x0_in=sysd.a*fpga_x0_in+sysd.b*fpga_u_out;
	%% Apply plant model (matlab)
    matlab_x0_in=sysd.a*matlab_x0_in+sysd.b*matlab_u_out;

end


if strcmp(TYPE_DESIGN_FLOW,'vivado') == 0
    load ../../ip_prototype/test/results/lqr_controller/fpga_x0_in_log.dat
    load ../../ip_prototype/test/results/lqr_controller/matlab_x0_in_log.dat

    plot(fpga_x0_in_log);
    title('FPGA test');
    figure
    plot(matlab_x0_in_log);
    title('Matlab test');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%write a dummy file to tell tcl script to continue with the execution

filename = strcat('_locked');
fid = fopen(filename, 'w');
fprintf(fid, 'locked write\n');
fclose(fid);

if strcmp(TYPE_DESIGN_FLOW,'vivado')
    disp('Test finished, exiting to Vivado');
	quit;
end

disp('Test finished, exiting to MATLAB');


end
