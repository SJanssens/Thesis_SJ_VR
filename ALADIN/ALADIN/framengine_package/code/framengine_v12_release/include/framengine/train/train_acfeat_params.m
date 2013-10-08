% Training function for all acoustic representations. Does codebook
% learning, exemplar-extraction, GMM learning, etc
% input
% 1) specfeatstruct - contains of all utterances the spectral data
% 2) conf - descripes the method(s) to be used
% 3) (optional) acfeat_params  - for overloading or overwriting an
% exisiting acfeat_paramas
% ouput
% 1) acfeat_params - contains the parameters of the model(s) for the
% method(s)


function [acfeat_params] = train_acfeat_params(specfeatstruct,conf)
    
    computetype = conf.settingconf.computetype;
    
    
    % store a single seed for reducing the set of frames, so the same set of
    % frames is used for each frame and method
    seed_framereduce = sum(clock*1e6);
    
    method = conf.settingconf.acfeat_params.acmethod; % the  method
    
    sample = specfeatstruct(1); % take the first entry to be representative for all utterances
    
    acfeat_params.specfeat_method = sample.desc; % save feature type in acfeat
       
    % put data in one big matrix
    specfeatmat = cell2mat(arrayfun(@(x) x.data,specfeatstruct,'Uniformoutput',false));

    
    
    % optionaly, use additional mean/variance normalisation
    usemapstd = conf.settingconf.acfeat_params.acmethod_usemapstd; % using mapstd for this method?
    if usemapstd
        if sample.mapstd
            disp(['WARNING: mean and variance normalisation is requested both per file and globally!'])
        end
        
        [specfeatmat, mapstd_settings]=mapstd(specfeatmat);
    else
        mapstd_settings=[]; % we assign the mapstd_settings to each acfeat_params struct regardsless, so make a placeholder
    end
    
    % reduce size of dataset if neccesary
    if isfield(conf.settingconf.acfeat_params,'numframes')
        % note: need some additional error checking here.
        % also, can add the option of a number between 0 and 1 being an percentage
        max_numframes = conf.settingconf.acfeat_params.numframes;
        
        current_numframes = size(specfeatmat,2);
        if current_numframes>max_numframes % need to reduce the number of frames
            % set some random seed (can be done trough options too?)
            rand('state',seed_framereduce);
            indices = randperm(current_numframes);
            specfeatmat_reduced = specfeatmat(:,indices(1:max_numframes));
        else
            specfeatmat_reduced = specfeatmat;
        end
    end
    
    
    % select method
    switch method
        case 'VQ'
            % make codebook
            
            % codebook size
            %for codebooksizeindex=1:length(numclusters)
            numclusters = conf.settingconf.acfeat_params.VQ_numclusters; % codebook size
            
            codebook = train_codebook(specfeatmat_reduced,numclusters,conf); % make codebook
            
            % store
            acfeat_params.VQ.codebook = codebook; % the codebook itself
            acfeat_params.VQ.numfreqbands = size(specfeatmat_reduced,1); % number of freqbands in this codebook
            acfeat_params.VQ.numclusters = numclusters; % codebook size
            acfeat_params.VQ.numsamples = size(specfeatmat_reduced,2); % size of data that was clustered - note-  may have been reduced!
            acfeat_params.VQ.info =  datestr(now); % current date and time
            acfeat_params.VQ.desc = sample.desc; % name of feature extraction used
            acfeat_params.VQ.usemapstd = usemapstd; % used mapstd or not
            acfeat_params.VQ.usemapstd_settings = mapstd_settings;
            
            %end
            
        case 'softVQ'
            
            
            %for codebooksizeindex=1:length(numclusters)
            numclusters = conf.settingconf.acfeat_params.softVQ_numclusters; % codebook size
            [codebook] = train_codebook(specfeatmat_reduced,numclusters,conf); % make codebook
            
            % assign frames to clusters
            blocksize=500000; % maximum number of frames to process at once
            membership=zeros(1,size(specfeatmat,2)); % initialize cluster assignment
            for index=1:blocksize:size(specfeatmat,2) % loop over blocks
                endindex=min(index+blocksize-1,size(specfeatmat,2)); % take care of the length of the last block
                [~,membership(index:endindex)]=min(eucdist(specfeatmat(:,index:endindex),codebook,computetype)); % assign original trainingdata to codebook clusters
            end
            
            % get Gaussian from each cluster
            covars = cell(numclusters,1); % cell structure holding the covariances
            for clusternum=1:numclusters % loop over clusters
                data = specfeatmat(:,membership==clusternum); % take the subset that belongs to this cluster
                covars{clusternum}=cov(data'); % calculate the covariance for this cluster
                if size(data,2) < size(data,1)+1 % if there is not enough data for proper covariance calculation
                    covars{clusternum}=covars{clusternum}+eye(size(data,1)); % regularize the covariances
                end
            end
            
            % store
            acfeat_params.softVQ.means = codebook; % the codebook means is the codebook itself
            acfeat_params.softVQ.covars = covars; % the codebook itself
            acfeat_params.softVQ.numfreqbands = size(specfeatmat_reduced,1); % number of freqbands in this codebook
            acfeat_params.softVQ.numclusters = numclusters; % codebook size
            acfeat_params.softVQ.numsamples = size(specfeatmat_reduced,2); % size of data that was clustered
            acfeat_params.softVQ.info =  datestr(now); % current date and time
            acfeat_params.softVQ.desc = sample.desc; % name of feature extraction used
            acfeat_params.softVQ.usemapstd = usemapstd; % used mapstd or not
            acfeat_params.softVQ.usemapstd_settings = mapstd_settings;
            
            %end
            
            
        case 'online_softVQ'
            
            
            %for codebooksizeindex=1:length(numclusters)
            numclusters = conf.settingconf.acfeat_params.onlineSoftVQ_numclusters; % codebook size
            [codebook] = train_codebook_clustersize(specfeatmat_reduced,numclusters,conf); % make codebook
            
            
            
            % assign frames to clusters
            blocksize=500000; % maximum number of frames to process at once
            membership=zeros(1,size(specfeatmat,2)); % initialize cluster assignment
            for index=1:blocksize:size(specfeatmat,2) % loop over blocks
                endindex=min(index+blocksize-1,size(specfeatmat,2)); % take care of the length of the last block
                
                [~,membership(index:endindex)]=min(eucdist(specfeatmat(:,index:endindex),codebook,codebooktype)); % assign original trainingdata to codebook clusters
                
            end
            
            % get Gaussian from each cluster
            covars = cell(numclusters,1); % cell structure holding the covariances
            for clusternum=1:numclusters % loop over clusters
                data = specfeatmat(:,membership==clusternum); % take the subset that belongs to this cluster
                covars{clusternum}=cov(data'); % calculate the covariance for this cluster
                if size(data,2) < size(data,1)+1 % if there is not enough data for proper covariance calculation
                    covars{clusternum}=covars{clusternum}+eye(size(data,1)); % regularize the covariances
                end
            end
            
            % store
            acfeat_params.online_softVQ.means = codebook; % the codebook means is the codebook itself
            acfeat_params.online_softVQ.covars = covars; % the codebook itself
            acfeat_params.online_softVQ.numfreqbands = size(specfeatmat_reduced,1); % number of freqbands in this codebook
            acfeat_params.online_softVQ.numclusters = size(codebook,2); % codebook size
            acfeat_params.online_softVQ.numsamples = size(specfeatmat_reduced,2); % size of data that was clustered
            acfeat_params.online_softVQ.info =  datestr(now); % current date and time
            acfeat_params.online_softVQ.desc = sample.desc; % name of feature extraction used
            acfeat_params.online_softVQ.usemapstd = usemapstd; % used mapstd or not
            acfeat_params.online_softVQ.usemapstd_settings = mapstd_settings;
            
            %end
            
        case 'gmm'
            % use matlab to get a Gaussian mixture model
            nummixtures=conf.settingconf.acfeat_params.gmm_nummixtures; % number of mixture Gaussians
            numiters=conf.settingconf.acfeat_params.gmm_numiters; % number of EM iterations
            %gmm_model=gmdistribution.fit(specfeatmat_reduced',nummixtures,'CovType','diagonal','Regularize',1e-6,'Options',statset('MaxIter',numiters,'Display','iter'));
            gmm_model=gmdistribution.fit(specfeatmat_reduced',nummixtures,'CovType','diagonal','Regularize',1e-6,'Options',statset('MaxIter',numiters));
            
            % store
            acfeat_params.gmm.gmm_model = gmm_model; % the gmm model itself
            acfeat_params.gmm.numfreqbands = size(specfeatmat_reduced,1); % number of freqbands in this codebook
            acfeat_params.gmm.nummixtures = nummixtures; % number of mixture Gaussians
            acfeat_params.gmm.numiters = numiters; % number of EM iterations
            acfeat_params.gmm.numsamples = size(specfeatmat_reduced,2); % size of data that was clustered
            acfeat_params.gmm.info =  datestr(now); % current date and time
            acfeat_params.gmm.desc = sample.desc; % name of feature extraction used
            acfeat_params.gmm.usemapstd = usemapstd; % used mapstd or not
            acfeat_params.gmm.usemapstd_settings = mapstd_settings;
    end
    
end

