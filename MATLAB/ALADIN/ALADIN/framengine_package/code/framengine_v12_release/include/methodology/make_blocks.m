function [blocks, L, Utterance_to_remove]=make_blocks(labelmat, conf)
    % MAKE_BLOCKS divide utterances(columns in labelmat) over blocks. First utterances
    % are random assigned to nblocks, then movements of utterances are
    % done in order to lower the Jensen-Channon divergene, to do block
    % stratification.
    %
    % blocks: is a cell array of size N, each cell has a vector with labelmat-columns-indices
    % nblocks: is an optional integer for the desired number of blocks, without
    % flag settings, this will be the final number of blocks.
    % labelmat: is an indicator matrix for the presence of items (rows) that should be
    % shared over the blocks as good as possible and the columns are utterances.
    % L: is output as it is handy afterwards to omit scoring on some slotvalues
    % that might be abscent in some blocks
    %
    % In conf.experiment tatitatita, for explanation see the code
    %
    %convergence seems (experimentally) to be garanteed, but final solution
    %depends on initialization of randomseed
    
    rowlength=size(labelmat,2); %number of utterances
    columnlength=size(labelmat,1); %number of keywords
    Utterance_to_remove=[];
    if isfield(conf.settingconf.expconf,'max_num_blocks')
        N=conf.settingconf.expconf.max_num_blocks;
        if conf.settingconf.verbose % optional output
            disp(['CREATING ' num2str(N) ' BLOCKS'])
        end
        if N > size(labelmat,2)
            error('You request more blocks than the number of utterances')
        end
    else
        n=ceil(columnlength/mean(sum(labelmat)));% n is number of utterances in one block at start
        N=floor(rowlength/n); % N is a good start, however, is overestimated when keywords are tied and flags are set (that is extra constrains)
    end
    
    if ~isempty(conf.settingconf.expconf.randomseed) %
        rng(conf.settingconf.expconf.randomseed,'v5uniform');%flag for reproductable blocks
    else
        disp('Warning!, no fixed randomseed was used for the block generator')
    end
    
    ind_perm=randperm(rowlength);%used for initial partition of utterances to blocks
    
    
    
    
    [blocks]=create_some_blocks(labelmat, ind_perm, N,conf);%N blocks are created
    
    %in default settings, the algorithm does not care about
    %slotvalues (row-entities in labelmat) absent in one particular block, however,
    frdist=zeros(size(labelmat,1),N);
    for i=1:N
        frdist(:,i)=sum(labelmat(:,blocks{i}),2); %freq dist per block
    end
    
    L_=(frdist==0); %rows in labelmat with less examples than conf.expconf.dismiss_slotsvalues_treshold
    L__=any(L_,2);
    L=find(L__);
    [~,D]=find(labelmat(~L__,:)~=0);
    D=unique(D);
    
    Utterance_to_remove=setdiff(1:size(labelmat,2),D);
    labelmat(:,Utterance_to_remove)=0;
    %[blocks]=create_some_blocks(labelmat, ind_perm, N);%N blocks are created
    
    
    
    
    
    if conf.settingconf.expconf.all_slotsvalues_in_block==1 %check flags, 1 continue, otherwise, blocks are final
        %blocks without examples of slotvalues are not allowed anymore
        %if some empty slotvalue in a block then the number of blocks is lowered
        %with one
        
        check= any(any(frdist==0)); %test wheter all slotvalues are in each block
        while check %if not, repeat the whole thing but with fewer blocks
            N=N-1;
            
            [blocks]=create_some_blocks(labelmat, ind_perm, N,conf);
            
            frdist=zeros(size(labelmat,1),N);
            for i=1:N
                frdist(:,i)=sum(labelmat(:,blocks{i}),2);%check again and repeat ....
            end
            check= any(any(frdist==0));
        end
    end
    
end




