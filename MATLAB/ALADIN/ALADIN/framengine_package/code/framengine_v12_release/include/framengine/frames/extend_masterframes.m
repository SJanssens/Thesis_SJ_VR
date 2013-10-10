% appends statistics, overviews of field names, and conversion tables

function [masterframes] = extend_masterframes(masterframes)
    
    
    
    masterframes.numframes = length(masterframes.framenames); % number of frames
    
    % -----------------------------------------------------------------------------
    % ------------------- slot names and stats for each frame ---------------------
    % -----------------------------------------------------------------------------
    masterframes.numvalues=0; % total number of values in all frames
    
    for frameid=1:masterframes.numframes % loop over frames
        % slot names
        if isempty(masterframes.frame(frameid).data)
            masterframes.frame(frameid).slotnames='';
        else
            masterframes.frame(frameid).slotnames=fieldnames(masterframes.frame(frameid).data)';
        end
        
        % number of slots
        masterframes.frame(frameid).numslots=length(masterframes.frame(frameid).slotnames);
        
        % bit more work to get number of values
        tmpdata = nstruct2cell(masterframes.frame(frameid).data); % convert to a cell which in the second dim, contains the data
        masterframes.frame(frameid).numvalues=0;
        for fieldnum=1:masterframes.frame(frameid).numslots % loop over fields
            masterframes.frame(frameid).numvalues=masterframes.frame(frameid).numvalues + length(tmpdata{fieldnum,2}); % get number of values in each field, add to numvalues
        end
        
        if masterframes.frame(frameid).numvalues==0
            masterframes.frame(frameid).numvalues=1; % default to one, as having a single slot with a single allowed value is identical to having no slots
        end
        
        % update total number of values
        masterframes.numvalues = masterframes.numvalues + masterframes.frame(frameid).numvalues;
    end
    
    
    % ------ make indexlists for masterframes which can be used as lookup tables ------
    % -----> note this can also be done in the masterframe description, or seperately in the initialisation. Less overhead!!!!!
    
    
    % frames
    masterframes.convlist.frameindex = ones(masterframes.numframes,1);
    for frameid=2:masterframes.numframes % loop over frames, but start at 2nd since index of first is set to one
        masterframes.convlist.frameindex(frameid)=masterframes.convlist.frameindex(frameid-1) + masterframes.frame(frameid-1).numvalues; % list is cumulative; startingpoint begins with previous starting point
    end
    
    % fields
    for frameid=1:masterframes.numframes
        tmpdata = nstruct2cell(masterframes.frame(frameid).data); % get the masterdata for the corresponding frame
        masterframes.convlist.frame(frameid).fieldindex=zeros(max(masterframes.frame(frameid).numslots,1),1) + masterframes.convlist.frameindex(frameid); % init to first index of frame. Since numslots defaults to zero, still set fieldindex using max(numslots,1)
        for fieldnum=2:masterframes.frame(frameid).numslots % loop over fields, starting at 2nd as first was init already
            masterframes.convlist.frame(frameid).fieldindex(fieldnum)=masterframes.convlist.frame(frameid).fieldindex(fieldnum-1) + length(tmpdata{fieldnum-1,2});
        end
    end
    
    for frameid=1:masterframes.numframes
        localnumslots = masterframes.frame(frameid).numslots;
        if localnumslots > 0
            for fieldnum=1:localnumslots % loop over each slot name

                % use the convlist in masterframes to get labelvec-based indices to the corrent slot-value pairs
                slotstartindex = masterframes.convlist.frame(frameid).fieldindex(fieldnum);
                if fieldnum~=localnumslots
                    slotendindex = masterframes.convlist.frame(frameid).fieldindex(fieldnum+1)-1; % the endindex is the next startindex, minus 1
                else
                    slotendindex = masterframes.convlist.frame(frameid).fieldindex(1) + masterframes.frame(frameid).numvalues-1; % on the last frame, we dont have a higher entry in convlist, so we need the total number of values
                end

                masterframes.convlist.frame(frameid).fieldindices{fieldnum}  = slotstartindex:slotendindex; % indices in labelvec pertaining to this slot

            end % end for slotindex
        else
            masterframes.convlist.frame(frameid).fieldindices = [];
        end
    end
    
    Slots_all={};
    Slotvalues_all={};
    for i=1:numel(masterframes.frame)
        if ~isempty(masterframes.frame(i).data)
            F=fieldnames(masterframes.frame(i).data);
            Slots_all=[Slots_all F'];
            for j=1:length(F)
                Slotvalues_all=[Slotvalues_all masterframes.frame(i).data.(F{j})];
            end
        end
    end
    
    masterframes.slotnames=Slots_all;
    masterframes.slotvaluenames=Slotvalues_all;
    
    masterframes.uniqueslotnames=unique(masterframes.slotnames);
    masterframes.uniqueslotvaluenames=unique(masterframes.slotvaluenames);
    
    % --------------- map slot values to slots -----------------------
    
    % get starting positions of slots
    slotstart=[];
    for framenum=1:masterframes.numframes
        slotstart = [slotstart masterframes.convlist.frame(framenum).fieldindex'];
    end
    
    % now create mapping
    numslots = length(slotstart);
    masterframes.SV2S_mapping=zeros(masterframes.numvalues,numslots); % init mapping
    for slotnum=1:numslots-1
        masterframes.SV2S_mapping(slotstart(slotnum):slotstart(slotnum+1)-1,slotnum)=1;
    end
    masterframes.SV2S_mapping(slotstart(end):end,end)=1;
    
    
    % --------------- map slot values to frames -----------------------
    framestart = masterframes.convlist.frameindex; % get starting positions of frames
    
    % now create mapping
    numframes = masterframes.numframes;
    masterframes.SV2F_mapping=zeros(masterframes.numvalues,numframes); % init mapping
    for framenum=1:numframes-1
        masterframes.SV2F_mapping(framestart(framenum):framestart(framenum+1)-1,framenum)=1;
    end
    masterframes.SV2F_mapping(framestart(end):end,end)=1;    
    
    % finally, construct a unique string for each slotvalue
    masterframes.stringdesc = make_node_stringdesc(masterframes); 