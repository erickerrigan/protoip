function [project_name]=make_configuration_parameters_matlab_interface( varargin )

varargin=varargin{1,1};
nargin=length(varargin);

    

    if rem(nargin,2) ~= 0
        error('-E- passed one parameter not complete. Every parameter must be passed with a value.');
    else
        
        parameters=[];
        values=[];
        
        for i=1:2:nargin-1
            parameters=[parameters,varargin(i)];
            values=[values,varargin(i+1)];
            
        end
        
        input_vectors=[];
		input_vectors_length=[];
		input_vectors_type=[];
		input_vectors_integer_length=[];
		input_vectors_fraction_length=[];
        output_vectors=[];
		output_vectors_length=[];
		output_vectors_type=[];
		output_vectors_integer_length=[];
		output_vectors_fraction_length=[];
        FPGA_name=[];
        fclk=[];
        board_name=[];
        type_test=[];
        num_test=[];
        type_eth=[];
        to=[];
        from=[];
        mem_base_address=[];
        type_template=[];
        project_name=[];
		
		%added by Bulat
		soc_input_vectors=[];
		soc_input_vectors_length=[];
		soc_output_vectors=[];
		soc_output_vectors_length=[];
		%end added by Bulat		
		
        
        
        for i=1:length(parameters)

            if strcmp(parameters(i),'project_name')
                project_name=char(values(i));
            elseif strcmp(parameters(i),'input')
                tmp_split = strsplit(char(values(i)),':');
                input_vectors=[input_vectors,(tmp_split(1))];
                input_vectors_length=[input_vectors_length,(tmp_split(2))];
                input_vectors_type=[input_vectors_type,(tmp_split(3))];
                if strcmp(tmp_split(3),'fix')
                    input_vectors_integer_length=[input_vectors_integer_length,(tmp_split(4))];
                    input_vectors_fraction_length=[input_vectors_fraction_length,(tmp_split(5))];
                end
            elseif strcmp(parameters(i),'output')
                tmp_split = strsplit(char(values(i)),':');
                output_vectors=[output_vectors,(tmp_split(1))];
                output_vectors_length=[output_vectors_length,(tmp_split(2))];
                output_vectors_type=[output_vectors_type,(tmp_split(3))];
                if strcmp(tmp_split(3),'fix')
                    output_vectors_integer_length=[output_vectors_integer_length,(tmp_split(4))];
                    output_vectors_fraction_length=[output_vectors_fraction_length,(tmp_split(5))];
                end
            elseif strcmp(parameters(i),'FPGA_name')
                FPGA_name=char(values(i));
            elseif strcmp(parameters(i),'fclk')
                fclk=values{i};
            elseif strcmp(parameters(i),'board_name')
                board_name=char(values(i));
            elseif strcmp(parameters(i),'type_test')
                type_test=char(values(i));
            elseif strcmp(parameters(i),'num_test')
                num_test=values{i};
            elseif strcmp(parameters(i),'type_eth')
                type_eth=char(values(i));
            elseif strcmp(parameters(i),'to')
                to=char(values(i));
            elseif strcmp(parameters(i),'from')
                from=char(values(i));
            elseif strcmp(parameters(i),'mem_base_address')
                mem_base_address=char(values(i));
            elseif strcmp(parameters(i),'type')
                type_template=char(values(i));
			elseif strcmp(parameters(i),'soc_input') 			%added by Bulat
				tmp_split = strsplit(char(values(i)),':');
				soc_input_vectors=[soc_input_vectors,(tmp_split(1))];
                soc_input_vectors_length=[soc_input_vectors_length,(tmp_split(2))];
			elseif strcmp(parameters(i),'soc_output') 
				tmp_split = strsplit(char(values(i)),':');
				soc_output_vectors=[soc_output_vectors,(tmp_split(1))];
                soc_output_vectors_length=[soc_output_vectors_length,(tmp_split(2))];		%end added by Bulat		
            else
               tmp_str=strcat('parameter ', parameters(i), 'is not supported'); 
               error(tmp_str);
            end

        end
        
        count_fix=0;
        count_float=0;
       for i=1:length(input_vectors_type)
            if strcmp(input_vectors_type(i),'fix')
                count_fix=count_fix+1;
            else
                count_float=count_float+1;
            end
       end
       for i=1:length(output_vectors_type)
            if strcmp(output_vectors_type(i),'fix')
                count_fix=count_fix+1;
            else
                count_float=count_float+1;
            end
       end
       
       if count_fix==(length(input_vectors)+length(output_vectors)) || count_float==(length(input_vectors)+length(output_vectors))
        
          mkdir '.metadata'

        filename = strcat('.metadata/configuration_parameters_matlab_interface.dat');
        fid = fopen(filename, 'w');

        fprintf(fid,'#project_name\n');
        fprintf(fid,'%s\n',project_name);
        fprintf(fid,'#Input\n');
        fprintf(fid,'%d\n',length(input_vectors));
        for i=1:length(input_vectors)
          fprintf(fid,'%s\n',char(input_vectors(i)));  
          fprintf(fid,'%s\n',char(input_vectors_length(i)));
          if strcmp(input_vectors_type(i),'fix')
            fprintf(fid,'1\n');
            fprintf(fid,'%s\n',char(input_vectors_integer_length(i)));
            fprintf(fid,'%s\n',char(input_vectors_fraction_length(i)));
          else
            fprintf(fid,'0\n');
            fprintf(fid,'0\n');
            fprintf(fid,'0\n');
          end
        end
         fprintf(fid,'#Output\n');
        fprintf(fid,'%d\n',length(output_vectors));
        for i=1:length(output_vectors)
          fprintf(fid,'%s\n',char(output_vectors(i)));  
          fprintf(fid,'%s\n',char(output_vectors_length(i)));
           if strcmp(output_vectors_type(i),'fix')
            fprintf(fid,'1\n');
             fprintf(fid,'%s\n',char(output_vectors_integer_length(i)));
            fprintf(fid,'%s\n',char(output_vectors_fraction_length(i)));
          else
            fprintf(fid,'0\n');
            fprintf(fid,'0\n');
            fprintf(fid,'0\n');
           end

        end
        fprintf(fid,'#fclk\n');
        fprintf(fid,'%d\n',fclk);
        fprintf(fid,'#FPGA_name\n');
        fprintf(fid,'%s\n',FPGA_name);
        fprintf(fid,'#board_name\n');
        fprintf(fid,'%s\n',board_name);
        fprintf(fid,'#type_eth\n');
        fprintf(fid,'%s\n',type_eth);
        fprintf(fid,'#mem_base_address\n');
        fprintf(fid,'%s\n',mem_base_address);
        fprintf(fid,'#num_test\n');
        fprintf(fid,'%d\n',num_test);
        fprintf(fid,'#type_test\n');
        fprintf(fid,'%s\n',type_test);
        fprintf(fid,'#type_template\n');
        fprintf(fid,'%s\n',type_template);
        fprintf(fid,'#type_design_flowe\n');
        fprintf(fid,'matlab\n');
        fprintf(fid,'#from\n');
        fprintf(fid,'%s\n',from);
        fprintf(fid,'#to\n');
        fprintf(fid,'%s\n',to);
		
		%added by Bulat
		fprintf(fid,'#soc_Input\n');
        fprintf(fid,'%d\n',length(soc_input_vectors));
        for i=1:length(soc_input_vectors)
          fprintf(fid,'%s\n',char(soc_input_vectors(i)));  
          fprintf(fid,'%s\n',char(soc_input_vectors_length(i)));
          fprintf(fid,'0\n');
          fprintf(fid,'0\n');
          fprintf(fid,'0\n');
        end
		
		fprintf(fid,'#soc_Output\n');
        fprintf(fid,'%d\n',length(soc_output_vectors));
        for i=1:length(soc_output_vectors)
          fprintf(fid,'%s\n',char(soc_output_vectors(i)));  
          fprintf(fid,'%s\n',char(soc_output_vectors_length(i)));
          fprintf(fid,'0\n');
          fprintf(fid,'0\n');
          fprintf(fid,'0\n');
        end
		%end added by Bulat

        fclose(fid);

       else
           error(' -E- Inputs and Outputs must be either fixed-point or floating-point.');
       end
        
    end


