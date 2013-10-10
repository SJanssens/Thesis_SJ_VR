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

function [acfeatcellmat] = convert_intfeat2acfeat(intfeat,useslidingwindow,conf)
    
    % ---------------------------initialisation ---------------------------
    
    % get number of cells
    if ~iscell(intfeat)
        numutts=1;
        intfeat={intfeat};
    else
        numutts = length(intfeat);
    end
    
    
    for uttnum=1:numutts
        labelmat_utt = intfeat{uttnum};
        
        % get number of frames
        numframes = size(labelmat_utt,2);
        
        if useslidingwindow % is sliding window set to be used?
            
            slidingwindow.windowsize=conf.settingconf.acfeat.slidingwindow.windowsize;
            slidingwindow.Delta = conf.settingconf.acfeat.slidingwindow.Delta;
            if slidingwindow.windowsize<slidingwindow.Delta
                error(['ERROR: the sliding window size ' num2str(slidingwindow.windowsize) ' should be larger or equal to the window shift ' num2str(slidingwindow.Delta)]);
            end
            slidingwindow.numwindows = floor((numframes - slidingwindow.windowsize ) / slidingwindow.Delta)+1; % number of windows (columns of Y) for this speech file. 'floor' means we skip the last window if it does not have full dimensionality (T), which may happen when Delta>1
        else % dont use sliding windows
            slidingwindow.numwindows=1; % dont use sliding windows by setting numwindows to 1
            slidingwindow.Delta = 1;
            slidingwindow.windowsize = numframes; % use the entire spectrogram
        end
        
        
        % initialize acfeatmat
        acfeatmat = []; % not properly initialized since we dont know resulting feature size yet. (Could be calculated though based on methods)
        
        
        % --------------------- sparsification ------------------
        numentries = conf.settingconf.acfeat.numentries; % doesnt have to be one!!!
        
        % maximum size of numentries is all entries, minimum is zero
        numentries = max(min(numentries,size(labelmat_utt,1)),0);
        
        % sort the indices
        [~,indices]=sort(labelmat_utt,'descend');
        
        
        % set all but the best-scoring entries to zero
        
        
        for framenum=1:size(labelmat_utt,2) % loop over each frame
            labelmat_utt(indices(numentries+1:end,framenum),framenum)=0;
        end
        
        %%%%%%%%%%%%%% This code does the same as the for-end loop and
        %%%%%%%%%%%%%% and is 1.5 times faster
        %X=indices(1:numentries,:);
        %j=kron(1:size(labelmat,2),ones(numentries,1));
        
        %I=reshape(X,numentries*size(X,2),1);
        %J=reshape(j,numentries*size(j,2),1);
        %labelmat=sparse(I,J, labelmat(size(labelmat,1)*(J-1)+I),size(labelmat,1),size(labelmat,2));
        %%%%%%%%%%%%%% code end
        
        labelmat_utt=bsxfun(@rdivide,labelmat_utt,sum(labelmat_utt,1));
        
        labelmat_utt = sparse(labelmat_utt);
        % ---------- loop over windows ---------
        
        for window=1:slidingwindow.numwindows, % loop over windows
            startindex= (slidingwindow.Delta*(window-1))+1;   % index of the start of the current window in specfeatmat
            endindex= min(startindex + slidingwindow.windowsize - 1, size(labelmat_utt,2));       % index of the end of the current window in specfeatmat, or the last frame
            labelmat=labelmat_utt(:,startindex:endindex); % store this windows
            
            
            % --------------------- time-reduction ------------------
            switch conf.settingconf.acfeat.timemethod
                
                % sum()
                case 'sum'
                    stream_acfeat=sum(labelmat,2); % take transpose as we need a column vector
                    
                    % HAC
                case 'HAC'
                    
                    lags=cell2mat(conf.settingconf.acfeat.HAC_lag); % get lags from the configuration
                    stream_acfeat = makeHAC(labelmat,lags,numentries);
                case 'sumHAC'
                    lags=cell2mat(conf.settingconf.acfeat.HAC_lag); % get lags from the configuration
                    stream_acfeat=[sum(labelmat,2) ; makeHAC(labelmat,lags,numentries)];
                    
                case 'HACtrail'
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %In de conf we need the correct settings for the number of
                    %VQclusters in sequence, N for a N-gram sequence (conf.settingconf.acfeat.HACtrail_length)
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    lags=cell2mat(conf.settingconf.acfeat.HAC_lag);
                    Hac_trailsize=conf.settingconf.acfeat.HACtrail_length;
                    stream_acf=cell(size(lags,2),1);
                    
                    for tel=1:length(lags),
                        %utterances are converted in sequences of VQ labels
                        %and VQ sequence n+1 is shifted with the current
                        %lag in respect to VQ sequence n, n=1..N
                        VQt=cell(1,Hac_trailsize);
                        for  L=1:Hac_trailsize
                            VQt{L}=labelmat(:,(L-1)*lags(tel)+1:end-(Hac_trailsize-L)*lags(tel));
                        end
                        VQttot=VQt{1};
                        %start with the first sequence (culum vector) and do the outer matrix product
                        %prod with the next sequence (culumn vector). then
                        %do the outer prod between the result and the next
                        %sequence, repeat until all sequences have passed
                        %and the final results are the counts of all possible n-grams of VQ clusters                        %possible
                        for L=2:Hac_trailsize
                            A=kron(VQttot,ones(size(VQt{L},1),1));
                            B=repmat(VQt{L},size(VQttot,1),1);
                            VQttot=A.*B;
                        end
                        clear VQt;
                        stream_acf{tel,1}=sum(VQttot,2);
                    end
                    stream_acfeat=cell2mat(stream_acf);
                    
                case 'none'
                    stream_acfeat=labelmat;
            end
            
            acfeatmat = [acfeatmat stream_acfeat]; % assign acfeat to current window
            
        end % end loop over windows
        
        if conf.settingconf.acfeat.usedense
            acfeatmat=double(acfeatmat);
        else
            acfeatmat=sparse(acfeatmat);
        end
        
        if numutts>1
            acfeatcellmat{uttnum}=acfeatmat;
        else
            acfeatcellmat = acfeatmat;
        end
    end
