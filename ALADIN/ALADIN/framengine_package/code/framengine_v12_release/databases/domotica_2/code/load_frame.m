function [framedescs] = load_frame(filename,conf,masterframes)
    % generates frame description for each utterance
    % we dont have masterframes, so we cannot check for consistency
    % if nargin<3
    %     masterframes=[];
    % end
    %%%%%%%%%%%%%%%
    
    speakerid = conf.database.speakerid;
    
    frametypes = {'automatic','oracleaction','oraclecommand'};
    
    for frametypenum=1:length(frametypes)
        frametype = frametypes{frametypenum};
    
    sequentie_speakerlist=[];
    csv_filename = [conf.dirconf.frames.(frametype).frame_dir conf.fileconf.frames.(frametype).frame_suffix];
    fid2=fopen(csv_filename);
    csv_data = textscan(fid2,'%s %s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',';');  % ,'CollectOutput',1)
    fclose(fid2);
    
    
    
    % from the filename, extract the corresponding utterance number: filename has the format 'SegmentNr_1'
    %filename_split = textscan(filename,'%s','delimiter','_'); % use the textread function to split on the delimiter '_'
    %utt_number_string = filename_split{1}{2}; % get the number (as string) from the second part of the filename
    if isempty(intersect(speakerid,sequentie_speakerlist))
        filename_split = textscan(filename,'%s','delimiter','_'); % use the textread function to split on the delimiter '_'
        utt_number_string = filename_split{1}{2};
    else
        filename_split = textscan(filename,'%s'); % use the textread function to split on the delimiter '_'
        temp=char(filename_split{1});
        utt_number_string = temp(10:end);
        
    end
    %get utt_number as index in framedesc (ideally equal to str2num(utt_number_string)
    utt_number = find(ismember(csv_data{1}, utt_number_string)==1);
    
    % assign frame label
    %framedesc.thisframe = csv_data{3}{utt_number};
    % if(isempty(csv_data{5}{utt_number}))
    %     if(isempty(csv_data{4}{utt_number}))
    % framedesc.thisframe = csv_data{3}{utt_number};
    %     else
    %        framedesc.thisframe = csv_data{4}{utt_number};  % address 2 sided door commands
    %     end;
    % else
    %    framedesc.thisframe = csv_data{5}{utt_number}; % addresses if executed command is different case
    % end;
    
    framedesc_all= csv_data{4}{utt_number};
    
    %%%%%%%%%%%%%
    removemissingfield = true; % when checking against masterframes, remove fields not in masterframes
    
    % check whether we need to construct filename automatically or not
    
    
    if isempty(framedesc_all)
        disp(['ERROR: no frame info in frame for file: ' filename])
        
    end
    string_slotcheckup_list={'Aan','Uit','Open','Dicht','1','2','3'};
    
    
    
    
    for i=1:length(string_slotcheckup_list)
        if isempty(strfind(framedesc_all,string_slotcheckup_list{i}))
            index(i)=0;
            
            if i==length(string_slotcheckup_list)
                
                framedesc.thisframe='verwarmingHoger';
                framedesc.data={};
                
            end;
            continue;
        else
            index(i)=strfind(framedesc_all,string_slotcheckup_list{i}); % gives the starting indices of string patterns stored in string_slotcheckup_list
            if ~isempty(index(i))
                index_indicator=i; % identifies  index of the detected string pattern of the current utterance in string_slotcheckup_list
                index_slot=index(i);
                framedesc.data.object=framedesc_all(1:(index_slot-1)); %fills .object slot
                if ismember(index_indicator,[1,2])  % identify to which frame the utterance belongs to
                    framedesc.thisframe='aan_uit';  % assigns frame name
                    framedesc.data.action=string_slotcheckup_list{i}; % fills .action slot
                end;
                if ismember(index_indicator,[3,4])
                    framedesc.thisframe='open_dicht';
                    framedesc.data.action=string_slotcheckup_list{i};
                end;
                if ismember(index_indicator,[5,6,7])
                    framedesc.thisframe='commando_triplets';
                    framedesc.data.stand=string_slotcheckup_list{i};
                end;
                
            end;
            break;
            
        end;
    end;

        framedescs.(frametype).framedesc = framedesc;        
        
    end
    
