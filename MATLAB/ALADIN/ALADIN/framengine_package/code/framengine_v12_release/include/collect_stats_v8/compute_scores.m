function scores_structs = compute_scores(confmat_structs, varargin)

%---------------------------------------------------------------------------------------------------
% Computes scores based on confusion matrices (confmats).
% The input is an array of confmat structures or a single confmat structure.
% For each confmat structure in the input, the function produces a scores structure.
% The confmat structures in the input contain confusion matrices on different levels:
% frame level, slotvalue level and binary slot filling level (the latter uses only the classes 
% 'filled' and 'empty' for each slot).
% Scores are computed on slotvalue level, slot level, binary slot filling level and frame level.
% And they are computed per slotvalue, per slot, per frame and globally.
%----------------------------------------------------------------------------------------------------
% Optional argument (varargin): Fbeta
% - Fbeta is the value of beta for computing the F-score
%----------------------------------------------------------------------------------------------------

if ~isempty(varargin)
    Fbeta = varargin{1};
else
    Fbeta = 1;
end
if length(varargin) > 1
    disp('ERROR: too many input arguments for function compute_scores');
    return;
end

if iscell(confmat_structs)
    num_confmats = length(confmat_structs);
    for confmat_num = 1:num_confmats
        scores_structs{confmat_num} = compute_scores(confmat_structs{confmat_num}, Fbeta);
    end
elseif ~isstruct(confmat_structs)
    disp('ERROR: confmats should be a struct or a cell array of structs');
    return;
else % confmats is a single confmat struct
    confmat_struct = confmat_structs;
    scores_struct = initialise_scores_structure(confmat_struct);
    scores_struct = compute_individual_slotvalue_scores(scores_struct, confmat_struct, Fbeta);
    scores_struct = compute_micro_averaged_slotvalue_scores(scores_struct, Fbeta);
    scores_struct = compute_macro_averaged_slotvalue_scores(scores_struct, Fbeta);
    scores_struct = compute_slot_scores(scores_struct, confmat_struct, Fbeta);
    scores_struct = compute_individual_frame_scores(scores_struct, confmat_struct, Fbeta);
    scores_struct = compute_global_frame_scores(scores_struct, confmat_struct, Fbeta);
    scores_struct = compute_binary_slot_filling_scores(scores_struct, confmat_struct, Fbeta);
    scores_structs = scores_struct;
end


function scores_struct = initialise_scores_structure(confmat_struct)

scores_struct.num_instances = confmat_struct.num_instances;
num_frames = length(confmat_struct.frame_level.class_labels);
for frame_num = 1:num_frames
    scores_struct.frame(frame_num).frame_name = confmat_struct.frame_level.class_labels{frame_num};
    slot_names = confmat_struct.slotvalue_level.frame(frame_num).slot_names;
    num_slots = length(slot_names);
    for slot_num = 1:num_slots
        scores_struct.frame(frame_num).slot(slot_num).slot_name = slot_names{slot_num};
        num_slotvalues = length(confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).class_labels);
        for slotvalue_num = 1: num_slotvalues
            value = confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).class_labels{slotvalue_num};
            scores_struct.frame(frame_num).slot(slot_num).slotvalue(slotvalue_num).value = value;
        end
    end
end
    

function scores_struct = compute_individual_slotvalue_scores(scores_struct, confmat_struct, Fbeta)

num_frames = length(confmat_struct.frame_level.class_labels);
num_instances = scores_struct.num_instances;
for frame_num = 1:num_frames
    slot_names = confmat_struct.slotvalue_level.frame(frame_num).slot_names;
    num_slots = length(slot_names);
    for slot_num = 1:num_slots
        confmat_global = confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).confmat_global;
        num_slotvalues = length(confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).class_labels);
        for slotvalue_num = 1: num_slotvalues
            % compute scores for this slotvalue and save them in a temporary struct 'sv_scores':
            % first get the positive counts for this slotvalue from the confmat
            sv_scores = get_positive_counts_from_confmat(confmat_global, slotvalue_num);
            % then compute the scores based on the counts
            sv_scores = compute_precision_recall_Fscore_from_counts(sv_scores, Fbeta);
            % copy the scores from 'sv_scores' to the overall 'scores' struct
            scores_struct.frame(frame_num).slot(slot_num).slotvalue(slotvalue_num).slotvalue_level_scores = sv_scores;
        end
    end
end


function scores_struct = compute_micro_averaged_slotvalue_scores(scores_struct, Fbeta)

