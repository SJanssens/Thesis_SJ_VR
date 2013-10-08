% convert utterance to a two-dimensionsal acoustic representation, optionally using a
% sliding window
% input
% 1) specfeat - struct containing the spectro-temporal representation (that
% matches the acfeat method specified in conf (e.g. melmag for exemplars
% with sparse representations obtained through NMF, mfccdd for
% triple-stream(static,velocity,acceleratioin) VQ approaches, etc)
% 2) acfeat_params - struct containing all the data/models neccesary for
% the specified acfeat method - VQ codebookds or VQ-based features,
% exemplars for sparse representations, etc
% 3) conf - specifies the acfeat method
%
% output
% acfeatmat is a two dimensional matrix containign for each column the
% acoustic features of that window position.
% If sliding windows are not used, acfeatmat is a vector.

function [intfeat_output] = convert_specfeat2intfeat(specfeat_input,acfeat_params,conf)
    if ~isstruct(specfeat_input)
        celloutput=false;
    else
        celloutput=true;
    end
    
    nb_files = length(specfeat_input);
    intfeatcell=cell(1,nb_files);
    for filenum=1:nb_files
        specfeat = specfeat_input(filenum);
        
        
        
        % ---------------------------initialisation ---------------------------
        computetype = conf.settingconf.computetype;
        
        % check existence of correponding model
        if ~isfield(acfeat_params,conf.settingconf.acfeat_params.acmethod)
            error(['ERROR: the method "' conf.settingconf.acfeat_params.acmethod '" was specified, but is not found in the acoustic model acfeat.params:'])
        end
        
        % check correct feature extraction
        requested_featdesc = acfeat_params.specfeat_method;
        if ~strcmp(requested_featdesc,specfeat.desc)
            error(['ERROR: feature extraction: "' requested_featdesc '" does not match extracted spectra: ' specfeat.desc])
        end
        
        
        
        
        specfeatmat = specfeat.data;
        
        % depending on the training, apply mean/variance normalisation
        usemapstd = acfeat_params.(conf.settingconf.acfeat_params.acmethod).usemapstd; % using mapstd for this method?
        if usemapstd
            if specfeat.mapstd
                disp(['WARNING: mean and variance normalisation is requested both per file and globally!'])
            end
            
            specfeatmat=mapstd('apply',specfeatmat,acfeat_params.(conf.settingconf.acfeat_params.acmethod).usemapstd_settings);
        end
        
        
        % ---------------- quantification ----------------------
        
        method = conf.settingconf.acfeat_params.acmethod; % the  method
        switch method
            % VQ
            case 'VQ'
                codebook = acfeat_params.VQ.codebook; % the selected codebook
                
                %[~,labelmat]=min(eucdist(specfeatmat_win,codebook,computetype)); % labelmat is a vector containing, for each frame, the best matching codebook index
                labelmat_utt = eucdist(specfeatmat,codebook,computetype); % labelmat is a matrix containing the distance to each cluster
                
                % invert the distances in each frame so that sorting (in a later stage) goes correctly
                %labelmat = 1./exp(labelmat.^2);
                labelmat_utt=1./labelmat_utt+1e-50;
                %                     labelmat = bsxfun(@minus,labelmat,min(labelmat));
                %                     labelmat = bsxfun(@rdivide,labelmat,max(labelmat));
            case 'softVQ'
                % note: softVQ is off course very similar to 'gmm'. Implementation could be unified further
                labeldim = acfeat_params.softVQ.numclusters;
                
                labelmat_utt = zeros(labeldim,size(specfeatmat,2));
                for clusternum=1:labeldim % loop over clusters
                    labelmat_utt(clusternum,:)=mvnpdf(specfeatmat', acfeat_params.softVQ.means(:,clusternum)', acfeat_params.softVQ.covars{clusternum})';
                end
                
                
                % sparse representations
            case 'online_softVQ'
                % note: softVQ is off course very similar to 'gmm'. Implementation could be unified further
                labeldim = acfeat_params.online_softVQ.numclusters;
                
                labelmat_utt = zeros(labeldim,size(specfeatmat,2));
                for clusternum=1:labeldim % loop over clusters
                    labelmat_utt(clusternum,:)=mvnpdf(specfeatmat', acfeat_params.online_softVQ.means(:,clusternum)', acfeat_params.online_softVQ.covars{clusternum})';
                end
                
                % sparse representations
                
            case 'gmm'
                gmm_model = acfeat_params.gmm.gmm_model; % the selected gmmmodel
                %labelmat = cluster(gmm_model,specfeatmat_win')'; % get the index of cluster identies according to the gmm model
                labelmat_utt = posterior(gmm_model,specfeatmat')'; % get a matrix with posterior estimates
                
        end
        
        
        % ----- normalise ----
        labelmat_utt = labelmat_utt + 1e-50;
        labelmat_utt=bsxfun(@rdivide,labelmat_utt,sum(labelmat_utt,1));
        
        
        intfeatcell{filenum} = labelmat_utt;
        
    end
    
    if celloutput
        intfeat_output = intfeatcell;
    else
        intfeat_output = intfeatcell{1};
    end
