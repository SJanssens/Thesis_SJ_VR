function [framedescs] = load_frame(filename,conf,masterframes)
    
    % we dont have masterframes, so we cannot check for consistency
    if nargin<3
        masterframes=[];
    end
    
    removemissingfield = true; % when checking against masterframes, remove fields not in masterframes
    
    frametypes = {'automatic','oracleaction','oraclecommand'};
    
    for frametypenum=1:length(frametypes)
        frametype = frametypes{frametypenum};
        
        xml_filename=fullfile(conf.dirconf.frames.(frametype).frame_dir,[filename conf.fileconf.frames.(frametype).frame_suffix]);
        
        
        
        framedesc_xml = xmltree(xml_filename);
        
        framedesc=convert(framedesc_xml);
        
        if ~isfield(framedesc,'thisframe')
            disp(['ERROR: no frame info in frame. Assuming frame to be "stop" for file: ' filename])
            framedesc.thisframe='stop';
        end
        
        
        % some backward compatibility code (can be replaced by a program that
        % processes all exisiting files instead)
        
        switch framedesc.thisframe % depending on frame
            case 'move_abs'
                %no code needed (at this moment)

            case 'move_rel'
                %no code needed (at this moment)

            case 'turn_abs'
                %no code needed (at this moment)

            case 'turn_rel'
                %no code needed (at this moment)

            case 'grab'
                %no code needed (at this moment)

            case 'release'
                %no code needed (at this moment)

            case 'spin'
                %no code needed (at this moment)

            case 'drive'
                %no code needed (at this moment)

            case 'stop'
                %no code needed (at this moment)
           
        end
        
        % Optionally, check for consistency with masterframes
        if ~isempty(masterframes)
            framedesc_frameid =  find(strcmp(masterframes.framenames,framedesc.thisframe));
            
            if isempty(framedesc_frameid)
                disp(['ERROR: the frame "' framedesc.thisframe '" can not be found in masterframes.framenames:'])
                masterframes.framenames
                return
            end
            
            master_cell = nstruct2cell(masterframes.frame(framedesc_frameid).data); % get the masterdata for the corresponding frame
            framedesc_cell = nstruct2cell(framedesc.data); % extract the field names and values to a 2-dim cell array, for easier handling
            
            for framedesc_fieldnum=1:size(framedesc_cell,1)
                
                master_fieldnum=find(strcmp(framedesc_cell{framedesc_fieldnum,1},master_cell(:,1)));
                
                if isempty(master_fieldnum)
                    if removemissingfield
                        tmpdata = framedesc.data;
                        framedesc = rmfield(framedesc,'data');
                        tmpdata = rmfield(tmpdata,framedesc_cell{framedesc_fieldnum,1}(2:end));
                        framedesc.data=tmpdata;
                    else % throw an error
                        disp(['ERROR: the field "' framedesc_cell{framedesc_fieldnum,1} '" can not be found in masterframes.frame(' num2str(framedesc_frameid) ').data:'])
                        master_cell(:,1)
                        return
                    end
                end
                
                
                
                % TODO Check if values match masterframes
                %             % check if we need to take care of multiple slot values
                %             if ~iscell(framedesc_cell{framedesc_fieldnum,2}) % not a cell, so safe to proceed as normal
                %                 master_valuenum=find(strcmp(framedesc_cell{framedesc_fieldnum,2},master_cell{master_fieldnum,2}));
                %             else
                %
                %                 master_valuenum =[]; % build the list up, to support multiple slot values
                %                 for valueindex=1:length(framedesc_cell{framedesc_fieldnum,2}) % number of slot values set
                %                     current_slottarget = framedesc_cell{framedesc_fieldnum,2}{valueindex}; % assign current target
                %                     master_valuenum=[master_valuenum find(strcmp(current_slottarget,master_cell{master_fieldnum,2}))]; % expand list with found target
                %                 end
                %             end
                %
                %             if isempty(master_valuenum)
                %                 disp(['ERROR: the value "' framedesc_cell{framedesc_fieldnum,2} '" can not be found in masterframes.frame(' num2str(framedesc_frameid) ').data' master_cell{master_fieldnum,1} ':'])
                %                 master_cell{master_fieldnum,2}
                %                 return
                %             end
                
            end
        end

    
        framedescs.(frametype).framedesc = framedesc;        
        
    end
