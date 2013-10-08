function [masterframes,dataset,sharingdata]=remove_slotvalues(masterframes,dataset,sharingdata,traintestfolds,conf)

    if conf.settingconf.verbose % optional output
        disp(['Removing ' num2str(length(traintestfolds.slotvalues_to_remove)) ' slotvalues'])
    end         

    % masterframes
    masterframes = change_masterframe(traintestfolds.slotvalues_to_remove,masterframes); % depending on the settings, we may wish to remove some entries from the masterframes
    masterframes = extend_masterframes(masterframes); % re-append masterframes with stats, conversion tables, etc
    
    % sharingdata
    sharingdata.identity_words=sharingdata.identity_words(:,traintestfolds.slotvalues_to_retain);
    sharingdata.word_sharings_matrix=sharingdata.word_sharings_matrix(traintestfolds.slotvalues_to_retain,:);
    sharingdata.word_sharings_matrix=sharingdata.word_sharings_matrix(:,traintestfolds.slotvalues_to_retain);

    % dataset
    nb_files = length(dataset);
    
    for filenum=1:nb_files, % loop over filenames
        labelvec_data = dataset(filenum).labelvecs;
        
        structfields=fields(labelvec_data); % get fields
    
        for fieldnum=1:length(structfields) % loop over fields
            fieldname = structfields{fieldnum}; % get current field name

            % process in the labelvec domain    
            labelvec = labelvec_data.(fieldname).labelvec; % old data
            new_labelvec = labelvec(traintestfolds.slotvalues_to_retain); % remove entries
            
            % now use adapted masterframes to convert back to frames
            framedesc = convert_labelvec2frame(new_labelvec,masterframes,true); % database specific routine that loads the frame description of this utterance (allow ambigious frames)

            % assign new data
            dataset(filenum).labelvecs.(fieldname).labelvec = new_labelvec;
            dataset(filenum).framedescs.(fieldname).framedesc = framedesc{1};
        end
    end
            