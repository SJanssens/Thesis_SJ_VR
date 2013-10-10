function transcription = load_transcription(filename,conf,speakerid)


textfile = fullfile(conf.dirconf.transcription_dir,[filename '_transcription.txt']);
fid = fopen(textfile); % open transcription file
transcription = fgets(fid); % read the transcription
fclose(fid);

% bit of cleanup
transcription = strrep(transcription,'.',''); % remove periods

                    