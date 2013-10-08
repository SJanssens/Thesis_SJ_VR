function dataset = load_dataset(masterframes,conf)
    
    [fnames,nb_files] = getfilenames(conf); % get the filelist from the file mentioned in conf
    
    for filenum=1:nb_files, % loop over filenames
        fileid=fnames(filenum);
        filename=fileid{1}; % select a filename
        
        if conf.settingconf.verbose % optional output
            disp(['...Loading file: ' filename ' (file ' num2str(filenum) ' of ' num2str(nb_files) ')']) % output current filename to screen
        end
        
        % ----------------- load frames -------------
        framedescs = load_frame(filename,conf,masterframes); % database specific routine that loads the frame description of this utterance
        labelvecs = convert_struct_frame2labelvec(framedescs,masterframes,conf); % convert the frames to vector notation
        
        % ----------------- Load acoustic features -------------
        wavdata = load_wav(filename,conf); % database-specific routine that loads the waveform representation of this utterance
        specfeat = convert_wav2specfeat(wavdata,conf); % create a spectro-graphic representation of this utterance.
        
        % ----------------- Load transciption -------------
        % Note: transcriptions are ONLY used for conf.settingconf.verbose output, never by the code. So you do not need them here
        % Note: If you do wish to use transcriptions as *features*, instead make a function that creates a "specfeat"
        % compatible format. You can use this load_transcriptions function in there
        sentence_stringdesc=load_transcription(filename,conf,conf.database.speakerid);
        
        
        % --------------- assign data ----------------
        dataset(filenum).framedescs = framedescs;
        dataset(filenum).labelvecs = labelvecs;
        dataset(filenum).specfeat = specfeat;
        dataset(filenum).sentence_stringdesc = sentence_stringdesc;
        
    end