% first sum the positive counts over slotvalues, slots and frames
positive_counts_fieldnames= {'num_true_positives' 'num_positives_reference' 'num_positives_prediction'};
num_frames = length(scores_struct.frame);
for field_num = 1:length(positive_counts_fieldnames)
    fieldname = positive_counts_fieldnames{field_num};
    fieldname_sum = strrep(fieldname, 'num_', 'sum_');
    total_count_global = 0;
    for frame_num = 1:num_frames
        num_slots = length(scores_struct.frame(frame_num).slot);
        total_count_this_frame = 0;
        for slot_num = 1:num_slots
            num_slotvalues = length(scores_struct.frame(frame_num).slot(slot_num).slotvalue);
            total_count_this_slot = 0;  
            for slotvalue_num = 1:(num_slotvalues-1) % do not include the empty slot value ''
                % add the count in this field for this slotvalue to the total slot, frame and global counts for this field
                count_this_slotvalue = scores_struct.frame(frame_num).slot(slot_num).slotvalue(slotvalue_num).slotvalue_level_scores.(fieldname);
                total_count_this_slot = total_count_this_slot + count_this_slotvalue;
                total_count_this_frame = total_count_this_frame + count_this_slotvalue;
                total_count_global = total_count_global + count_this_slotvalue;
            end
            scores_struct.frame(frame_num).slot(slot_num).slotvalue_level_scores.(fieldname_sum) = total_count_this_slot;
        end
        scores_struct.frame(frame_num).slotvalue_level_scores.(fieldname_sum) = total_count_this_frame;
    end
    scores_struct.global.slotvalue_level_scores.(fieldname_sum) = total_count_global;
end

% then compute the micro_averaged scores based on the summed counts
for frame_num = 1:num_frames
    frame_scores = scores_struct.frame(frame_num).slotvalue_level_scores;
    frame_scores = compute_micro_precision_recall_Fscore_from_counts(frame_scores, Fbeta);
    scores_struct.frame(frame_num).slotvalue_level_scores = frame_scores;
    num_slots = length(scores_struct.frame(frame_num).slot);
    for slot_num = 1:num_slots
        slot_scores = scores_struct.frame(frame_num).slot(slot_num).slotvalue_level_scores;
        slot_scores = compute_micro_precision_recall_Fscore_from_counts(slot_scores, Fbeta);
        scores_struct.frame(frame_num).slot(slot_num).slotvalue_level_scores = slot_scores;
    end
end
global_scores = scores_struct.global.slotvalue_level_scores;
global_scores = compute_micro_precision_recall_Fscore_from_counts(global_scores, Fbeta);
scores_struct.global.slotvalue_level_scores = global_scores;


function scores_struct = compute_macro_averaged_slotvalue_scores(scores_struct, Fbeta)

scores_fieldnames= {'precision' 'recall' 'Fscore'};
num_frames = length(scores_struct.frame);
for field_num = 1:length(scores_fieldnames)
    fieldname = scores_fieldnames{field_num};
    fieldname_macro = ['macro_' fieldname];
    sum_global = 0;
    num_scores_global = 0;
    for frame_num = 1:num_frames
        num_slots = length(scores_struct.frame(frame_num).slot);
        sum_this_frame = 0;
        num_scores_this_frame = 0;
        for slot_num = 1:num_slots
            num_slotvalues = length(scores_struct.frame(frame_num).slot(slot_num).slotvalue);
            sum_this_slot = 0;
            num_scores_this_slot = 0;
            for slotvalue_num = 1:(num_slotvalues-1) % do not include the empty slot value ''
                % add the count in this field for this slotvalue to the total slot, frame and global sums for this field
                score_this_slotvalue = scores_struct.frame(frame_num).slot(slot_num).slotvalue(slotvalue_num).slotvalue_level_scores.(fieldname);
                if ~isnan(score_this_slotvalue)
                    sum_this_slot = sum_this_slot + score_this_slotvalue;
                    sum_this_frame = sum_this_frame + score_this_slotvalue;
                    sum_global = sum_global + score_this_slotvalue;
                    num_scores_this_slot = num_scores_this_slot + 1;
                    num_scores_this_frame = num_scores_this_frame + 1;
                    num_scores_global = num_scores_global + 1;
                end
            end
            scores_struct.frame(frame_num).slot(slot_num).slotvalue_level_scores.(fieldname_macro) = sum_this_slot / num_scores_this_slot;
        end
        scores_struct.frame(frame_num).slotvalue_level_scores.(fieldname_macro) = sum_this_frame / num_scores_this_frame;
    end
    scores_struct.global.slotvalue_level_scores.(fieldname_macro) = sum_global / num_scores_global;
