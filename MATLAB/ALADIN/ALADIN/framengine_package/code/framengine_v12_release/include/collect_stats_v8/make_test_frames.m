clear all
close all

%-------------------------------------------------------------
% This script produces a small test set of predicted frames, 
% oracle command frames and oracle action frames.
%-------------------------------------------------------------

% make (ambiguous) oracle command frames

oracle_command_frames{1,1}.thisframe = 'movecard';
oracle_command_frames{1,1}.data.from_suit = 's';
oracle_command_frames{1,1}.data.from_value = '2';
oracle_command_frames{1,1}.data.target_suit = '';
oracle_command_frames{1,1}.data.target_value = '';
oracle_command_frames{1,1}.data.from_foundation = '';
oracle_command_frames{1,1}.data.target_foundation = '1';
oracle_command_frames{1,1}.data.from_fieldcol = '';
oracle_command_frames{1,1}.data.target_fieldcol = '';
oracle_command_frames{1,1}.data.from_hand = '';

oracle_command_frames{1,2}.thisframe = 'movecard';
oracle_command_frames{1,2}.data.from_suit = {'s' 'c'};
oracle_command_frames{1,2}.data.from_value = '2';
oracle_command_frames{1,2}.data.target_suit = '';
oracle_command_frames{1,2}.data.target_value = '';
oracle_command_frames{1,2}.data.from_foundation = '';
oracle_command_frames{1,2}.data.target_foundation = {'1' '2' '3' '4'};
oracle_command_frames{1,2}.data.from_fieldcol = '';
oracle_command_frames{1,2}.data.target_fieldcol = '';
oracle_command_frames{1,2}.data.from_hand = '';

oracle_command_frames{1,3}.thisframe = 'movecard';
oracle_command_frames{1,3}.data.from_suit = {'s' 'c'};
oracle_command_frames{1,3}.data.from_value = '1';
oracle_command_frames{1,3}.data.target_suit = '';
oracle_command_frames{1,3}.data.target_value = '';
oracle_command_frames{1,3}.data.from_foundation = '';
oracle_command_frames{1,3}.data.target_foundation = '1';
oracle_command_frames{1,3}.data.from_fieldcol = '';
oracle_command_frames{1,3}.data.target_fieldcol = '';
oracle_command_frames{1,3}.data.from_hand = '';

oracle_command_frames{1,4}.thisframe = 'movecard';
oracle_command_frames{1,4}.data.from_suit = 's';
oracle_command_frames{1,4}.data.from_value = '3';
oracle_command_frames{1,4}.data.target_suit = '';
oracle_command_frames{1,4}.data.target_value = '';
oracle_command_frames{1,4}.data.from_foundation = '';
oracle_command_frames{1,4}.data.target_foundation = {'1' '2' '3' '4'};
oracle_command_frames{1,4}.data.from_fieldcol = '';
oracle_command_frames{1,4}.data.target_fieldcol = '';
oracle_command_frames{1,4}.data.from_hand = '';

oracle_command_frames{1,5}.thisframe = 'dealcard';
oracle_command_frames{1,5}.data = {};

oracle_command_frames{1,6}.thisframe = 'dealcard';
oracle_command_frames{1,6}.data = {};

% make (unambiguous) oracle action frames

oracle_action_frames{1,1}.thisframe = 'movecard';
oracle_action_frames{1,1}.data.from_suit = 's';
oracle_action_frames{1,1}.data.from_value = '2';
oracle_action_frames{1,1}.data.target_suit = '';
oracle_action_frames{1,1}.data.target_value = '';
oracle_action_frames{1,1}.data.from_foundation = '';
oracle_action_frames{1,1}.data.target_foundation = '1';
oracle_action_frames{1,1}.data.from_fieldcol = '';
oracle_action_frames{1,1}.data.target_fieldcol = '';
oracle_action_frames{1,1}.data.from_hand = '';

oracle_action_frames{1,2}.thisframe = 'movecard';
oracle_action_frames{1,2}.data.from_suit = 'c';
oracle_action_frames{1,2}.data.from_value = '2';
oracle_action_frames{1,2}.data.target_suit = '';
oracle_action_frames{1,2}.data.target_value = '';
oracle_action_frames{1,2}.data.from_foundation = '';
oracle_action_frames{1,2}.data.target_foundation = '1';
oracle_action_frames{1,2}.data.from_fieldcol = '';
oracle_action_frames{1,2}.data.target_fieldcol = '';
oracle_action_frames{1,2}.data.from_hand = '';

