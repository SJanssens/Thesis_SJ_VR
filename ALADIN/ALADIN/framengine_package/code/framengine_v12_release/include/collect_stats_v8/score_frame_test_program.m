clear all
close all

%-----------------------------------------------------------------------------------
% A script for testing the functions 'collect_all_stats.m' and 'print_all_stats.m', 
% based on a set of test frames that have been stored in 'test_frames.mat' and 
% masterframes that have been stored in 'masterframes_patience.mat'.
%-----------------------------------------------------------------------------------

dbstop if error

load('test_frames.mat');
load('masterframes_patience.mat');

stats = [];
stats = collect_all_stats(masterframes, predicted_frames, oracle_action_frames, oracle_command_frames, 1);
%stats = collect_all_stats(masterframes, predicted_frames, oracle_action_frames);
print_confmat_indices = [1 2];
print_scores_indices = [1 2];
print_confmat_types = {'frame_level' 'slotvalue_level' 'binary_slot_filling'};
print_scoretypes = {{'global' 'frame_level_scores'} {'global' 'slotvalue_level_scores'} {'global' 'slot_level_scores'} {'global' 'binary_slot_filling_scores'} {'per_slot' 'slot_level_scores'} {'per_slot' 'slotvalue_level_scores'}};
output_filename = 'test_stats.txt';
output_fileID = fopen(output_filename, 'w');
print_all_stats(output_fileID, stats, print_confmat_indices, print_scores_indices, print_confmat_types, print_scoretypes);
%print_all_stats(output_fileID, stats);
fclose(output_fileID);