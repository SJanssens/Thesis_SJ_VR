% loads a wav file from disc 
% input
% 1) fileid (to make full filename)
% 2) conf (specifies target feature representation, dirs and suffixes)

function [wavdata] = load_wav(fileid,conf)
    
    % create full filename
    speech_filename=fullfile(conf.dirconf.speech_dir,[fileid conf.fileconf.speech_suffix]);
    
    
    % check file existance from matlab
    if ~exist(speech_filename)
        error(['ERROR: the file: "' speech_filename '" does not exist!'])
    end
    
    [sam, fs] = audioread(speech_filename); % load waveform
  
    % assign data
    wavdata.sam = sam;
    wavdata.fs = fs;
    wavdata.filename = speech_filename;
end