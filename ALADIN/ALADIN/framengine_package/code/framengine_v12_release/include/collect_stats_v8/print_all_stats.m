function print_all_stats(output_fileID, stats, varargin)

%-----------------------------------------------------------------------------------------------------------------------------

% Prints the stats that have been collected with the function 'collect_all_stats.m' or 'collect_stats_for_frames.m'.
% It first checks whether the fields 'confmat_structs' and/or 'scores_structs' are main fields in the current structure;
% if so, the function 'print_stats.m' is called, which prints the confusion matrices and/or scores.
% If not, it recursively calls the function 'print_all_stats.m' to find the fields 'confmat_structs' and/or 'scores_structs' 
% deeper inside the structure.

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
    % Default:
    confmat_indices = 1:length(stats.confmat_structs); 
else
    confmat_indices = [];
end

if (length(varargin) > 1) && (~isempty(varargin{2}))
    scores_indices = varargin{2};
elseif isfield(stats, 'scores_structs')
    % Default:
    scores_indices = 1:length(stats.scores_structs);
else
    scores_indices = [];
end

if (length(varargin) > 2) && (~isempty(varargin{3}))
    confmat_types = varargin{3};
else
    % Default:
    confmat_types = {'frame_level' 'slotvalue_level' 'binary_slot_filling'};
end

if (length(varargin) > 3) && (~isempty(varargin{4}))
    score_types = varargin{4};
else
    % Default:
    score_types = {{'global' 'frame_level_scores'} {'global' 'slot_level_scores'} {'global' 'slotvalue_level_scores'} {'global' 'binary_slot_filling_scores'} {'per_slot' 'slot_level_scores'} {'per_slot' 'slotvalue_level_scores'}};
end

if length(varargin) > 4
    disp('ERROR: too many input arguments for function print_all_stats');
    return;
end


stats_fieldnames = fieldnames(stats);
if (ismember('confmat_structs', stats_fieldnames)) || (ismember('scores_structs', stats_fieldnames))
    print_stats(output_fileID, stats, confmat_indices, scores_indices, confmat_types, score_types);
else
    for field_num = 1:length(stats_fieldnames)
        fieldname = stats_fieldnames{field_num};
        if iscell(stats.(fieldname))
            for index = 1:length(stats.(fieldname))
                fieldname_printstring = strrep(fieldname, '_', ' ');
                title = [fieldname_printstring ': ' num2str(index)];
                print_title(output_fileID, title, 1);
                print_all_stats(output_fileID, stats.(fieldname){index}, confmat_indices, scores_indices, confmat_types, score_types);
            end
        else
            fieldname_printstring = strrep(fieldname, '_', ' ');
            title = fieldname_printstring;
            print_title(output_fileID, title, 1);
            print_all_stats(output_fileID, stats.(fieldname), confmat_indices, scores_indices, confmat_types, score_types);
        end
    end
end
