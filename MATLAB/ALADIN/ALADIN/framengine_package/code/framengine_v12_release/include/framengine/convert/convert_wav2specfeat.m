% loads a wav file from disc and does the neccesary preprocessing
% input
% 1) fileid (to make full filename)
% 2) conf (specifies target feature representation, dirs and suffixes)

function [specfeat] = convert_wav2specfeat(wavdata,conf)
    
    % get settings
    audioconf = conf.audioconf;
    
    % get data from wavdata
    sam = wavdata.sam;
    fs = wavdata.fs;
    
    % -------  resample -------
    if audioconf.fs~=fs
        sam = resample(sam,audioconf.fs,fs);
    end
    
    % ------- extract Mel features ------
    mel_feats = FE(sam, audioconf);
    logmel_feats = log(mel_feats); % log-Mel spectra
    
    % ------- MFCC features ------
    [MM,Mstatic]=vec2featmat(audioconf.melbands,audioconf.CepOrder); % DCT matrix, and version for derivative features
    
    mfcc_feat = Mstatic*logmel_feats; % static MFCC features
    mfcc_feat_d_dd=MM*stacklp(logmel_feats,4); % static MFCC features stacked with delta's and delta-delta's (dim= 3 x CepOrder)
    
    % -------------------------------------------------------------------
    
    method = conf.settingconf.specfeat.method;
    
    switch method
        case 'mfcc'
            specmat = mfcc_feat;
        case 'mfccdd'
            specmat = mfcc_feat_d_dd;
        case 'melmag'
            specmat = exp(mel_feats);
        case 'logmel'
            specmat = mel_feats;
    end
    
    
    
    % -------------------------------------------------------------------
    
    % optional dropping of silence frames
    if conf.settingconf.specfeat.usevad
        min_vadfraction = conf.settingconf.specfeat.min_vadfraction;
        
        vad = vadIBI(sam,audioconf);
        
        % some safety checks
        numframes_spec = size(specmat,2);
        numframes_vad = length(vad);
        
        if numframes_spec ~= numframes_vad
            error(['Number of frames in Spectra and VAD do not match'])
        end
        
        num_speechframes = sum(vad);
        
        if conf.settingconf.verbose
            disp(['......VAD yields ' num2str(num_speechframes) ' speech frames out of ' num2str(numframes_spec) ' (' num2str((num_speechframes/numframes_spec)*100) '%)']);
        end
        
        if num_speechframes<floor(min_vadfraction*numframes_vad)
            disp(['WARNING: Number of speech frames (' num2str(num_speechframes) ') is lower than allowed fraction of frames (' num2str(min_vadfraction*100) '%)'])
        else
            % Apply VAD
            specmat = specmat(:,vad);
        end
    end
    
    
    
    % optional normalisation
    if conf.settingconf.specfeat.usemapstd_perutt % is it set to true?
        specmat=mapstd(specmat); % do local mean/variance normalisation
    end
    
    
    
    
    % store
    specfeat.data = specmat;
    specfeat.desc = method;
    specfeat.usevad = conf.settingconf.specfeat.usevad;
    specfeat.mapstd = conf.settingconf.specfeat.usemapstd_perutt;
    specfeat.numfreqbands=size(specmat,1);
    specfeat.numframes=size(specmat,2);
    
    
    
end