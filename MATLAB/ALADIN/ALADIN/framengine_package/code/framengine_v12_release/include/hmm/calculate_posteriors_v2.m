function Ypost_seqs = calculate_posteriors_v2(Yprob,H,state_supervision)

if ~iscell(Yprob)
    Yprob_tmp{1}=Yprob;
    Yprob=Yprob_tmp;
   
    cellinput=0;
else
    cellinput=1;
end

usestatesupervision = ~isempty(state_supervision);

numseqs = length(Yprob);
for seqs=1:numseqs
    localYprob=Yprob{seqs};
    Ypost = H'*localYprob;
    if usestatesupervision
        Ypost(~logical(state_supervision(:,seqs)),:)=0; % probability of states not in this sentence are zero
    end
    Ypost=bsxfun(@rdivide,Ypost,sum(Ypost)); % renormalise
    Ypost_seqs{seqs} = Ypost; % compute posteriors p(x|y)
end


if ~cellinput
    Ypost_seqs=Ypost_seqs{1};
end