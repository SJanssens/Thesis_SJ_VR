% finds label activations using NMF for one or multiple acoustic representations
% this is the most basic version: it does not support multiple W models
%
% input
% 1) acfeatmat - acoustic representation of the utterance (one or multiple
% frames). MxN dimensional: M features, N representations
% 2) NMF_params - contains the rained NMF models
% 3) conf - containing NMF decoding settings
% output
% 1) labelmat - a matrix containing the found labels. LxM dimensional - L
% labels for N representations in acfeatmat
% NOTE: no cleaning  up has been done on this! Thats up to the label2frame
% conversion


function [Lambda,distmat] = do_DST_recog(acfeatmat,NMF_params,conf)

% local settings
modelnum=1; % dont support multiple NMF models for now, even if there are any

acfeatmat = acfeatmat(~NMF_params.remove_acfeats_indices,:); % remove the unused features from the acoustic features

acfeat_dictionary = NMF_params.W_acfeat{modelnum}; % the part of the dictionary (W) pertaining to acoustic features
label_dictionary = NMF_params.W_label{modelnum}; % the part of the dictionary (W) pertaining to labels

% normalisation of observed data
Xobs = bsxfun(@rdivide,acfeatmat,max(sum(acfeatmat,1),1e-50));

% normalisation of acoustic models
Xdict = bsxfun(@rdivide,acfeat_dictionary,max(sum(acfeat_dictionary,1),1e-50));

dst_method = 'seuclidean';

switch dst_method
    case 'seuclidean'
        % noisyfy the dictionary to prevent problems with zero std()
        Xdict=Xdict+1e-10*rand(size(Xdict));
        
        % use pdist2 matlab build-in
        distmat=pdist2(Xdict',Xobs',dst_method);

    case 'euclidean'    
       distmat = eucl_dx_thread(Xobs,Xdict);

    % KL-divergence
    case 'KLD'
        distmat = KLD(acfeatmat,acfeat_dictionary);

    % reverse KLD (or maybe the other one is truly reverse KL)    
    case 'RKLD' 
        distmat = KLD(acfeat_dictionary,acfeatmat)';
    
    % symmetric KLD    
    case 'SKLD' 
        distmat = KLD(acfeatmat,acfeat_dictionary) + KLD(acfeat_dictionary,acfeatmat)'; 
        
    % weighted symmetric KLD    
    case 'WSKLD' 
        distmat = WSKLD(acfeatmat,acfeat_dictionary); 
        
    %  Jensen-Shannon divergence
    case 'JSD'
        distmat = JSD(acfeatmat,acfeat_dictionary);
        

end

distmat=1./distmat;
distmat = bsxfun(@minus,distmat,min(distmat));
distmat = bsxfun(@rdivide,distmat,max(distmat));

Lambda = label_dictionary*distmat; % calculate labelvec





function divergence = KLD(p,q)
divergence = zeros(size(q,2),size(p,2));

p=p+1e-100; %to avoid NaN
q=q+1e-100;

for r=1:size(q,2)
    qs = repmat(q(:,r),1,size(p,2));
    temp = qs./p;
    temp = (qs.*log(temp));    

    divergence(r,:) = sum(temp,1);
end


function divergence = JSD(p,q)

divergence1 = zeros(size(q,2),size(p,2));
divergence2 = zeros(size(q,2),size(p,2));
p=p+1e-100; %to avoid NaN
q=q+1e-100;

for r=1:size(q,2)
    m = 0.5*bsxfun(@plus,p,q(:,r));
    temp = p./m;
    temp = (p.*log(temp));

    divergence1(r,:) = sum(temp,1);
    qs = repmat(q(:,r),1,size(m,2));
    temp = qs./m;
    temp = (qs.*log(temp));    

    divergence2(r,:) = sum(temp,1);
end

divergence = 0.5*(divergence1+divergence2);

function divergence = WSKLD(p,q)

divergence1 = zeros(size(q,2),size(p,2));
divergence2 = zeros(size(q,2),size(p,2));
p=p+1e-100; %to avoid NaN
q=q+1e-100;

% calculate inverse entropies
inv_entropy_p = 1./sum(p.*log(p),1);
inv_entropy_q = 1./sum(q.*log(q),1);

% extend to matrices
inv_entropy_p_mat = repmat(inv_entropy_p,size(q,2),1);
inv_entropy_q_mat = repmat(inv_entropy_q',1,size(p,2));

w_p = inv_entropy_p_mat./(inv_entropy_p_mat+inv_entropy_q_mat);
w_q = inv_entropy_q_mat./(inv_entropy_p_mat+inv_entropy_q_mat);

for r=1:size(p,2)    
    qs = repmat(p(:,r),1,size(q,2));
    temp = qs./q;
    temp = (qs.*log(temp));    
    divergence1(:,r) = sum(temp,1);
end

for r=1:size(q,2)    
    qs = repmat(q(:,r),1,size(p,2));
    temp = qs./p;
    temp = (qs.*log(temp));    
    divergence2(r,:) = sum(temp,1);
end

divergence = w_p .* divergence1 + w_q .* divergence2;


% --- some code that handles the problem of zero values differently ---

% function divergence = JSD2(p,q)
% 
% divergence1 = zeros(size(q,2),size(p,2));
% divergence2 = zeros(size(q,2),size(p,2));
% %p=full(p);
% %q=full(q);
% 
% for r=1:size(q,2)
%     m = 0.5*bsxfun(@plus,p,q(:,r)); % mean between p and q
%     temp = p./m; % term we will take log over later
%     temp(m==0)=0; % fix places where we divided by zero
%     temp = log(temp); % seperate so we can fix NaNs
%     temp(temp==-Inf)=0; % assign zero to Infs
%     temp = (p.*temp) - p + m; % generalized KLD
%     
%     divergence1(r,:) = sum(temp,1);
%     
%     
%     qs = repmat(q(:,r),1,size(m,2));
%     
%     temp = qs./m; % term we will take log over later
%     temp(m==0)=0; % fix places where we divided by zero
%     temp = log(temp); % seperate so we can fix NaNs
%     temp(temp==-Inf)=0; % assign zero to Infs
% 
%     temp = (qs.*temp) - qs + m; % generalized KLD
% 
%     divergence2(r,:) = sum(temp,1);
% end
%
%
%divergence = 0.5*(divergence1+divergence2);