end

% % code by Bart. Needs comments!!
% function HAC = makeHAC(labelmat,lags)
%     stream_acf=cell(size(lags,2),1);
%     for tel=1:length(lags),
%         VQt1=labelmat(:,1:end-lags(tel));
%         VQttau=labelmat(:,lags(tel)+1:end);
%         A=kron(VQt1,ones(size(VQt1,1),1));
%         B=repmat(VQttau,size(VQt1,1),1);
%         C=A.*B;
%         stream_acf{tel,1}=sum(C,2);
%     end
%     HAC=cell2mat(stream_acf);
% end

function HAC = makeHAC(labelmat,lags,numentries) % Code by Joris/Hugo/Bart. Needs comments!!
    [p,i]=sort(labelmat,'descend');
    
    
    labeldim = size(labelmat,1);
    
    k=1;%is codebooksize number but is 1 because I add codebook HACs in the main menu
    ndx1=ones(numentries,1)*(1:numentries); ndx2=ndx1';
    
    ndx1=ndx1(:); ndx2=ndx2(:);
    n1=0;
    s=0;
    
    for lag=lags,
        i=i(1:numentries,:); p=p(1:numentries,:);% are the K first rows from the sorted labelmat
        
        IDX=i(ndx1,1:end-lag)+(i(ndx2,lag+1:end)-1)*labeldim;
        IDX=IDX(:);
        n1=n1+length(IDX);
    end
    
    is1=zeros(n1,1);
    js1=zeros(n1,1);
    hs1=zeros(n1,1);
    
    n1=0;
    
    for lag=lags,
        i=i(1:numentries,:); p=p(1:numentries,:);% are the K first rows from the sorted labelmat
        
        
        IDX=i(ndx1,1:end-lag)+(i(ndx2,lag+1:end)-1)*labeldim;
        IDX=IDX(:);
        val=p(ndx1,1:end-lag).*p(ndx2,lag+1:end); val=val(:);
        
        
        is1(n1+(1:length(IDX)))=s+IDX;
        js1(n1+(1:length(IDX)))=k;
        hs1(n1+(1:length(IDX)))=val;
        n1=n1+length(IDX);
        
        s=s+labeldim^2;
    end
    %is1=is1(1:n1); js1=js1(1:n1); hs1=hs1(1:n1);
    HAC=sparse(is1,js1,hs1,s,k);
    
end
