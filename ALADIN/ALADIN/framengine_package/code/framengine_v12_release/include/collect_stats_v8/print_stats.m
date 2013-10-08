function print_stats(output_fileID, stats, varargin)

%-----------------------------------------------------------------------------------------------------------------------------

% Prints the stats produced with the script 'collect_stats_for_frames.m': the confusion matrices (confmats,
% specified in the field 'confmat_structs') and the scores (specified in the field 'scores_structs').
% So it assumes that the input structure 'stats' contains the main fields 'confmat_structs' and/or 'scores_structs'.
% Both 'confmat_structs' and 'scores_structs' are arrays of structures (but they can be arrays of length 1).

%-----------------------------------------------------------------------------------------------------------------------------
% Optional arguments (varargin): {confmat_indices, scores_indices, confmat_types, score_types}

% - confmat_indices: the indices of the confmat structs of which you want to print the confmats (confusion matrices). 
%   The first confmat struct contains the confmat based on unambiguous ref. frames, the second contains the confmats after 
%   incorporating ambiguous ref. frames. Default: all indices of the cell array 'confmat_structs'.
% - scores_indices: the indices of the scores structs of which you want to print the scores. The first scores struct contains 
%   the scores based on unambiguous ref. frames, the second contains the scores after incorporating ambiguous ref. frames. 
%   Default: all indices of the cell array 'scores_structs'.
% - confmat_types: a cell array of confusion matrix types. Options: 'frame_level', 'slotvalue_level', 'binary_slot_filling'. 
%   Default: see below.
% - scores_types: a cell array of score types. Each score type consists of two strings: the first string specifies 'per_what' 
%   (options: 'per_slotvalue', 'per_slot', 'per_frame', 'global'), the second string specifies the score level (options: 
%   'slotvalue_level_scores', 'slot_level_scores', 'binary_slot_filling_scores', 'frame_level_scores'). Default: see below.

% ----------------------------------------------------------------------------------------------------------------------------

if (length(varargin) > 0) && (~isempty(varargin{1}))
    confmat_indices = varargin{1};
elseif isfield(stats, 'confmat_structs')
    confmat_indices = 1:length(stats.confmat_structs);
else
    confmat_indices = [];
end

if (length(varargin) > 1) && (~isempty(varargin{2}))
    scores_indices = varargin{2};
elseif isfield(stats, 'scores_structs')
    scores_indices = 1:length(stats.scores_structs);
else
    scores_indices = [];
end

if (length(varargin) > 2) && (~isempty(varargin{3}))
    confmat_types = varargin{3};
else
    confmat_types = {'frame_level' 'slotvalue_level' 'binary_slot_filling'};
end

if (length(varargin) > 3) && (~isempty(varargin{4}))
    score_types = varargin{4};
else
    score_types = {{'global' 'frame_level_scores'} {'global' 'slot_level_scores'} {'global' 'slotvalue_level_scores'} {'global' 'binary_slot_filling_scores'} {'per_slot' 'slot_level_scores'} {'per_slot' 'slotvalue_level_scores'}};
end

if length(varargin) > 4
    disp('ERROR: too many input arguments for function print_stats');
    return;
end


if isfield(stats, 'confmat_structs')
    num_confmats = length(stats.confmat_structs);
    for confmat_index = confmat_indices
        if confmat_index > num_confmats
            disp('ERROR: confmat index is larger than the number of confmats');
        else
            if confmat_index == 1
                title_string = 'CONFUSION MATRICES BASED ON UNAMBIGUOUS FRAMES';
            elseif confmat_index == 2
                title_string = 'CONFUSION MATRICES AFTER INCORPORATING AMBIGUOUS FRAMES';
            else
                title_string = ['CONFUSION MATRICES (' num2str(confmat_index) ')'];
            end
            print_title(output_fileID, title_string, 2);
            print_confmats_in_confmat_struct(output_fileID, stats.confmat_structs{confmat_index}, confmat_types);
        end
    end
else
    disp('structure "stats" does not contain any field "confmat_structs --> no confmats printed"');
end


if isfield(stats, 'scores_structs')
    num_scores = length(stats.scores_structs);
    for scores_index = scores_indices
        if scores_index > num_scores
            disp('ERROR: scores index is larger than the number of scores');
        else
            if scores_index == 1
                title_string = 'SCORES BASED ON UNAMBIGUOUS FRAMES';
            elseif scores_index == 2
                title_string = 'SCORES AFTER INCORPORATING AMBIGUOUS FRAMES';
            else
                title_string = ['SCORES (' num2str(scores_index) ')'];
            end
            print_title(output_fileID, title_string, 2);
            print_scores_in_scores_struct(output_fileID, stats.scores_structs{scores_index}, score_types);
        end
    end
else
    disp('structure "stats" does not contain any field "scores_structs --> no scores printed"');    
end


function print_confmats_in_confmat_struct(output_fileID, confmat_struct, confmat_types)

