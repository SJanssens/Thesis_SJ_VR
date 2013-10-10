function stats = collect_all_stats(masterframes, predicted_frames, unambiguous_ref_frames, varargin)

%----------------------------------------------------------------------------------
% Computes stats (statistics, mainly consisting of confusion matrices and scores)
% - for all instances (stats.all_instances)
% - for specific reference frames (stats.ref_frame{frame_num})
% This function uses the function 'collect_stats_for_frames.m', 
% which only collects the stats for *all* instances specified
% in the arrays of predicted frames and reference frames in the
% input arguments.
%----------------------------------------------------------------------------------
% Optional arguments (varargin): {ambiguous_ref_frames, Fbeta}
% - Fbeta is the value of beta for computing the F-score
%----------------------------------------------------------------------------------

if length(varargin) > 0
    ambiguous_ref_frames = varargin{1};
else
    ambiguous_ref_frames = {};
end
if length(varargin) > 1
    Fbeta = varargin{2};
else
    Fbeta = 1;
end
if length(varargin) > 2
    disp('ERROR: too many input arguments for function collect_all_stats');
    return;
end


num_frames = length(masterframes.framenames);
num_instances = length(predicted_frames);
for frame_num = 1:num_frames
    instance_numbers_with_ref_frame{frame_num} = [];
    for instance_num = 1:num_instances
        if strcmp(unambiguous_ref_frames{instance_num}.thisframe, masterframes.framenames{frame_num})
            instance_numbers_with_ref_frame{frame_num}(end+1) = instance_num;
        end
    end
end

stats.all_instances = collect_stats_for_frames(masterframes, predicted_frames, unambiguous_ref_frames, ambiguous_ref_frames, Fbeta);
for frame_num = 1:num_frames
    if ~isempty(ambiguous_ref_frames)
        stats.ref_frame{frame_num} = collect_stats_for_frames(masterframes, predicted_frames(instance_numbers_with_ref_frame{frame_num}), unambiguous_ref_frames(instance_numbers_with_ref_frame{frame_num}), ambiguous_ref_frames(instance_numbers_with_ref_frame{frame_num}), Fbeta);
    else
        stats.ref_frame{frame_num} = collect_stats_for_frames(masterframes, predicted_frames(instance_numbers_with_ref_frame{frame_num}), unambiguous_ref_frames(instance_numbers_with_ref_frame{frame_num}), {}, Fbeta);
    end
end