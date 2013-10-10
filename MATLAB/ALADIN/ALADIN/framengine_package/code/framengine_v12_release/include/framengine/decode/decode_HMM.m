function predicted_frame=decode_HMM(featmat,NMF_params,HMM_params,masterframes,conf)
    % local parameters
    use_NMF_basisatoms=true;
    use_NMF_obsprob_DST = false; % use KL-HMM like distance decoding 

    % init
    prior = HMM_params.prior;
    transmat = HMM_params.transmat;
    emissionmat = HMM_params.emissionmat;
    endnodes = HMM_params.endnodes;
    
    num_sts = size(transmat,1);
    diagmat_states=eye(num_sts);    
    
    %preparation HMMs:
    Yprob = calculate_obsprob_NMF(featmat,NMF_params,use_NMF_basisatoms,use_NMF_obsprob_DST,conf); % observations are now predicted labels from NMF in a sliding window
    logB = calculate_posteriors_v2(Yprob,emissionmat,[]); % convert to HMM state probs using a 'soft' (interpolating) discrete HMM
    
    %Viterbi HMM
    HMM_path = hmmViterbiC_endnodes(log(prior), log(transmat),log(logB),endnodes);
    slot_value_activations_HMM = diagmat_states(:,HMM_path);
    
    if conf.settingconf.hmm.use_decoding_probs
        slot_value_activations_HMM = logB.*slot_value_activations_HMM;
    end
    
    labelvec_HMM = sum(slot_value_activations_HMM,2); % time average (sum)
    framedesc_HMM = convert_labelvec2frame(labelvec_HMM(1:masterframes.numvalues),masterframes);
    predicted_frame= framedesc_HMM{1};
    
    