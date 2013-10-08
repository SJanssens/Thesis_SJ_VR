% This function does the actual NMF training
% It solves the problem V=W*H
% With V an matrix containing the acoustic information together with the
% grounding info, W the dictionary capturing the patterns, and the
% accompanying word-association data, and H the activations of the W matrix
%
% input
% 1) acfeatmat: NxM dimensional matrix, with N acoustic feature representations (GMM,VQ, etc) from M utterances
% 2) labelmat: KxM dimensional matrix, with K (binary) labels describing the frame/slots of each M utterances
% 3) conf, containing NMF_param settings
% output
% 1) NMF_params, a struct containing
% .remove_acfeats_indices - indices of acfeat [1,M] that contain acoustic features for which there was no training data
% .numtraindata - the number of utterances (M) used (in the end) for NMF training
% .info - date and time when learning the model
% .nummodels - the number of NMF models (equivalent up to different initialisation)
% .seed{..} - the seed for the random number generator used for initialisation for each model
% .W{..} - contains the trained W matrix (the NMF pattern model)

function [NMF_params] = train_NMF_params(acfeat_input,label_input,conf)

computetype = conf.settingconf.computetype;

% -- handle both matrix and cell input
if iscell(acfeat_input)
    acfeatmat=cell2mat(acfeat_input);
else
    acfeatmat = acfeat_input;
end

if iscell(label_input)
    labelmat=cell2mat(label_input);
else
    labelmat = label_input;
end


% local variables (dont know how critical)
Hinit_randoffset=0.1;
Hinit_randscale=1e-4;
Winit_randoffset=0.2;
Winit_randscale=1e-4;

% check for and remove unused acoustic features
NMF_params.remove_acfeats_indices = (sum(acfeatmat,2)==0); % indices of acoustic features that have not been seen during training - cannot be trained
acfeatmat = acfeatmat(~NMF_params.remove_acfeats_indices,:); % remove the features from the acoustic features


% store info
NMF_params.info =  datestr(now); % current date and time
NMF_params.nummodels = conf.settingconf.NMF_params.nummodels; % get number of NMF models from config
NMF_params.numiters = conf.settingconf.NMF_params.numiters; % number of NMF iterations
NMF_params.numlabels = size(labelmat,1); % number of labels in labelmat
NMF_params.nonzero_label_indices = find(sum(labelmat,2)~=0); % indices of existing labels in data
NMF_params.numWlabels = length(NMF_params.nonzero_label_indices); % number of labels used in training W

