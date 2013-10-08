function confmat_structs = make_confmats(instances_for_confmats)

% ----------------------------------------------------------------------------------------------------------------------
% Makes one or two confusion matrix structures (confmat_structs), based on a structure in which the instances have been
% collected (consisting of predicted classes and reference classes, based on predicted frames and reference frames) 
% First, a confmat structure is made on the basis of the unambiguous reference classes.
% If the instance structure also contains *ambiguous* reference values for the slots,
% an extra confmat structure is made; then the output is an array of two confmat structures.
%------------------------------------------------------------------------------------------------------------------------

confmat_structs = {};

% make the confusion matrix on the basis of the unambiguous reference classes
confmat_structs{1} = make_confmat_unambiguous(instances_for_confmats);
% if ambiguous reference classes are included, also make the confusion matrix on the basis of the ambiguous reference classes
if isfield(instances_for_confmats.slotvalue_level.frame(1).slot(1), 'ambiguous_ref_classes')
    confmat_structs{2} = make_confmat_ambiguous(instances_for_confmats, confmat_structs{1});
end	


function confmat_struct = make_confmat_unambiguous(instances_for_confmats)

confmat_struct.num_instances = instances_for_confmats.num_instances;
num_frames = length(instances_for_confmats.slotvalue_level.frame);
num_instances = confmat_struct.num_instances;

% --- make frame level confmats ---
% copy class labels
confmat_struct.frame_level.class_labels = instances_for_confmats.frame_level.class_labels;
num_classes = length(confmat_struct.frame_level.class_labels);
% initialise confmats per instance
confmats_per_instance = zeros(num_classes, num_classes, num_instances);
% loop over the instances and increase the appropriate counts in the confmats per instance
for instance_num = 1:num_instances
    reference_class_index = instances_for_confmats.frame_level.unambiguous_ref_class_indices{instance_num};
    predicted_class_index = instances_for_confmats.frame_level.predicted_class_indices{instance_num};
    confmats_per_instance(reference_class_index, predicted_class_index, instance_num) = confmats_per_instance(reference_class_index, predicted_class_index, instance_num) + 1;
end
% make the global confmat
confmat_global = sum(confmats_per_instance, 3);
% copy confmats to structure
confmat_struct.frame_level.confmats_per_instance = confmats_per_instance;
confmat_struct.frame_level.confmat_global = confmat_global;

% --- make slot value level confmats --- 
for frame_num = 1:num_frames 
    % copy frame and slot names
    confmat_struct.slotvalue_level.frame(frame_num).frame_name = instances_for_confmats.slotvalue_level.frame(frame_num).frame_name;
    confmat_struct.slotvalue_level.frame(frame_num).slot_names = instances_for_confmats.slotvalue_level.frame(frame_num).slot_names;
    num_slots = length(confmat_struct.slotvalue_level.frame(frame_num).slot_names);
    for slot_num = 1:num_slots
        % copy slot name and class label
        confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).slot_name = instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).slot_name;
        confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).class_labels = instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).class_labels;
        num_classes = length(instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).class_labels);
        % initialise confmats per instance
        confmats_per_instance = zeros(num_classes, num_classes, num_instances);
        % loop over the instances and increase the appropriate counts in the confmats per instance
        for instance_num = 1:num_instances
            reference_class_index = instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).unambiguous_ref_class_indices{instance_num};
            predicted_class_index = instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).predicted_class_indices{instance_num};
            confmats_per_instance(reference_class_index, predicted_class_index, instance_num) = confmats_per_instance(reference_class_index, predicted_class_index, instance_num) + 1;
        end
        % make the global confmat
        confmat_global = sum(confmats_per_instance, 3);
        % copy confmats to structure
        confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).confmats_per_instance = confmats_per_instance;
        confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).confmat_global = confmat_global;
    end
end