end


function scores_struct = compute_slot_scores(scores_struct, confmat_struct, Fbeta)

% first collect the counts for each slot
num_frames = length(scores_struct.frame);
for frame_num = 1:num_frames
    num_slots = length(scores_struct.frame(frame_num).slot);
    for slot_num = 1:num_slots
        confmat_global = confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).confmat_global;
        class_labels = confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).class_labels;
        empty_class_index = get_empty_class_index(class_labels);
        slot_scores = get_overall_counts_from_confmat(confmat_global, empty_class_index);
        scores_struct.frame(frame_num).slot(slot_num).slot_level_scores = slot_scores;
    end
end    

% then sum the slot level counts over slots and frames
counts_fieldnames = fieldnames(scores_struct.frame(1).slot(1).slot_level_scores);
for field_num = 1:length(counts_fieldnames)
    fieldname = counts_fieldnames{field_num};
    total_count_global = 0;
    for frame_num = 1:num_frames
        num_slots = length(scores_struct.frame(frame_num).slot);
        total_count_this_frame = 0;
        for slot_num = 1:num_slots         
            % add the count in this field for this slot to the total frame and global counts for this field
            count_this_slot = scores_struct.frame(frame_num).slot(slot_num).slot_level_scores.(fieldname);
            total_count_this_frame = total_count_this_frame + count_this_slot;
            total_count_global = total_count_global + count_this_slot;
        end
        scores_struct.frame(frame_num).slot_level_scores.(fieldname) = total_count_this_frame;
    end
    scores_struct.global.slot_level_scores.(fieldname) = total_count_global;
end

% finally, compute the scores based on the counts
for frame_num = 1:num_frames
    frame_scores = scores_struct.frame(frame_num).slot_level_scores;
    frame_scores = compute_scores_from_overall_counts(frame_scores, Fbeta);
    scores_struct.frame(frame_num).slot_level_scores = frame_scores;
    num_slots = length(scores_struct.frame(frame_num).slot);
    for slot_num = 1:num_slots
        slot_scores = scores_struct.frame(frame_num).slot(slot_num).slot_level_scores;
        slot_scores = compute_scores_from_overall_counts(slot_scores, Fbeta);
        scores_struct.frame(frame_num).slot(slot_num).slot_level_scores = slot_scores;
    end
end
global_scores = scores_struct.global.slot_level_scores;
global_scores = compute_scores_from_overall_counts(global_scores, Fbeta);
scores_struct.global.slot_level_scores = global_scores;


function scores_struct = compute_individual_frame_scores(scores_struct, confmat_struct, Fbeta)

num_frames = length(scores_struct.frame);
confmat_global = confmat_struct.frame_level.confmat_global;
for frame_num = 1:num_frames
    frame_scores = get_positive_counts_from_confmat(confmat_global, frame_num);
    frame_scores = compute_precision_recall_Fscore_from_counts(frame_scores, Fbeta);
    scores_struct.frame(frame_num).frame_level_scores = frame_scores;
end


function scores_struct = compute_global_frame_scores(scores_struct, confmat_struct, Fbeta)

confmat_global = confmat_struct.frame_level.confmat_global;
global_scores = get_overall_counts_from_confmat(confmat_global, []);
global_scores = compute_scores_from_overall_counts(global_scores, Fbeta);
scores_struct.global.frame_level_scores = global_scores;


function scores_struct = compute_binary_slot_filling_scores(scores_struct, confmat_struct, Fbeta)

% first collect the counts for each slot
num_frames = length(scores_struct.frame);
for frame_num = 1:num_frames
    num_slots = length(scores_struct.frame(frame_num).slot);
    for slot_num = 1:num_slots
        confmat_global = confmat_struct.binary_slot_filling.frame(frame_num).slot(slot_num).confmat_global;
        class_labels = confmat_struct.binary_slot_filling.frame(frame_num).slot(slot_num).class_labels;
        empty_class_index = get_empty_class_index(class_labels);
        slot_scores = get_overall_counts_from_confmat(confmat_global, empty_class_index);
        scores_struct.frame(frame_num).slot(slot_num).binary_slot_filling_scores = slot_scores;
    end
end    