for nmfmodelnum=1:NMF_params.nummodels % loop over number of models we'll create
    
    
    if isfield(conf.settingconf.NMF_params,'fixedseeds')
        rng('default');
        rng(conf.settingconf.NMF_params.fixedseeds(nmfmodelnum));
    else
        NMF_params.seed{nmfmodelnum}=sum(66*clock); % get random seed; store it
        rand('state',NMF_params.seed{nmfmodelnum}); % apply random seed
    end
    
    % check for utterances that do not have acoustic or label information
    train_ndx=(sum(acfeatmat,1)>0 & sum(labelmat,1)>0); % indices of files (columns) with label AND acfeat values
    labelmat=labelmat(:,train_ndx); % apply the indices to labelmat
    acfeatmat=acfeatmat(:,train_ndx); % apply the indices to labelmat
    NMF_params.numtraindata = size(acfeatmat,2);
    
    % store info
    NMF_params.NMFtype = 'singlepass';
    NMF_params.numWcol_per_label = min(sum(labelmat,2),conf.settingconf.NMF_params.numWcol_per_label);  % conf.settingconf.NMF_params.numWcol_per_label is an integer > 0 which tells us how many W columns we want to use to model each label. This is an upper limit: the maximum number of W columns is the number of times it appears as an observation in labelmat
    NMF_params.numWlabelcol = sum(NMF_params.numWcol_per_label); % the number of W columns corresponding to content words
    NMF_params.numWgarbagecol = floor(size(labelmat,1) * conf.settingconf.NMF_params.numgarbageWcol); % the number of garbage columns is a fraction of the number of labels (content-words)
    NMF_params.numWcol = NMF_params.numWlabelcol + NMF_params.numWgarbagecol;
    
    % convert NMF_params.numWcol_per_label to a representation in which label
    % indices are repeated an appropriate number of times. For example, for
    % numlabels=4 and conf.settingconf.NMF_params.numWcol_per_label=2:
    % NMF_params.numWcol_per_label = [2 2 2 2]
    % Wlabel_indices = [1 1 2 2 3 3 4 4]
    Wlabel_indices = zeros(1,sum(NMF_params.numWcol_per_label));
    indexnum=1; % keep track of position in Wlabel_indices
    for labelnum=1:length(NMF_params.numWcol_per_label); % loop over classes
        Wlabel_indices(indexnum:indexnum+NMF_params.numWcol_per_label(labelnum)-1)=labelnum; % assign the label index to the correpsonding index
        indexnum=indexnum+NMF_params.numWcol_per_label(labelnum); % update index to new start position
    end
    
    % normalise the weight of the acfeat mat so its comparable to the labelmat
    acfeatmat=acfeatmat*sum(labelmat(:))/sum(acfeatmat(:));
    
    % construct V matrix
    Vtrain=[labelmat(NMF_params.nonzero_label_indices,:) ; acfeatmat];
    
    
    
    % construct H matrix
    if isfield(conf.settingconf.NMF_params,'Winit_numvalue_association') % is initital W described (for sharing)?
        Hinit_label = conf.settingconf.NMF_params.Winit_numvalue_association*full(labelmat); % map to the sharing association through multiplication
        Hinit_label = Hinit_label(Wlabel_indices,:); %  repeat the labelmat as many times as needed to satisfy NMF_params.numWcol_per_label
    else % use default
        Hinit_label =  full(labelmat(Wlabel_indices,:)); %  repeat the labelmat as many times as needed to satisfy NMF_params.numWcol_per_label
    end
    Hinit_label = Hinit_label + Hinit_randscale*rand(size(Hinit_label)); % use the (perturbed) labelmat as initialisation;
    Hinit_garbage = rand(NMF_params.numWgarbagecol,NMF_params.numtraindata)+Hinit_randoffset; %  use random intialisation for garbage columns;
    Hinit=[Hinit_label; Hinit_garbage];
    Hinit=full(bsxfun(@times,Hinit,sum(Vtrain,1)./sum(Hinit,1))); % normalisation
    
    % construct W matrix
    if isfield(conf.settingconf.NMF_params,'Winit_numvalue_association') % is initital W described (for sharing)?
        Wlabelmat_content = conf.settingconf.NMF_params.Winit_numvalue_association;
    else % use default
        Wlabelmat_content = eye(NMF_params.numlabels); % init as identity matrix
    end
    Wlabelmat_content = Wlabelmat_content(:,Wlabel_indices); % repeat the initial labelmat as many times as needed for each label to satisfy NMF_params.numWcol_per_label
    Wlabelmat_content = Wlabelmat_content + Winit_randscale*rand(size(Wlabelmat_content)); % add some random noise to content init
    Wlabelmat_garbage = rand(NMF_params.numlabels,NMF_params.numWgarbagecol)+Winit_randoffset; % garbage columns are purely randomly intialized
    Wlabelmat = [Wlabelmat_content Wlabelmat_garbage]; % top of W init consists of the part associated with classes (content) and filler words (garbage)
    Wlabelmat = Wlabelmat(NMF_params.nonzero_label_indices,:); % now remove rows pertaining to always-zero labels
    Winit = [Wlabelmat ; rand(size(Vtrain,1)-NMF_params.numWlabels,NMF_params.numWcol)+Winit_randoffset]; % Initial W is formed by top-level initial labels and bottom-level initial acoustic features
    Winit=bsxfun(@rdivide,Winit,sum(Winit,1)); % normalisation
    
    %switch conf.settingconf.computetype
    %    case 0 % use CPU
    
    [W,H]=nmfdivs_sa_em(sparse(Vtrain), NMF_params.numWcol, zeros(1,NMF_params.numiters),Winit, Hinit,computetype); % call MU for NMF learning; zeros(1,NMF_params.numiters) indicates a (turned of) simmulated annealing, resulting in NMF_params.numiters iterations
    
    %    case 1
    % not implemented yet
    %    case 2
    % not implemented yet
    %end
    
    W_label = zeros(NMF_params.numlabels,NMF_params.numWcol); % initialize to original labelsize
    W_label(NMF_params.nonzero_label_indices,:) = W(1:NMF_params.numWlabels,:); % the part of the dictionary (W) pertaining to labels
    W_acfeat = W(NMF_params.numWlabels+1:end,:); % the part of the dictionary (W) pertaining to acoustic features
    
end
% store model
NMF_params.W_label{nmfmodelnum} = W_label;
NMF_params.W_acfeat{nmfmodelnum} = W_acfeat;
