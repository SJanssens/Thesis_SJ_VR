function instances_for_confmats = collect_instances_for_confmats(masterframes, predicted_frames, unambiguous_ref_frames, varargin) 

%------------------------------------------------------------------------------------------------------------------------------------
% Restructures the instances in the frame arrays in such a way, that confusion matrices can be easily made, based on those instances
% (using the function make_confmats.m).
% On three different levels, the predicted classes and the reference classes are aggregated into arrays, 
% and the indices of those classes in the array of class labels are collected as well.
% The three different levels are: the frame level, the slotvalue level, and the binary slot filling level.
% (At the binary slot filling level, only two classes are distinguished for each slot: 'filled' and 'empty'.)
%-------------------------------------------------------------------------------------------------------------------------------------
% Optional arguments (varargin): ambiguous_ref_frames
%----------------------------------------------------------

if ~isempty(varargin)
   ambiguous_ref_frames = varargin{1};
else
   ambiguous_ref_frames = {};
end
if length(varargin) > 1
    disp('ERROR: too many input arguments for function instances_for_confmats');
    return;
end

% check if frame arrays are all equal in size
if length(predicted_frames) ~= length(unambiguous_ref_frames)
    disp('ERROR: array of predicted frames and array of unambiguous reference frames are not of same size')
end
if (~isempty(ambiguous_ref_frames)) && (length(predicted_frames) ~= length(unambiguous_ref_frames))
    disp('ERROR: array of predicted frames and array of ambiguous reference frames are not of same size')
end

% make sure that the predicted frames have only one frame per instance: 
% multiple predicted frames per instance are not supported at this point
for instance_num = 1:length(predicted_frames)
    if iscell(predicted_frames{instance_num})
        predicted_frames{instance_num} = predicted_frames{instance_num}{1};
    end
end

% determine number of instances
instances_for_confmats.num_instances = length(predicted_frames);

% collect the frame level instances: 
% get the frame types of the predicted frames and the reference frames,
% and their indices in the array of possible frame types (=class labels)
class_labels = masterframes.framenames;
instances_for_confmats.frame_level.class_labels = class_labels;
for instance_num = 1:instances_for_confmats.num_instances
    predicted_class = predicted_frames{instance_num}.thisframe;
    predicted_class_index = get_index(predicted_class, class_labels);
    unambiguous_ref_class = unambiguous_ref_frames{instance_num}.thisframe;
    unambiguous_ref_class_index = get_index(unambiguous_ref_class, class_labels);
    instances_for_confmats.frame_level.predicted_classes{instance_num} = predicted_class;
    instances_for_confmats.frame_level.predicted_class_indices{instance_num} = predicted_class_index;
    instances_for_confmats.frame_level.unambiguous_ref_classes{instance_num} = unambiguous_ref_class;
    instances_for_confmats.frame_level.unambiguous_ref_class_indices{instance_num} = unambiguous_ref_class_index;
end

% collect the slot value level instances: 
% for each slot in each frame in 'masterframes', 
% get the slot value (=class) in the predicted frame and the reference frame(s),
% and determine the index of the class in the array of possible class labels
for frame_num = 1:masterframes.numframes
    frame_name = masterframes.framenames{frame_num};
    instances_for_confmats.slotvalue_level.frame(frame_num).frame_name = frame_name;
    if isempty(masterframes.frame(frame_num).data)
        slot_names = {frame_name}; % if the frame has no slots, make one slot 'frame_name'
    else
        slot_names = fieldnames(masterframes.frame(frame_num).data);
    end
    num_slots = length(slot_names);
    instances_for_confmats.slotvalue_level.frame(frame_num).slot_names = slot_names;
    for slot_num = 1:num_slots
        slot_name = slot_names{slot_num};
        instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).slot_name = slot_name;
        % get the class labels (= the possible slot values) for this slot
        if isempty(masterframes.frame(frame_num).data)
            class_labels = {'1'}; % if the frame has no slots, the slot 'frame_name' gets the possible value '1'
        else
            class_labels = masterframes.frame(frame_num).data.(slot_name);
        end
        % add the class label '' (=empty) to the class labels
        class_labels{end+1} = '';
        instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).class_labels = class_labels;
        for instance_num = 1:instances_for_confmats.num_instances
            % get the predicted class and class index for this slot
            predicted_class = get_slotvalue(predicted_frames{instance_num}, frame_num, slot_name, masterframes);
            predicted_class_index = get_index(predicted_class, class_labels);
            instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).predicted_classes{instance_num} = predicted_class;
            instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).predicted_class_indices{instance_num} = predicted_class_index;
            % get the unambiguous reference class and class index for this slot
            unambiguous_ref_class = get_slotvalue(unambiguous_ref_frames{instance_num}, frame_num, slot_name, masterframes);
            unambiguous_ref_class_index = get_index(unambiguous_ref_class, class_labels);
            instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).unambiguous_ref_classes{instance_num} = unambiguous_ref_class;
            instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).unambiguous_ref_class_indices{instance_num} = unambiguous_ref_class_index;
            % if ambiguous reference frames are given as an extra argument: also get the ambiguous reference class and class index for this slot
            if ~isempty(ambiguous_ref_frames)
                ambiguous_ref_class = get_slotvalue(ambiguous_ref_frames{instance_num}, frame_num, slot_name, masterframes);
                ambiguous_ref_class_index = get_index(ambiguous_ref_class, class_labels);
                instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).ambiguous_ref_classes{instance_num} = ambiguous_ref_class;
                instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).ambiguous_ref_class_indices{instance_num} = ambiguous_ref_class_index;
            end
        end
    end
end


function slotvalue = get_slotvalue(frame, frame_num, slot_name, masterframes)

% if the frame is of the current frame type:
if strcmp(frame.thisframe, masterframes.framenames{frame_num})
    % if the current frame does not have any slots and the current slot name corresponds to the frame name
    if (isempty(masterframes.frame(frame_num).data)) && (strcmp(slot_name, masterframes.framenames{frame_num}))
        slotvalue = '1'; % the slot 'frame_name' gets value '1'
    % else: if the current slot exists in the frame, the value is the value in that slot
    elseif isfield(frame.data, slot_name)
        slotvalue = frame.data.(slot_name);
    % else: current slot does not exist in the frame --> give an error
    else
        disp(['ERROR: slot "' slot_name '" does not exist in frame "' frame.thisframe '"']);
        return;
    end
else % if the frame is NOT of the current frame type:
    slotvalue = ''; % the value in the current slot is '' (empty)
end


function index = get_index(item, cell_array)

% cell_array is a cell array of strings (cellstr)
% item is either a string or a cell array of strings (cellstr)

index = [];
if ischar(item)
    index = find(strcmp(item, cell_array));
    if isempty(index)
        disp('ERROR: index of item not found');
    end
elseif iscellstr(item) % if the item itself is a cell array of strings
    % then the index becomes a vector of indices
    num_strings = length(item);
    for string_num = 1:num_strings
        index(string_num) = find(strcmp(item{string_num}, cell_array));
        if isempty(index(string_num))
            disp('ERROR: index of sub-item not found');
        end
    end   
else
    disp('ERROR: get_index currently only gets indices of strings or cell arrays of strings');
end

    

    