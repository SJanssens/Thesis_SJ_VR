% This function creates a string description for each slot-value pair in
% all frames

% input
% 1) masterframes: struct containing at least the fields:
% .framenames - list of framesnames framedesc.thisframe can be
% .frame{...} cell array of frames, which in turns contains for each frame
% .frame{}.data (can be empty), containing all fields and all possible values of these fields
% .frame{}.slotnames a list of all the field names

% output
% 1) stringdesc: a cell structure containing a unique string for each frame-slot-value pair, based on their frame/slot/value names

function [stringdesc] = make_node_stringdesc(masterframes)

% ------- init --------
stringdesc = cell(1,masterframes.numvalues);
stringdesc_index = 0;

% ------------------- now process labelvec ----------------------

for frameid=1:masterframes.numframes % loop over frames
    startindex = masterframes.convlist.frameindex(frameid);
    if frameid~=masterframes.numframes
        endindex = masterframes.convlist.frameindex(frameid+1)-1; % the endindex is the next startindex, minus 1
    else
        endindex=masterframes.numvalues; % on the last frame, we dont have a higher entry in convlist, so we need the total number of values
    end
    
    frame_indices =  startindex:endindex; % indices in labelvec pertaining to this frame
    
    stringdesc_frame_name = masterframes.framenames{frameid}; % temporary store the correct name to the output frame
   
    if masterframes.frame(frameid).numslots>0
        % find slot data, loop over all slot names and fill them
        for fieldnum=1:masterframes.frame(frameid).numslots % loop over fields
            
            stringdesc_slot_name = masterframes.frame(frameid).slotnames{fieldnum};
            for valuenum=1:length(masterframes.frame(frameid).data.(stringdesc_slot_name))
                stringdesc_value_name = masterframes.frame(frameid).data.(stringdesc_slot_name){valuenum};
                
                stringdesc_index = stringdesc_index + 1;
                stringdesc{stringdesc_index} = [stringdesc_frame_name '_' stringdesc_slot_name '_' stringdesc_value_name];
            end
            
        end
    else
        stringdesc_index = stringdesc_index + 1;
        stringdesc{stringdesc_index} = stringdesc_frame_name;
    end

    
end

