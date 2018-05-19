%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% icl::protoip
% Author: asuardi <https://github.com/asuardi>
% Date: November - 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function load_configuration_parameters(project_name)

    filename=strcat(project_name,'_configuration_parameters.dat');
    fileID=fopen(filename,'r');
    tmp=textscan(fileID, '%s');
    fclose(fileID);
    configuration_parameters=tmp{1,1};
    num_inputs_value=str2double(configuration_parameters{4,1});
    num_outputs_value=str2double(configuration_parameters{6+num_inputs_value*5,1});

    assignin('caller', 'num_inputs', num_inputs_value)
    assignin('caller', 'num_outputs', num_outputs_value)
    
    for i=0:num_inputs_value-1
        %size
        tmp_str=strcat(upper(configuration_parameters{5+i*5,1}),'_IN_LENGTH');
        input_size=str2double(configuration_parameters{6+i*5,1});
        assignin('caller', tmp_str, input_size);
        %float_fix=0 if floating point, float_fix=1 if fixed-point
        tmp_str=strcat('FLOAT_FIX_',upper(configuration_parameters{5+i*5,1}),'_IN');
        input_size=str2double(configuration_parameters{7+i*5,1});
        assignin('caller', tmp_str, input_size);
        %integer length
        tmp_str=strcat(upper(configuration_parameters{5+i*5,1}),'_IN_INTEGERLENGTH');
       input_size=str2double(configuration_parameters{8+i*5,1});
        assignin('caller', tmp_str, input_size);
        %fraction length
        tmp_str=strcat(upper(configuration_parameters{5+i*5,1}),'_IN_FRACTIONLENGTH');
        input_size=str2double(configuration_parameters{9+i*5,1});
        assignin('caller', tmp_str, input_size);
        
    end
    
    for i=0:num_outputs_value-1
        %size
        tmp_str=strcat(upper(configuration_parameters{7+5*num_inputs_value+i*5,1}),'_OUT_LENGTH');
        input_size=str2double(configuration_parameters{8+5*num_inputs_value+i*5,1});
        assignin('caller', tmp_str, input_size);
        %float_fix=0 if floating point, float_fix=1 if fixed-point
        tmp_str=strcat('FLOAT_FIX_',upper(configuration_parameters{7+5*num_inputs_value+i*5,1}),'_IN');
        input_size=str2double(configuration_parameters{9+5*num_inputs_value+i*5,1});
        assignin('caller', tmp_str, input_size);
        %integer length
        tmp_str=strcat(upper(configuration_parameters{7+5*num_inputs_value+i*5,1}),'_IN_INTEGERLENGTH');
        input_size=str2double(configuration_parameters{10+5*num_inputs_value+i*5,1});
        assignin('caller', tmp_str, input_size);
        %fraction length
        tmp_str=strcat(upper(configuration_parameters{7+5*num_inputs_value+i*5,1}),'_IN_FRACTIONLENGTH');
        input_size=str2double(configuration_parameters{11+5*num_inputs_value+i*5,1});
        assignin('caller', tmp_str, input_size);
    end
    
    num_test_value=str2double(configuration_parameters{18+num_inputs_value*5+num_outputs_value*5,1});
    assignin('caller', 'NUM_TEST', num_test_value);
    
    type_test_value=str2double(configuration_parameters{20+num_inputs_value*5+num_outputs_value*5,1});
    assignin('caller', 'TYPE_TEST', type_test_value);

    type_design_flow=(configuration_parameters{24+num_inputs_value*5+num_outputs_value*5,1});
    assignin('caller', 'TYPE_DESIGN_FLOW', type_design_flow);

	%added by Bulat
    %find the index of #soc_Input
    IndexC = strfind(configuration_parameters, '#soc_Input');
    index_soc_input = find(not(cellfun('isempty', IndexC))); 
    if(index_soc_input > 0) 
        num_soc_inputs_value = str2double(configuration_parameters{index_soc_input+1,1});
        for i=0:num_soc_inputs_value-1
            %size
            tmp_str=strcat('SOC_',upper(configuration_parameters{index_soc_input+2+i*5,1}),'_IN_LENGTH');
            input_size=str2double(configuration_parameters{index_soc_input+3+i*5,1});
            assignin('caller', tmp_str, input_size);
        end
    end
    %find the index of #soc_Output
    IndexC = strfind(configuration_parameters, '#soc_Output');
    index_soc_output = find(not(cellfun('isempty', IndexC)));
    if(index_soc_output > 0) 
        num_soc_outputs_value = str2double(configuration_parameters{index_soc_output+1,1});  
        for i=0:num_soc_outputs_value-1
            %size
            tmp_str=strcat('SOC_',upper(configuration_parameters{index_soc_output+2+i*5,1}),'_OUT_LENGTH');
            input_size=str2double(configuration_parameters{index_soc_output+3+i*5,1});
            assignin('caller', tmp_str, input_size);
        end      
    end      
   %end added by Bulat
end
