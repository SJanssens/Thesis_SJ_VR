% finds label activations using NMF for one or multiple acoustic representations
% this is the most basic version: it does not support multiple W models
%
% input
% 1) acfeatmat - acoustic representation of the utterance (one or multiple
% frames). MxN dimensional: M features, N representations
% 2) NMF_params - contains the rained NMF models
% 3) conf - containing NMF decoding settings
% output
% 1) labelmat - a matrix containing the found labels. LxM dimensional - L
% labels for N representations in acfeatmat
% NOTE: no cleaning  up has been done on this! Thats up to the label2frame
% conversion


function [labelmat,activations] = do_NMF_recog(acfeatmat,NMF_params,conf)
nmfmodelnum=conf.settingconf.NMF_params.nummodels;
computetype = conf.settingconf.computetype;

if nmfmodelnum==1
    
    label_dictionary =  NMF_params.W_label{nmfmodelnum};
    acfeat_dictionary = NMF_params.W_acfeat{nmfmodelnum};
    
    acfeatmat = acfeatmat(~NMF_params.remove_acfeats_indices,:); % remove the unused features from the acoustic features
    
    
    activations=nmfHdivs(sparse(acfeatmat),acfeat_dictionary,[],[],computetype); % calculate activations

    labelmat = label_dictionary*activations; % calculate labelvec
    
else
    
    if length(conf.settingconf.NMF_params.seed) < NMF_params.nummodels % not enough seeds for the desired number of models
        disp(['ERROR: Not enough seeds available (' num2str(length(conf.settingconf.NMF_params.seed)) ') for the desired number of NMF models (' num2str(NMF_params.nummodels) ')'])
        return
    end
    
    for nmfmodelnum=1:conf.settingconf.NMF_params.nummodels
        
        acfeat_dictionary = NMF_params.W{modelnum}(NMF_params.numlabels+1:end,:); % the part of the dictionary (W) pertaining to acoustic features
        label_dictionary = NMF_params.W{modelnum}(1:NMF_params.numlabels,:); % the part of the dictionary (W) pertaining to labels
        acfeatmat = acfeatmat(~NMF_params.remove_acfeats_indices,:); % remove the unused features from the acoustic features
        
        activations=nmfHdivs(sparse(acfeatmat),acfeat_dictionary,[],[],computetype); % calculate activations
        
        labelmat{modelnum} = label_dictionary*activations; % calculate labelvec
    end
end