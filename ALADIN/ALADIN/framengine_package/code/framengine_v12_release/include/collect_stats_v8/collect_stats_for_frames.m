function stats = collect_stats_for_frames(masterframes, predicted_frames, unambiguous_ref_frames, varargin)

%-------------------------------------------------------------------------------------------------
% Collects stats for all instances in the frame arrays that are given as input arguments:
% an array of predicted frames, an array of unambiguous reference frames (one value per slot) 
% and optionally an array of ambiguous reference frames (one or more values per slot).
% The input argument 'masterframes' contains the general structures of the frames that are used.
% The function first restructures the instances, then it makes confusion matrices, and finally
% it computes scores based on those confusion matrices.
%-------------------------------------------------------------------------------------------------
% Optional arguments(varargin): {ambiguous_ref_frames, Fbeta}
% - Fbeta is the value of beta for computing the F-score
%-------------------------------------------------------------------------------------------------

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

stats.instances_for_confmats = collect_instances_for_confmats(masterframes, predicted_frames, unambiguous_ref_frames, ambiguous_ref_frames);
stats.confmat_structs = make_confmats(stats.instances_for_confmats);
stats.scores_structs = compute_scores(stats.confmat_structs, Fbeta);

