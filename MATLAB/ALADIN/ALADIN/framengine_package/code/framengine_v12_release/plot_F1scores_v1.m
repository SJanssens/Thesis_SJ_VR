
close all
clear


% --------------------------- database settings -------------------------
%databases = {'domotica_2','patience'};
databases = {'patience'};
for database_num=1:length(databases)
    database_name = databases{database_num}
    
    % framengine is speaker-specific, so this needs to be set in advance. off course, this can be looped over, or a 'speaker' can be constructed that contains, in fact, all speakers
    
    linewidth=2;
    fontsize = 16;
    
    col_red = [255 0 0];
    col_darkred = [100 0 0];
    col_darkgreen = [0 100 0];
    col_green2 = [0 238 0];
    col_orange = [255 165 0];
    col_darkorange = [100 50 0];
    col_mediumblue = [0 0 205];
    col_deepskyblue = [0 191 255];
    col_deeppink = [255 20 147];
    col_purple = [160 32 240];
    col_darkblue = [0 0 100];
    col_lichtblue = [0 0 255];
    col_darkpink = [150 5 100];
    col_lichtskyblue=[0 50 150];
    col_gray1=[50 50 50];
    col_gray2=[100 100 100];
    col_gray3=[150 150 150];
    
    
    color_cell = { col_darkred, col_darkgreen,  col_orange, col_darkorange, col_mediumblue, col_deepskyblue, ...
        col_deeppink,  col_darkblue, col_green2, col_lichtblue, col_darkpink, col_lichtskyblue, col_gray1, col_purple,col_red, col_gray2, col_gray3};
    
    
    
    
    
    if strcmp(database_name,'patience')
        speakeridlist=[1];
        %speakeridlist=[1 3 4 6 7 8 9 10];
    elseif strcmp(database_name,'domotica_2')
        %speakeridlist=[11 17 28:35  37 40:48];
        speakeridlist=[11 17 29 31 34 35 41 45];
    end
    
    if strcmp(database_name,'patience')
        xlim_data=[0 270];
        ylim_data=[0.15 0.9];
    elseif strcmp(database_name,'domotica_2')
        xlim_data=[0 170];
        ylim_data=[0.1 1];
    end
    
    for speakerid_index=1:length(speakeridlist)
        speakerid = speakeridlist(speakerid_index);
        
        disp(['-----------------------------------------------------'])
        disp(['-------- starting speaker: pp' num2str(speakerid) ' ---------'])
        disp(['-----------------------------------------------------'])
        
        %   ---------------------------------------------------------------------
        % ------------------------------ start program -----------------------------------
        %---------------------------------------------------------------------------------
        
        
        
        % --------------------------- configuration ---------------------------
        
        conf=getconfigs; % get global configuration
        
        addpath(fullfile('databases',database_name,'code')); % add the directory containing the database-specific codes
        
        conf = getconfigs_database(conf,speakerid); % add settings to conf that are database dependent
        
        masterframes = load_masterframes(conf); % load masterframes for this database
        masterframes = extend_masterframes(masterframes); % append masterframes with stats, conversion tables, etc (database independent)
        [sharingdata.word_sharings_matrix, sharingdata.identity_words]=load_word_sharings_matrix(masterframes);
        
        
        %         try
        %
        %             savefilename = [conf.dirconf.keep_large_files  'block_pp' num2str(speakerid) '.mat'];
        %             load(savefilename,'L');
        %         catch
        %             continue
        %         end
        %
        %         newL_logical = ones(30,1);
        %         newL_logical(L)=0;
        %         L_logical = sharingdata.identity_words'*newL_logical;
        %         L=find(L_logical==0);
        %
        %         tra(L,speakerid_index)=0;
        
        
        
        savefilename = fullfile(conf.dirconf.datadir,['traintestfolds_pp' num2str(speakerid) '.mat']);
        
        load(savefilename,'traintestfolds');
        
        
        TP_NMF=zeros(size(traintestfolds.train_utterance_block));
        denom_recall_NMF=zeros(size(traintestfolds.train_utterance_block));
        denom_prec_NMF=zeros(size(traintestfolds.train_utterance_block));
        
        TP_HMM=zeros(size(traintestfolds.train_utterance_block));
        denom_recall_HMM=zeros(size(traintestfolds.train_utterance_block));
        denom_prec_HMM=zeros(size(traintestfolds.train_utterance_block));
        
        
        for fold=1:size(traintestfolds.train_utterance_block,1)
            for subexp=1:size(traintestfolds.train_utterance_block,2)
                Number_of_utterances(fold,subexp)=length(traintestfolds.train_utterance_block{fold,subexp});
                
                resultfile=fullfile(conf.dirconf.results,['results_pp' num2str(speakerid) '_fold' num2str(fold) '_subexp'  num2str(conf.settingconf.expconf.blockstep_array(subexp)) '.mat']);
                if exist(resultfile,'file')
                    load (resultfile);
                    TP_NMF(fold,subexp)=stats.stats_NMF.scores_structs{1, 1}.global.slotvalue_level_scores.sum_true_positives;
                    denom_recall_NMF(fold,subexp)=stats.stats_NMF.scores_structs{1, 1}.global.slotvalue_level_scores.sum_positives_reference;
                    denom_prec_NMF(fold,subexp)=stats.stats_NMF.scores_structs{1, 1}.global.slotvalue_level_scores.sum_positives_prediction;
                    
                    TP_HMM(fold,subexp)=stats.stats_HMM.scores_structs{1, 1}.global.slotvalue_level_scores.sum_true_positives;
                    denom_recall_HMM(fold,subexp)=stats.stats_HMM.scores_structs{1, 1}.global.slotvalue_level_scores.sum_positives_reference;
                    denom_prec_HMM(fold,subexp)=stats.stats_HMM.scores_structs{1, 1}.global.slotvalue_level_scores.sum_positives_prediction;
                    
                    
                    
                end
            end
        end
        %
        
        
        F1_scores{speakerid_index}.score_NMF=2*(sum(TP_NMF)./sum(denom_recall_NMF).*sum(TP_NMF)./sum(denom_prec_NMF))./(sum(TP_NMF)./sum(denom_recall_NMF)+sum(TP_NMF)./sum(denom_prec_NMF));
        %
        F1_scores{speakerid_index}.score_HMM=2*(sum(TP_HMM)./sum(denom_recall_HMM).*sum(TP_HMM)./sum(denom_prec_HMM))./(sum(TP_HMM)./sum(denom_recall_HMM)+sum(TP_HMM)./sum(denom_prec_HMM));
        num_utt{speakerid_index}=mean(Number_of_utterances);
    end
    
    NMF_fig = figure(10*database_num)
    for speakerid_index=1:length(speakeridlist)
        speakerid = speakeridlist(speakerid_index);
        
        if strcmp(database_name,'patience')
            spid = speakerid_index;
        elseif strcmp(database_name,'domotica_2')
            spid = speakerid;
        end
        hold on
        plot(num_utt{speakerid_index},F1_scores{speakerid_index}.score_NMF,'-','Color',color_cell{mod(speakerid_index,length(color_cell))+1}/255,'LineWidth',linewidth);
        
        
        hold on
        for blokstep=1:length(F1_scores{speakerid_index}.score_NMF)
            text(num_utt{speakerid_index}(blokstep)-1,F1_scores{speakerid_index}.score_NMF(blokstep)-0.001,num2str(spid),'Color',color_cell{mod(speakerid_index,length(color_cell))+1}/255);
            hold on
        end
        
    end
    hold off
    xlim(xlim_data);
    ylim(ylim_data);
    xlabel('Size of training set (#utterances)','FontSize',fontsize);
    ylabel('F-score','FontSize',fontsize);
    set(gca,'FontSize',fontsize);
    
    
    
    
    HMM_fig=figure(10*database_num+1)
    for speakerid_index=1:length(speakeridlist)
        speakerid = speakeridlist(speakerid_index);
        
        if strcmp(database_name,'patience')
            spid = speakerid_index;
        elseif strcmp(database_name,'domotica_2')
            spid = speakerid;
        end
        
        hold on
        plot(num_utt{speakerid_index},F1_scores{speakerid_index}.score_HMM,'-','Color',color_cell{mod(speakerid_index,length(color_cell))+1}/255,'LineWidth',linewidth);
        
        hold on
        for blokstep=1:length(F1_scores{speakerid_index}.score_HMM)
            text(num_utt{speakerid_index}(blokstep)-1,F1_scores{speakerid_index}.score_HMM(blokstep)-0.001,num2str(spid),'Color',color_cell{mod(speakerid_index,length(color_cell))+1}/255,'FontSize',12);
            hold on
        end
        
    end
    hold off
    xlim(xlim_data);
    ylim(ylim_data);
    xlabel('Size of training set (#utterances)','FontSize',fontsize);
    ylabel('F-score','FontSize',fontsize);
    set(gca,'FontSize',fontsize);
    
    saveas(NMF_fig,[database_name '_NMF.pdf'],'pdf');
    saveas(HMM_fig,[database_name '_HMM.pdf'],'pdf');
    
end