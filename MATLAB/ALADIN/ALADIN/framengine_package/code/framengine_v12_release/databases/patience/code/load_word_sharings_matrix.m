function [word_sharings_matrix, identity_words] = load_word_sharings_matrix(masterframes)
% word_sharings_matrix is a square matrix and multiplied (leftside) to the 
% columnvector labelvec or to labelmat
% This function builds on the assumption that the rows in the labelmatrix 
% have the same order than the summation of frames, slots and values in the 
% masterframe function.
% An extra row is assumed to be inserted for an empty frame  

masterbrains=masterframes;

frameid=2;
masterbrains.frame(2).data.from_value;
masterbrains.frame(frameid).data.from_value=vec2str(100+[1:13]); % the card to be moved, card value
masterbrains.frame(frameid).data.target_value=vec2str(100+[1:13]); % the target card, card value

masterbrains.frame(frameid).data.from_foundation=vec2str(1000+[1:4]); % the card to be moved, foundation column  1-4
masterbrains.frame(frameid).data.target_foundation=vec2str(1000+[1:4]); % the target position, foundation column  1-4

masterbrains.frame(frameid).data.from_fieldcol=vec2str(10000+[1:7]); % the card to be moved, field column  1-7
masterbrains.frame(frameid).data.target_fieldcol= vec2str(10000+[1:7]); % the target position, field column 1-7


masterbrains.frame(frameid).data.from_hand={'1'}; % the card to be moved comes from the hand (flag)
%masterframes.frame(frameid).data.target_foundationempty={'1'}; % the target foundation is empty (flag)
%masterframes.frame(frameid).data.target_fieldcolempty={'1'}; % the target field column is empty
 

for frameid=1:masterbrains.numframes
    if isempty(masterbrains.frame(frameid).data)
        masterbrains.frame(frameid).data.dummy_slot={'dummy_value'};
    end
end

Slots_all={};
Slotvalues={};
for i=1:numel(masterbrains.frame)
    F=fieldnames(masterbrains.frame(i).data);
    Slots_all=[Slots_all F'];
    for j=1:length(F)
        Slotvalues=[Slotvalues masterbrains.frame(i).data.(F{j})];
    end
end

% Slotvalues is an array of strings with all slotvalues in the sequential 
% order arranged by masterframes except for the empty frames: An empty frame is
% changed in a frame with a dummy slot and dummy value = 'dummy_value' at 
% its corresponding location

word_sharings_matrix=zeros(length(Slotvalues));

for i=1:length(Slotvalues)
%     if strcmp(Slotvalues{i},'dummy_value')
%         return;%you can choose to put any value for sharing empty slots, here there are not shared
%     else
    index= strcmp(Slotvalues,Slotvalues{i});
   % end
    word_sharings_matrix(index,i)=1; % This value can be lower for soft_sharing, i.e. <1
end

%word_sharings_matrix=eye(length(Slotvalues));

[~,unique_rowindices]=unique(word_sharings_matrix','rows');% is used to create blocks
identity_words=word_sharings_matrix(:,sort(unique_rowindices))';
identity_words=bsxfun(@rdivide, identity_words, sum(identity_words, 2));
%identity_words is able to turn the labelmatrix into the keywords, i.e.
%the original labelmatrix of Joris driessen door
%identity_words*word_sharings_matrix*labelframeslotvalue_mat is de
%oorspronkelijke labelmat
end