% --- make binary slot filling confmats
for frame_num = 1:num_frames 
    % copy frame and slot names
    confmat_struct.binary_slot_filling.frame(frame_num).frame_name = instances_for_confmats.slotvalue_level.frame(frame_num).frame_name;
    confmat_struct.binary_slot_filling.frame(frame_num).slot_names = instances_for_confmats.slotvalue_level.frame(frame_num).slot_names;
    num_slots = length(confmat_struct.binary_slot_filling.frame(frame_num).slot_names);
    for slot_num = 1:num_slots
        % copy slot name and class label
        confmat_struct.binary_slot_filling.frame(frame_num).slot(slot_num).slot_name = instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).slot_name;
        confmat_struct.binary_slot_filling.frame(frame_num).slot(slot_num).class_labels = {'filled' 'empty'};
        num_classes = 2;
        % initialise confmats per instance
        confmats_per_instance = zeros(num_classes, num_classes, num_instances);
        % loop over the instances and increase the appropriate counts in the confmats per instance
        for instance_num = 1:num_instances
            reference_class = instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).unambiguous_ref_classes{instance_num};
            predicted_class = instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).predicted_classes{instance_num};
            if isempty(reference_class)
                reference_class_index = 2;
            else
                reference_class_index = 1;
            end
            if isempty(predicted_class)
                predicted_class_index = 2;
            else
                predicted_class_index = 1;
            end
            confmats_per_instance(reference_class_index, predicted_class_index, instance_num) = confmats_per_instance(reference_class_index, predicted_class_index, instance_num) + 1;
        end
        % make the global confmat
        confmat_global = sum(confmats_per_instance, 3);
        % copy confmats to structure
        confmat_struct.binary_slot_filling.frame(frame_num).slot(slot_num).confmats_per_instance = confmats_per_instance;
        confmat_struct.binary_slot_filling.frame(frame_num).slot(slot_num).confmat_global = confmat_global;
    end
end


function confmat_struct = make_confmat_ambiguous(instances_for_confmats, confmat_struct_unambiguous)

% initialise the ambiguous confmat by copying the unambiguous confmat
confmat_struct = confmat_struct_unambiguous;

num_frames = length(instances_for_confmats.slotvalue_level.frame);
num_instances = confmat_struct.num_instances;

% adapt the ambiguous confmat where appropriate
for frame_num = 1:num_frames
    num_slots = length(confmat_struct.slotvalue_level.frame(frame_num).slot_names);
    for slot_num = 1:num_slots
        % copy confmats_per_instance to a local variable (with a shorter name)
        confmats_per_instance = confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).confmats_per_instance;
        % loop over the instances and adapt the confmats_per_instance where appropriate
        for instance_num = 1:num_instances
            ambiguous_ref_class_index = instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).ambiguous_ref_class_indices{instance_num};
            % if the ambiguous reference class was indeed ambiguous (consisting of multiple possible classes):
            if length(ambiguous_ref_class_index) > 1
                unambiguous_ref_class_index = instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).unambiguous_ref_class_indices{instance_num};
                predicted_class_index = instances_for_confmats.slotvalue_level.frame(frame_num).slot(slot_num).predicted_class_indices{instance_num};
                % if the predicted class does NOT correspond to the unambiguous reference class, but IS a member of the ambiguous reference classes:
                if (predicted_class_index ~= unambiguous_ref_class_index) && (ismember(predicted_class_index, ambiguous_ref_class_index))
                    % lower the (unambiguous_ref, predicted) count
                    confmats_per_instance(unambiguous_ref_class_index, predicted_class_index, instance_num) = confmats_per_instance(unambiguous_ref_class_index, predicted_class_index, instance_num) - 1;
                    % increase the (predicted, predicted) count
                    confmats_per_instance(predicted_class_index, predicted_class_index, instance_num) = confmats_per_instance(predicted_class_index, predicted_class_index, instance_num) + 1;
                end
            end
        end
        % adapt the global confmat (by summing over the confmats per instance)
        confmat_global = sum(confmats_per_instance, 3);
        % copy confmats to structure
        confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).confmats_per_instance = confmats_per_instance;
        confmat_struct.slotvalue_level.frame(frame_num).slot(slot_num).confmat_global = confmat_global;
    end
end
        

   
    
    
    