% first print the frame level confusion matrix
if ismember('frame_level', confmat_types)
    fprintf(output_fileID, '%s', 'CONFUSION MATRIX ON FRAME LEVEL:');
    fprintf(output_fileID, '\n');
    fprintf(output_fileID, '\n');
    class_labels = confmat_struct.frame_level.class_labels;
    confmat = confmat_struct.frame_level.confmat_global;
    print_matrix(output_fileID, confmat, 'ref.', 'pred.', class_labels, class_labels);
end

% then print the slotvalue level confusion matrix
if ismember('slotvalue_level', confmat_types)
    fprintf(output_fileID, '%s', 'CONFUSION MATRICES ON SLOT-VALUE LEVEL:');
    fprintf(output_fileID, '\n');
    fprintf(output_fileID, '\n');
    fprintf(output_fileID, '\n');
    num_frames = length(confmat_struct.slotvalue_level.frame);
    for frame_num = 1:num_frames
        frame_name = confmat_struct.slotvalue_level.frame(frame_num).frame_name;
        fprintf(output_fileID, '%s\n', ['FRAME: ' frame_name]);
        fprintf(output_fileID, '\n');
        slot_names = confmat_struct.slotvalue_level.frame(frame_num).slot_names;
        num_slots = length(slot_names);
        for slot_num = 1:num_slots
            slot_name = slot_names{slot_num};
            class_labels = confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).class_labels;
            confmat = confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).confmat_global;
            print_matrix(output_fileID, confmat, 'ref.', 'pred.', class_labels, class_labels, ['Slot: ' slot_name]);
        end
    end
end

% then print the binary slot filling confusion matrix
if ismember('binary_slot_filling', confmat_types)
    fprintf(output_fileID, '%s', 'CONFUSION MATRICES FOR BINARY SLOT FILLING:');
    fprintf(output_fileID, '\n');
    fprintf(output_fileID, '\n');
    fprintf(output_fileID, '\n');
    num_frames = length(confmat_struct.binary_slot_filling.frame);
    for frame_num = 1:num_frames
        frame_name = confmat_struct.binary_slot_filling.frame(frame_num).frame_name;
        fprintf(output_fileID, '%s\n', ['FRAME: ' frame_name]);
        fprintf(output_fileID, '\n');
        slot_names = confmat_struct.binary_slot_filling.frame(frame_num).slot_names;
        num_slots = length(slot_names);
        for slot_num = 1:num_slots
            slot_name = slot_names{slot_num};
            class_labels = confmat_struct.binary_slot_filling.frame(frame_num).slot(slot_num).class_labels;
            confmat = confmat_struct.binary_slot_filling.frame(frame_num).slot(slot_num).confmat_global;
            print_matrix(output_fileID, confmat, 'ref.', 'pred.', class_labels, class_labels, ['Slot: ' slot_name]);
        end
    end
end

%function print_matrix(output_fileID, matrix, varargin)

% varargin: {x_label, y_label, row_names, column_names, title}

function print_scores_in_scores_struct(output_fileID, scores_struct, score_types)

for scoretype_index = 1:length(score_types)
    scoretype_cell = score_types{scoretype_index};
    per_what = scoretype_cell{1};
    score_level = scoretype_cell{2};
    print_specific_scoretype(output_fileID, scores_struct, per_what, score_level);
end


function print_specific_scoretype(output_fileID, scores_struct, per_what, score_level)

per_what_printstring = strrep(per_what, '_', ' ');
per_what_printstring = upper(per_what_printstring);
score_level_printstring = strrep(score_level, '_', ' ');
score_level_printstring = upper(score_level_printstring);
fprintf(output_fileID, '%s, %s:\n', score_level_printstring, per_what_printstring);
fprintf(output_fileID, '\n');
num_frames = length(scores_struct.frame);
switch per_what
    case 'global'
        scores = scores_struct.global.(score_level);
        print_scores(output_fileID, scores);
    case 'per_frame'
        for frame_num = 1:length(scores_struct.frame)
            frame_name = scores_struct.frame(frame_num).frame_name;
            fprintf(output_fileID, '%s\n', ['-- ' frame_name ' --']);
            scores = scores_struct.frame(frame_num).(score_level);
            print_scores(output_fileID, scores);
        end            
    case 'per_slot'
        for frame_num = 1:length(scores_struct.frame)
            frame_name = scores_struct.frame(frame_num).frame_name;
            for slot_num = 1:length(scores_struct.frame(frame_num).slot)
                slot_name = scores_struct.frame(frame_num).slot(slot_num).slot_name;
                fprintf(output_fileID, '%s\n', ['-- ' frame_name '_' slot_name ' --']);
                scores = scores_struct.frame(frame_num).slot(slot_num).(score_level);
                print_scores(output_fileID, scores);
            end
        end 
    case 'per_slotvalue'
        for frame_num = 1:length(scores_struct.frame)
            frame_name = scores_struct.frame(frame_num).frame_name;
            for slot_num = 1:length(scores_struct.frame(frame_num).slot)
                slot_name = scores_struct.frame(frame_num).slot(slot_num).slot_name;
                for slotvalue_num = 1:length(scores_struct.frame(frame_num).slot(slot_num).slotvalue)
                    value = scores_struct.frame(frame_num).slot(slot_num).slotvalue(slotvalue_num).value;
                    if ~isempty(value)
                        fprintf(output_fileID, '%s\n', ['-- ' frame_name '_' slot_name '_' value ' --']);
                        scores = scores_struct.frame(frame_num).slot(slot_num).slotvalue(slotvalue_num).(score_level);
                        print_scores(output_fileID, scores);
                    end
                end
            end
        end 
    otherwise
        disp('ERROR: invalid value for variable "per_what"');        
