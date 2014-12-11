%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% icl::protoip
% Author: asuardi <https://github.com/asuardi>
% Date: November - 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function test_HIL(project_name)


addpath('../../.metadata');
mex FPGAclientMATLAB.c
load_configuration_parameters(project_name)

load FGM_example.mat
nx=size(A_d,1);
nu=size(B_d,2);


	%% pre-process
	%(algorithm's steps that will be implemented on the CPU)
	Fxr=[Fx,Fr];                            % This can be precomputed
	invH0 = inv(H);                         % This can be precomputed
	dualH0 = Aineq*invH0*Aineq';            % This can be precomputed
	sh = diag(1./sqrt(sum(abs(dualH0),2))); % This can be precomputed
	dualH = sh*dualH0*sh;                   % This can be precomputed
	premat_xout = -invH0*Aineq'*sh;         % This can be precomputed
	premat_xr = -invH0*Fxr;                 % This can be precomputed

%print to screen	
x0
xref

fpga_x0=x0;
matlab_x0=x0;

for i=1:NUM_TEST
	tmp_disp_str=strcat('Test number ',num2str(i));
	disp(tmp_disp_str)
	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%save fpga_x0_log. SYSTEM STATES
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/fpga_x0_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/fpga_x0_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(fpga_x0)
		fprintf(fid, '%2.18f,',fpga_x0(j));
	end
	fprintf(fid, '\n');

	fclose(fid);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%save matlab_x0_log. SYSTEM STATES
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/matlab_x0_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/matlab_x0_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(matlab_x0)
		fprintf(fid, '%2.18f,',matlab_x0(j));
	end
	fprintf(fid, '\n');

	fclose(fid);

	
	xrlvec=[fpga_x0;xref;1];
	xr=[fpga_x0;xref];
	b=Bineq0 + Bineq*fpga_x0;
	FTxrl_int=[Aineq*invH0*Fxr, b];
	FTxrl = (sh*FTxrl_int)';
	fpga_x_in = FTxrl'*xrlvec; %this will be passed to the FPGA
	
	xrlvec=[matlab_x0;xref;1];
	xr=[matlab_x0;xref];
	b=Bineq0 + Bineq*fpga_x0;
	FTxrl_int=[Aineq*invH0*Fxr, b];
	FTxrl = (sh*FTxrl_int)';
	matlab_x_in = FTxrl'*xrlvec; %this will be passed to Matlab

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%save fpga_x_in_log
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/fpga_x_in_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/fpga_x_in_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(fpga_x_in)
		fprintf(fid, '%2.18f,',fpga_x_in(j));
	end
	fprintf(fid, '\n');

	fclose(fid);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%save matlab_x_in_log
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/matlab_x_in_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/matlab_x_in_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(matlab_x_in)
		fprintf(fid, '%2.18f,',matlab_x_in(j));
	end
	fprintf(fid, '\n');

	fclose(fid);



	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	num_iter_in=num_iter;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%save num_iter_in_log
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/num_iter_in_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/num_iter_in_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(num_iter_in)
		fprintf(fid, '%2.18f,',num_iter_in(j));
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
	% send x_in
	Packet_type=3; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=1;
	data_to_send=fpga_x_in;
	FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);

	% send num_iter_in
	Packet_type=3; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=1;
	packet_output_size=1;
	data_to_send=num_iter_in;
	FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);


	% start FPGA
	Packet_type=2; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=1;
	data_to_send=0;
	FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);


	% read data from FPGA
	% read fpga_x_out
	Packet_type=4; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=X_OUT_LENGTH;
	data_to_send=0;
	[output_FPGA, time_IP] = FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);
	fpga_x_out=output_FPGA;
	% Stop Matlab timer
	time_matlab=toc;
	time_communication=time_matlab-time_IP;


	%save fpga_x_out_log.dat
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/fpga_x_out_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/fpga_x_out_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(fpga_x_out)
		fprintf(fid, '%2.18f,',fpga_x_out(j));
	end
	fprintf(fid, '\n');

	fclose(fid);



	%save fpga_time_log.dat
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/fpga_time_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/fpga_time_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	fprintf(fid, '%2.18f, %2.18f \n',time_IP, time_communication);

	fclose(fid);


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% compute with Matlab and save in a file simulation results
	[matlab_x_out] = foo_user(project_name,matlab_x_in, num_iter_in);


	%save matlab_x_out_log
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/matlab_x_out_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/matlab_x_out_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(matlab_x_out)
		fprintf(fid, '%2.18f,',matlab_x_out(j));
	end
	fprintf(fid, '\n');

	fclose(fid);
	
	
	%% post-process FPGA
	theta = premat_xout*fpga_x_out + premat_xr*[fpga_x0;xref];
   
	%% Apply plant model FPGA
	fpga_u = theta(1:nu);
	fpga_x0 = A_d*fpga_x0 + B_d*fpga_u;
	
	
	%save fpga_u_log.dat
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/fpga_u_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/fpga_u_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(fpga_u)
		fprintf(fid, '%2.18f,',fpga_u(j));
	end
	fprintf(fid, '\n');

	fclose(fid);
	
	
	%% post-process Matlab
	theta = premat_xout*matlab_x_out + premat_xr*[matlab_x0;xref];
   
	%% Apply plant model Matlab
	matlab_u = theta(1:nu);
	matlab_x0 = A_d*matlab_x0 + B_d*matlab_u;
	
	%save matlab_u_log
	if (TYPE_TEST==0)
		filename = strcat('../../ip_prototype/test/results/', project_name ,'/matlab_u_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/matlab_u_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(matlab_u)
		fprintf(fid, '%2.18f,',matlab_u(j));
	end
	fprintf(fid, '\n');

	fclose(fid);

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%write a dummy file to tell tcl script to continue with the execution

filename = strcat('_locked');
fid = fopen(filename, 'w');
fprintf(fid, 'locked write\n');
fclose(fid);

if strcmp(TYPE_DESIGN_FLOW,'vivado')
	quit;
end

end
