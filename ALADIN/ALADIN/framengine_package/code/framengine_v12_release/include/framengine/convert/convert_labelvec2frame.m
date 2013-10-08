% This function converts a one-dimensional labelvector into one or multiple
% frame descriptions

% input
% 1) labelvec is a one-dimensional vector, describing all possible values of
% all slots of all frames. It is a binary vector.
% 2) masterframes: struct containing at least the fields:
% .framenames - list of framesnames framedesc.thisframe can be
% .frame{...} cell array of frames, which in turns contains for each frame
% .frame{}.data (can be empty), containing all fields and all possible values of these fields
% .frame{}.slotnames a list of all the field names


% output
% 1) framedesc: cell array containing one or multiple structs, each containing at least the fields:
% .data (can be empty), containing fields which represent slots
% .thisframe which describes the current frame
% 2) numframes: the number of frames in framedesc
% 3) framenames: the names of the frames in framedesc

% Thoughts for future versions
% a (normalized) weight

% versions
% v2 now supports non-binary input in the sense that for each slot, the
% maximum value of labelvec is used to determine the slot value
% [~,valuenum]=max(labelvec(frame_indices));
% v3 now optionally allows ambiguous output if the flag amiguous is set to true
% [~,valuenum]=max(labelvec(frame_indices)); --> valuenum=find(labelvec(frame_indices));

function [framedesc,numframes,framenames, framedescrition] = convert_labelvec2frame(labelvec,masterframes, ambiguous)


    % ------- init --------
    framedesc = {};
    numframes=0;

    labelvecdim=length(labelvec);

    if labelvecdim~=masterframes.numvalues % sanity check - does the labelvec match the masterframes description
        disp(['ERROR: the dimension of labelvec (' num2str(labelvecdim) ') does not match the one specified in masterframes (' num2str(masterframes.numvalues) ')'])
        return
    end

    % normalise so we can use thresholding when needed
    labelvec=labelvec/sum(labelvec);

    % set (arbitrary) threshold; 
    frame_threshold =  1e-6; % frames with probability mass under this threshold will not be created
    slot_threshold = 1e-6; % slots with probability mass under this threshold will be empty
    slotvalue_threshold = 1e-6;


    % ------------------- now process labelvec ----------------------

    for frameid=1:masterframes.numframes % loop over frames
        startindex = masterframes.convlist.frameindex(frameid);
        if frameid~=masterframes.numframes
            endindex = masterframes.convlist.frameindex(frameid+1)-1; % the endindex is the next startindex, minus 1
        else
            endindex=masterframes.numvalues; % on the last frame, we dont have a higher entry in convlist, so we need the total number of values
        end

        frame_indices =  startindex:endindex; % indices in labelvec pertaining to this frame
        temp_frame_probmass = sum(labelvec(frame_indices)); % amount of probability mass for this frames
        if temp_frame_probmass>frame_threshold % there are non-zero entries pertaining to this frame
            numframes=numframes+1; % serves both as a counter and as a statistic (output)
            framedesc{numframes}.thisframe = masterframes.framenames{frameid}; % assign the correct name to the output frame
            framedesc{numframes}.probmass = temp_frame_probmass; % store probability mass in the frame
            frame_probmass(numframes) = temp_frame_probmass; % also store it in a vector for sorting later

            % fill slot data
            if isempty(masterframes.frame(frameid).slotnames) % frame may have no slots
                framedesc{numframes}.data={}; % so gets empty .data
            else % now loop over all slot names and fill them
                tmpdata = nstruct2cell(masterframes.frame(frameid).data); % get the masterdata for the corresponding frame
                for fieldnum=1:masterframes.frame(frameid).numslots % loop over fields
                    startindex = masterframes.convlist.frame(frameid).fieldindex(fieldnum);
                    if fieldnum~=masterframes.frame(frameid).numslots
                        endindex = masterframes.convlist.frame(frameid).fieldindex(fieldnum+1)-1; % the endindex is the next startindex, minus 1
                    else
                        endindex = masterframes.convlist.frame(frameid).fieldindex(1) + masterframes.frame(frameid).numvalues-1; % on the last frame, we dont have a higher entry in convlist, so we need the total number of values
                    end            

                    frame_indices = startindex:endindex; % indices in labelvec pertaining to this slot

                    if sum(labelvec(frame_indices))<slot_threshold % there are no non-zero entries pertaining to this slot/field
                        framedesc{numframes}.data.(tmpdata{fieldnum,1}(2:end))=''; % no data, so empty. tmpdata{fieldnum,1} gives the .field name, (2:end) corrects it so it can be used as a struct field name
                    else % there are non-zero entries, so now figure out which entry they correspond to
                        temp_labelvec = labelvec(frame_indices);
                        temp_labelvec(temp_labelvec<slotvalue_threshold)=0;
                        
                        if (nargin<3 || ambiguous==0)
                            [~,valuenum]=max(temp_labelvec);
                        else
                            valuenum=find(temp_labelvec);
                        end
                        if length(valuenum)>1
                            datavalue=tmpdata{fieldnum,2}(valuenum); % tmpdata{fieldnum,2} gives the fields cell array of values, then {valuenum} indexes that cell array
                        else
                            datavalue=tmpdata{fieldnum,2}{valuenum}; % tmpdata{fieldnum,2} gives the fields cell array of values, then {valuenum} indexes that cell array
                        end
                        
                        framedesc{numframes}.data.(tmpdata{fieldnum,1}(2:end))=datavalue; % tmpdata{fieldnum,2} gives the fields cell array of values, then {valuenum} indexes that cell array
                    end

                end
            end

        end

    end
    
    % reorder frames in order of probability mass
    % TODO normalize by number of SV per frame...
    
    [~,frame_order] = sort(frame_probmass,'descend');
    temp_framedesc={}; % temporary copy for reordering
    for frameid=1:numframes % loop over frames
        new_frameid = frame_order(frameid); % new position in order
        temp_framedesc{frameid}=framedesc{new_frameid};
    end
    framedesc = temp_framedesc;



    % now we are done, get the framenames
    for frameid=1:numframes % loop over frames
        framenames{frameid}=framedesc{frameid}.thisframe;
    end
    
    framedescrition=framedesc{1};
 
