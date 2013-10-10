function traintestfolds = make_traintestfolds(dataset,masterframes,sharingdata,conf) % high level function to create folds struct
    
    frametype = conf.settingconf.expconf.frametype;
    
    labelmat_orig = cell2mat(arrayfun(@(x) x.labelvecs.(frametype).labelvec,dataset,'UniformOutput',false));
        
    if conf.settingconf.expconf.usesharing
        %labelmat = double(sharingdata.identity_words*sharingdata.word_sharings_matrix*labelmat_orig>0);
        labelmat = sharingdata.identity_words*sharingdata.word_sharings_matrix*labelmat_orig;
    else
        labelmat = labelmat_orig;
    end
    
    [blocks,slotvalues_to_remove,utterances_to_remove]=make_blocks(labelmat, conf); % create blocks
     
    % crappy code to correct indices, in slotvalue terms
    if conf.settingconf.expconf.usesharing
        newL_logical = ones(size(sharingdata.identity_words,1),1);
        newL_logical(slotvalues_to_remove)=0;
        L_logical = sharingdata.identity_words'*newL_logical;
        slotvalues_to_remove=find(L_logical==0);
    end

   
    % restate the removal in terms of what to keep
    slotvalues_to_retain = setdiff(1:size(labelmat_orig,1),slotvalues_to_remove);
    utterances_to_retain = setdiff(1:length(dataset),utterances_to_remove);

    % mapping to recast indices that were removed to new indexing
    mapping_vec = zeros(1,length(dataset));
    mapping_vec(utterances_to_retain)=1:length(utterances_to_retain);
   
 
    % apply utterances to remove to blocks
    for blocknum=1:length(blocks)
        blocks{blocknum}=mapping_vec(setdiff(blocks{blocknum},utterances_to_remove,'stable'));
    end    
    
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % in the following, code, blocks and train-test sets are
    % created with utterance numbers (according filelist) and
    % these utterance numbers also correspond to the column
    % indexes of acfeatmat_NMF and labelmat_NMF above
    seed = conf.settingconf.expconf.randomseedcrossval;
    n_experiment = conf.settingconf.expconf.n_experiment;
    [train_utterance_block,test_utterance_block,train_blocks,test_blocks]=create_incremental_training_blocks(seed, blocks, conf.settingconf.expconf.blockstep_array, n_experiment);

    
    % assign data we actually need
    traintestfolds.utterances_to_remove = utterances_to_remove;
    traintestfolds.utterances_to_retain = utterances_to_retain;
    
    traintestfolds.slotvalues_to_remove = slotvalues_to_remove;
    traintestfolds.slotvalues_to_retain = slotvalues_to_retain;
    
    traintestfolds.train_utterance_block = train_utterance_block;
    traintestfolds.test_utterance_block = test_utterance_block;