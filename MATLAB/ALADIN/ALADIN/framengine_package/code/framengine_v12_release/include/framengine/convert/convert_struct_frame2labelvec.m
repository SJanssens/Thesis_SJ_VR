% This function converts a struct of frame descriptions into a struct of one-dimensional
% labelvector for use in machine learning.

function [labelvec_struct, framevec_struct] = convert_struct_frame2labelvec(framedesc_struct,masterframes,conf)
    
    structfields=fields(framedesc_struct); % get fields
    
    for fieldnum=1:length(structfields) % loop over fields
        fieldname = structfields{fieldnum}; % get current field name
        
        [labelvec, framevec] = convert_frame2labelvec(framedesc_struct.(fieldname).framedesc,masterframes,conf);
        
        labelvec_struct.(fieldname).labelvec=labelvec;
        framevec_struct.(fieldname).framevec=framevec;
        
        
    end
    