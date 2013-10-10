database_name = 'domotica_2';
%cd /users/spraak/jgemmeke/projects/ALADIN/framengine_v2/
cd /users/spraak/ntessema/projects/domotica/framengine_v5/

conf=getconfigs; % get global configuration
addpath('include'); % add general matlab helper files
addpath(fullfile('databases',database_name,'code')); % add the directory containing the database-specific codes
%speakerlist = [vec2str([26:48])];
speakerlist = [vec2str([26:37,17,11,40:48])]; % contains some data that dont exist, but simply test for that
noiselist = [0];

sequentie_speakerlist ={}; % no longer needed since all segments start with 'Segment_Nr'

base_outputdir = '/users/spraak/ntessema/projects/domotica/framengine_v5/databases/domotica_2/flists/'; % base directory of the filelists


for speakerid = speakerlist; % loop over speakers
    for noise_used=noiselist; % loop over noisy or not
        
        if noise_used
            noise_string = '_N';
        else
            noise_string = '_NL';
        end
        
        conf = getconfigs_database(conf,speakerid{1},noise_used); % add or overwrite settings to conf that are database dependent

        % load csv for this speaker so we can get the frame description
        if ~exist(conf.fileconf.framedesc,'file') % test if the file exists
            continue % if not, dont do anythign else this loop
        end
        
        outputfile = fullfile(base_outputdir,['pp' speakerid{1} '.txt']); % construct output filename
        fid = fopen(outputfile, 'w'); % open flist file


        
        % get data from csv
        csv_filename = conf.fileconf.framedesc;
        fid2=fopen(csv_filename);
        csv_data = textscan(fid2,'%s %s  %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',';');  % ,'CollectOutput',1)
        fclose(fid2);
         if (str2double(speakerid)==47)
              csv_data{1}(72)=[];csv_data{2}(72)=[];csv_data{3}(72)=[];csv_data{4}(72)=[];
              csv_data{5}(72)=[];csv_data{6}(72)=[];csv_data{7}(72)=[];
         end;
        
        %csv_data = importdata(csv_filename,';'); % load the comma seperated file into memory
        %csv_framedesc = csv_data.textdata(2:end,[1 2]); % first row contains the explanation, so is skipped. First column contains utterance number, second column whether or not the utterence should be used
                
        for utterance_num=1:length(csv_data{1}) % loop over all potential utterances
            
            if isempty(csv_data{2}{utterance_num}) % if this utterance isnt bad
                if ~isempty(csv_data{1}{utterance_num})
                    if isempty(intersect(speakerid,sequentie_speakerlist)) 
                        filename = ['SegmentNr_' csv_data{1}{utterance_num}];
                    else
                        filename = ['Sequentie' csv_data{1}{utterance_num}];
                    end
                  
                    fprintf(fid, '%s\n',filename); % write filename to file
                end
         %else
              % disp(['bad frame detected'])
                % disp(csv_framedesc{utterance_num,2})
                 
               %tada  
            end
            lengthArray(utterance_num)=utterance_num;
        end
        
        fclose(fid); % close flist file
    end
    % Artificially protecting from bug
    
end

