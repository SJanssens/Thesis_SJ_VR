function [Tnew,p0new,Hnew,ll] = bwx_ypost_v3_sparse_endnodes_sharingv2(Ypost_seqs,Yprob_seqs,T,fwbw_T,p0,H,T_sparsity,updateflags,endnodes,state_constraint,transition_share_matrix)
%[Tnew,p0new,Hnew,ll] = bwx(Y,T,p0,H,updateflags)
%
% do one iteration of BaumWelch to update HMM params
% for DISCRETE SYMBOL HMMs
% calls fbx.m to do forward-backward (E-step)
%
% Y is a vector (or cell array of vectors if many sequences) of integers
%
% T(i,j) is the probability of going to j next if you are now in i
% p0(j)  is the probability of starting in state j
% H(m,j) is the probability of emitting symbol m if you are in state j
% state_constraints(j) is a binary vector (or cell array of vectors if many
% sequences) which indicates whether a state is present (1) in this
% (sub)sequence or not (0). If empty, it is ignored
%
% updateflags controls the update of parameters
%   it is a three-vector whose elements control the updating of
%   [T,p0,H] -- nonzero elements mean update that parameter
%
% ll is a scalar (or vector for multiple sequences) that holds
%    the log likelihood per symbol (ie total divided by seq length)
%
% gamma(i,t) = p(x_t=i|Y) are the state inferences
% eta(i,j) = sum_t p(x_t=i,x_t+1=j|Y) are the transition counts
% rho(t) = p(y_t | y_1,y2,...y_t-1) are the scaling factors

OFFSET=1.0e-30;

%if(nargin<5) updateflags=[1,1,1]; end

assert_hmm(length(updateflags==3));

if(updateflags(1))
    Tnew  = zeros(size(T));
else
    Tnew =T;
end
if(updateflags(2))
    p0new = zeros(length(p0),1);
else
    p0new=p0;
end
if(updateflags(3))
    Hnew  = zeros(size(H));
else
    Hnew =H;
end

ll=[];
if(~iscell(Ypost_seqs))
    Ypost_seqs_temp=cell(1,1);
    Ypost_seqs_temp{1}=Ypost_seqs;
    Ypost_seqs=Ypost_seqs_temp;
    clear Ypost_seqs_temp;
end

numseqs=length(Ypost_seqs);

if(any(updateflags))
    [M,kk] = size(H);
    ll=zeros(1,numseqs);
    gammasum=zeros(1,kk);
    for seqs=1:numseqs
        % compute posteriors p(x|y)
        Ypost = Ypost_seqs{seqs};
        Yprob = Yprob_seqs{seqs};
        
        [gamma,eta,rho] = fbx_v2_endnodes_posteriors(Ypost,fwbw_T,p0,H,updateflags,endnodes);
        
        if ~ (sum(sum(gamma))>0 | sum(sum(gamma))<=0)
            disp(seqs)
            error('NaN appears in BW!');
        end
        
        % update global T
        if(updateflags(1)) % Eq.(40b) in Rabiner1989
            Tnew  = Tnew  + eta;
        end
        
        if(updateflags(2))
            p0new = p0new + gamma(:,1);
        end
        
        if(updateflags(3))
            gammasum = gammasum + sum(gamma,2)';
            for qq=1:M
                %ff = find(localY==qq);
                %Hnew(qq,:) = Hnew(qq,:) + sum(gamma(:,ff),2)'; % Eq.(40c) in Rabiner1989
                Hnew(qq,:) = Hnew(qq,:) + Yprob(qq,:)*gamma';
            end
        end
        % ll(seqs)=sum(log(rho))/tau; % rho(end)?
        % ll(seqs)=rho(end);
        ll(seqs)=sum(log(rho)); % rho(end)?
    end
    
    
    % THIS ONLY WORKS FOR BLOCK-ORGANISED FULLY CONNECTED
    if ~isempty(transition_share_matrix)
        numslots=size(transition_share_matrix,2);
            for from_slot=1:numslots
                from_SV_indices=find(transition_share_matrix(:,from_slot)>0);
                from_SV_indices = intersect(find(state_constraint),from_SV_indices); % only share transitions of actually occuring states
                for target_slot=setdiff(1:numslots,from_slot) % loop over all targets not being the same (no self-transition)
                    target_SV_indices=find(transition_share_matrix(:,target_slot)>0);
                    target_SV_indices = intersect(find(state_constraint),target_SV_indices); % only share transitions of actually occuring states
                    Transval=mean(mean(Tnew(from_SV_indices,target_SV_indices)));
                    Tnew(from_SV_indices,target_SV_indices)=repmat(Transval,length(from_SV_indices),length(target_SV_indices));
                end
            end
    end
        
    
    % APPLY SPARSITY
    Tfloormat=zeros(size(T))+1e-5;
    Tfloormat(T==0)=0; % for truly zero values, leave at zero
    Tnew = max(Tnew-T_sparsity,Tfloormat);
   
    
    % normalize probability distributions
    if(updateflags(1)) % Eq.(40b) in Rabiner1989
        Tnew  = Tnew./(sum(Tnew,2)*ones(1,kk)+OFFSET);
    end
    if(updateflags(2))
        p0new = p0new/(sum(p0new)+OFFSET);
    end
    if(updateflags(3))  % Eq.(40c) in Rabiner1989
        Hnew  = Hnew./(ones(M,1)*gammasum+OFFSET);
    end
    
    
    
    
    
    
    
    
end