function [blocks]=create_some_blocks(labelmat, ind_perm, N,conf)
    rowlength=size(labelmat,2);
    %make the blocks based on the Jensen-Shannon divergence, Here we don't care about flags
    
    
    %assignment of all utterances to N blocks
    ind=0;
    blockind=0;
    blocks=cell(N,1);
    while   ind<rowlength
        ind=ind+1;
        blockind=mod(blockind,N)+1;
        blocks{blockind}=[blocks{blockind} ind_perm(ind)];
    end
    
    
    
    %make distribution stats per block etc
    frdist=[];
    
    for i=1:N
        nN(i)=sum(sum(labelmat(:,blocks{i}),2));%number of labels in the blocks
        frdist(:,i)=sum(labelmat(:,blocks{i}),2);% freq dist per block, one label=1 unit
        %             if (mod(i,floor(N/5))==0) %draw for some blocks a histogram
        %                 figure(i)
        %                 bar(frdist(:,i));
        %             end
        %             drawnow;
    end
    
    
    tot_dist=sum(labelmat,2)/sum(nN); %dist for all utterances (mean of all)
    dist_tot_kronn=kron(tot_dist,ones(1,size(frdist,2))); %make distr of appropriate size, number of slotvalues x N
    dist=bsxfun(@rdivide,frdist,sum(frdist));%freq dist to dist
    
    
    JSD=sum(sum((dist+1e-200).*log((dist+1e-200)./(dist_tot_kronn+1e-200)+1e-20)));
    if conf.settingconf.verbose % optional output
        disp(['START Jensen-Shannon Divergence is ' num2str(JSD)]); %start JSD
    end
    
    
    for tel=1:rowlength
        label_kronn=kron(labelmat(:,tel),ones(1,size(frdist,2))); %make matrix of approproiate size for each utterance
        dist_plus_labelcolumn=bsxfun(@rdivide, (frdist+label_kronn), nN+sum(label_kronn));
        DIVERGENCE_swap(tel,:)=sum(dist_tot_kronn.*log(dist_tot_kronn./(dist_plus_labelcolumn+1e-20)+1e-20))-sum(dist_tot_kronn.*log(dist_tot_kronn./(dist+1e-20)+1e-20));% improvement divergence as utt it is enclosed by new cluster
    end
    %DIVERGENCE_swap=delta divergence for each utterance(rows) as it would be added
    %to each block(columns) minus the divergence for the blocks as they are now
    
    for tel=1:rowlength
        %find block
        Loc = cellfun(@(x) any(x(:)==tel),blocks);
        %distr without utt
        dist_min_labelcolumn=bsxfun(@rdivide, frdist(:,Loc)-labelmat(:,tel), nN(Loc)-sum(labelmat(:,tel))); % resulting distribution as if the current lavelvec of utterance(tel) would be assigned to this cluster
        DIVERGENCE_without(tel,1)=sum(tot_dist.*log(tot_dist./(dist_min_labelcolumn+1e-20)+1e-20))-sum(tot_dist.*log(tot_dist./(dist(:,Loc)+1e-20)+1e-20));%Difference in divergence when the utt is gone from its current block
    end
    %DIVERGENCE_without=delta divergence for each utterance(rows) as it would leave
    %its respective block minus the divergence as it would not leave its block
    
    
    DIVERGENCE=bsxfun(@plus, DIVERGENCE_swap, DIVERGENCE_without);
    %DIVERGENCE is improvement in Jensen?Shannon divergence
    
    %reassignment based on DIVERGENCE
    counter=0;
    decrease=0;
    utt_ind_old=-1;
    [DIVERGENCE_FIRST, assign_index]=sort(DIVERGENCE(:));%sort according improvement in JSD
    utt_ind=mod(assign_index(1)-1,size(DIVERGENCE,1))+1;% the utt index for the best move
    block_ind=floor((assign_index(1)-1)/size(DIVERGENCE,1))+1;% the block index for the utterance with the best move
    iter=0;
    if DIVERGENCE_FIRST(1)<-1e-4 %Check if it is still an improvement
        decrease=1;
        while decrease
            Loc_n = cellfun(@(x) any(x(:)==utt_ind),blocks);%Find block for the utt to move
            blocks{block_ind}=[blocks{block_ind} utt_ind];%move the utt to the other block
            blocks{Loc_n}=setdiff(blocks{Loc_n}, utt_ind,'stable'); % remove the utt in older block
            iter=iter+1;
            
            frdist(:,Loc_n)=sum(labelmat(:,blocks{Loc_n}),2);% freq dist of the new block
            frdist(:,block_ind)=sum(labelmat(:,blocks{block_ind}),2);% freq of the old block
            dist(:,Loc_n)=frdist(:,Loc_n)/sum(frdist(:,Loc_n));%same
            dist(:,block_ind)=frdist(:,block_ind)/sum(frdist(:,block_ind));%same
            %in the next 3 for loops: recalculate stats but only for the row(utt) and columns(source and target block) in the DIVERGENCE matrix that were involved in the move
            for tel=1:rowlength
                dist_plus_labelmat=(frdist(:,Loc_n)+labelmat(:,tel))/sum(frdist(:,Loc_n)+labelmat(:,tel));
                DIVERGENCE_swap(tel,Loc_n)=sum(tot_dist.*log(tot_dist./(dist_plus_labelmat+1e-20)+1e-20))-sum(tot_dist.*log(tot_dist./(dist(:,Loc_n)+1e-20)+1e-20));
                dist_plus_labelmat=(frdist(:,block_ind)+labelmat(:,tel))/sum(frdist(:,block_ind)+labelmat(:,tel));
                DIVERGENCE_swap(tel,block_ind)=sum(tot_dist.*log(tot_dist./(dist_plus_labelmat+1e-20)+1e-20))-sum(tot_dist.*log(tot_dist./(dist(:,block_ind)+1e-200)+1e-20));
            end
            for tel=[blocks{Loc_n}]
                dist_min_labelcolumn=(frdist(:,Loc_n)-labelmat(:,tel))/sum(frdist(:,Loc_n)-labelmat(:,tel));
                DIVERGENCE_without(tel,1)=sum(tot_dist.*log(tot_dist./(dist_min_labelcolumn+1e-20)+1e-20))-sum(tot_dist.*log(tot_dist./(dist(:,Loc_n)+1e-20)+1e-20));
            end
            
            for tel=[blocks{block_ind}]
                dist_min_labelcolumn=(frdist(:,block_ind)-labelmat(:,tel))/sum(frdist(:,block_ind)-labelmat(:,tel)); % resulting distribution as if the current lavelvec of utterance(tel) would be assigned to this cluster
                DIVERGENCE_without(tel,1)=sum(tot_dist.*log(tot_dist./(dist_min_labelcolumn+1e-200)+1e-20))-sum(tot_dist.*log(tot_dist./(dist(:,block_ind)+1e-200)+1e-20));%distan
            end
            
            DIVERGENCE=bsxfun(@plus, DIVERGENCE_swap, DIVERGENCE_without);
            
            [DIVERGENCE_FIRST, assign_index]=sort(DIVERGENCE(:));%take item that make a block most similar to average
            utt_ind=mod(assign_index(1)-1,size(DIVERGENCE,1))+1;
            block_ind=floor((assign_index(1)-1)/size(DIVERGENCE,1))+1;
            
            
            if (DIVERGENCE_FIRST(1)<-1e-4 && utt_ind~=utt_ind_old && iter<500)
                decrease=1;
            else
                decrease=0;
            end
            utt_ind_old=utt_ind;
            JSD=sum(sum((dist+1e-200).*log((dist+1e-20)./(dist_tot_kronn+1e-20)+1e-20)));
            if conf.settingconf.verbose % optional output
                disp(['Jensen-Shannon Divergence is ' num2str(JSD) ' for number of blocks = ' num2str(N)]);
            end
        end
    end
    
    clear DIVERGENCE_swap; clear DIVERGENCE_without; clear frdist; clear tot_dist; clear dist_tot_kronn; clear dist; clear labe_kronn; clear dist_plus_labelcolumn; clear DIVERGENCE;
end


