% Train a HMM. This code needs *serious* cleaning up
function HMM_params = train_HMM_params(train_acfeatcell_windowed,labelcell_train,NMF_params,masterframes,conf)
    % local parameters
    use_NMF_basisatoms=true;
    use_NMF_obsprob_DST = false; % use KL-HMM like distance decoding 
    update_E=1; % update E or keep it fixed (uses NMF best guess)
    offset = 1.0e-300; % small number to prevent zero values
   
    % calculate window-based observation probs
    Yprob_seqs = calculate_obsprob_NMF(train_acfeatcell_windowed,NMF_params,use_NMF_basisatoms,use_NMF_obsprob_DST,conf);
    
    % set up initial transition matrix
    [connectedSV.bigram,connectedSV.node2labelvec,connectedSV.startnodes,connectedSV.endnodes,connectedSV.grammars] = make_connected_slotvalue_transitions_v3(masterframes);
    
    num_sts=size(connectedSV.bigram,1);
    
    % find state constraints from NMF-supervision
    state_constraint = sum(labelcell_train,2)>0; % states with non-zero usage
    
    % modify: use-slot constraints rather than state-constraints (if
    % you have seen any value of a slot, dont remove unseen values of
    % that slot)
    SV2S_mapping = masterframes.SV2S_mapping;
    state_constraint = (SV2S_mapping*SV2S_mapping'*state_constraint)>0;
    
    % ------------- initialise transition (transmat) matrix ------------------
    
    transmat=sparse(connectedSV.bigram); % make it sparse
    
    % modify: states that never occur cannot have transitions
    transmat(~state_constraint,:)=0; % dont allow transitions from states that are not in this sentence
    transmat(:,~state_constraint)=0; % dont allow transitions to states that are not in this sentence
    
    % ------- eligable end states -------
    % binary vector - 1 means eligable state
    endnodes=zeros(num_sts,1);
    endnodes(connectedSV.endnodes)=1;
    
    % modify: states that never occur cannot be end states
    endnodes(~state_constraint)=0;
    
    
    % ---- initial state probs ----
    
    % form initial states
    stateindexlist=zeros(1,num_sts);
    prior= stateindexlist;
    prior(connectedSV.startnodes)=1/length(connectedSV.startnodes);
    prior_tmp = prior;
    
    % modify: states that never occur cannot be start states
    prior_tmp(~state_constraint)=0;
    prior_tmp=prior_tmp/sum(prior_tmp);
    
    % -------- intitial emission probs ---------
    emissionmatinit=NMF_params.W_label{1}'; % matrix with dimensions <num_of_atoms> x <num_of_states>
    
    emissionmatinit=emissionmatinit+conf.settingconf.hmm.Einit_NMF_rand_weight*rand(size(emissionmatinit));%  possibly regularised with random numbers
    emissionmatinit=bsxfun(@rdivide,emissionmatinit,sum(emissionmatinit)); % normalise
    emissionmat = emissionmatinit;
    
    
    
    % --------------- set up transition sharing -----------------------
    transition_share_matrix = SV2S_mapping;

    
    % %%% Baum-Welsh tuning of the parameters: transmat,emissionmat
    
    for idx_hmmpass = 1:conf.settingconf.hmm.num_bwpass
        if idx_hmmpass > 1
            [prior,emissionmat,transmat] = normalize_HMM(prior_tmp,emissionmat_tmp,T_tmp,offset);
        end
        
        % calculate posteriors
        Ypost_seqs = calculate_posteriors_v2(Yprob_seqs,emissionmat,labelcell_train);
        
        [T_tmp,prior_tmp,emissionmat_tmp,ll] = bwx_ypost_v4_sparse_endnodes_sharingv2(Ypost_seqs,Yprob_seqs,transmat,transmat,prior,emissionmat,conf.settingconf.hmm.T_sparsity,[1 1 update_E],endnodes,state_constraint,transition_share_matrix);
        
        totCost = sum(ll);
        if conf.settingconf.verbose % optional output
            disp(['BW-EM pass ' num2str(idx_hmmpass) ' log-likelihood: ' num2str(totCost)]);
        end        
    end
    
 
    % final normalisation step
    [prior,emissionmat,transmat] = normalize_HMM(prior_tmp,emissionmat_tmp,T_tmp,offset);
    
    % assign to output struct
    HMM_params.prior = prior;
    HMM_params.emissionmat = emissionmat;
    HMM_params.transmat = transmat;
    HMM_params.endnodes = endnodes;
    