end


function print_scores(output_fileID, scores)

field_names = fieldnames(scores);
fieldnames_lengths = cellfun(@length, field_names);
max_fieldnames_length = max(fieldnames_lengths);
fieldwidth = max_fieldnames_length;
for field_num = 1:length(field_names)
    field_name = field_names{field_num};
    fprintf(output_fileID, '%-*s', fieldwidth, field_name);
    fprintf(output_fileID, '%s', ': ');
    if ~isempty(regexp(field_name, '[ns]um_'))
        fprintf(output_fileID, '%d', scores.(field_name));
    else
        fprintf(output_fileID, '%.4f', scores.(field_name));
    end
    fprintf(output_fileID, '\n');
end
fprintf(output_fileID, '\n');


function print_matrix(output_fileID, matrix, varargin)

% varargin: {x_label, y_label, row_names, column_names, title}

if (length(varargin) > 0) && (~isempty(varargin{1}))
    x_label = varargin{1};
else
    x_label = [];
end
if (length(varargin) > 1) && (~isempty(varargin{2}))
    y_label = varargin{2};
else
    y_label = [];
end
if (length(varargin) > 2) && (~isempty(varargin{3}))
    row_names = varargin{3};
else
    row_names = [];
end
if (length(varargin) > 3) && (~isempty(varargin{4}))
    column_names = varargin{4};
else
    column_names = [];
end
if (length(varargin) > 4) && (~isempty(varargin{5}))
    title = varargin{5};
else
    title = [];
end
if length(varargin) > 5
    disp('ERROR: too many input arguments for function print_matrix');
    return;
end

% print title if specified (varargin)
if ~isempty(title)
    fprintf(output_fileID, '%s', title);
    fprintf(output_fileID, '\n');
    fprintf(output_fileID, '\n');
end
% print header with a specification of the dimensions, if specified
if ~isempty(x_label)
    fprintf(output_fileID, '%s', ['| ' x_label]);  
end
if ~isempty(y_label)
    fprintf(output_fileID, '%s', ['  --> ' y_label]);
end
if (~isempty(x_label)) || (~isempty(y_label))
    fprintf(output_fileID, '\n');
end
if ~isempty(x_label)
    fprintf(output_fileID, '%s\n', 'v');
end
% determine field width for row names, if row names are specified
if ~isempty(row_names)
    for x = 1:length(row_names)
        if isempty(row_names{x})
            row_names{x} = '{}';
        end
    end
    rowname_lengths = cellfun(@length, row_names);
    max_rowname_length = max(rowname_lengths);
    fieldwidth_rownames = max_rowname_length + 2;
else
    fieldwidth_rownames = 0;
end
% determine field width for the rest of the matrix
if ~isempty(column_names)
    for y = 1:length(column_names)
        if isempty(column_names{y})
            column_names{y} = '{}';
        end
    end
    colname_lengths = cellfun(@length, column_names);
    max_colname_length = max(colname_lengths);
else
    max_colname_length = 0;
end
max_value_length = 0;
for x = 1:size(matrix, 1)
    for y = 1:size(matrix, 2)
        value_length = length(num2str(matrix(x,y)));
        max_value_length = max([max_value_length, value_length]);
    end
end
fieldwidth_matrix = max([max_colname_length, max_value_length]) + 2;
% print matrix
if ~isempty(row_names)
    fprintf(output_fileID, '%-*s', fieldwidth_rownames, '');
    fprintf(output_fileID, '%s', '|  ');
end
if ~isempty(column_names)
    for y = 1:length(column_names)
        fprintf(output_fileID, '%-*s', fieldwidth_matrix, column_names{y});
    end
    fprintf(output_fileID, '\n');
end
if ~isempty(column_names)
    if ~isempty(row_names)
        for i = 1:fieldwidth_rownames
            fprintf(output_fileID, '%s', '-');
        end
        fprintf(output_fileID, '%s', '+--');
    end
    for i = 1:(size(matrix, 2) * fieldwidth_matrix)
        fprintf(output_fileID, '%s', '-');
    end
    fprintf(output_fileID, '\n');
end
for x = 1:size(matrix, 1)
    if ~isempty(row_names)
        fprintf(output_fileID, '%-*s', fieldwidth_rownames, row_names{x});
        fprintf(output_fileID, '%s', '|  ');
    end
    for y = 1:size(matrix, 2)
        fprintf(output_fileID, '%-*d', fieldwidth_matrix, matrix(x,y));
    end
    fprintf(output_fileID, '\n');
end
fprintf(output_fileID, '\n');
fprintf(output_fileID, '\n');