oracle_action_frames{1,3}.thisframe = 'movecard';
oracle_action_frames{1,3}.data.from_suit = 's';
oracle_action_frames{1,3}.data.from_value = '1';
oracle_action_frames{1,3}.data.target_suit = '';
oracle_action_frames{1,3}.data.target_value = '';
oracle_action_frames{1,3}.data.from_foundation = '';
oracle_action_frames{1,3}.data.target_foundation = '1';
oracle_action_frames{1,3}.data.from_fieldcol = '';
oracle_action_frames{1,3}.data.target_fieldcol = '';
oracle_action_frames{1,3}.data.from_hand = '';

oracle_action_frames{1,4}.thisframe = 'movecard';
oracle_action_frames{1,4}.data.from_suit = 's';
oracle_action_frames{1,4}.data.from_value = '3';
oracle_action_frames{1,4}.data.target_suit = '';
oracle_action_frames{1,4}.data.target_value = '';
oracle_action_frames{1,4}.data.from_foundation = '';
oracle_action_frames{1,4}.data.target_foundation = '2';
oracle_action_frames{1,4}.data.from_fieldcol = '';
oracle_action_frames{1,4}.data.target_fieldcol = '';
oracle_action_frames{1,4}.data.from_hand = '';

oracle_action_frames{1,5}.thisframe = 'dealcard';
oracle_action_frames{1,5}.data = {};

oracle_action_frames{1,6}.thisframe = 'dealcard';
oracle_action_frames{1,6}.data = {};

% make predicted frames

predicted_frames{1,1}.thisframe = 'movecard';
predicted_frames{1,1}.data.from_suit = 's';
predicted_frames{1,1}.data.from_value = '1';
predicted_frames{1,1}.data.target_suit = '';
predicted_frames{1,1}.data.target_value = '';
predicted_frames{1,1}.data.from_foundation = '';
predicted_frames{1,1}.data.target_foundation = '2';
predicted_frames{1,1}.data.from_fieldcol = '';
predicted_frames{1,1}.data.target_fieldcol = '';
predicted_frames{1,1}.data.from_hand = '';

predicted_frames{1,2}.thisframe = 'movecard';
predicted_frames{1,2}.data.from_suit = 's';
predicted_frames{1,2}.data.from_value = '1';
predicted_frames{1,2}.data.target_suit = '';
predicted_frames{1,2}.data.target_value = '';
predicted_frames{1,2}.data.from_foundation = '';
predicted_frames{1,2}.data.target_foundation = '1';
predicted_frames{1,2}.data.from_fieldcol = '';
predicted_frames{1,2}.data.target_fieldcol = '';
predicted_frames{1,2}.data.from_hand = '';

predicted_frames{1,3}.thisframe = 'movecard';
predicted_frames{1,3}.data.from_suit = 'd';
predicted_frames{1,3}.data.from_value = '1';
predicted_frames{1,3}.data.target_suit = '';
predicted_frames{1,3}.data.target_value = '2';
predicted_frames{1,3}.data.from_foundation = '';
predicted_frames{1,3}.data.target_foundation = '1';
predicted_frames{1,3}.data.from_fieldcol = '';
predicted_frames{1,3}.data.target_fieldcol = '';
predicted_frames{1,3}.data.from_hand = '';

predicted_frames{1,4}.thisframe = 'dealcard';
predicted_frames{1,4}.data = {};

predicted_frames{1,5}.thisframe = 'movecard';
predicted_frames{1,5}.data.from_suit = 'c';
predicted_frames{1,5}.data.from_value = '2';
predicted_frames{1,5}.data.target_suit = '';
predicted_frames{1,5}.data.target_value = '2';
predicted_frames{1,5}.data.from_foundation = '';
predicted_frames{1,5}.data.target_foundation = '1';
predicted_frames{1,5}.data.from_fieldcol = '';
predicted_frames{1,5}.data.target_fieldcol = '';
predicted_frames{1,5}.data.from_hand = '';

predicted_frames{1,6}.thisframe = 'dealcard';
predicted_frames{1,6}.data = {};

save('test_frames.mat', 'predicted_frames', 'oracle_command_frames', 'oracle_action_frames');
