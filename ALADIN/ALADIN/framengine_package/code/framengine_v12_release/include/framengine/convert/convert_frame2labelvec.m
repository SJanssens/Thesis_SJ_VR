% This function converts a frame description into a one-dimensional
% labelvector for use in machine learning.

% input
% 1) framedesc: struct containing at least the fields:
% .data (can be empty), containing fields which represent slots
% .thisframe which describes the current frame
% 2) masterframes: struct containing at least the fields:
% .framenames - list of framesnames framedesc.thisframe can be
% .frame{...} cell array of frames, which in turns contains for each frame
% .frame{}.data (can be empty), containing all fields and all possible values of these fields
% .frame{}.slotnames a list of all the field names
% 3) conf: contains the flag conf.settingconf.frane.ignoremissingfield, which
% determines whether or not missing field names in the masterframe
% description needs to be ignore

% output
% labelvec is a one-dimensional vector, describing all possible values of
% all slots of all frames. It is a binary vector.
% Three vectors are added to the traditional labelvec: the frist one, 'semanticvec', is
% a vector based on the categories defined in masterframes, e.g. 'properties
% in Acorns', the second one gives a vector based on active slots, and the
% third one gives a vector based on frame id.




function [labelvec, framevec] = convert_frame2labelvec(framedesc,masterframes,conf)
    
    labelvec = zeros(masterframes.numvalues,1); % masterframes already contains the info needed to set its dimension
    framedesc_frameid =  find(strcmp(masterframes.framenames,framedesc.thisframe));
    
    
    
    % ------------------- now process framedesc ----------------------
   
    
    %old code start from here
    if isempty(framedesc_frameid)
        disp(['ERROR: the frame "' framedesc.thisframe '" can not be found in masterframes.framenames:'])
        masterframes.framenames
        return
    end
    
    master_cell = nstruct2cell(masterframes.frame(framedesc_frameid).data); % get the masterdata for the corresponding frame
    framedesc_cell = nstruct2cell(framedesc.data); % extract the field names and values to a 2-dim cell array, for easier handling
    
    if isempty(framedesc_cell{1,1}) % we are dealing with a frame without slots
        labelvec(masterframes.convlist.frameindex(framedesc_frameid))=1; % only a single value associated with this
    else % now loop over each field in framedesc
        for framedesc_fieldnum=1:size(framedesc_cell,1)
            if ~isempty(framedesc_cell{framedesc_fieldnum,2}) % empty values default to the value zero, so no need to spend time on them
                
                master_fieldnum=find(strcmp(framedesc_cell{framedesc_fieldnum,1},master_cell(:,1)));
                
                if isempty(master_fieldnum)
                    if conf.settingconf.frame.ignoremissingfield
                        continue  % break to the next fieldnum, as this field doesnt exist in masterframes
                    else % throw an error
                        disp(['ERROR: the field "' framedesc_cell{framedesc_fieldnum,1} '" can not be found in masterframes.frame(' num2str(framedesc_frameid) ').data:'])
                        master_cell(:,1)
                        return
                    end
                end
                
                % check if we need to take care of multiple slot values
                if ~iscell(framedesc_cell{framedesc_fieldnum,2}) % not a cell, so safe to proceed as normal
                    master_valuenum=find(strcmp(framedesc_cell{framedesc_fieldnum,2},master_cell{master_fieldnum,2}));
                else
                    
                    master_valuenum =[]; % build the list up, to support multiple slot values
                    for valueindex=1:length(framedesc_cell{framedesc_fieldnum,2}) % number of slot values set
                        current_slottarget = framedesc_cell{framedesc_fieldnum,2}{valueindex}; % assign current target
                        master_valuenum=[master_valuenum find(strcmp(current_slottarget,master_cell{master_fieldnum,2}))]; % expand list with found target
                    end
                end
                
                if isempty(master_valuenum)
                    disp(['ERROR: the value "' framedesc_cell{framedesc_fieldnum,2} '" can not be found in masterframes.frame(' num2str(framedesc_frameid) ').data' master_cell{master_fieldnum,1} ':'])
                    master_cell{master_fieldnum,2}
                    return
                end
                
                % index is formed by the index describing the field in absolute terms, plus the index describing the selected vallue
                labelvec_index=masterframes.convlist.frame(framedesc_frameid).fieldindex(master_fieldnum)+master_valuenum-1;
                
                labelvec(labelvec_index)=1;
            end
        end
    end
    
    framevec= zeros(numel(masterframes.frame),1);
    framevec(framedesc_frameid)=1;
    
