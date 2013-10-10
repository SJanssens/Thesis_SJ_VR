function transcription = load_transcription(filename,conf,speakerid)

% load csv for this speaker so we can get the frame description
csv_filename = fullfile(conf.dirconf.transcription_dir,['pp' num2str(speakerid) '.csv']);
fid2=fopen(csv_filename);
csv_data = textscan(fid2,'%s %s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',';');  % ,'CollectOutput',1)
fclose(fid2);
sequentie_speakerlist =[]; % no longer necessary because all the filenames start with 'Segment_Nr'
if isempty(intersect(speakerid,sequentie_speakerlist))
    filename_split = textscan(filename,'%s','delimiter','_'); % use the textread function to split on the delimiter '_'
    utt_number_string = filename_split{1}{2};
else
    filename_split = textscan(filename,'%s'); % use the textread function to split on the delimiter '_'
    temp=char(filename_split{1});
    utt_number_string = temp(10:end);
    
end

% from the filename, extract the corresponding utterance number: filename has the format 'SegmentNr_1'
%filename_split = textscan(filename,'%s','delimiter','_'); % use the textread function to split on the delimiter '_'
%utt_number_string = filename_split{1}{2}; % get the number (as string) from the second part of the filename

%get utt_number as index in framedesc (ideally equal to str2num(utt_number_string)
utt_number = find(ismember(csv_data{1}, utt_number_string)==1);

% assign frame label
if(isempty(csv_data{5}{utt_number}))
 
 if (isempty(csv_data{4}{utt_number}) ) 
      transcription = csv_data{3}{utt_number};
 else
     transcription = csv_data{4}{utt_number}; % addresses the 2 sided door situations
 end;
else
   transcription = csv_data{5}{utt_number};  % addresses if the executed command is different situations
end;