function [bigram,node2labelvec,startnodes,endnodes,grammars] = make_connected_slotvalue_transitions_v3(masterframes)
% This function converts a grammar to a bigram for use in Viterbi/graph decoding

% For now, this function makes the assumption that within each frame, there
% is a strict ordering from the first slot to the last slot.
% This restriction may be lifted in later versions (this requires additional
% information of which slots are in which order, and which slots are mandatory 
% (in combination with each other), but note that as long
% as the goal is to have *a* value for each slot, this is no problem.
%
% The routine describes each slot/value pair in each frame as a node. Optionally, 
% It contains two additional nodes: a start and end node. The graph is constructed by first
% tying the first node to all slot *values* (entries in labelvec) of *each*
% frame. Then all slot values within a frame are connected to all slot
% values of the next slot in that frame. Finally, all slot 
% values of the last slot of each frame are connected to the end node.
% Instead of using a start and end node, its possible to output a list of
% start and end nodes, instead.
%
% Future thoughts: support for weights of grammars
%
% input
% masterframes: struct containing at least the fields:
% .framenames - list of framesnames framedesc.thisframe can be
% .frame(...) struct array of frames, which in turn contains data for each frame
% .frame().data (can be empty), containing all fields and all possible values of these fields
% .frame().slotnames a list of all the field names
% and finally, UNLESS frame().numvalues==1 (no grammar possible with one slot), the grammar as below:
% .frame().grammar(..) a struct array of one or multiple grammars
% .frame().grammar().slot_sequence a sequence of permissable slot names. Each slot_sequence itself
% is a cell structure containing L chars, with L the number of slots in
% sequence.
% OR
% frame().grammar().slotvalue_sequence a sequence of slot-value numbers, indexed globally (labelvec based). The
% vector slotvalue_sequence has dimension L, the number of slot-value pairs
% in sequence, and each element is a discrete number [1,J], with J the
% number of slot-value pairs in all frames
% OR
% .frame().grammar().bigram + .frame().grammar().startnodes + .frame().grammar().endnodes:  a bigrams local to this frame. The matrix bigram has dimensions N x N with N the
% number of slot-value pairs in this frame
%
% Note to self: maybe create a helper function that overloads masterframes to
% contain these (slot-based) grammars, based on these defaults:
% 1) left-to-right, all slots
% 2) left-to-right, any number of slots
% 3) any order, all slots
% 4) any order, any number of slots
% this is easily implemented through use of the perms() function (NOTE
% there are factorial(K) options for grammar default (3), with K the number
% of slots. That means 40 million options for 11 slots...
%
% output
% 1) bigram: a (M+2)x(M+2) or MxM sparse matrix with M=number of nodes. A non-zero weight indicates
% a possible transition from a slot value to another slot value with the 
% weight indicated by the weight in labelvec for that slot value 
% 2) node2labelvec contains for each node index the corresponding labelvec index. In its simplest form, there is a one-to-one relation
% between the node numbers and the entries in a labelvector. With more
% complex grammars, or when using start and end nodes, this mapping is no
% onger one-to-one.
% 3) startnodes. When not using a startnode, this vector gives a list of
% elegible starting nodes
% 4) endnodes. When not using an endnode, this vector gives a list of
% elegible ending nodes

% ------- init --------

% ---- construct one or multiple bigrams for each frame ----
% loop over frames
% - loop over bigrams within frames (if any)
% -- construct a bigram from grammar, or use provided grammar

% ---- construct one big bigram over all frames -----
% find total number of nodes
% all starting nodes of each bigram are collected in the startnode list
% all end nodes of each bigram are collected in the endnode list
% place all bigrams as block diagonal bigram
% optionally, create a startnode and endnode and expand the bigram matrix
% to account.


% ------- init --------
labelvec2nodes = zeros(1,masterframes.numvalues);
grammars.bigram = {} ; % cell structure holding all bigrams.
grammars.startnodes = {}; % cell structure holding all bigram startnodes.
grammars.endnodes = {};% cell structure holding all bigram endnodes.
grammars.mapping = {};% cell structure holding the labelvec indices of the bigram
global_numgrammars=0; % keep count of total number of grammars

