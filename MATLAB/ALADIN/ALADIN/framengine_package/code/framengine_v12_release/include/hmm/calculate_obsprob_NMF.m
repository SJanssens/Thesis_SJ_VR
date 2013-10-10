function Yprob_seqs = calculate_obsprob_NMF(featmat_cell,NMF_params,NMF_based_E,use_NMF_obsprob_DST,conf)

if ~iscell(featmat_cell)
    featmat_celltmp{1}=featmat_cell;
    featmat_cell=featmat_celltmp;
    clear featmat_celltmp;
    cellinput=0;
else
    cellinput=1;
end

numfeatures = length(NMF_params.remove_acfeats_indices);
%disp(['numfeatures ' num2str(numfeatures)])
%diagmat=eye(numfeatures);


numseqs = length(featmat_cell);
for seqs=1:numseqs
    featmat = featmat_cell{seqs};
    if use_NMF_obsprob_DST
        [Lambda,distmat] = do_DST_recog(featmat,NMF_params,conf);
        if NMF_based_E
            
            Yprob = distmat;
        else
            Yprob=Lambda;
        end
        
    else
        
        [slot_value_activations_NMF,W_activations] = do_NMF_recog(featmat,NMF_params,conf);
        if NMF_based_E
            
            Yprob = W_activations;
            
        else
            Yprob = slot_value_activations_NMF;
        end
    end
    Yprob=bsxfun(@rdivide,Yprob,sum(Yprob)); % renormalise
    Yprob_seqs{seqs} = Yprob; % compute posteriors p(x|y)
end


if ~cellinput
    Yprob_seqs=Yprob_seqs{1};
end
end