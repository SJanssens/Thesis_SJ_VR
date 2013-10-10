clear;

% --------------------------- database settings -------------------------
%databases = {'domotica_2','patience'};
databases = {'patience'};
for database_num=1:length(databases)
    database_name = databases{database_num}
    
    %  ---------- TODO TODO TODO TODO TODO TODO TODO ---------
    if strcmp(database_name,'patience')
        speakeridlist=[1];
        %speakeridlist=[1 3 4 6 7 8 9 10];
    elseif strcmp(database_name,'domotica_2')
        %speakeridlist=[11 17 28:35  37 40:48];
        speakeridlist=[11 17 29 31 34 35 41 45];
    end
    %  ---------- TODO TODO TODO TODO TODO TODO TODO ---------
    
    %% --------------------------------------------------------------------------------
    % ------------------------------ start program ------------------------------------
    % ---------------------------------------------------------------------------------
    
    for speakerid_index=1:length(speakeridlist)
        speakerid = speakeridlist(speakerid_index);
        
        disp(['-----------------------------------------------------'])
        disp(['-------- starting speaker: pp' num2str(speakerid) ' ---------'])
        disp(['-----------------------------------------------------'])
        
        %% --------------------------- local configuration ---------------------------
        
        conf=getconfigs; % get global configuration
        addpath(fullfile('databases',database_name,'code')); % add the directory containing the database-specific codes
        conf = getconfigs_database(conf,speakerid); % add settings to conf that are database dependent
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% --------------------------- load masterframes ---------------------------
        
        masterframes = load_masterframes(conf); % load masterframes for this database
        masterframes = extend_masterframes(masterframes); % append masterframes with stats, conversion tables, etc (database independent)
        
        % --------------------------- load slotvalue word sharing ---------------------------
        % Note: while (for now) the code expects these to exist, identity matrices can be used instead for no sharing. See the code in domotica_2
        [sharingdata.word_sharings_matrix, sharingdata.identity_words]=load_word_sharings_matrix(masterframes);
        
        % --------------------------- load all data for this speaker ---------------------------
        % Note: If you dont have enough memory for this, and/or have specific test/train data,
        % you could split up the train and test file loading
        
        savefilename = fullfile(conf.dirconf.datadir,['dataset_pp' num2str(speakerid) '.mat']);
        if ~exist(savefilename,'file') % only load the data if we didnt save it
            if conf.settingconf.verbose % optional output
                disp(['Loading data for speaker: ' num2str(speakerid)])
            end
            
            dataset = load_dataset(masterframes,conf); % high-level function which loops over files and loads data
            
            if conf.settingconf.savedata % if we specified we want to save data
                save(savefilename,'dataset');
            end
        else
            if conf.settingconf.verbose % optional output
                disp(['Loading data for speaker ' num2str(speakerid) ' from matlab save file'])
            end
            load (savefilename,'dataset'); % load from .mat file
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        %% --------------------------- Partition the dataset in test/train folds ---------------------------
        % Note: if you have a specific train/test partitioning, either load two seperate datasets using
        % load_dataset (with specific filenames), or partition the train/test data by subindexing dataset{} as below
        
        savefilename = fullfile(conf.dirconf.datadir,['traintestfolds_pp' num2str(speakerid) '.mat']);
        if ~exist(savefilename,'file')
            if conf.settingconf.verbose % optional output
                disp(['Creating train/test partitions for speaker: ' num2str(speakerid)])
            end
            
            traintestfolds = make_traintestfolds(dataset,masterframes,sharingdata,conf); % high level function to create folds struct
            
            if conf.settingconf.savedata % if we specified we want to save data
                save(savefilename,'traintestfolds');
            end
        else
            if conf.settingconf.verbose % optional output
                disp(['Loading train/test partitions for speaker: ' num2str(speakerid)])
            end
            load(savefilename,'traintestfolds');
        end
        
        
        % --- Based on these folds, we may not use some slotvalues and/or utterances at all -----
        if ~isempty(traintestfolds.utterances_to_remove) % if some utterances are not used
            dataset=dataset(traintestfolds.utterances_to_retain); % retain the others
        end
        
        if ~isempty(traintestfolds.slotvalues_to_remove) % if some slotvalues are not used
            [masterframes,dataset,sharingdata]=remove_slotvalues(masterframes,dataset,sharingdata,traintestfolds,conf); % complex procedure to remove slotvalues
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% ------------------------ train intermediate acoustic representation (VQ,GMM, etc) --------------
        % Note: for online methods (meaning that they only see the training data in the current fold) this needs to move to inside the training for-loop
        savefilename = fullfile(conf.dirconf.datadir,['acfeatparams_pp' num2str(speakerid) '_' conf.settingconf.specfeat.method '_' conf.settingconf.acfeat_params.acmethod  '.mat']);
        if ~exist(savefilename,'file')
            if conf.settingconf.verbose % optional output
                disp('Training intermediate acoustic representation...')
                disp(['   Method = ' conf.settingconf.acfeat_params.acmethod])
                disp(['   Spectral representation = ' conf.settingconf.specfeat.method])
            end
            
            [acfeat_params] = train_acfeat_params([dataset.specfeat],conf); % make a model for the acoustic features (VQ,GMM,SRs,etc)
            
            if conf.settingconf.savedata % if we specified we want to save data
                save(savefilename,'acfeat_params')
            end
        else
            if conf.settingconf.verbose % optional output
                disp('Loading model of intermediate acoustic representation')
            end
            load(savefilename,'acfeat_params')
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% ------------------------ Create intermediate acoustic representation (VQ,GMM, etc) --------------
        % Note: this can also be done within the train/test folds (and *needs* to be, for online versions). But this saves time.
        
        savefilename = fullfile(conf.dirconf.datadir,['intfeat_pp' num2str(speakerid) '_' conf.settingconf.specfeat.method '_' conf.settingconf.acfeat_params.acmethod '.mat']);
        if ~exist(savefilename,'file')
            if conf.settingconf.verbose % optional output
                disp('Creating intermediate acoustic representations...')
            end
            
            intfeatcell=convert_specfeat2intfeat([dataset.specfeat],acfeat_params,conf); % convert all spectrographic features at once
            
            if conf.settingconf.savedata % if we specified we want to save data
                save(savefilename,'intfeatcell')
            end
        else
            if conf.settingconf.verbose % optional output
                disp('Loading intermediate acoustic representations')
            end
            load(savefilename,'intfeatcell')
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% ------------------------ Create final acoustic representation (co-occurance features) --------------
        % Note: this can also be done within the train/test folds (and *needs* to be, for online versions). But this saves time.
        
        savefilename = fullfile(conf.dirconf.datadir,['acfeat_pp' num2str(speakerid) '_' conf.settingconf.acfeat.timemethod '.mat']);
        if ~exist(savefilename,'file')
            if conf.settingconf.verbose % optional output
                disp('Creating co-occurance acoustic representations...')
            end
            
            acfeatcell = convert_intfeat2acfeat(intfeatcell,false,conf); % per-utterance based acoustic features
            acfeatcell_windowed = convert_intfeat2acfeat(intfeatcell,true,conf); % sliding window based acoustic features
            
            if conf.settingconf.savedata % if we specified we want to save data
                save(savefilename,'acfeatcell','acfeatcell_windowed')
            end
        else
            if conf.settingconf.verbose % optional output
                disp('Loading co-occurance acoustic representations')
            end
            load(savefilename,'acfeatcell','acfeatcell_windowed')
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% ------------------------ Start loops over train/test folds --------------
        for fold=1:size(traintestfolds.train_utterance_block,1)
            for subexp=1:size(traintestfolds.train_utterance_block,2)
                
                resultfile=fullfile(conf.dirconf.results,['results_pp' num2str(speakerid) '_fold' num2str(fold) '_subexp'  num2str(conf.settingconf.expconf.blockstep_array(subexp)) '.mat']);
                if ~exist(resultfile) % only do this experiment if there isnt an exisiting result for it yet
                    
                    %% --------------------------- select subset of data for training -----------------------
                    train_dataset = dataset(traintestfolds.train_utterance_block{fold,subexp});
                    train_acfeatcell = acfeatcell(traintestfolds.train_utterance_block{fold,subexp});
                    train_acfeatcell_windowed = acfeatcell_windowed(traintestfolds.train_utterance_block{fold,subexp});
                    
                    % construct supervision matrices
                    supervisiontype = conf.settingconf.frame.supervision_type; % Type of frame supervision. local assignment for readability
                    labelmat = cell2mat(arrayfun(@(x) x.(supervisiontype).labelvec,[train_dataset.labelvecs],'Uniformoutput',false));
                    %labelmat_shared = double(sharingdata.word_sharings_matrix*labelmat>0); % retain size but share entries
                    labelmat_shared = sharingdata.word_sharings_matrix*labelmat; % retain size but share entries
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    %% --------------------------- training phase one: utterance-based ----------------------
                    % train NMF
                    savefilename = fullfile(conf.dirconf.datadir,['NMFparams_pp' num2str(speakerid) '_fold' num2str(fold) '_subexp'  num2str(conf.settingconf.expconf.blockstep_array(subexp)) '.mat']);
                    if ~exist(savefilename,'file')
                        if conf.settingconf.verbose % optional output
                            disp('Training utterance-based non-negative matrix factorisation (NMF) models...')
                        end
                        
                        NMF_params        = train_NMF_params(train_acfeatcell,labelmat,conf);
                        NMF_params_shared = train_NMF_params(train_acfeatcell,labelmat_shared,conf);
                        
                        if conf.settingconf.savedata % if we specified we want to save data
                            save(savefilename,'NMF_params','NMF_params_shared')
                        end
                    else
                        if conf.settingconf.verbose % optional output
                            disp('Loading utterance-based non-negative matrix factorisation (NMF) models')
                        end
                        load(savefilename,'NMF_params','NMF_params_shared')
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    %% --------------------------- training phase two: window-based -------------------------
                    % train HMM
                    savefilename = fullfile(conf.dirconf.datadir,['HMMparams_pp' num2str(speakerid) '_fold' num2str(fold) '_subexp'  num2str(conf.settingconf.expconf.blockstep_array(subexp)) '.mat']);
                    if ~exist(savefilename,'file')
                        if conf.settingconf.verbose % optional output
                            disp('Training HMM models...')
                        end
                        
                        % Note: One alternative is using labelmat_shared instead of labelmat
                        HMM_params        = train_HMM_params(train_acfeatcell_windowed,labelmat,NMF_params,masterframes,conf);
                        HMM_params_shared = train_HMM_params(train_acfeatcell_windowed,labelmat,NMF_params_shared,masterframes,conf);
                        
                        if conf.settingconf.savedata % if we specified we want to save data
                            save(savefilename,'HMM_params','HMM_params_shared')
                        end
                    else
                        if conf.settingconf.verbose % optional output
                            disp('Loading HMM models')
                        end
                        load(savefilename,'HMM_params','HMM_params_shared')
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    %%  ----------- Testing phase: loop over test files -----------------------------------------
                    % --------------------------- select subset of data for training --------------------
                    test_dataset = dataset(traintestfolds.test_utterance_block{fold,subexp});
                    test_acfeatcell = acfeatcell(traintestfolds.test_utterance_block{fold,subexp});
                    test_acfeatcell_windowed = acfeatcell_windowed(traintestfolds.test_utterance_block{fold,subexp});
                    
                    numsentences=length(traintestfolds.test_utterance_block{fold, subexp});
                    
                    savefile=fullfile(conf.dirconf.datadir,['predictedframes_pp' num2str(speakerid) '_fold' num2str(fold) '_subexp'  num2str(conf.settingconf.expconf.blockstep_array(subexp)) '.mat']);
                    if  ~exist(savefile,'file')
                        if conf.settingconf.verbose % optional output
                            disp(['Testing fold ' num2str(fold) ' subexperiment ' num2str(subexp) '...'])
                        end
                        
                        % initialize output frame descriptions
                        predicted_frames_NMF=cell(1,numsentences);
                        predicted_frames_HMM=cell(1,numsentences);
                        
                        % loop over sentences
                        for sentencenum=1:numsentences
                            
                            
                            % NMF decoding (some alternatives commented out)
                            predicted_frames_NMF{sentencenum}=decode_NMF(test_acfeatcell_windowed{sentencenum},NMF_params,masterframes,conf);
                            %predicted_frames_NMF{sentencenum}=decode_NMF(test_acfeatcell_windowed,NMF_params,masterframes,conf);
                            %predicted_frames_NMF{sentencenum}=decode_NMF(test_acfeatcell_windowed,NMF_params_shared,masterframes,conf);
                            
                            % HMM decoding (some alternatives commented out)
                            predicted_frames_HMM{sentencenum}=decode_HMM(test_acfeatcell_windowed{sentencenum},NMF_params,HMM_params,masterframes,conf);
                            %predicted_frames_HMM{sentencenum}=decode_HMM(test_acfeatcell_windowed{sentencenum},NMF_params,HMM_params,masterframes,conf);
                            
                            % ------------------------------ display ------------------------
                            if conf.settingconf.verbose
                                disp(['------------ file nr: ' num2str(sentencenum) ' ------------------'])
                                disp(['transcription: ' test_dataset(sentencenum).sentence_stringdesc])
                                
                                % display NMF result (empty means dealcard)
                                predicted_frames_NMF{sentencenum}.data
                                
                                % display HMM result (empty means dealcard)
                                predicted_frames_HMM{sentencenum}.data
                                
                            end
                            
                        end
                        
                        if conf.settingconf.savedata % if we specified we want to save data
                            save(savefile,'predicted_frames_NMF','predicted_frames_HMM');
                        end
                    else
                        load(savefile)
                    end
                    
                    %% ------------------------------ scoring ----------------------------------------------
                    unambiguous_ref_frames = arrayfun(@(x) x.framedescs.(conf.settingconf.frame.evaluation_type).framedesc,test_dataset,'Uniformoutput',false);
                    stats.stats_NMF = collect_stats_for_frames(masterframes, predicted_frames_NMF, unambiguous_ref_frames);
                    stats.stats_HMM = collect_stats_for_frames(masterframes, predicted_frames_HMM, unambiguous_ref_frames);
                    
                    
                    %                 unambiguous_ref_frames = arrayfun(@(x) x.framedescs.oracleaction.framedesc,test_dataset,'Uniformoutput',false);
                    %                 ambiguous_ref_frames = arrayfun(@(x) x.framedescs.oraclecommand.framedesc,test_dataset,'Uniformoutput',false);
                    %                 stats.stats_NMF = collect_stats_for_frames(masterframes, predicted_frames_NMF, unambiguous_ref_frames,ambiguous_ref_frames);
                    %                 stats.stats_HMM = collect_stats_for_frames(masterframes, predicted_frames_HMM, unambiguous_ref_frames,ambiguous_ref_frames);
                    
                    
                    scores.score_NMF(fold,subexp)=stats.stats_NMF.scores_structs{1}.global.slotvalue_level_scores.micro_Fscore*100; % contains the score of each validation sets for each NMF intialization
                    scores.score_HMM(fold,subexp)=stats.stats_HMM.scores_structs{1}.global.slotvalue_level_scores.micro_Fscore*100; % contains the score of each validation sets for each NMF intialization
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    % ------- display -------
                    if conf.settingconf.verbose
                        disp(['F-score NMF: ' num2str(scores.score_NMF(fold,subexp))  ' %'])
                        disp(['F-score HMM: ' num2str(scores.score_HMM(fold,subexp))  ' %'])
                    end
                    
                    % ------- saving -------
                    save(resultfile,'scores','stats'); % intermediate saving
                else
                    load(resultfile,'scores','stats'); % load intermediate saving so we can append next result
                end % end if exist resultfile
            end % end block
        end %end fold
        
        %% ------------------------ display results for speaker ------------------------------------------------
        disp(['Averaged results for speaker ' num2str(speakerid) ' for increasing numbers of training blocks'])
        disp(['F-score NMF: ' num2str(mean(scores.score_NMF))])
        disp(['F-score HMM: ' num2str(mean(scores.score_HMM))])
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end % end speaker loop
end % end database