% ---- construct one or multiple bigrams for each frame ----
% loop over frames
for frameid=1:masterframes.numframes % loop over frames
    
    % get labelvec-based indices, usefull for slotvalue_sequence grammars
    startindex = masterframes.convlist.frameindex(frameid);
    if frameid~=masterframes.numframes
        endindex = masterframes.convlist.frameindex(frameid+1)-1; % the endindex is the next startindex, minus 1
    else
        endindex=masterframes.numvalues; % on the last frame, we dont have a higher entry in convlist, so we need the total number of values
    end
    
    % get some more infos for this frame
    numvalues =  masterframes.frame(frameid).numvalues;
    numslots = max(masterframes.frame(frameid).numslots,1); % Since numslots defaults to zero in the absence of slots (even though there is a values in labelvec), use the max() to put it to one
    
    % NOTE: debatable, whether one slot with multiple values CAN contain a
    % grammar. Probably not: so then change this criterion, and the bigram
    % assignment code gets a bit more complex...
    if numvalues==1 % of there is only one slot-value pair, no grammar is possible. Assign trivial grammar and skip to next frame
        global_numgrammars = global_numgrammars+1; % increase overall grammar index, for assigning to grammars
        local_numgrammars(frameid) = 1; % count this as a single local grammar
        
        % assign an arbitrary 1x1 dimensional scalar as 'bigram'
        if 1
            grammars.bigram{global_numgrammars}=1; 
        else
            grammars.bigram{global_numgrammars}=0; % no self loop needed when only one entry
        end
        grammars.startnodes{global_numgrammars}=1; 
        grammars.endnodes{global_numgrammars}=1; 
        grammars.mapping{global_numgrammars} = startindex;
        % continue % use continue to skip when not using if...else
    else % we need a grammar
        

            global_numgrammars = global_numgrammars+1; % increase overall grammar index, for assigning to grammars{} later
            
            % construct a local bigram for this grammar

                slot_sequence = masterframes.frame(frameid).slotnames;

                % two phases, first get all indices for each slot name in
                % the sequence. Then, set all transitions
                
                % phase one: get all slot-value indices of each entry
                frameslot_indices = cell(1,length(slot_sequence)); % empty initialisation of indices
                slot_indices = 1:length(slot_sequence);
                for slotindex=slot_indices % loop over each slot name 
                    
                    fieldnum = find(ismember(masterframes.frame(frameid).slotnames, slot_sequence{slotindex})==1); % find index in masterframes
                   
                    % use the convlist in masterframes to get labelvec-based indices to the corrent slot-value pairs
                    slotstartindex = masterframes.convlist.frame(frameid).fieldindex(fieldnum);
                    if fieldnum~=masterframes.frame(frameid).numslots
                        slotendindex = masterframes.convlist.frame(frameid).fieldindex(fieldnum+1)-1; % the endindex is the next startindex, minus 1
                    else
                        slotendindex = masterframes.convlist.frame(frameid).fieldindex(1) + masterframes.frame(frameid).numvalues-1; % on the last frame, we dont have a higher entry in convlist, so we need the total number of values
                    end            

                    frameslot_indices{slotindex}  = slotstartindex:slotendindex; % indices in labelvec pertaining to this slot
                
                    % convert to local indices
                    frameslot_indices{slotindex} = frameslot_indices{slotindex} - startindex + 1;
                end % end for slotindex
                
                
                % phase two: assign indices to bigram
                localbigram = sparse(numvalues,numvalues); % create a sparse bigram for this frame
                
                for slotindex=slot_indices % loop over each slot name (-1 for pairwise indexing)
                    
                    for from_index=frameslot_indices{slotindex} % from index loop. likely one could get rid of this for loop as well
                       to_indices = cell2mat(frameslot_indices(setdiff(slot_indices,slotindex))); % the to-indices are all indices in all other slots
                       %kaka 
                       localbigram(from_index,to_indices)=1; % set from-nodes to arbitrary value
                        if 1
                            localbigram(from_index,from_index)=1; % additionally, set self-transition
                        end
                    end 
                end % end for slotindex
                
                grammars.bigram{global_numgrammars}=localbigram; % assign bigram directly. NOTE: might get in trouble with weights if not carefull
                grammars.startnodes{global_numgrammars} = 1:numvalues; % all indices are the start nodes
                grammars.endnodes{global_numgrammars} = 1:numvalues; % all indices are the end nodes
                grammars.mapping{global_numgrammars} = startindex + (0:(numvalues-1));
            

    end % if we need a grammar (numvalues==1)
end % end for frameid

% ---- construct one big bigram over all frames -----
% find total number of nodes
numnodes = sum(cellfun('size',grammars.bigram,1)); % count the dimensions of the bigrams in grammars to get the total number of nodes

% create intial bigram
bigram = sparse(numnodes,numnodes);
startnodes = []; % starting nodes. size depends on each individual bigram
endnodes = []; % starting nodes. size depends on each individual bigram

% intialize mapping
node2labelvec = zeros(1,numnodes);

% loop over all grammars
node_startindex = 1; % counter to keep track of node indices
for global_grammarid=1:global_numgrammars
    local_bigram = grammars.bigram{global_grammarid}; % local assignment for brevity
    local_numnodes = size(local_bigram,1);
    
  
    % convert start and endnodes list to global node numbers
    global_startnodes = grammars.startnodes{global_grammarid}+node_startindex-1;
    global_endnodes = grammars.endnodes{global_grammarid}+node_startindex-1;
    
    % add to startnodes and endnodes list
    startnodes = [startnodes global_startnodes];
    endnodes = [endnodes global_endnodes];
        
    % assignment to global bigram
    global_nodeindices = node_startindex:(node_startindex+local_numnodes-1); % indices in global bigram
    bigram(global_nodeindices,global_nodeindices)=local_bigram; % assignment
 
    % build node assignment mapping
    node2labelvec(global_nodeindices)=grammars.mapping{global_grammarid};
    
    
    
    node_startindex = node_startindex + local_numnodes; % increment nodeindex
end % end for global_grammarid
    