% then sum the slot level counts over slots and frames
counts_fieldnames = fieldnames(scores_struct.frame(1).slot(1).binary_slot_filling_scores);
for field_num = 1:length(counts_fieldnames)
    fieldname = counts_fieldnames{field_num};
    total_count_global = 0;
    for frame_num = 1:num_frames
        num_slots = length(scores_struct.frame(frame_num).slot);
        total_count_this_frame = 0;
        for slot_num = 1:num_slots         
            % add the count in this field for this slot to the total frame and global counts for this field
            count_this_slot = scores_struct.frame(frame_num).slot(slot_num).binary_slot_filling_scores.(fieldname);
            total_count_this_frame = total_count_this_frame + count_this_slot;
            total_count_global = total_count_global + count_this_slot;
        end
        scores_struct.frame(frame_num).binary_slot_filling_scores.(fieldname) = total_count_this_frame;
    end
    scores_struct.global.binary_slot_filling_scores.(fieldname) = total_count_global;
end

% finally, compute the scores based on the counts
for frame_num = 1:num_frames
    frame_scores = scores_struct.frame(frame_num).binary_slot_filling_scores;
    frame_scores = compute_scores_from_overall_counts(frame_scores, Fbeta);
    scores_struct.frame(frame_num).binary_slot_filling_scores = frame_scores;
    num_slots = length(scores_struct.frame(frame_num).slot);
    for slot_num = 1:num_slots
        slot_scores = scores_struct.frame(frame_num).slot(slot_num).binary_slot_filling_scores;
        slot_scores = compute_scores_from_overall_counts(slot_scores, Fbeta);
        scores_struct.frame(frame_num).slot(slot_num).binary_slot_filling_scores = slot_scores;
    end
end
global_scores = scores_struct.global.binary_slot_filling_scores;
global_scores = compute_scores_from_overall_counts(global_scores, Fbeta);
scores_struct.global.binary_slot_filling_scores = global_scores;


function scores = get_positive_counts_from_confmat(confmat, class_index)

scores.num_true_positives = confmat(class_index, class_index);
scores.num_positives_reference = sum(confmat(class_index,:));
scores.num_positives_prediction = sum(confmat(:, class_index));


function scores = compute_precision_recall_Fscore_from_counts(scores, Fbeta)

scores.precision = scores.num_true_positives / scores.num_positives_prediction;
scores.recall = scores.num_true_positives / scores.num_positives_reference;
scores.Fscore = compute_Fscore(scores.precision, scores.recall, Fbeta);


function scores = compute_micro_precision_recall_Fscore_from_counts(scores, Fbeta)

scores.micro_precision = scores.sum_true_positives / scores.sum_positives_prediction;
scores.micro_recall = scores.sum_true_positives / scores.sum_positives_reference;
scores.micro_Fscore = compute_Fscore(scores.micro_precision, scores.micro_recall, Fbeta);


function scores = get_overall_counts_from_confmat(confmat, empty_class_index)

scores.num_classifications = sum(sum(confmat));
scores.num_correct = trace(confmat);
if ~isempty(empty_class_index)
    scores.num_correct_empty = confmat(empty_class_index, empty_class_index);
    scores.num_correct_filled = scores.num_correct - scores.num_correct_empty;
    scores.num_empty_reference = sum(confmat(empty_class_index, :));
    scores.num_empty_prediction = sum(confmat(:, empty_class_index));
    scores.num_filled_reference = scores.num_classifications - scores.num_empty_reference;
    scores.num_filled_prediction = scores.num_classifications - scores.num_empty_prediction;
end    


function scores = compute_scores_from_overall_counts(scores, Fbeta)

scores.accuracy = scores.num_correct / scores.num_classifications;
scores.errorrate = 1 - scores.accuracy;
if isfield(scores, 'num_correct_empty')
    scores.truenegrate = scores.num_correct_empty / scores.num_empty_reference;
    scores.precision = scores.num_correct_filled / scores.num_filled_prediction;
    scores.recall = scores.num_correct_filled / scores.num_filled_reference;
    scores.Fscore = compute_Fscore(scores.precision, scores.recall, Fbeta);
end


function empty_class_index = get_empty_class_index(class_labels);

empty_class_index = [];
for class_index = length(class_labels):-1:1
    if (isempty(class_labels{class_index})) || (strcmp(class_labels{class_index}, 'empty'))
        empty_class_index = class_index;
        break;
    end
end


function Fscore = compute_Fscore(precision, recall, Fbeta)

Fscore = (1+Fbeta^2)*(precision*recall)/((Fbeta^2*precision)+recall+1e-300);


    


