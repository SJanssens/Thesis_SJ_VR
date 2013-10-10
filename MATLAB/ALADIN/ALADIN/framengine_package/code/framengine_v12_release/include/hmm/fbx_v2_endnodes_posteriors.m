function [gamma,eta,rho] = fbx_v2_endnodes_posteriors(bb,T,p0,H,updateflags,endnodes)
% [gamma,eta,rho] = fbx(Y,T,p0,H,updateflags)
%
% Forward Backward for DISCRETE symbol HMMs
%
% bb is a matrix of state posteriors (for example H(observation_sequence,:))
%    dimension is states x time-frames
%
% T(i,j) is the probability of going to j next if you are now in i
% p0(j)  is the probability of starting in state j
% H(m,j) is the probability of emitting symbol m if you are in state j
%
% updateflags controls the update of parameters
%   it is a three-vector whose elements control the updating of
%   [T,p0,H] -- nonzero elements mean update that parameter
%
% gamma(i,t) = p(x_t=i|Y) are the state inferences
% eta(i,j) = sum_t p(x_t=i,x_t+1=j|Y) are the transition counts
% rho(t) = p(y_t | y_1,y2,...y_t-1) are the scaling factors
%

OFFSET = 1.0e-300;
gamma=[];
eta=[];
rho=[];


% initial checking and nonsense
tau = size(bb,2);
[M,kk] = size(H);
if(size(p0,2)~=1) p0=p0(:); end
if tau<=0, error('length of Y should be positive');end
if ~(length(p0)==kk), error('The numbers of hidden states are not matched.');end

% initialize space
alpha=zeros(kk,tau);
beta=zeros(kk,tau);
rho=zeros(1,tau);



% compute alpha, rho, beta
alpha(:,1) = p0.*bb(:,1) +OFFSET;
rho(1)=sum(alpha(:,1));
alpha(:,1) = alpha(:,1)/rho(1);
for tt=2:tau
    if iscell(T)
        localT=T{tau};
    else
        localT=T;
    end    
    alpha(:,tt) = (localT'*alpha(:,tt-1)).*bb(:,tt)+OFFSET;
    rho(tt) = sum(alpha(:,tt));
    alpha(:,tt) = alpha(:,tt)/rho(tt);
end
%beta(:,tau) = 1;
beta(logical(endnodes),tau)=1; % only endnodes are allowed
for tt=(tau-1):-1:1
    if iscell(T)
        localT=T{tau};
    else
        localT=T;
    end        
    beta(:,tt) = (localT*(beta(:,tt+1).*bb(:,tt+1))+OFFSET)/(rho(tt+1)+OFFSET);
end

% compute eta, AND sum it over all time (but don't normalize the result)
if(updateflags(1))
    eta = zeros(kk,kk);
    for tt=1:(tau-1)
        if iscell(T)
            localT=T{tau};
        else
            localT=T;
        end        
        etatmp = localT.*(alpha(:,tt)*(beta(:,tt+1).*bb(:,tt+1))');
        eta = eta+etatmp/(rho(tt+1)+OFFSET);
        %    eta = eta+etatmp/sum(etatmp(:)); % same thing as above, just slower
    end
    %  eta = eta./(sum(eta,2)*ones(1,kk)); % this would make each row sum to unity
    % but doesn't work with multiple seqs.
end

% compute gamma
gamma = (alpha.*beta);  % here we could just say alpha=alpha.*beta


